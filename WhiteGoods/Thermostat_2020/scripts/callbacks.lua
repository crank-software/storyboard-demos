-- local globals
local TOGGLE_LEFT_POS = 643
local TOGGLE_RIGHT_POS = 690
local ACTIVE_SLIDER
local SECURITY_PIN = 1278
local LANGUAGES = {"english", "german", "french"}
local MAX_BRIGHTNESS = 200
local min_temp = 8
local max_temp = 35

-- globals
armed_status = 0
VarLoader = require("VariableLoader")

---
-- triggered on press of any toggle control
-- handles the repositioning of the toggle, and displaying of the correct text value
-- @param gre#context mapargs
-- @return nothing
function cb_toggle(mapargs) 
  local data = {}
  local current_value = mapargs.current_value
  local context_group = mapargs.context_group
  -- all toggles send along their possible left/right values. Some will be translation keys, we have to check for that.
  local left_value = gre.get_value(string.format("translations.%s",mapargs.left_value)) or mapargs.left_value
  local right_value = gre.get_value(string.format("translations.%s",mapargs.right_value)) or mapargs.right_value
  -- toggles send along their callback function names.
  local cb_var = context_group .. '.callback'
  local cb_name = gre.get_value(cb_var)
  
  -- 0 represents left value, 1 represents right value.
  -- flips to the opposite value.
  if (current_value == 0) then
    data[string.format("%s.toggle.current_value",context_group)] = 1
    data[string.format("%s.toggle.new_text_value",context_group)] = right_value
    data[string.format("%s.toggle.toggle_x_position",context_group)] = TOGGLE_RIGHT_POS
  elseif (current_value == 1) then
    data[string.format("%s.toggle.current_value",context_group)] = 0
    data[string.format("%s.toggle.new_text_value",context_group)] = left_value
    data[string.format("%s.toggle.toggle_x_position",context_group)] = TOGGLE_LEFT_POS
  end
  
  gre.set_data(data)
  
  -- execute the callback functions captured by the incoming toggle data
  local cb_func = _G[cb_name]
  if (cb_func == nil or type(cb_func) ~= 'function') then
    return
  end
  
  cb_func(context_group)
end

---
-- handle press events on slider controls
-- @param gre#context mapargs 
-- @return nothing
function cb_slider_press(mapargs)
  ACTIVE_SLIDER = mapargs.context_group
  -- update the active slider's properties
  slider_setup(mapargs)
end

---
-- handle motion events on slider controls
-- @param gre#context mapargs 
-- @return nothing
function cb_slider_motion(mapargs)
  if (ACTIVE_SLIDER == nil) then
    return
  end
  
  if (ACTIVE_SLIDER == mapargs.context_group) then
    -- if the motion event has occurred on the active slider, update it's properties
    slider_setup(mapargs)
  end
end

---
-- handle release events on slider controls
-- @param gre#context mapargs
-- @return nothing
function cb_slider_release(mapargs)
  ACTIVE_SLIDER = nil
end

---
-- handle outbound events on slider controls
-- @param gre#context mapargs
-- @return nothing
function cb_slider_outbound(mapargs)
  ACTIVE_SLIDER = nil
end

---
-- updates the given slider's properties: dot position, fill length, percentage, and callbacks
-- @param gre#context mapargs
-- @return nothing
function slider_setup(mapargs)
  local dk_data = {}
  local press_pos, group_pos, slider_width, percentage
  local event_data = mapargs.context_event_data
  local data = {}
  local cb_var = mapargs.context_group .. '.callback'
  local cb_name = gre.get_value(cb_var)
  local slider_x_path = string.format("%s.grd_x", ACTIVE_SLIDER)
  local slider_width_path = string.format("%s.base_control.grd_width", ACTIVE_SLIDER)
  local slider_fg_width_path = string.format("%s.base_control.width", ACTIVE_SLIDER)
  local slider_dot_x_path = string.format("%s.slider_control.grd_x", ACTIVE_SLIDER)
  local slider_overlay_x_path = string.format("%s.overlay_control.grd_x", ACTIVE_SLIDER)
  local minimum_value = 1
  local padding = 1
    
  -- Get the necessary data for the slider in context
  dk_data = gre.get_data(slider_x_path, slider_width_path)
  
  group_pos = dk_data[slider_x_path]
  slider_width = dk_data[slider_width_path]

  -- calculate the slider position based off of where the user selected while accommodating for 
  -- the x position of the slider group, and padding. 
  press_pos = (event_data.x - group_pos) + padding
  
  -- clamp the circle/dot's newly calculated x position so that it does not go outside
  -- the bounds of the slider.
  if (press_pos > slider_width) then
    press_pos = slider_width
  elseif (press_pos < minimum_value) then
    press_pos = minimum_value
  end

  -- The percentage of the slider that is filled up
  -- Pass this into the slider's associated callback functions
  percentage = (press_pos / slider_width) * 100
  percentage = math.ceil(percentage)

  data[slider_fg_width_path] = press_pos
  data[slider_dot_x_path] = press_pos - 22
  data[slider_overlay_x_path] = press_pos - 34
  gre.set_data(data)
  
  -- check if a callback function has been specified
  local cb_func = _G[cb_name]
  if (cb_func == nil or type(cb_func) ~= 'function') then
    return
  end
  
  -- call the callback function and pass the slider's percentage 
  cb_func(percentage)
end

---
-- updates the global brightness of the application
-- @param percent the percentage that the slider was filled.
-- @return nothing
function cb_update_global_brightness(percent)
  local calc_percent = percent/100
  
  -- There is a layer containing a black fill control in front of everything else.
  -- adjust the alpha value to increase/decrease "brightness"
  gre.set_value("transparency_layer.transparency_control.alpha", MAX_BRIGHTNESS - (MAX_BRIGHTNESS * calc_percent))
end

---
-- show the main menu side panel when the menu icon is pressed
-- @param gre#context mapargs
-- @return nothing
function cb_open_main_menu(mapargs)
  -- trigger the main menu open animation
  gre.animation_trigger("main_menu_open")
end

---
-- close the main menu side panel
-- @param gre#context mapargs
-- @return nothing
function cb_close_main_menu(mapargs)
  -- trigger the main menu close animation
  gre.animation_trigger("main_menu_close")
end

---
-- update the temperature value when the increase/decrease temp control is pressed
-- @param gre#context mapargs
-- @return nothing
function cb_update_temp(mapargs)
  local delta = tonumber(mapargs.delta)
  local current_temp = gre.get_value("current_temp")
  local new_temp
  local data = {}
  
  -- clamp the new temperature to min and max temperatures
  if (current_temp + delta > max_temp or current_temp + delta < min_temp) then
    new_temp = current_temp
  else
    new_temp = current_temp + delta
  end
  
  data["current_temp"] = new_temp
  data["thermostat_layer.temperature.text"] = string.format("%dº",new_temp)
  gre.set_data(data)
end

-- buffer containing the numpad keys pressed
local sec_buffer = ""

---
-- record the keys pressed on the security numpad
-- @param gre#context mapargs
-- @return nothing
function cb_numpad_key_press(mapargs)
  local input_val = mapargs.value

  -- handle if the user has selected delete, clear, or a regular key
  if (input_val == "del") then
    -- remove the last entered character
    sec_buffer = string.sub(sec_buffer,1,string.len(sec_buffer)-1)
  elseif (input_val == "clr") then
    -- clear the buffer
    sec_buffer = ""
  elseif (string.len(sec_buffer) < 4) then
    -- append the latest key to the buffer
    sec_buffer = string.format("%s%s",sec_buffer,input_val)
  else
    -- if the buffer already contains 4 characters, return
    return
  end
  
  gre.set_value("mode_security_settings_layer.pin_box.text",sec_buffer)
end

---
-- Checks if the entered key combination is the correct security pin
-- @param gre#context mapargs
-- @return nothing
function cb_security_ok_press(mapargs)
  -- SECURITY_PIN is hardcoded to 1278
  if (tonumber(sec_buffer) == SECURITY_PIN) then
    -- if PIN is correct, update the system's "armed" status and clear the security buffer and keypad text
    update_armed_status()
    sec_buffer = ""
    gre.set_value("mode_security_settings_layer.pin_box.text", "")
  end
end

---
-- flips the armed status between armed and unarmed status.
-- updates the appropriate labels and translations
-- @return nothing
function update_armed_status()
  local unarmed_translation_id = "id_27"
  local armed_translation_id = "id_28"
  local data = {}
  
  if ( armed_status == 0 ) then
    -- set to armed
    armed_status = 1
    data["mode_security_settings_layer.security_status_control.text"] = gre.get_value("translations." .. armed_translation_id)
    data["mode_security_settings_layer.security_status_control.color"] = gre.get_value("armed_color")
  elseif (armed_status == 1) then
    -- set to unarmed
    armed_status = 0  
    data["mode_security_settings_layer.security_status_control.text"] = gre.get_value("translations." .. unarmed_translation_id)
    data["mode_security_settings_layer.security_status_control.color"] = gre.get_value("unarmed_color")
  else
    return
  end
  
  gre.set_data(data)
end

---
-- play the rain video on the weather screen.
-- @param gre#context mapargs
-- @return nothing
function cb_play_rain_video(mapargs)
  local data = {}
  
  data["video_name"] = "videos/rain-preview.webm"
  data["video_width"] = 800
  data["video_height"] = 480
  data["video_buffer_name"] = "video_3"
  data["video_object_name"] = "/video_3"
  data["weather_layer.weather_circle_group.weather_bg_pic.alpha"] = 0
  gre.set_data(data)
  
  gre.send_event("MEDIA_STOP")
  gre.send_event("MEDIA_START")
  
end


--- 
-- init function called on startup. Sets up the appropriate translations and application-wide settings
-- @param gre#context mapargs
-- @return nothing
function CBInit(mapargs) 
  -- English is the application's base design language so we don't have
  -- to perform any loading initially. If we start with a different language
  -- then we should use loadOnInit to set those initial values.
  local attrs = {}
  attrs.language = "English"
  --attrs.loadOnInit = true
  attrs.textDB = gre.APP_ROOT .. "/translations/translations.csv"
  attrs.attributeDB = gre.APP_ROOT .. "/translations/attributes.csv"
  
  -- set the default language and update the necessary translations
  Translation = VarLoader.CreateLoader(attrs)
  Translation:setLanguage(attrs.language)
  update_active_lang_icon(attrs.language)
  update_dynamic_translations()
  
  -- initialize the screen brightness to max percentage value.
  cb_update_global_brightness(100)
end

---
-- Load the requested language and update translation strings 
-- @param gre#context mapargs
-- @return nothing
function CBLoadLanguage(mapargs)
  Translation:setLanguage(mapargs.language)
  update_dynamic_translations()
end

---
-- update the translations that update based on their value as well as current language.
function update_dynamic_translations()
  update_settings_translation()
  update_main_menu_translation()
  update_toggle_translation()
  update_thermostat_translation()
end

-- table containing toggles whose text changes based on translations
local translation_toggle_groups = {
  "mode_general_settings_layer.temperature_unit_group",
  "mode_general_settings_layer.cooling_heating_group",
  "mode_general_settings_layer.energy_saver_group",
  "mode_voice_settings_layer.microphone_group",
  "mode_voice_settings_layer.play_sound_group",
}
---
-- update the translation strings of the toggle controls
-- @return nothing
function update_toggle_translation()
  local data = {}
  for i = 1, #translation_toggle_groups do
    local current_value = gre.get_value(string.format("%s.toggle.current_value",translation_toggle_groups[i]))
    local left_value = gre.get_value(string.format("%s.toggle.left_value",translation_toggle_groups[i]))
    local right_value = gre.get_value(string.format("%s.toggle.right_value",translation_toggle_groups[i]))

    if (current_value == 0) then
      data[string.format("%s.toggle.text",translation_toggle_groups[i])] = gre.get_value(string.format("translations.%s",left_value))
    elseif (current_value == 1) then
      data[string.format("%s.toggle.text",translation_toggle_groups[i])] = gre.get_value(string.format("translations.%s",right_value))
    end
  end
  gre.set_data(data)
end

---
-- update the thermostat translation strings
-- @return nothing
function update_thermostat_translation()
  local data = {}
  local thermostat_mode = gre.get_value("mode_general_settings_layer.cooling_heating_group.toggle.current_value")
  
  if (thermostat_mode == 0) then
    data["thermostat_layer.mode_control.text"] = gre.get_value("translations.id_42")
  elseif (thermostat_mode == 1) then
    data["thermostat_layer.mode_control.text"] = gre.get_value("translations.id_43")
  end
  
  gre.set_data(data)
end

---
-- updates the language icons to reflect the new active language
-- @param string language the new language to be changed to
function update_active_lang_icon(language)
  local data = {}
  language = string.lower(language)
  for i = 1, #LANGUAGES do
    if (language == LANGUAGES[i]) then
      -- determine the newly selected language, and set that language icon to full alpha
      data[string.format("mode_house_settings_layer.language_%s.alpha",language)] = 255
    else
      -- set all other language icons to reduced alpha
      data[string.format("mode_house_settings_layer.language_%s.alpha",LANGUAGES[i])] = 77
    end
  end
  
  gre.set_data(data)
end

---
-- updates the temperature units between fahrenheit and celsius
-- updates the necessary temperature strings based on the new temp units
-- @param string toggle_group the group containing the toggle in context
-- @return nothing
function cb_toggle_temp_units(toggle_group)
  local new_temp_units = gre.get_value(string.format("%s.toggle.current_value",toggle_group))
  local data_table = gre.get_data("current_temp","thermostat_layer.temperature.text","weather_layer.weather_info_group.tempOutValue.text","weather_layer.weather_info_group.tempHighValue.text","weather_layer.weather_info_group.tempLowValue.text")
  local data = {}
  local translation_key
  
  if (new_temp_units == 0) then
    -- change to fahrenheit
    min_temp = 46
    max_temp = 95
    translation_key = "translations.id_9"
    for k,v in pairs(data_table) do
      -- each temperature value in the data_table contains a degree symbol "º"
      -- in order to convert those temps we have to separate this symbol from the temp
      local temp = string.gsub(v,"%W", "")
      -- call utility function to convert celsius to fahrenheit and add the degree symbol back
      data_table[k] = string.format("%dº",c_to_f(tonumber(temp)))
    end
  elseif (new_temp_units == 1) then
    -- change to celsius
    min_temp = 8
    max_temp = 35
    translation_key = "translations.id_10"
    for k,v in pairs(data_table) do
      local temp = string.gsub(v,"%W", "")
      -- call utility function to convert fahrenheit to celsius and add the degree symbol back
      data_table[k] = string.format("%dº",f_to_c(tonumber(temp)))
    end
  end
  
  data["weather_layer.weather_info_group.tempOutUnit.text"] = gre.get_value(translation_key)
  data["thermostat_layer.Farenheit_Celsius_control.text"] = string.upper(gre.get_value(translation_key))
  gre.set_data(data)
  gre.set_data(data_table)
end

---
-- updates between cooling and heating modes
-- @param string toggle_group the group containing the toggle in context
-- @return nothing
function cb_toggle_cooling_heating(toggle_group)
  local new_mode = gre.get_value(string.format("%s.toggle.current_value",toggle_group))
  local data = {}
  
  -- update the cooling/heating label on the thermostat screen 
  if (new_mode == 0) then
    data["thermostat_layer.mode_control.text"] = gre.get_value("translations.id_42")
  elseif (new_mode == 1) then
    data["thermostat_layer.mode_control.text"] = gre.get_value("translations.id_43")
  end
  
  gre.set_data(data)
end

---
-- triggered when a video completes playback. determines which video completed and replays it.
-- @param gre#context mapargs
-- @return nothing
function cb_media_complete(mapargs)
  local video_title
  -- isolates the video title from the event data
  string.gsub(mapargs.context_event_data.name,"Thermostat_2020/(.*)", function(a)  video_title = a end )
  
  local screen = mapargs.context_screen
  local variable_path
  
  -- depending on screen, the path to the control containing external render extension is different 
  if (screen == "settings") then
    variable_path = "mode_circle_layer.video"
  elseif(screen == "weather") then
    variable_path = "weather_layer.weather_circle_group.weather_bg_pic"
  else
    return
  end
  
  -- get variable paths to playback data associated to the external render extension of that screen
  local media_width = string.format("%s.media_width", variable_path)
  local media_height = string.format("%s.media_height", variable_path)
  local media_ext_buf = string.format("%s.media_ext_buf", variable_path)
  local media_obj = string.format("%s.media_obj", variable_path)
  local data_table = gre.get_data(media_width, media_height, media_ext_buf, media_obj)
  
  local data = {}
  
  -- set the gra.media.new.video action data to be called by the MEDIA_START event we will send. 
  data["video_name"] = video_title
  data["video_width"] = data_table[media_width]
  data["video_height"] = data_table[media_height]
  data["video_buffer_name"] = data_table[media_ext_buf]
  data["video_object_name"] = data_table[media_obj]
  
  gre.set_data(data)
  
  -- send the MEDIA_START event to trigger playback of the video that just completed.
  gre.send_event("MEDIA_START")
end
