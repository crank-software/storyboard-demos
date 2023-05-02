local date_time = require "date_time"

local hour
local minute 
local second

function set_analog_clock(mapargs)
  hour = date_time.get_current_time()["hour"]
  minute = date_time.get_current_time()["minute"]
  second = date_time.get_current_time()["second"]
  
  local data = {}
  data["analog_clock_layer.hour_hand.angle"] = (360 / 12) * hour
  data["analog_clock_layer.minute_hand.angle"] = (360 / 60) * minute
  gre.set_data(data)
end

-- Called when second hand animates full rotation
function animate_minute_hand(mapargs) 
  if gre.get_value("analog_clock_layer.minute_hand.angle") == 360 then 
    gre.set_value("analog_clock_layer.minute_hand.angle", 0)
  end
  
  minute = minute + 1
  gre.set_value("analog_clock_layer.minute_hand.to_angle", (360 / 60) * minute)
  gre.animation_trigger("minute_hand_rotation")
  
  if minute == 60 then 
    minute = 0
    animate_hour_hand()
  end
end

function animate_hour_hand(mapargs) 
  hour = hour + 1
  gre.set_value("analog_clock_layer.hour_hand.to_angle", (360 / 12) * hour)
  gre.animation_trigger("hour_hand_rotation")
  
  if hour == 12 then 
    hour = 0
    gre.set_value("analog_clock_layer.hour_hand.angle", 0)
  end
end