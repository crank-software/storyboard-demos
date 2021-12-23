local time = require "date_time"

local hour
local minute 
local second

local function get_hour_fraction()
  return (360 / 720) * minute
end

function set_analog_clock(mapargs)
  hour = time.get_current_time()["hour"]
  minute = time.get_current_time()["minute"]
  second = time.get_current_time()["second"]
  local hour_angle = (360 / 12) * hour
  
  local data = {}
  data["analog_minute_angle"] = (360 / 60) * minute
  data["analog_hour_angle"] = hour_angle + get_hour_fraction()
  data["analog_second_angle"] = (360 / 60) * second
  gre.set_data(data)
end
