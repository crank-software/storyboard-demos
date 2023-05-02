function pre_lighting(mapargs)
  local data = {}
  local left = 250

  data["lighting_screen.security_keypad_layer.grd_x"] = -700
  data["lighting_screen.security_keypad_layer.grd_alpha"] = 0
  
  data["lighting_screen.security_camera_layer.grd_alpha"] = 0
  data["lighting_screen.security_camera_layer.grd_x"] = -700
  
  data["lighting_screen.lighting_layer.grd_alpha"] = 255
  data["lighting_screen.lighting_layer.grd_x"] = 0
  
  data["lighting_screen.music_layer.grd_alpha"] = 0
  data["lighting_screen.music_layer.grd_x"] = 700
  


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

