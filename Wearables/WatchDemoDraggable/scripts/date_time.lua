local clockTimer = nil

local time_offset = 0
if (gre.env("target_os") == "freertos") then
  time_offset = 1637861456180 
end

--25 times per second we will update the second hand in analogue mode
--Every second we will update the minute hand / digital minute
--Every minute we will update the hour hand / digital hour
--Timers are going to be 1000 ms for digital and 40ms

function cb_digital_screen_show(mapargs)
  cb_digital_sync_time()
  --Update the digital clock every second
  if (clockTimer == nil) then
    clockTimer = gre.timer_set_interval(cb_digital_sync_time, 1000)
  end
end

function cb_digital_sync_time(mapargs)
  local time = (time_offset + gre.mstime()) / 1000
  local data = {}
  --3:45 pm

  local time = math.floor(time)
  data["digital_clock_layer.hour_control.text"] = os.date("%H", time)
  data["digital_clock_layer.minute_control.text"] = os.date("%M", time)
  data["digital_clock_layer.date_control.text"] = os.date("%a\n%b\n%d", time)
  data["step_tracker_layer.time_control.text"] = os.date("%H:%M", time)
  gre.set_data(data)
end

local clockTimer = nil
local seconds
local hrs_key = "analog_clock_layer.hour_hand"
local mins_key = "analog_clock_layer.minute_hand"
local secs_key = "analog_clock_layer.second_hand"

local function get_analog_angles(hour, min, sec)
  if(hour > 12) then
      hour = hour - 12
  end
    
  local sec_angle = (sec / 60) * 360
  
  local min = min + (sec / 60)
  local min_angle = (min / 60) * 360
  
  local hour = hour + (min / 60)
  local hour_angle = (hour / 12) * 360

  return hour_angle, min_angle, sec_angle
end

function cb_analog_sync_time(mapargs)
  local time = (time_offset + gre.mstime()) / 1000
  
  --Since the os.date doesn't give us back a fractional number of seconds, we keep track of the amount which was truncated
  local partial_secs = time - math.floor(time)
  local time_table = os.date("*t",time)
  local hour, min, sec = get_analog_angles(time_table.hour, time_table.min, time_table.sec + partial_secs)
  local data = {}
  data[string.format("%s.angle",hrs_key)] = hour
  data[string.format("%s.angle", mins_key)] = min 
  data[string.format("%s.angle", secs_key)] = sec
  gre.set_data(data)
end

function cb_analog_screen_show(mapargs)
  cb_analog_sync_time()
  clockTimer = gre.timer_set_interval(cb_analog_sync_time, 50)
end

function cb_analog_screen_hide(mapargs)
  gre.timer_clear_interval(clockTimer)
end

function cb_analog_hands_seconds_complete(mapargs)
  local angle_key = string.format("%s.angle", secs_key)
  local angle = gre.get_value(angle_key)
  
  if(angle >= 360) then
    gre.set_value(angle_key, angle - 360)
  end
end
