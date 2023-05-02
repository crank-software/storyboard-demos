local date_time = require "date_time"
local arc_info = {
  step = {
    current_val = 0,
    goal = 10000,
    increment = 50,
    duration = "step_tracker_screen.step_duration",
    string = "%s steps",
    text = "step_tracker_layer.steps_control.text", 
    arc = "step_tracker_layer.step_arc_control.endAngle",
    timer_callback = update_step_count
  }, 
  km = {
    current_val = 0,
    goal = 7.9,
    increment = 0.1,
    duration = "step_tracker_screen.km_duration",
    string = "%.1f km",
    text = "step_tracker_layer.km_control.text", 
    arc = "step_tracker_layer.km_arc_control.endAngle",
    timer_callback = update_km_count
  },
  cal = {
    current_val = 0,
    goal = 700,
    increment = 10,
    duration = "step_tracker_screen.cal_duration",
    string = "%s kCal",
    text = "step_tracker_layer.calories_control.text", 
    arc = "step_tracker_layer.cal_arc_control.endAngle", 
    timer_callback = update_cal_count
  }
}

local function update_current_val(table_index)
  if table_index.current_val >= table_index.goal then
    gre.timer_clear_interval(table_index.timer)
    return
  end
  
  table_index.current_val = table_index.current_val + table_index.increment
  local path = table_index.text
  local string = string.format(table_index.string, table_index.current_val)
  
  gre.set_value(path, string)
end

local function update_step_count()
  update_current_val(arc_info.step)
end

local function update_cal_count()
  update_current_val(arc_info.cal)
end

local function update_km_count()
  update_current_val(arc_info.km)
end

local timer_callbacks = {
  step = update_step_count, 
  cal = update_cal_count, 
  km = update_km_count
}

function set_step_tracker_clock() 
  local time = date_time.get_current_time()
  gre.set_value("step_tracker_layer.time_control.text", string.format("%02d:%02d", time.hour, time.minute))
end

local function start_tracking_steps()
  local data = {}
  
  for i, key in pairs(arc_info) do 
   local duration = gre.get_value(key.duration)
    key.timer = gre.timer_set_interval(timer_callbacks[i], duration / (key.goal / key.increment))
    key.current_val = 0
  end
  
  gre.animation_trigger("step_tracker_rotation")
end

local function resume_tracking_steps()
  for i, key in pairs(arc_info) do 
    local duration = gre.get_value(key.duration)
    key.timer = gre.timer_set_interval(timer_callbacks[i], duration / (key.goal / key.increment))
  end
  
  gre.animation_resume("step_tracker_rotation")
end

function cb_enter_step_tracker_screen(mapargs)
  local goals_reached = 0
  
  for i, key in pairs(arc_info) do 
    if key.current_val >= key.goal or key.current_val == 0 then 
      goals_reached = goals_reached + 1
    end
  end
  
  if goals_reached == 3 then
    start_tracking_steps()
  else
    resume_tracking_steps()
  end
end

function cb_exit_step_tracker_screen(mapargs) 
  for _, key in pairs(arc_info) do 
    gre.timer_clear_interval(key.timer)
  end
  
  gre.animation_pause("step_tracker_rotation")
end
