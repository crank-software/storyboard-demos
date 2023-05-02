function pre_weather(mapargs)
  local data = {}

-- set modes 3/4/5 off to the right for them to transition onto screen / into view
  data["weather_screen.security_keypad_layer.grd_alpha"] = 0
  data["weather_screen.security_keypad_layer.grd_x"] = 700
  data["weather_screen.security_camera_layer.grd_alpha"] = 0
  data["weather_screen.security_camera_layer.grd_x"] = 700

  data["weather_screen.lighting_layer.grd_alpha"] = 0
  data["weather_screen.lighting_layer.grd_x"] = 700

  data["weather_screen.music_layer.grd_alpha"] = 0
  data["weather_screen.music_layer.grd_x"] = 700


gre.set_data(data)
  
end

