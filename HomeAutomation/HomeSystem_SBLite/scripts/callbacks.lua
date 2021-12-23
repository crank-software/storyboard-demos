local TEMP_ANGLE_OFFSET = 53
local TEMP_MAX_ANGLE = 287
local TEMP_OUTBOUND_ANGLE_MEDIAN = 323.5

local TEMP_MIN_VALUE = 14
local TEMP_MAX_VALUE = 26 

local DIMMER_MIN_LEVEL = 0
local DIMMER_MAX_LEVEL = 35

local selected_light_index = 1
local light_list = {
 {id = 1, value = DIMMER_MIN_LEVEL },
 {id = 2, value = DIMMER_MIN_LEVEL },
 {id = 3, value = DIMMER_MIN_LEVEL },
 {id = 4, value = DIMMER_MIN_LEVEL }
}

--- On startup, setup default light values
function cb_init(mapargs) 
  sync_dimmer_ui_to_value(light_list[selected_light_index])
end

function ypos_to_dimmer_value(ypos)
  --Offset in the touch area, convert to a dimmer value
  local cInfo = gre.get_control_attrs("light_dimmer_layer.dimmer_ref_area", "y", "height")

  -- Normalize the value relative to the reference control
  if(ypos > (cInfo.y + cInfo.height)) then
    ypos = cInfo.y + cInfo.height
  elseif(ypos < cInfo.y) then
    ypos = cInfo.y
  end

  -- Calculate the percent complete running from bottom (0) to top (100)
  local percent = 1 - ((ypos - cInfo.y) / cInfo.height)
  
  -- Apply the percent as a value
  return DIMMER_MIN_LEVEL + ((DIMMER_MAX_LEVEL - DIMMER_MIN_LEVEL) * percent)
end

-- This function centers a control on the specified X/Y position
function center(cname, x, y)
  local cInfo = gre.get_control_attrs(cname, "width", "height")
  
  local attrs = {}
  if(x) then
    attrs["x"] = math.floor(x - (cInfo.width / 2))
  end
  if(y) then
    attrs["y"] = math.floor(y - (cInfo.height / 2))
  end
  gre.set_control_attrs(cname, attrs)
end

-- This function extends the controls height, width to a specified Y/Y position
function extend(cname, x, y)
  local cInfo = gre.get_control_attrs(cname, "x", "y", "width", "height")
  --Normalize since we can only extend, not move
  if(x and x < cInfo.x) then
    x = cInfo.x
  end
  if(y and y < cInfo.y) then
    y = cInfo.y
  end

  local attrs = {}
  if(x) then
    attrs["width"] = x - cInfo.x
  end
  if(y) then
    attrs["height"] = y - cInfo.y
  end
  gre.set_control_attrs(cname, attrs) 
end

--
-- Dimmer
-- 

function dimmer_value_to_ypos(value)
  local percent = (value - DIMMER_MIN_LEVEL) / (DIMMER_MAX_LEVEL - DIMMER_MIN_LEVEL)

  --Offset in the touch area, convert to a dimmer value
  local cInfo = gre.get_control_attrs("light_dimmer_layer.dimmer_ref_area", "y", "height")
  
  --Invert the percentage to grow from the bottom
  return math.floor(cInfo.y + (cInfo.height * (1 - percent)))
end

-- Synchronize the value of the dimmer data model with the 
-- UI presentation (slider, color bar, text control) 
--move the slider, level text control, and level indicator to the touch position
function sync_dimmer_ui_to_value(dimmer)
  local ypos = dimmer_value_to_ypos(dimmer.value)
  
  center("light_dimmer_layer.slider", nil, ypos)
  center("light_dimmer_layer.current_level", nil, ypos)
  extend("light_dimmer_layer.slider_top", nil, ypos)  
  
  -- Display the minimum and maximum values as a string instead of as a number
  local label
  if (dimmer.value <= DIMMER_MIN_LEVEL) then
    label = "MIN"
  elseif(dimmer.value >= DIMMER_MAX_LEVEL) then
    label = "MAX"
  else
    label = string.format("%d", dimmer.value)
  end
  gre.set_value("light_dimmer_layer.current_level.text", label)  
 
  gre.set_value("light_dimmer_layer.current_light_title.text", "LIGHT " .. dimmer.id)
end

---Callback when the user adjusts the dimmer level
--store the y position of the context event and use it to set the positions of the level slider, level text, and level indicator 
function cb_light_dimmer_touch(mapargs)
  local ev_data = mapargs.context_event_data

  local dimmer_value = ypos_to_dimmer_value(ev_data.y)
  light_list[selected_light_index].value = dimmer_value

  sync_dimmer_ui_to_value(light_list[selected_light_index])  
end


---Updates the current light index to the newly selected light index
--@param direction The requested direction to navigate to determine the new light index
local function update_selected_light_index(direction)
  selected_light_index = selected_light_index + direction
  
  -- If the direction exceeds the bounds of the light_list, wrap the index appropriately
  if (selected_light_index < 1) then
    selected_light_index = #light_list
  elseif(selected_light_index > #light_list) then
    selected_light_index = 1
  end
  
  -- Update dimmer values since the light in context has changed
  sync_dimmer_ui_to_value(light_list[selected_light_index])
end

---Navigate the light list incrementally, i.e. to the right
function cb_next_light(mapargs)
  update_selected_light_index(1)
end

---Navigate the light list decrementally, i.e. to the left
function cb_previous_light(mapargs)
  update_selected_light_index(-1)
end

--
-- Light switches
--

---toggle the selected light switch on and off
function cb_light_toggle_touch(mapargs)
  local status_var = mapargs.context_group .. ".status"
  local status = gre.get_value(status_var)
  local new_status
  
  --check for the current status and then set it to the opposite value, then play the animation
  if (status == 0) then
    new_status = 1
    gre.send_event_target("turn_light_on_event", mapargs.context_control)
  else
    new_status = 0
    gre.send_event_target("turn_light_off_event", mapargs.context_control)
  end
  
  gre.set_value(status_var, new_status)
end

--
-- Temperature Dial
--

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
  local angle_perc = angle / math.ceil(TEMP_MAX_ANGLE / (TEMP_MAX_VALUE - TEMP_MIN_VALUE))
  
  -- Pad the calculation
  local value = TEMP_MIN_VALUE + round(angle_perc)
 
  -- Show one decimal place of formatting
  local label = string.format("%2.1f°C", value)
  
  --add a celcius symbol to the end of the value
  gre.set_value("temperature_dial_layer.temperature_value.text", label)
end

---Callback for when the user interacts with the temperature dial
--calculate the angle from the context_event coordinates
function cb_temperature_dial_touch(mapargs)
  local ev_data = mapargs.context_event_data
  local control_data = gre.get_control_attrs(mapargs.context_control, "x", "y", "width", "height")

  local touch_x = ev_data.x
  local touch_y = ev_data.y  
  local control_cx = control_data.x + (control_data.width / 2)
  local control_cy = control_data.y + (control_data.height / 2)
    
  local angle_from_center = math.deg(math.atan2(control_cy - touch_y, control_cx - touch_x))
  
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
  
  gre.set_value("temperature_dial_layer.temperature_dial.angle", angle)
  
  set_temperature_dial_value(angle)
end
