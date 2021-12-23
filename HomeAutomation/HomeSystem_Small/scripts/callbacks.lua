local DIMMER_SLIDER_PADDING = 18
local DIMMER_LEVEL_PADDING = 34
local DIMMER_MIN_HEIGHT = 39
local DIMMER_MAX_HEIGHT = 254
local DIMMER_MIN_LEVEL = 0
local DIMMER_MAX_LEVEL = 35
local DIMMER_TOTAL_LEVEL_HEIGHT = 215
local TEMP_ANGLE_OFFSET = 53
local TEMP_MAX_ANGLE = 287
local TEMP_OUTBOUND_ANGLE_MEDIAN = 323.5
local TEMP_TOTAL_INT_VALUES = 12
local TEMP_MIN_VALUE = 14
local selected_light_index = 1

local light_list = {
 {id = 1, dimness_level = "MAX", y_position = DIMMER_MIN_HEIGHT},
 {id = 2, dimness_level = "MAX", y_position = DIMMER_MIN_HEIGHT},
 {id = 3, dimness_level = "MAX", y_position = DIMMER_MIN_HEIGHT},
 {id = 4, dimness_level = "MAX", y_position = DIMMER_MIN_HEIGHT}
}

---set the y_position and dimness_level values for the default light in light_list
local function set_default_light_config()
  local y_position = gre.get_value("light_dimmer_layer.slider.grd_y") + DIMMER_SLIDER_PADDING
  
  --clamp the y_position to the bottom or top of the dimmer slider
  if (y_position < DIMMER_MIN_HEIGHT) then
    y_position = DIMMER_MIN_HEIGHT
  elseif (y_position > DIMMER_MAX_HEIGHT) then
    y_position = DIMMER_MAX_HEIGHT
  end
  
  light_list[selected_light_index].y_position = y_position
  set_dimmer_level(y_position)
end

---On startup, setup default light values
function cb_init(mapargs) 
  set_default_light_config()
end

---toggle the selected light switch on and off
function cb_light_toggle_touch(mapargs)
  local status = gre.get_value(mapargs.context_group .. ".status")
  --check for the current status and then set it to the opposite value, then play the animation
  if (status == 0) then
    gre.animation_trigger("turn_light_on", {context = mapargs.context_group})
    gre.set_value(mapargs.context_group .. ".status", 1)
  elseif (status == 1) then
    gre.animation_trigger("turn_light_off", {context = mapargs.context_group})
    gre.set_value(mapargs.context_group .. ".status", 0)    
  end
end

---Set the dimmer level text to the current selected level value
--@param current_level The dimness level the user has selected
local function set_current_level(current_level)
  --store the value being set into the light_list table
  light_list[selected_light_index].dimness_level = current_level
  
  --display the minimum and maximum values as a string instead of as a number
  if (current_level == DIMMER_MIN_LEVEL) then
    current_level = "MIN"
  elseif(current_level == DIMMER_MAX_LEVEL) then
    current_level = "MAX"
  end
  
  gre.set_value("light_dimmer_layer.current_level.text", current_level)
end

---Callback when the user adjusts the dimmer level
--store the y position of the context event and use it to set the positions of the level slider, level text, and level indicator 
function cb_light_dimmer_touch(mapargs)
  local ev_data = mapargs.context_event_data
  local touch_pos_y = ev_data.y
  
  --clamp the y_position to the bottom or top of the dimmer slider
  if (touch_pos_y < DIMMER_MIN_HEIGHT) then
    touch_pos_y = DIMMER_MIN_HEIGHT
  elseif (touch_pos_y > DIMMER_MAX_HEIGHT) then
    touch_pos_y = DIMMER_MAX_HEIGHT
  end
  
  --store the touch position
  light_list[selected_light_index].y_position = touch_pos_y
  
  --move the slider, level text control, and level indicator to the touch position
  local data = {}
  data["light_dimmer_layer.slider.grd_y"] = touch_pos_y - DIMMER_SLIDER_PADDING
  data["light_dimmer_layer.current_level.grd_y"]  = touch_pos_y - gre.get_value("light_dimmer_layer.current_level.grd_height")/2
  data["light_dimmer_layer.slider_top.grd_height"] = touch_pos_y - DIMMER_LEVEL_PADDING
  gre.set_data(data)
  
  --update the dimmer value
  set_dimmer_level(touch_pos_y)
end

---Convert the position given into a value between the minimum(0) and maximum(35) dimness levels
--@param touch_pos_y The y position of the context_event
function set_dimmer_level(touch_pos_y)
  local level = touch_pos_y - DIMMER_MIN_HEIGHT
  local dimmer_level_perc = (1 - (level/DIMMER_TOTAL_LEVEL_HEIGHT))
  local dimmer_level = dimmer_level_perc * DIMMER_MAX_LEVEL
  local current_level = math.modf(dimmer_level_perc * DIMMER_MAX_LEVEL)
  
  --update the dimness level text
  set_current_level(current_level)
end

---Display the stored dimmer values for the light in context 
local function update_selected_dimmer()
  set_current_level(light_list[selected_light_index].dimness_level)
  
  local data = {}
  data["light_dimmer_layer.slider.grd_y"] = light_list[selected_light_index].y_position - DIMMER_SLIDER_PADDING
  data["light_dimmer_layer.slider_top.grd_height"] = light_list[selected_light_index].y_position - DIMMER_LEVEL_PADDING
  data["light_dimmer_layer.current_level.grd_y"]  = light_list[selected_light_index].y_position - gre.get_value("light_dimmer_layer.current_level.grd_height")/2
  data["light_dimmer_layer.current_light_title.text"] = "LIGHT " .. light_list[selected_light_index].id
  gre.set_data(data)
end

---Updates the current light index to the newly selected light index
--@param direction The requested direction to navigate to determine the new light index
local function update_selected_light_index(direction)
  selected_light_index = selected_light_index + direction
  
  --if the direction exceeds the bounds of the light_list, wrap the index appropriately
  if (selected_light_index < 1) then
    selected_light_index = #light_list
  elseif(selected_light_index > #light_list) then
    selected_light_index = 1
  end
  
  --update dimmer values since the light in context has changed
  update_selected_dimmer()
end

---Navigate the light list incrementally, i.e. to the right
function cb_next_light(mapargs)
  update_selected_light_index(1)
end

---Navigate the light list decrementally, i.e. to the left
function cb_previous_light(mapargs)
  update_selected_light_index(-1)
end

---Round the value passed to the nearest 0.5 using a 25% clamp rule
local function round(n)
  --if the value has a remainder of 0.75 or more, round up. if it is 0.25 or less, round down. Otherwise round by 0.5
  if (n % 1 >= 0.75) then
    return math.ceil(n)
  elseif(n % 1 <= 0.25) then
    return math.floor(n)
  else
    return (n - (n % 1)) + 0.5
  end
end

---Convert the angle generated from the context event into a value between 14 and 26 and then set the text of the control
local function set_temperature_dial_value(angle)
  local angle_perc = angle / math.ceil(TEMP_MAX_ANGLE / TEMP_TOTAL_INT_VALUES)
  --pad the calculation by the minimum value of 14
  local angle_value = round(angle_perc + TEMP_MIN_VALUE)
  --if the angle is a whole number, append a ".0"
  if (angle_value % 1 == 0) then
    angle_value = string.format("%s.0", angle_value)
  end
  --add a celcius symbol to the end of the value
  gre.set_value("temperature_dial_layer.temperature_value.text", string.format("%s°C", angle_value))
end

---Callback for when the user interacts with the temperature dial
--calculate the angle from the context_event coordinates
function cb_temperature_dial_touch(mapargs)
  local ev_data = mapargs.context_event_data
  local control_data = gre.get_control_attrs(mapargs.context_control, "x", "y", "width", "height")
  
  local control_width = control_data.width
  local control_height = control_data.height
  local center_x = control_width/2
  local center_y = control_height/2
  local x = ev_data.x - control_data.x
  local y = ev_data.y - control_data.y
  local delta_x = center_x-x
  local delta_y = center_y-y
  
  local angle_from_center = math.deg(math.atan2(delta_y, delta_x))
  local angle = angle_from_center + TEMP_ANGLE_OFFSET
  if angle < 0 then
    angle = angle + 360
  end
  --clamp the angle to either the maximum or minimum possible value, using the halfway point/median of the unselectable area
  if (angle > TEMP_MAX_ANGLE and angle < TEMP_OUTBOUND_ANGLE_MEDIAN) then
    angle = TEMP_MAX_ANGLE
  elseif(angle > TEMP_OUTBOUND_ANGLE_MEDIAN) then
    angle = 0
  end
  
  local data = {}
  data["temperature_dial_layer.temperature_dial.angle"] = angle
  gre.set_data(data)
  
  set_temperature_dial_value(angle)
end
