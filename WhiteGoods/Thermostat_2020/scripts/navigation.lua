require "utilities"

-- local globals
-- Table which stores: the translation key for the title, image icon, and layer path for each menu setting
local settings_menu = {
  [1] = {title = "id_18", icon = "images/icn_settings.png", layer_name = "mode_general_settings_layer"},
  [2] = {title = "id_19", icon = "images/icn_house.png", layer_name = "mode_house_settings_layer"},
  [3] = {title = "id_20", icon = "images/icn_voice.png", layer_name = "mode_voice_settings_layer"},
  [4] = {title = "id_21", icon = "images/icn_security.png", layer_name = "mode_security_settings_layer"}
}

-- Table which stores the translation keys for each title of the main menu
local main_menu_translation_ids = {
  [1] = {id = "id_29"},
  [2] = {id = "id_30"},
  [3] = {id = "id_31"},
  [4] = {id = "id_32"},
  [5] = {id = "id_33"},
  [6] = {id = "id_34"},
  [7] = {id = "id_35"}
}

-- Tracks which settings page was viewed last
local current_settings_index = 1

---
-- called when the weather navigation control has been pressed
-- triggers correct pre_transition navigation animation to the weather screen.
-- @param gre#context mapargs
-- @return nothing
-- 
function cb_weather_press(mapargs) 
  local current_screen = mapargs.context_screen
  
  if (current_screen == "weather") then
    return
  elseif (current_screen == "thermostat") then
    gre.animation_trigger("pre_transition_thermostat_to_weather")
  elseif (current_screen == "settings") then
    gre.animation_trigger("pre_transition_settings_to_weather")
    --pause ffmpeg playback
    gre.send_event("MEDIA_STOP")
  end
  
  --prevent selection of a different destination screen for navigation.
  disable_navigation()
end

---
-- called when the thermostat navigation control has been pressed
-- triggers correct pre_transition navigation animation to the thermostat screen.
-- @param gre#context mapargs
-- @return nothing
-- 
function cb_thermostat_press(mapargs)
  local current_screen = mapargs.context_screen
  
  if (current_screen == "thermostat") then
    return
  elseif (current_screen == "weather") then
    --trigger weather to thermostat animation
    gre.animation_trigger("pre_transition_weather_to_thermostat")
    --pause ffmpeg playback
    gre.send_event("MEDIA_STOP")
  elseif (current_screen == "settings") then
    gre.animation_trigger("pre_transition_settings_to_thermostat")
    --pause ffmpeg playback
    gre.send_event("MEDIA_STOP")
  end
    
  --prevent selection of a different destination screen for navigation.
  disable_navigation()
end

---
-- triggered when the settings navigation control has been pressed
-- triggers correct pre_transition navigation animation to the settings screen.
-- @param gre#context mapargs
-- @return nothing
-- 
function cb_settings_press(mapargs)
  local current_screen = mapargs.context_screen
  
  if (current_screen == "settings") then
    return
  elseif (current_screen == "weather") then
    --trigger weather to thermostat animation
    gre.animation_trigger("pre_transition_weather_to_settings")
    --pause ffmpeg playback
    gre.send_event("MEDIA_STOP")
  elseif (current_screen == "thermostat") then
    gre.animation_trigger("pre_transition_thermostat_to_settings")
  end
    
  --prevent selection of a different destination screen for navigation.
  disable_navigation()
end

---
-- triggered by the completion of a pre_transition animation.
-- transitions to respective screen and calls the corresponding post_transition animation.
-- @param gre#context mapargs
-- @return nothing
-- 
function transition_screens(mapargs)
  local target_screen
  local pre_transition_anim
  local post_transition_anim
  
  -- using string manipulation, deconstruct the pre_transition animation event string 
  -- to determine correct post_transition animation to trigger.
  string.gsub(mapargs.context_event,"_to_(.*)", function(a)  target_screen = a end )
  string.gsub(mapargs.context_event,"complete.(.*)", function(a)  pre_transition_anim = a end )
  post_transition_anim = string.gsub(pre_transition_anim,"pre", "post", 1)
  
  gre.set_value("target_screen", target_screen)
  gre.send_event("screen_navigate")
  
  gre.animation_trigger(post_transition_anim)
end

---
-- triggerd when a navigation selection has been made to transition to a new screen.
-- updates the position of the navigation bar
-- @param gre#context mapargs
-- @return nothing
-- 
function cb_update_nav_selection(mapargs)
  --Get the center of the new navigation selection
  local x = gre.get_value(string.format("%s.grd_x", mapargs.context_control))
  local width = gre.get_value(string.format("%s.grd_width", mapargs.context_control))
  local center_x = x + (width/2)
  --Get the center of the current navigation selection
  local current_x = gre.get_value("navigation_layer.nav_bar_selected.grd_x")
  local nav_width = gre.get_value("navigation_layer.nav_bar_selected.grd_width")
  local current_center_x = current_x + (nav_width/2)
  
  
  --setup nav bar animation
  local total_steps = 10
  for i = 1, total_steps do
    local t = i/total_steps
    local p = spring_wobbly(t)
    
    local position = lerp(current_center_x,center_x,p)
    -- sets table values to be used as keyframes in nav_bar_movement_tween animation.
    gre.set_value(string.format("navigation_layer.nav_anim_values.1.%d", i), position - (nav_width/2))
  end

  gre.animation_trigger("nav_bar_movement_tween")
end

---
-- triggered when the settings navigation arrows have been pressed
-- Handles the transition to the new settings menu
-- @param gre#context mapargs
-- @return nothing
-- 
function cb_settings_navigation(mapargs)
  local data = {}
  local start_x
  local direction = tonumber(mapargs.direction)
  local new_index
  
  
  -- sets start_x value to be used for settings_change_menu animation
  -- this controls which direction the settings icon will move to in the animation
  -- it is based on which direction the user has selected.
  if (direction == -1) then
    start_x = 30
  elseif (direction == 1) then
    start_x = 280
  end
  
  -- increment the settings index to track last viewed settings menu
  new_index = current_settings_index + direction
  
  -- clip index to bounds.
  if (new_index < 1 ) then
    new_index = #settings_menu
  elseif (new_index > #settings_menu) then
    new_index = 1
  end
  current_settings_index = new_index
  
  data["mode_circle_layer.mode_control.target_title"] = gre.get_value(string.format("translations.%s",settings_menu[current_settings_index].title))
  data["mode_circle_layer.mode_control.target_image"] = settings_menu[current_settings_index].icon
  data["mode_circle_layer.mode_control.destination_x"] = start_x
  
  -- show settings menu content
  update_settings_menu()
  
  gre.set_data(data)
  gre.animation_trigger("settings_change_menu")
end

---
-- Initialize the visual content of the settings menu on gre.init.
-- @return nothing
-- 
function cb_init_settings_menu()
  local settings_title
  local settings_icon
  local data = {}

  -- set setting icon image and text
  data["mode_circle_layer.mode_control.text"] = gre.get_value(string.format("translations.%s",settings_menu[current_settings_index].title))
  data["mode_circle_layer.mode_control.image"] = settings_menu[current_settings_index].icon
  
  -- display the correct menu for the current setting mode.
  for i = 1, #settings_menu do
    if (i == current_settings_index) then
      data[string.format("settings.%s.grd_hidden",settings_menu[i].layer_name)] = 0
    else
      data[string.format("settings.%s.grd_hidden",settings_menu[i].layer_name)] = 1
    end
  end
  
  
  gre.set_data(data)
end

---
-- displays the correct menu options when the settings menu has changed.
-- @return nothing
-- 
function update_settings_menu()
  local settings_title
  local settings_icon
  local data = {}
  
  -- unhides the correct menu options layer as determined by current_settings_index, and hides the rest.
  for i = 1, #settings_menu do
    if (i == current_settings_index) then
      data[string.format("%s.target_hidden",settings_menu[i].layer_name)] = 0
    else
      data[string.format("%s.target_hidden",settings_menu[i].layer_name)] = 1
    end
  end
  
  gre.set_data(data)
end

---
--  handles navigation from the main menu side panel.
--  @param gre#context mapargs
--  @return nothing
--  
function cb_main_menu_navigation(mapargs)
  local target_screen = mapargs.target_screen
  if (target_screen == "" or target_screen == nil) then return end
  
  -- check if navigating to one of the settings' sub menus
  for i = 1, #settings_menu do
    if (gre.get_value(string.format("translations.%s",settings_menu[i].title)) == string.upper(target_screen)) then
      -- update the settings menu to the correct submenu.
      -- this is because each submenu is just a layer on the "settings" screen
      current_settings_index = i
      update_settings_menu()
      target_screen = "settings"
      break
    end
  end
  
  -- trigger the correct navigation/transition functions and animations. 
  local cb_func = _G[string.format("cb_%s_press",target_screen)]
  if (cb_func ~= nil) then
    gre.animation_trigger("main_menu_close")
    cb_func(mapargs)
    
    local nav_mapargs = {}
    nav_mapargs.context_control = string.format("navigation_layer.%s_control", target_screen)
    cb_update_nav_selection(nav_mapargs)
  end
end

---
-- sets all navigation controls to inactive.
-- gets re-enabled by data change upon transition animation complete.
-- @return nothing
-- 
function disable_navigation()
  local data = {}
  data["navigation_layer.weather_control.grd_active"] = 0
  data["navigation_layer.settings_control.grd_active"] = 0
  data["navigation_layer.thermostat_control.grd_active"] = 0
  data["main_menu_side_panel_layer.main_menu.grd_active"] = 0

  gre.set_data(data)
end

---
-- updates strings on settings screen when language changes
-- @return nothing
-- 
function update_settings_translation()
  local data = {}
  
  data["mode_circle_layer.mode_control.text"] = gre.get_value(string.format("translations.%s",settings_menu[current_settings_index].title))
  
  -- security
  local unarmed_translation_id = "id_27"
  local armed_translation_id = "id_28"
  
  if ( armed_status == 0 ) then
    data["mode_security_settings_layer.security_status_control.text"] = gre.get_value("translations." .. unarmed_translation_id)
  elseif (armed_status == 1) then
    data["mode_security_settings_layer.security_status_control.text"] = gre.get_value("translations." .. armed_translation_id)
  end
  
  gre.set_data(data)
end

---
-- updates strings on main menu side panel when language changes
-- @return nothing
-- 
function update_main_menu_translation()
  local data = {}
  for i = 1, #main_menu_translation_ids do
    data[string.format("main_menu_side_panel_layer.main_menu.text.%s.1",i)] = gre.get_value(string.format("translations.%s",main_menu_translation_ids[i].id))
  end
  gre.set_data(data)
end