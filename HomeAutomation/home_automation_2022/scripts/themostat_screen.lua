function pre_thermostat(mapargs)
  local data = {}

-- put modes 3/4/5 to outside / off screen to slide onto screen from right
  data["thermostat_screen.security_keypad_layer.grd_alpha"] = 0
  data["thermostat_screen.security_keypad_layer.grd_x"] = 700
  data["thermostat_screen.security_camera_layer.grd_alpha"] = 0
  data["thermostat_screen.security_camera_layer.grd_x"] = 700

  data["thermostat_screen.lighting_layer.grd_alpha"] = 0
  data["thermostat_screen.lighting_layer.grd_x"] = 700

  data["thermostat_screen.music_layer.grd_alpha"] = 0
  data["thermostat_screen.music_layer.grd_x"] = 700

-- resets alpha » visible temperature, heating cooling etc.
  data["thermostat_layer.temp_value.alpha"] = 255
  data["thermostat_layer.mode_control.alpha"] = 255
  data["thermostat_layer.mode_control.alpha1"] = 255
  data["thermostat_layer.Farenheit_Celsius_control.alpha"] = 255
  data["thermostat_layer.Farenheit_Celsius_control.alpha1"] = 255

-- position weather controls for weather transition
  data["weather_layer.label_condition.grd_x"] = 413
  data["weather_layer.pop_control.grd_x"] = 477 
  data["weather_layer.tempOutValue.grd_x"] = 611
  data["weather_layer.tempHighValue.grd_x"] = 785
  data["weather_layer.tempLowValue.grd_x"] = 784
  

gre.set_data(data)
  
end

