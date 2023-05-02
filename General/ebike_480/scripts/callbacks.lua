---
-- Handles the callbacks in the eBike screen

local btn_handle = require('btn_handler')

local beam_state = false
local turn_left = false
local turn_right = false

local alpha_off = 55
local alpha_on = 255

---
-- Changes the current trip value on the bottom bar
function add_distance(distance)
  gre.set_value("secondary_layer.trip_control.trip_text", distance)
end

---
-- Changes the avg speed shown on the bottom bar
function change_avg_speed(change_speed)
  gre.set_value("secondary_layer.avg_speed_control.avg_speed_text", change_speed)
end

---
-- Changes the watts used shown on the bottom bar
function change_watts(watts)
  gre.set_value("secondary_layer.watts_control.watts_text", watts)
end

---
-- Handles the battery display functionality
function change_batt_percentage(percent)
  -- Handles the number display
  gre.set_value("secondary_layer.battery_group.battery_value.battery_value_text", 
  string.format("%s%%", percent))
  
  -- Handles the battery-fill dispay
  local height = 56 * (100 - percent) / 100
  gre.set_value("secondary_layer.battery_group.div.batt_percent_height", height)

  -- Handles the battery-fill color
  local color = 0
  if(percent <= 20) then
    color = 0xFF0000
  else
    color = 0x38DE51
  end
  gre.set_value("secondary_layer.battery_group.battery_fill_hex_38de51.battery_color", color)
end

---
-- Changes the range shown on the left side of the screen
function change_range(range)
  gre.set_value("secondary_layer.battery_group.range_control.range_text", range)
end

---
-- Changes the speed that is displayed in the middle of the screen
function change_speed(speed)
  local first_speed = (speed - speed % 10) / 10
  gre.set_value("speed_power_layer.label_speed.speed_text", first_speed)
  gre.set_value("speed_power_layer.label_speed_decimal.speed_dec_text", speed % 10)
end

---
-- Toggles the ECO light that is shown above the Crank logo on the right side of the screen
function toggle_eco(is_eco)
  local val
  if(is_eco == 1)then
    val = alpha_on
  else
    val = alpha_off
  end
  gre.set_value("secondary_layer.label_mode.label_alpha", val)
end

---
-- Toggles the "Downhill" charging light that is shown on the right side of the screen
function toggle_charging(is_charging)
  local charging_on = "images/charging_on.png"
  local charging_off = "images/charging_off.png"

  local color = 0
  local charge_state = ""
  if(is_charging == 1) then
    charge_state = charging_on
    color = 0x00FF00
  else
    charge_state = charging_off
    color = 0x212B30
  end
  gre.set_value("secondary_layer.downhill_control.downhill_color", color)
  gre.set_value("secondary_layer.downhill_control.downhill_image", charge_state)
end

--- @param deg The starting degree for the arc (in degrees)
--- @param start_x Starting x coordinate of the arc
--- @param start_y Starting y coordinate of the arc
--- @param end_x   Final x coordinate of the arc
--- @param end_y   Final y coordinate of the arc
--- @param is_counter_clockwise Are we drawing the arc counter clockwise?
-- Determines the path for the arc. 
local function calc_arc(deg, start_x, start_y, end_x, end_y, is_counter_clockwise)

  local x_radius = end_x - start_x
  local y_radius = end_y - start_y
  

  local i = -90
  local stop_loop = false

  local arc = ''
  while(true)
  do
    --Convert i into radians
    local radians = 3.14159 * i / 180
      
    local __x = x_radius * math.cos(radians) + start_x
    local __y = y_radius * math.sin(radians) + end_y 
    
    if(is_counter_clockwise) then
      arc = string.format("%d,%d %s", __x, __y, arc)
    else
      arc = string.format("%s %d,%d", arc, __x, __y)
    end

    i = i + 5
    if(stop_loop) then
      break
    end

    if(i >= deg) then
      i = deg
      stop_loop = true
    end
  end
  return arc
end

--- @param percent How full is main power bar?
-- Fills the power bar that is in the middle of the screen (left to right)
-- The power bar is divided into 3 main sections; horizontal rectangle, arc, and sloped rectangle
function change_main_bar(percent)
  percent = percent / 100
  local horizontal_rect_distance = 142
  local arc_distance = 65
  local sloped_rect_distance = 79
  local submit_coords = {}
  
  -- Represent the distances as percentages
  local total_distance = horizontal_rect_distance + arc_distance + sloped_rect_distance
  local norm_horizontal_distance = horizontal_rect_distance / total_distance
  local norm_arc = arc_distance / total_distance
  local norm_slope_dist = sloped_rect_distance / total_distance

  -- Starting coordinates
  local left_x = 0
  local lower_y = 114
  local left_adj_x = 18
  local upper_y = 86
  local end_x = 160


  -- Slope rectangle coordinates
  local slope_start_x = 227
  local slope_start_end_y = 65
  local slope_upper_right_x = 268
  local slope_mid_y = 0
  local slope_upper_left_x = 236
  local slope_final_x = 190
  local slope_start_end_y = 65

  -- Horizontal height and width
  local rect_height = lower_y - upper_y
  
  -- Path value variables. Is segmented to create the perimeter of the polygon in a counterclockwise fashion
  -- Path is the total path; also will be used for the horizontal rectangle
  local path = ''
  local inner_arc = ''
  local outer_arc = ''
  local slope_rect = ''
  -- Get the percentage of the horizontal rectangle being filled
  -- Important for calculating if the bar is in the triangle on the left side
  local mod = percent / norm_horizontal_distance
  local x2 = mod * end_x


  -- A catch so the rectangle stops being drawn when the power fill reaches the arc
  if(x2 > end_x) then
    x2 = end_x
  end

  -- There is a triangle in the subsection of the rectangle. Must not overfill that triangle
  if(x2 < left_adj_x) then
    local angle = math.atan((upper_y - lower_y) / (left_adj_x - left_x))
    local y2 = math.tan(angle) * (x2 - left_x) + lower_y

    path = string.format("%d,%d %d,%d %d,%d", left_x, lower_y, x2, lower_y, x2, y2)

  else
    path = string.format("%d,%d %d,%d %d,%d %d,%d", x2, upper_y, left_adj_x, upper_y, left_x, lower_y, x2, lower_y)

  end
  
  -- Creates the arc path. Since we started with the horizontal rectangle, to draw in a counter clockwise fashion,
  -- the outer arc will be constructed counter clockwise and the inner arc will be constructed clockwise.
  if(percent >= norm_horizontal_distance) then
    local deg = (percent - norm_horizontal_distance) * 90 / norm_arc - 90
    if(deg > 0) then
      deg = 0
    end
    inner_arc = calc_arc(deg, end_x, upper_y, slope_final_x, slope_start_end_y, true)
    outer_arc = calc_arc(deg, end_x, lower_y, slope_start_x, slope_start_end_y, false)

  end

  -- Creates the sloped rectangle (the last main section)
  if(percent >= norm_horizontal_distance + norm_arc) then
    local mod = (percent - norm_horizontal_distance - norm_arc) / norm_slope_dist
    local slope = (slope_start_end_y - slope_mid_y) / (slope_start_x - slope_upper_right_x) 
    local intercept1 = slope_start_end_y - slope * slope_start_x
    local intercept2 = slope_start_end_y - slope * slope_final_x

    local new_y = slope_start_end_y - (mod * (slope_start_end_y - slope_mid_y))

    slope_rect = string.format("%d,%d %d,%d %d,%d %d,%d",
                          slope_start_x, slope_start_end_y,
                          (new_y - intercept1) / slope, new_y,
                          (new_y - intercept2) / slope, new_y,
                          slope_final_x, slope_start_end_y)

  end
  path = string.format("%s %s %s %s", path, outer_arc, slope_rect, inner_arc)
  gre.set_value("speed_power_layer.power_fill.power_fill_points", path)
   
end

--- 
-- Handles the high beam being pressed on the top right
function high_beam_pressed()
  beam_state = not beam_state
  local alpha
  if(beam_state) then
    alpha = alpha_on
  else
    alpha = alpha_off
  end  
  gre.set_value("top_bar_layer.icn_lights.beam_alpha", alpha)
end

---
-- Storyboard connector for "pressing" the beam on the top right
local curr_pressed_id = 0
function headlights(pressed_id)
  if(pressed_id == curr_pressed_id) then
    return
  end
  curr_pressed_id = pressed_id
  high_beam_pressed()
end

---
-- Makes the turn signal blink
local blink_state = {}
local btn_pressed_path = ""
local function blink()
  if(blink_state) then
    gre.set_value(btn_pressed_path, alpha_on)
    blink_state = false
  else
    gre.set_value(btn_pressed_path, alpha_off)
    blink_state = true
  end
end

---
-- Sets the timer for the blinking interval. Calls a function to make turn signal blink
local timer = {}  
local function turn_signal_helper(state, btn_path)
  local blink_interval = 450 -- milliseconds

  blink_state = false
  if(state) then
  
    if(btn_pressed_path ~= btn_path) then
      gre.timer_clear_interval(timer)
      gre.set_value(btn_pressed_path, alpha_off)
    end
    btn_pressed_path = btn_path
    blink_state = true
    timer = gre.timer_set_interval(blink_interval, blink)
    
  else
  
    if(btn_pressed_path ~= "") then
      gre.timer_clear_interval(timer)
      gre.set_value(btn_pressed_path, alpha_off)
    end
    btn_pressed_path = ""
    gre.timer_clear_interval(timer)
    gre.set_value(btn_path, alpha_off)
  end

end

---
-- Handles the on press event for the signal
-- You can break this function by using this function in
-- conjunction with the SBIO
-- It will still work, but clicking on the button may have unintended actions.
-- You can disable the blinker() function
function turn_signal_pressed(mapargs)
  local button = mapargs.context_control
  
  if(button == "top_bar_layer.signal_right") then
    turn_right = not turn_right
    turn_left = false
    turn_signal_helper(turn_right, string.format("%s.right_alpha", button))
  else
    turn_left = not turn_left
    turn_right = false
    turn_signal_helper(turn_left, string.format("%s.left_alpha", button))
  end
end

---
-- Handles the SBIO connector for the turn signal
local curr_blink_id = 1
function blinker(blinker_id)

  if(blinker_id == curr_blink_id) then
    return
  end

  curr_blink_id = blinker_id
  if(curr_blink_id == 2) then
    turn_right = true
    turn_left = false
    turn_signal_helper(true, string.format("top_bar_layer.signal_right.right_alpha"))
  elseif(curr_blink_id == 1) then
    turn_left = false
    turn_right = false
    turn_signal_helper(false, string.format("top_bar_layer.signal_right.right_alpha"))
    turn_signal_helper(false, string.format("top_bar_layer.signal_left.left_alpha"))
  else
    turn_left = true
    turn_right = false
    turn_signal_helper(true, string.format("top_bar_layer.signal_left.left_alpha"))
  end


end

---
-- Handles the time format in the main screen. Either displays 12h time or 24 hour time
function change_time(hours, minutes)
  local time
  if(get_time_id() == 2) then
    local time_of_day = "am"
    if(hours >= 12) then
      time_of_day = "pm"
    end
    hours = hours % 12
    if(hours == 0) then
      hours = 12
    end
    time = string.format("%d:%02d %s", hours, minutes, time_of_day)
  else
    time = string.format("%02d:%02d", hours, minutes)
  end
  gre.set_value("top_bar_layer.label_time.time", time)
end


---
-- Updates the values that are in the home_event
function update_values(mapargs)
  local event_data = mapargs.context_event_data
  
  add_distance(event_data.distance_update)
  change_avg_speed(event_data.avg_speed_update)
  change_watts(event_data.watt_update)
  change_batt_percentage(event_data.battery_level)
  change_range(event_data.range)
  change_speed(event_data.update_speed)
  toggle_eco(event_data.is_eco)
  toggle_charging(event_data.is_charging)
  change_main_bar(event_data.power)
  change_time(event_data.hours, event_data.minutes)
  blinker(event_data.blinker)
  headlights(event_data.headlights)

end