require "digital_clock"
require "step_tracker"

local date_time = require "date_time"
local clock_timer


function update_clock_timer()
  local minute = date_time.get_current_time().minute
  date_time.update_time()
  
  if gre.get_value("current_screen") ~= "analog_clock_screen" then
    set_analog_clock()
  end
  
  if minute ~= date_time.get_current_time().minute then
    animate_minute_hand()
    set_digital_clock()
    set_step_tracker_clock()
  end
end

function cb_start_clock_timer(mapargs)
  clock_timer = gre.timer_set_interval(update_clock_timer, 1000)
  set_digital_clock()
  set_step_tracker_clock()
end