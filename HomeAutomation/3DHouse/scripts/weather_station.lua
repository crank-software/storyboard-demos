
function get_wind_direction(degrees)
  local dir = ""
  if(degrees==nil)then
    print("No wind direction provided")
    dir=""
    return dir
  end
  if degrees >= 0 and degrees <= 11.25 then
    dir = "N"
  elseif degrees >= 11.25  and degrees <= 33.75 then
    dir = "NNE"
  elseif degrees >= 33.75 and degrees <= 56.25 then
    dir = "NE"
  elseif degrees >= 56.25 and degrees <= 78.75 then
    dir = "ENE"    
  elseif degrees >= 78.75 and degrees <= 101.25 then
    dir = "E"
  elseif degrees >= 101.25 and degrees <= 123.75 then
    dir = "ESE"
  elseif degrees >= 123.75 and degrees <= 146.25 then
    dir = "SE"
  elseif degrees >= 146.25 and degrees <= 168.75 then
    dir = "SSE"
  elseif degrees >= 168.75 and degrees <= 191.25 then
    dir = "S"
  elseif degrees >= 191.25 and degrees <= 213.75 then
    dir = "SSW"
  elseif degrees >= 213.75 and degrees <= 236.25 then
    dir = "SW"
  elseif degrees >= 236.25 and degrees <= 258.75 then
    dir = "WSW"
  elseif degrees >= 258.75 and degrees <= 258.75 then
    dir = "W"
  elseif degrees >= 236.25 and degrees <= 281.25 then
    dir = "W"
  elseif degrees >= 281.25 and degrees <= 303.75 then
    dir = "WNW"    
  elseif degrees >= 303.75 and degrees <= 326.25 then
    dir = "NW" 
  elseif degrees >= 326.25 and degrees <= 348.75 then
    dir = "NNW" 
  elseif degrees >= 348.75 and degrees <= 360 then
    dir = "N"           
  else
    print("Error : unhandled degrees number for wid direction : "..degrees)
    dir = ""
  end
  
  return dir                   
end


function updateWeatherStationUI(self)
  local data={}

  local target=self.controlData.groupName
  
  if(self.controlData.controlType == "weather_station")then
    local temp=self.properties.temp
    data["thermo_layer.myWeather.myweather_temp.text"] = tostring(math.floor(temp*9/5+32)).."° F"
    data["thermo_layer.myWeather.myweather_wind.text"]  = tostring(math.floor(tonumber(self.properties.wind_speed))).." mph "..get_wind_direction(tonumber(self.properties.wind_direction))
    data["thermo_layer.myWeather.myweather_pressure.text"] = tostring(self.properties.pressure).." kPa"
    data["thermo_layer.myWeather.myweather_rain.text"] = string.format("%.2f",self.properties.daily_rainfall/25.4).." inches"
    data["thermo_layer.myWeather.myweather_illum.text"] = tostring(self.properties.illuminance)
    gre.set_data(data)
   else
    print("Warning ("..self.controlData.controlType..") : currently not handled in update script")
   end
end

