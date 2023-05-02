function pre_music(mapargs)
  local data = {}
  local left = 250

  data["music_screen.security_keypad_layer.grd_alpha"] = 0
  data["music_screen.security_keypad_layer.grd_x"] = -700

  data["music_screen.security_camera_layer.grd_alpha"] = 0
  data["music_screen.security_camera_layer.grd_x"] = -700

  data["music_screen.lighting_layer.grd_alpha"] = 0
  data["music_screen.lighting_layer.grd_x"] = -700

  data["music_screen.music_layer.grd_alpha"] = 255
  data["music_screen.music_layer.grd_x"] = 0

-- set up weather to be on the left behind the frame for a transition back to weather
  data["music_screen.weather_layer.grd_hidden"] = false
  data["weather_layer.label_condition.grd_x"] = left
  data["weather_layer.pop_control.grd_x"] = left 
  data["weather_layer.tempOutValue.grd_x"] = left
  data["weather_layer.tempHighValue.grd_x"] = left
  data["weather_layer.tempLowValue.grd_x"] = left
  data["weather_layer.weather_bar.grd_x"] = left

  data["mode_mask_layer.bg.grd_hidden"] = false
  

gre.set_data(data)
  
end

