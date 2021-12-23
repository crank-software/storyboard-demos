
local idval = {}
local start_ms

function cb_sw_func()
  local current_ms = gre.mstime()
  local total_ms = current_ms - start_ms
  local data = {}
  
  local milli = math.fmod(total_ms / 10,100)
  local t_sec = total_ms / 1000
  local sec = math.fmod(t_sec,60)
  local min= math.floor(t_sec / 60)
  local angle= sec / 60 * 360
 
  data["stopwatch_layer.milliseconds.text"] = string.format("%02d",milli) 
  data["stopwatch_layer.timer_value.text"] = string.format("%02d:%02d",min, sec)
  data["stopwatch_layer.arc.endAngle"] = angle
  gre.set_data(data)
end


function cb_stopwatch_start(mapargs)
  start_ms = gre.mstime()

  -- update the stoptwatch timer every 30 ms (might need to adjust this for the platform
  idval = gre.timer_set_interval(cb_sw_func, 30)
end

function cb_stopwatch_stop(mapargs)
  idval = gre.timer_clear_interval(idval)
end