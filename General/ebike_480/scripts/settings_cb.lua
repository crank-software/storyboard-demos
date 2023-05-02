---
-- Handles the call back in the settings screen


local btn_handle = require('btn_handler')

local settings_layer = "settings_layer"
local menu_layer = "menu_layer"
local bg_layer = "overlay_layer"

---
-- A table to hide layers
local hide_layer_table = {
  alpha = 255,
  hidden = true,
  active = false,
  x = 0,
  y = 0,
  width = screen_width,
  height = screen_height
}

---
-- A table to show layers
local show_layer_table = {
  alpha = 255,
  hidden = false,
  active = true,
  x = 0,
  y = 0,
  width = screen_width,
  height = screen_height
}

---
-- Initializes the layers
function initialize_layers()

  local screen_width = 480
  local screen_height = 272 
  settings_table = hide_layer_table
  menu_table = show_layer_table
  bg_table = {
    alpha = 255,
    hidden = false,
    active = false,
    x = 0,
    y = 0,
    width = screen_width,
    height = screen_height
  }

  gre.set_layer_attrs_global(
    settings_layer,
    settings_table
  )

  gre.set_layer_attrs_global(
    menu_layer,
    menu_table
  )

  gre.set_layer_attrs_global(
    bg_layer,
    bg_table
  )

end

--- @param group The group to be made active
-- Switches to the settings layer
local active_group = nil
function switch_to_settings(group)
  gre.set_layer_attrs_global(
    settings_layer,
    show_layer_table
  )

  gre.set_layer_attrs_global(
    menu_layer,
    hide_layer_table
  )

  local show_group = {
    x = 0,
    y = 0,
    hidden = false
  }

  gre.set_group_attrs(
    group,
    show_group
  )

  active_group = group
end

---
-- Switches to the menu
function switch_to_menu()
  gre.set_layer_attrs_global(
    settings_layer,
    hide_layer_table
  )

  gre.set_layer_attrs_global(
    menu_layer,
    show_layer_table
  )

  local hide_group = {
    x = 0,
    y = 0,
    hidden = true
  }

  gre.set_group_attrs(
    active_group,
    hide_group
  )

  active_group = nil
  update_confirm_button(nil)

end

--- @param func The function that the confirm button will execute. Will be recorded into the lambda variable
-- Updates the confirm button function. Great for adding back-end functionality (which isn't implemented)
-- If func is nil, then there will be no confirm button
local lambda = nil
function update_confirm_button(func)
  lambda = func
  table = {
    x = 356,
    y = 205,
    width = 70,
    height = 35,
    hidden = true,
    active = false,
    zindex = 30,
    findex = 30,
    effect = nil,
    mask_enabled = false
  }


  if(lambda == nil)then
    gre.set_control_attrs(
      "settings_layer.btn_close_control",
      table
    )
  else
    table["hidden"] = false
    table["active"] = true
    gre.set_control_attrs(
      "settings_layer.btn_close_control",
      table
    )
    table["x"] = 54
    table["y"] = 205
    table["hidden"] = false
    table["active"] = true
    gre.set_control_attrs(
      "settings_layer.btn_back_control",
      table
    )
  end
end

---
-- Called when the confirm button has been pressed.
function lambda_cb()
  if(lambda == nil) then
    print("Callback on undefined function")
    switch_to_menu()
    return
  end
  lambda()
  switch_to_menu()
end

---
-- Updates the settings, more of a helper function to reduce lines of code
local function update_settings_function(group, string, func)
  switch_to_settings(group)
  gre.set_value("settings_layer.settings_title.text", string)
  update_confirm_button(func)
end

---
-- Updates the units in the eBike screen
function units_cb(mapargs)
  local group = "settings_layer.units_group"
  local units = "Units"
  local change_loc = "eBike.units" 
  local other_loc = "eBike.per_unit_text"
  local units_prompt = function () 
    if(get_unit_id() == 1) then
      gre.set_value(change_loc, "m") 
      gre.set_value(other_loc, "ph")
    else
      gre.set_value(change_loc, "km")
      gre.set_value(other_loc, "/h")
    end
  end
  
  update_settings_function(group, units, units_prompt)
end

---
-- Updates the time in the eBike screen
function time_format_cb(mapargs)
  local group = "settings_layer.time_group"
  local time = "Time Format"
  local time_prompt = function () end
  
  update_settings_function(group, time, time_prompt)
end

---
-- Toggle button active, does nothing else
function lights_cb(mapargs)
  local group = "settings_layer.light_group"
  local lights = "Lights"
  local lights_prompt = function () end
  
  update_settings_function(group, lights, lights_prompt)
end

---
-- Pseudo-Shutdowns down the application. Will output a message to the console instead.
-- Shutdown prompt can be updated to truly shutdown the application
function shutdown_cb(mapargs)
  local group = "settings_layer.shutdown_group"
  local shutdown = "Shutdown"
  local shutdown_prompt = function ()
    local cell_id = gre.get_value("settings_layer.shutdown_group.Table.grd_yoffset") 
    cell_id = -cell_id / 25 + 3

    print(shutdown .. ' ' .. cell_id .. ' minutes') 
  end

  update_settings_function(group, shutdown, shutdown_prompt)

end

---
-- Table for the back button
local back_btn_table = {
  x = 54,
  y = 205,
  width = 70,
  height = 35,
  hidden = true,
  active = false,
  zindex = 30,
  findex = 30,
  effect = nil,
  mask_enabled = false
}

---
-- Pseudo-resets the application. If the user the clicks on the "Yes" button, a redirection to the eBike screen will occur
-- Otherwise they will be taken to the settings menu
function reset_cb(mapargs)
  local group = "settings_layer.reset_group"
  local reset = "Reset"
  local reset_prompt = nil

  back_btn_table[hidden] = true
  back_btn_table[active] = false
  gre.set_control_attrs(
      "settings_layer.btn_back_control",
      back_btn_table
    )
  update_settings_function(group, reset, reset_prompt)

end

---
-- Displays information about the company who created this
function system_cb(mapargs)
  local group = "settings_layer.system_info_group"
  local system = "System Info"
  local system_prompt = nil

  back_btn_table[hidden] = true
  back_btn_table[active] = false
  gre.set_control_attrs(
      "settings_layer.btn_back_control",
      table
    )
  update_settings_function(group, system, system_prompt)

end
