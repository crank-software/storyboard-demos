
local hour = 12
local min = 0
local sec = 0

function cb_time_update()
  local data = {}
  
  sec = sec + 1
  if (sec > 59) then
    min = min + 1
    sec = 0
    if (min > 59) then
      hour = hour + 1
      min = 0
      if (hour > 12) then
        hour = 1
      end
    end
  end
  if (min < 10) then
   data["digital_layer.time_control.text"] = hour..":0"..min
  else
    data["digital_layer.time_control.text"] = hour..":"..min
  end
  if (sec < 10) then
    data["digital_layer.time_control.sec"] = "0"..sec
  else
    data["digital_layer.time_control.sec"] = sec
  end
  
  gre.set_data(data)  
end

--- @param gre#context mapargs
function cb_init(mapargs) 
  gre.timer_set_interval(cb_time_update,1000)
end
