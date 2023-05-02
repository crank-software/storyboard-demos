local menu_active = 1
local menu_select = nil
local mode_current = 2
local new_mode_offset = 190
local frame = "right"

function test_function()
print (menu_active)
end

--// ---------  
-- DATA SETS FOR "frame_layer" MODE CONTENT AND POSITIONING
--// ---------  

local thermostat_data = {
  mode_image = nil,
  mode_label = "",
  bg_mode_image = nil,
  screen = "thermostat_screen",
}

local weather_data = {
  mode_image = "images/icn_weather.png",
  mode_label = "Weather",
  bg_mode_image = "images/mode_bg_weather.png",
  screen = "weather_screen"
}

local security_data = {
  mode_image = "images/icn_security.png",
  mode_label = "Security",
  bg_mode_image = "images/mode_bg_security.png",
  screen = "security_screen"
}

local lights_data = {
  mode_image = "images/icn_light.png",
  mode_label = "Lights",
  bg_mode_image = "images/mode_bg_lighting.png",
  screen = "lighting_screen"
}

local music_data = {
  mode_image = "images/icn_music.png",
  mode_label = "Music",
  bg_mode_image = "images/mode_bg_music.png",
  screen = "music_screen"
}

local mode_left_data = {
  mode_offset = new_mode_offset * -1,
  mode_offset_outgoing = new_mode_offset,
  mask_image = "images/fade_LR.png",
  mask_start_x = -480,
  mask_end_x = 480,
  bg_offset = -100,
}

local mode_right_data = {
  mode_offset = new_mode_offset,
  mode_offset_outgoing = new_mode_offset * -1,
  mask_image = "images/fade_RL.png",
  mask_start_x = 0,
  mask_end_x = -962,
  bg_offset = 100,
}

function outgoing_mode(mapargs)
  
-- if mode 3/4/5/ hide mode mask so it doesn't interfere with transition animation
  if mode_current > 2 and menu_select < 3 then
    local data = {}
      data["mode_mask_layer.bg.grd_hidden"] = true
    gre.set_data(data)
  end


-- set incoming animation
  if menu_select ~= mode_current then
    if menu_select == 1 then
      gre.animation_trigger("thermostat_show")
    elseif menu_select == 2 then
      gre.animation_trigger("weather_show")
    elseif menu_select == 3 then
      security()
    elseif menu_select == 4 then
      lighting()
    elseif menu_select == 5 then
      music()
    end
  else
    -- do nothing
  end

-- set outgoing animation
  if mode_current ~= menu_select then
    if mode_current == 1 then
      gre.animation_trigger("thermostat_hide")
      gre.animation_trigger("thermostat_hide2")
    elseif mode_current == 2 then
      gre.animation_trigger("weather_hide")
    elseif mode_current == 3 then
      security()
    elseif mode_current == 4 then
      lighting()
    elseif mode_current == 5 then
      music()
    end
  else 
    -- do nothing
  end

end


--//------------
--//Transitions security layer on or off of screen 
--//------------
function security(mapargs)
  local data = {}
  local animate = {}


--// handles security mode outoing  
  if mode_current == 3 and menu_select ~= 3 then
    animate = "true"
    data["mode_security_alpha"] = 0 -- fades out
    data["mode_security_cam_alpha"] = 0 -- fades out
    
    if menu_select < 3 then 
      data["mode_security_delta"] = 700 -- pushed to the right
      data["mode_security_cam_delta"] = 700 -- pushed to the right
    elseif menu_select > 3 then
      data["mode_security_delta"] = -700 -- pushed to the left
      data["mode_security_cam_delta"] = -700 -- pushed to the left
    end

  else
--    do nothing
  end

--// handles security mode incoming  
  if menu_select == 3 then 
    animate = "true"
    data["mode_security_alpha"] = 255 -- fades in
    data["mode_security_cam_alpha"] = 255 -- fades in
    
    if mode_current < 3 then
      data["mode_security_delta"] = -700 -- pushed to the left
      data["mode_security_cam_delta"] = -700 -- pushed to the left
    elseif mode_current > 3 then
      print ("mode 4/5 outgoing - mode 3 incoming")
      data["mode_security_delta"] = 700 -- pushed to the right
      data["mode_security_cam_delta"] = 700 -- pushed to the right
    end

  else
--    do nothing
  end

  gre.set_data(data)

  if animate == "true" then
    gre.animation_trigger("security_keypad")
    gre.animation_trigger("security_camera")
  end

end

--//------------
--//Transitions lighting layer on or off of screen 
--//------------
function lighting(mapargs)
  local data = {}
  local animate = {}

--// handles lighting mode outoing  
  if mode_current == 4 and menu_select ~= 4 then
    animate = "true"
    data["mode_lighting_alpha"] = 0 -- fades out
    
    if menu_select < 4 then 
      data["mode_lighting_delta"] = 700 -- pushed to the right
    elseif menu_select > 4 then
      data["mode_lighting_delta"] = -700 -- pushed to the left
    end
  
  gre.set_data(data)
  
  else
--    animate = "false"
  end

--// handles lighting mode incoming  
  if menu_select == 4 then 
    animate = "true"
    data["mode_lighting_alpha"] = 255 -- fades in

    if mode_current < 4 then
      data["mode_lighting_delta"] = -700 -- pushed to the left
    elseif mode_current > 4 then
      data["mode_lighting_delta"] = 700 -- pushed to the right
    end
  
  gre.set_data(data)
  
  else
--    animate = "false"
  end

--  gre.set_data(data)

  if animate == "true" then
    gre.animation_trigger("lighting")
  end

end


--//------------
--//Transitions music layer on or off of screen 
--//------------
function music(mapargs)
  local data = {}
  local animate = {}

--// handles music mode outoing  
  if mode_current == 5 and menu_select ~= 5 then
    animate = "true"
    data["mode_music_alpha"] = 0 -- fades out
    data["mode_music_delta"] = 700 -- incoming always pushed to the right
  else
--    animate = "false"
  end


--// handles music mode incoming  
  if menu_select == 5 then 
    animate = "true"
    data["mode_music_alpha"] = 255 -- fades in
    data["mode_music_delta"] = -700 -- incoming always pushed to the left
  else
--    animate = "false"
  end

  gre.set_data(data)

  if animate == "true" then
    print ("animate music")
    gre.animation_trigger("music")
  end

end


-- // 
-- MENU BUTTONS TRIGGER FUNCTION "mode_selected"
-- //

function mode_selected(mapargs)
local mode = tonumber(mapargs.mode)

  menu_select = mode

-- set incoming mode on left or right
  if menu_select > mode_current then
    set_mode_position(mode_right_data)
  elseif menu_select < mode_current then
    set_mode_position(mode_left_data)
  end

-- set the mode data OR do nothing if current mode is selected
  if menu_select ~= mode_current then
    if menu_select == 1 then
      change_mode(thermostat_data)
    elseif menu_select == 2 then
      change_mode(weather_data)
    elseif menu_select == 3 then
      change_mode(security_data)
    elseif menu_select == 4 then
      change_mode(lights_data)
    elseif menu_select == 5 then
      change_mode(music_data)
    end
  end

  outgoing_mode() -- animates the current mode that's outgoing for the transition to the next mode
  menu() -- highlights the selected menu item
  menu_state() -- sets menu inactive while transition runs
  frame_fill() -- transition to / from frame fill for thermostat
  frame_slide() -- slide frame depending on selected mode
  frame_mode_bar() -- background bar in / out / collapse / expands depending on selection

  
  mode_current = menu_select  -- update the current mode

print ("now mode current is ".. mode_current)
print ("-")

end



--// Populate the incoming controls for the mode. Icon, text and background image
function change_mode(mode_data)
--  mode = mode_data.mode_number
    local data = {}
    data["frame_layer.mode_back.incoming_image"] = mode_data.mode_image 
    data["frame_layer.mode_back.incoming_text"] = mode_data.mode_label
    data["frame_layer.mode_image_back.image"] = mode_data.bg_mode_image
    data["target_screen"] = mode_data.screen
  gre.set_data(data)

  menu_active = 0 -- menu items are disabled during "mode_change" animation transition from one mode to the next
  
  gre.animation_trigger("mode_change")
end

--// Set the position for the incoming controls for the mode. Left / Right / which mask image etc.  
function set_mode_position(position_data)
  local data = {}
  data["frame_layer.mode_back.x3"] = position_data.mode_offset
  data["frame_layer.mode_back.x4"] = position_data.mode_offset
  data["frame_layer.mode_image_front.image"] = position_data.mask_image
  data["frame_layer.mode_image_back.x"] = position_data.bg_offset


--// animation step dynamic values
  data["frame_offset"] = position_data.frame_offset -- SLIDE FRAME animation » offset value
  data["mode_offset"] = position_data.mode_offset_outgoing -- » mode_change animation sends the outgoing mode left or right
  data["mode_mask_start"] = position_data.mask_start_x -- ${app:frame_layer.mode_image_front.x} » mode_change animation
  data["mode_mask_end"] = position_data.mask_end_x -- ${app:frame_layer.mode_image_front.x} » mode_change animation
  gre.set_data(data)
  
end

function reset_selected(mapargs)
  if mode_current == 1 then
    reset_mode(thermostat_data)
  elseif mode_current == 2 then
    reset_mode(weather_data)
  elseif mode_current == 3 then
    reset_mode(security_data)
  elseif mode_current == 4 then
    reset_mode(lights_data)
  elseif mode_current == 5 then
    reset_mode(music_data)
  end
end

function reset_mode(mode_data)

  local data = {}
    data["frame_layer.mode_front.outgoing_image"] = mode_data.mode_image -- set current mode image
    data["frame_layer.mode_front.outgoing_text"] = mode_data.mode_label -- set current mode text
    data["frame_layer.mode_image_front.image2"]= mode_data.bg_mode_image -- set current mode bg image

    data["frame_layer.mode_front.x1"] = 0 -- set current mode position
    data["frame_layer.mode_front.x2"] = 0 -- set current mode position

    data["frame_layer.mode_back.x3"] = 190 -- reset incoming mode image
    data["frame_layer.mode_back.x4"] = 190 -- reset incoming mode text

    data["frame_layer.mode_image_front.image"] = "images/fade_LR.png" -- mode mask image
    data["frame_layer.mode_image_front.x"] = -480 -- mode mask position

  gre.set_data(data)
end

function frame_slide(mapargs)
-- slide frame to center or left
local frame_x = {}
local animate = {}

  if frame == "left" and menu_select < 3 then
      frame_x["frame_offset"] = 345
      frame = "right"
      animate = true
  elseif frame == "left" and menu_select > 2 then
--      print("slide frame - do nothing")
      animate = false
  elseif frame == "right" and menu_select < 3 then
--      print("slide frame - do nothing")
      animate = false
  elseif frame == "right" and menu_select > 2 then
      frame_x["frame_offset"] = -345
      frame = "left"
      animate = true
  end

  gre.set_data(frame_x) -- set direction to slide frame

  if animate == true then
    gre.animation_trigger("slide_frame") 
  end

end

function frame_fill(mapargs)
local fill = {}
-- if mode_current is 1 and menu_select is 1 no animation
  if mode_current == 1 and menu_select == 1 then
  -- do nothing
  elseif mode_current == 1 and menu_select ~= 1 then
    fill = "hide"
-- if mode_current is 2,3,4,5 and menu_select is 1 animate frame fill ON
  elseif mode_current ~= 1 and menu_select == 1 then
    fill = "show"
  end

  if fill == "show" then
    gre.animation_trigger("frame_fill_show") 
  elseif fill == "hide" then
    gre.animation_trigger("frame_fill_hide")
  end

end

function menu(mapargs)
local data = {}

-- fades out the highlighted menu item
  if mode_current == 1 then
    data["menu_layer.thermostat_on"] = 0
    data["menu_layer.thermostat_off"] = 255
  elseif mode_current == 2 then
    data["menu_layer.weather_on"] = 0
    data["menu_layer.weather_off"] = 255
  elseif mode_current == 3 then
    data["menu_layer.security_on"] = 0
    data["menu_layer.security_off"] = 255
  elseif mode_current == 4 then
    data["menu_layer.lighting_on"] = 0
    data["menu_layer.lighting_off"] = 255
  elseif mode_current == 5 then
    data["menu_layer.music_on"] = 0
    data["menu_layer.music_off"] = 255
  end

-- fades in the selected menu item and moves the blue highlight bar
  if menu_select == 1 then
    data["menu_layer.thermostat_on"] = 255
    data["menu_layer.thermostat_off"] = 0
    data["menu_layer.mode_x"] = 348
  elseif menu_select == 2 then
    data["menu_layer.weather_on"] = 255
    data["menu_layer.weather_off"] = 0
    data["menu_layer.mode_x"] = 466
  elseif menu_select == 3 then
    data["menu_layer.security_on"] = 255
    data["menu_layer.security_off"] = 0
    data["menu_layer.mode_x"] = 590
  elseif menu_select == 4 then
    data["menu_layer.lighting_on"] = 255
    data["menu_layer.lighting_off"] = 0
    data["menu_layer.mode_x"] = 706
  elseif menu_select == 5 then
    data["menu_layer.music_on"] = 255
    data["menu_layer.music_off"] = 0
    data["menu_layer.mode_x"] = 825
  end

gre.set_data(data)
gre.animation_trigger("menu")

end

function menu_reset(mapargs)
  menu_active = 1
  menu_state()
end

function menu_state(mapargs)
local data = {}

  data["menu_layer.btn_thermostat.grd_active"] = menu_active
  data["menu_layer.btn_weather.grd_active"] = menu_active
  data["menu_layer.btn_security.grd_active"] = menu_active
  data["menu_layer.btn_lighting.grd_active"] = menu_active
  data["menu_layer.btn_music.grd_active"] = menu_active
  gre.set_data(data)  

end

-- // 
-- DATA SETS FOR MODE BAR TRANSITION ANIMATIONS
-- //

local mode_1_2 = {
  mask_left_x = -150,
  mask_right_x = 0,
  mask_right_img = "images/mode_bar_mask_RL.png",
  bar_y = 198,
  bar_h = 272,
}

local mode_1_3 = {
  mask_left_x = 550,
  mask_right_x_start = -775,
  mask_right_x = 0,
  mask_right_img = "images/mode_bar_mask_RL2.png",
  bar_y = 98,
  bar_h = 472,
}

local mode_2_1 = {
  mask_left_x = 550,
  mask_right_x = -600,
  mask_right_img = "images/mode_bar_mask_RL.png",
  bar_y = 198,
  bar_h = 272,
}

local mode_2_3 = {
  mask_left_x = 550,
  mask_right_x = 0,
  mask_right_img = "images/mode_bar_mask_RL2.png",
  bar_y = 98,
  bar_h = 472,
}

local mode_3_1 = {
  mask_left_x = 550,
  mask_right_x = -775,
  mask_right_img = "images/mode_bar_mask_RL2.png",
  bar_y = 198,
  bar_h = 272,
}

local mode_3_2 = {
  mask_left_x = -150,
  mask_right_x = 0,
  mask_right_img = "images/mode_bar_mask_RL2.png",
  bar_y = 198,
  bar_h = 272,
}

function frame_mode_bar(mapargs)

  if mode_current == 1 and menu_select == 2 then
    print ("1-2")
    mode_bar_transition(mode_1_2)
  elseif mode_current == 1 and menu_select > 2 then
    print ("1-3")
    mode_bar_transition(mode_1_3)
  elseif mode_current == 2 and menu_select == 1 then
    print ("2-1")
    mode_bar_transition(mode_2_1)
  elseif mode_current == 2 and menu_select > 2 then
    print ("2-3")
    mode_bar_transition(mode_2_3)
  elseif mode_current > 2 and menu_select == 2 then
    print ("3-2")
    mode_bar_transition(mode_3_2)
  elseif mode_current > 2 and menu_select == 1 then
    print ("3-1")
    mode_bar_transition(mode_3_1)
  end

end

function mode_bar_transition(end_data)

    local data = {}
    data["left_x"] = end_data.mask_left_x 
    data["frame_sub_layer.mode_bar_right.x"] = end_data.mask_right_x_start -- transition mode_1_3
    data["right_x"] = end_data.mask_right_x 
    data["bar_mask_image"] = end_data.mask_right_img 
    data["y_pos"] = end_data.bar_y 
    data["height"] = end_data.bar_h 
  gre.set_data(data)

  gre.animation_trigger("mode_bar") -- "mode_change" animation complete triggers screen transition
end

