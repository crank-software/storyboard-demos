local clockTimer

local seconds

local hrs_key = "analog_hands_layer.hand_hour"
local mins_key = "analog_hands_layer.hand_minute"
local secs_key = "analog_hands_layer.hand_seconds"

function CBAnalogScreenShow(mapargs)
  local time = gre.mstime() / 1000
  
  local timeTable = os.date("*t",time)
  local hrs = timeTable.hour
  local mins = timeTable.min
  seconds = timeTable.sec
  
  local data = {}
  data[string.format("%s.angle", secs_key)] = ((seconds / 60) * 360)
  data[string.format("%s.angle", mins_key)] = ((mins / 60) * 360) + ((seconds / 60) * 6) 
  if(hrs > 12) then
    hrs = hrs - 12
  end
  data[string.format("%s.angle",hrs_key)] = ((hrs / 12) * 360) + ((mins / 60) * 6)
  gre.set_data(data)
  
  clockTimer = gre.timer_set_interval(CBAnalogSyncTime,150)
end

function CBAnalogScreenHide(mapargs)
  gre.timer_clear_interval(clockTimer)
end

function CBAnalogSyncTime(mapargs)
  local time = gre.mstime() / 1000

  local timeTable = os.date("*t",time)
  local hrs = timeTable.hour
  local mins = timeTable.min
  local secs = timeTable.sec
  
  if(secs ~= seconds) then
    local data = {}
    seconds = secs
    if(secs == 0) then
      data[string.format("%s.dest_angle", secs_key)] = 360
    else
      data[string.format("%s.dest_angle", secs_key)] = ((secs / 60) * 360)
    end
    
    data[string.format("%s.angle", mins_key)] = ((mins / 60) * 360) + ((secs / 60) * 6)
    
    if(hrs > 12) then
      hrs = hrs - 12
    end
    data[string.format("%s.angle",hrs_key)] = ((hrs / 12) * 360) + ((mins / 60) * 6)
    gre.set_data(data)
        
    gre.animation_trigger("hands_seconds")
  end
end

function CBAnalogHandsSecondsComplete(mapargs)
  local angle_key = string.format("%s.angle", secs_key)
  local angle = gre.get_value(angle_key)
  
  if(angle == 360) then
    gre.set_value(angle_key, 0)
  end
end
