require('PageScroller')

local myScroller

local cur_selected = "time_group"
local workout_hour = 0
local workout_min = 0
local workout_sec = 0
local timer_hour = 0
local timer_min = 0
local timer_sec = 0

local function time_group_select()
end

local function time_group_unselect()
end

-- timer simulation
local stopwatch_timer = nil

local function timer_cb()
  timer_sec = timer_sec + 1
  if (timer_sec == 60) then
    timer_min = timer_min + 1
    timer_sec = 0
  end
  if (timer_min == 60) then
    timer_hour = timer_hour + 1
    timer_min = 0
  end

  str = string.format("%02d:%02d:%02d",timer_hour,timer_min,timer_sec)
  gre.set_value("menu_layer.timer_group.timer_value.time", str)
end

local function timer_group_select()
end

local function timer_group_unselect()
  gre.timer_clear_interval(stopwatch_timer)
  gre.set_value("menu_layer.timer_group.timer_value.time", "00:00:00")
  gre.set_value("menu_layer.timer_group.btn_start.image", "images/btn_start.png")
  timer_hour = 0
  timer_min = 0
  timer_sec = 0
  stopwatch_timer = nil
end

-- heartrate simulation
function heartrate_animation_complete_cb(mapargs)
  if (cur_selected == "heartrate_group") then
    gre.animation_trigger("heartrate")
  end
end

local function heartrate_group_select()
  gre.animation_trigger("heartrate")
end

local function heartrate_group_unselect()
  gre.animation_stop("heartrate")
end

-- workout simulation
local workout_timer = nil
local run_index = 1

local function workout_cb()
  workout_sec = workout_sec + 1
  if (workout_sec == 60) then
    workout_min = workout_min + 1
    workout_sec = 0
  end
  if (workout_min == 60) then
    workout_hour = workout_hour + 1
    workout_min = 0
  end
  run_index = run_index + 1
  if (run_index > 20) then
    run_index = 1
  end
  str = string.format("%02d:%02d:%02d",workout_hour,workout_min,workout_sec)
  gre.set_value("menu_layer.workout_group.workout_time_value.time", str)
  gre.set_value("menu_layer.workout_group.selected.image", "images/run"..run_index..".png")

end

local function workout_group_select()
  if (workout_timer == nil) then
    workout_timer = gre.timer_set_interval(workout_cb,60)
  end
end

local function workout_group_unselect()
  if (workout_timer) then
    gre.timer_clear_interval(workout_timer)
    workout_timer = nil
  end
  gre.set_value("menu_layer.workout_group.workout_time_value.time", "00:00:00")
  workout_hour = 0
  workout_min = 0
  workout_sec = 0
end

local menu_items = {
  time_group = { select = time_group_select, unselect = time_group_unselect},
  timer_group = { select = timer_group_select, unselect = timer_group_unselect},
  heartrate_group = { select = heartrate_group_select, unselect = heartrate_group_unselect},
  workout_group = { select = workout_group_select, unselect = workout_group_unselect},
}

local function time_group_cb()
  gre.timer_set_interval(time_update_cb,1000)
end

function select_cb(selected)
  menu_items[selected].select()
    if (selected == cur_selected) then
    return
  end
  
  if (cur_selected) then
    menu_items[cur_selected].unselect()
  end
  cur_selected = selected
end

function drag_cb(selected)
    menu_items[cur_selected].unselect()
end

local clock_min = 0
local clock_hour = 0

function clock_update_cb()
  local data = {}
  
  clock_min = clock_min + 6 -- 6 degrees
  if (clock_min >= 360) then
    clock_hour = clock_hour + 6
    clock_min = 0
  end
  data["minute_angle_last"] = clock_min - 6
  data["minute_angle"] = clock_min
  data["hour_angle"] = clock_hour
  gre.set_data(data)
  gre.animation_trigger("minute_animation")
end

--- @param gre#context mapargs
function cb_init(mapargs) 
  -- create a new scroller PageScroller:new((layer, screen width, x-padding, animation duration in msec, select callback)
   myScroller = PageScroller:new("menu_layer", 390, 0, 100, select_cb, drag_cb)

   -- add controls to the scroller
   myScroller:add_control("time_group")
   myScroller:add_control("timer_group")
   myScroller:add_control("heartrate_group")
   myScroller:add_control("woselect_group")
   myScroller:add_control("workout_group")

   gre.timer_set_interval(clock_update_cb, 1000)
end

function cb_scroll_press(mapargs)
  myScroller:press(mapargs.context_event_data.x)
end

function cb_scroll_release(mapargs)
  myScroller:release(mapargs.context_event_data.x)
end

function cb_scroll_drag(mapargs)
  myScroller:drag(mapargs.context_event_data.x)
end


--- @param gre#context mapargs
function timer_start_cb(mapargs)
  if (stopwatch_timer == nil) then -- running
    gre.set_value("menu_layer.timer_group.btn_start.image", "images/btn_stop.png")

    stopwatch_timer = gre.timer_set_interval(timer_cb, 100)
  else
    -- clear it
    timer_group_unselect()
  end
end

--- @param gre#context mapargs
function timer_reset_cb(mapargs) 
  timer_group_unselect()
end
