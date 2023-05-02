

--- @param gre#context mapargs
local data = {}
local pointer_main_angle = 0
local count = 12 
local curr_count = 0
local temperature_value = nil
local pressure_value = nil

-- Callback triggered when any cups click control is pressed
-- Updates meter guage pointers rotation start and end value
function set_pressure_bar_angle (mapargs)
  local espresso_bar_point = 41
  local mocha_bar_point = 27
  local latte_bar_point = 27
  local americano_bar_point = 35
  local macchiato_bar_point = 48

  local update_pressure_bar_angle = 0
  local data = {}

  local curr_control = mapargs.context_control

  count = gre.get_value("customize_timer_layer.btn_brew_control.num_sec") - 1
  curr_count = count
  
  -- resets timer countdown indicator value if countdown reaches 0 value
  if count == 0 then
    reset_timer_count()
  end



  if curr_control == "submenu_layer.cups_click_controlGroup.macchiato_click_control" then
    data ["pointer_start_value"] = gre.get_data("pointer_end_value")
    data ["pointer_end_value"] = macchiato_bar_point
    gre.set_data(data)

  elseif curr_control == "submenu_layer.cups_click_controlGroup.latte_click_control" then
    data ["pointer_start_value"]= gre.get_data("pointer_end_value")
    data ["pointer_end_value"]= latte_bar_point
    gre.set_data(data)

  elseif curr_control == "submenu_layer.cups_click_controlGroup.americano_click_control" then
    data ["pointer_start_value"]= gre.get_data("pointer_end_value")
    data ["pointer_end_value"]= americano_bar_point
    gre.set_data(data)

  elseif curr_control == "submenu_layer.cups_click_controlGroup.mocha_click_control" then
    data ["pointer_start_value"]= gre.get_data("pointer_end_value")
    data ["pointer_end_value"]= mocha_bar_point
    gre.set_data(data)

  elseif curr_control == "submenu_layer.cups_click_controlGroup.espresso_click_control" then
    data ["pointer_start_value"]= gre.get_data("pointer_end_value")
    data ["pointer_end_value"]= espresso_bar_point
    gre.set_data(data)
  end
end

-- Callback triggered when pressure gauge animation is complete
-- Sets count down values as timer goes on
function timer_mask()
  if count >=0 then
    gre.set_value("customize_timer_layer.label_timer_value.timer_valu_text", string.format("%s",count))
    count = count-1
  end
end

-- Callback triggered when timer arc animation is complete
-- Resets count down values back to 0 after every timer circle is done
function reset_timer_count()
  count = curr_count
end

-- Callback triggered when infusion scrolling bar is in motion
-- Updates pressure bar with respect to scrolling bar position
function cb_slide_slider(mapargs)
  local offset = gre.get_value("espresso.settings_pre_infusion_scrolling.grd_xoffset")
  gre.set_value("settings_pre_infusion_scrolling.slider_handle.slider_handle_x", offset + 218)
  local offset_start = -200
  local constant = -0.037
  local bar_value = (offset_start - offset)*(constant)
  bar_value = math.floor(bar_value)
  gre.set_value("settings_pre_infusion_layer.set_pressure_control.set_pressure_text", string.format("%s bars",bar_value))
end


-- Callback triggered when temperature plus or minus button is pressed on custom settings
-- Add or minus temperature value
function cb_temp_change(mapargs)
  local temperature_change = nil
  curr_control = mapargs.context_control
  temperature_value = string.match((gre.get_value("customize_settings_layer.set_drink_temp_group.label_temp_value.temperature_text")), '%d+')
  temperature_change = tonumber(temperature_value)
  
  -- Adds 1 to current temperature value
  if curr_control == "customize_settings_layer.set_drink_temp_group.plus_control" then
    temperature_change = temperature_change + 1
    gre.set_value("customize_settings_layer.set_drink_temp_group.label_temp_value.temperature_text", string.format("%sº",temperature_change))
  
  -- Subtracts 1 from current temperature value
  elseif curr_control == "customize_settings_layer.set_drink_temp_group.minus_control" then
    temperature_change = temperature_change - 1
    gre.set_value("customize_settings_layer.set_drink_temp_group.label_temp_value.temperature_text", string.format("%sº",temperature_change))
  end
end

-- Callback triggered when pressure plus or minus button is pressed on custom settings
-- Add or minus pressure value
function cb_pressure_change(mapargs)
  local pressure_change = nil
  curr_control = mapargs.context_control
  pressure_value = gre.get_value("customize_settings_layer.set_drink_pressure_group.label_bar_value.pressure_val_text")
  pressure_change = tonumber(pressure_value)
  
  -- Adds .5 to current pressure value
  if curr_control == "customize_settings_layer.set_drink_pressure_group.plus_control" then
    pressure_change = pressure_change + 0.5
    gre.set_value("customize_settings_layer.set_drink_pressure_group.label_bar_value.pressure_val_text", string.format("%s",pressure_change))

  -- Subtracts 1 from current pressure value
  elseif curr_control == "customize_settings_layer.set_drink_pressure_group.minus_control" then
    pressure_change = pressure_change - 0.5
    gre.set_value("customize_settings_layer.set_drink_pressure_group.label_bar_value.pressure_val_text", string.format("%s",pressure_change))
  end
end


