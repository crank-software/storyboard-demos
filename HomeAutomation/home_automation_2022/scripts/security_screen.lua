local keypad = "on"

function pre_security(mapargs)
  local data = {}
  local left = 250

  -- the VISIBILITY (on/off) of the keypad or camera layers will be set in the function keypad_camera
  -- the ALPHA of the keypad or camera layers are set in this function, triggered on the screenshow pre
  data["security_screen.security_keypad_layer.grd_alpha"] = 255
  data["security_screen.security_keypad_layer.grd_x"] = 0
  data["security_screen.security_camera_layer.grd_alpha"] = 255
  data["security_screen.security_camera_layer.grd_x"] = 0

  data["security_screen.lighting_layer.grd_alpha"] = 0
  data["security_screen.lighting_layer.grd_x"] = 700

  data["security_screen.music_layer.grd_alpha"] = 0
  data["security_screen.music_layer.grd_x"] = 700


-- set up weather to be on the left behind the frame for a transition back to weather
  data["weather_layer.label_condition.grd_x"] = left
  data["weather_layer.pop_control.grd_x"] = left 
  data["weather_layer.tempOutValue.grd_x"] = left
  data["weather_layer.tempHighValue.grd_x"] = left
  data["weather_layer.tempLowValue.grd_x"] = left
  data["weather_layer.weather_bar.grd_x"] = left

  data["mode_mask_layer.bg.grd_hidden"] = false
  

gre.set_data(data)
  
end


-- controls whether the keypad or the camera is in view

function mode_bar_swap(mapargs)
  local data = {}

    if keypad == "on" then
      data["frame_sub_layer.mode_camera_bar.grd_hidden"] = false
      data["frame_sub_layer.mode_bar_left.grd_hidden"] = true
      data["frame_sub_layer.mode_bar_right.grd_hidden"] = true
    else
      data["frame_sub_layer.mode_camera_bar.grd_hidden"] = true
      data["frame_sub_layer.mode_bar_left.grd_hidden"] = false
      data["frame_sub_layer.mode_bar_right.grd_hidden"] = false
    end
    
    gre.set_data(data)

end

function security_to_camera(mapargs)

end


function keypad_camera(mapargs)
  local data = {}

  mode_bar_swap()

  if keypad == "on" then
        
    data["frame_layer.mode_front.grd_hidden"] = true
    data["frame_layer.mode_back.grd_hidden"] = true
    data["frame_layer.mode_bg.grd_hidden"] = true
    data["frame_layer.mode_image_front.grd_hidden"] = true
    data["frame_layer.mode_image_back.grd_hidden"] = true
    data["bg_layer.bg.alpha"] = 0
    data["security_toggle_layer.btn_camera_control.grd_active"] = 0
    data["security_toggle_layer.btn_keypad_control.grd_active"] = 1
    
    
    -- HIDE KEYPAD ON OTHER SCREENS
    data["thermostat_screen.security_keypad_layer.grd_hidden"] = true
    data["weather_screen.security_keypad_layer.grd_hidden"] = true
    data["lighting_screen.security_keypad_layer.grd_hidden"] = true
    data["music_screen.security_keypad_layer.grd_hidden"] = true

    -- SHOW CAMERA ON OTHER SCREENS
    data["thermostat_screen.security_camera_layer.grd_hidden"] = false
    data["weather_screen.security_camera_layer.grd_hidden"] = false
    data["security_screen.security_camera_layer.grd_hidden"] = false
    data["lighting_screen.security_camera_layer.grd_hidden"] = false
    data["music_screen.security_camera_layer.grd_hidden"] = false

    -- set up keypad and camera to slide in/out
    data["mode_security_alpha"] = 0 -- fade out keypad
    data["mode_security_cam_alpha"] = 255 -- fades in camera
    data["security_screen.security_camera_layer.grd_x"] = -700 -- position camera on left
    data["mode_security_delta"] = 700 -- keypad pushed to the right
    data["mode_security_cam_delta"] = 700 -- camera pushed to the right


    keypad = "off"

  else

    data["frame_layer.mode_front.grd_hidden"] = false
    data["frame_layer.mode_back.grd_hidden"] = false
    data["frame_layer.mode_bg.grd_hidden"] = false
    data["frame_layer.mode_image_front.grd_hidden"] = false
    data["frame_layer.mode_image_back.grd_hidden"] = false
    data["bg_layer.bg.alpha"] = 255
    data["security_toggle_layer.btn_camera_control.grd_active"] = 1
    data["security_toggle_layer.btn_keypad_control.grd_active"] = 0


    -- SHOW KEYPAD ON OTHER SCREENS
    data["thermostat_screen.security_keypad_layer.grd_hidden"] = false
    data["weather_screen.security_keypad_layer.grd_hidden"] = false
    data["security_screen.security_keypad_layer.grd_hidden"] = false
    data["lighting_screen.security_keypad_layer.grd_hidden"] = false
    data["music_screen.security_keypad_layer.grd_hidden"] = false

    -- HIDE CAMERA ON OTHER SCREENS
    data["thermostat_screen.security_camera_layer.grd_hidden"] = true
    data["weather_screen.security_camera_layer.grd_hidden"] = true
    data["lighting_screen.security_camera_layer.grd_hidden"] = true
    data["music_screen.security_camera_layer.grd_hidden"] = true

    -- set up keypad and camera to slide in/out
    data["mode_security_alpha"] = 255 -- fade in keypad
    data["mode_security_cam_alpha"] = 0 -- fades out camera
    data["security_screen.security_keypad_layer.grd_x"] = 700 -- position keypad on the right
    data["mode_security_delta"] = -700 -- keypad pushed to the left
    data["mode_security_cam_delta"] = -700 -- camera pushed to the left

    keypad = "on"

  end  

  gre.set_data(data)

  gre.animation_trigger("security_keypad")
  gre.animation_trigger("security_camera")

end


--//
--// After leaving the security screen, set the VISIBILITY of the camera / keypad layers to reflect the active layer
--//
function security_screen_post(mapargs)

local data = {}

  if keypad == "on" then
    data["security_screen.security_keypad_layer.grd_hidden"] = false
    data["security_screen.security_camera_layer.grd_hidden"] = true
  else
    data["security_screen.security_keypad_layer.grd_hidden"] = true
    data["security_screen.security_camera_layer.grd_hidden"] = false
  end

  gre.set_data(data)

end