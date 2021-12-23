require "json"

local TODAY = {}

local ACTIVE_CITY = "Austin,TX"

local myenv = gre.env({ "target_os", "target_cpu" })

local today_string = "{\"coord\":{\"lon\":-97.74,\"lat\":30.27},\"sys\":{\"message\":0.0124,\"country\":\"United States of America\",\"sunrise\":1434194918,\"sunset\":1434245617},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"base\":\"stations\",\"main\":{\"temp\":87.07,\"temp_min\":87.07,\"temp_max\":87.07,\"pressure\":997.75,\"sea_level\":1022.1,\"grnd_level\":997.75,\"humidity\":55},\"wind\":{\"speed\":13.8,\"deg\":148.503},\"clouds\":{\"all\":80},\"dt\":1434155394,\"id\":4671654,\"name\":\"Austin\",\"cod\":200}"


local override_env = os.getenv("GRE_LUA_MODULES")
if (override_env) then
  package.cpath = override_env .."/?.so;" .. package.cpath
  package.path = override_env.."/?.lua;" .. package.path
else
  package.path = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.lua;"..package.path
  if myenv.target_os  == "win32" then
    package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.dll;"..package.cpath
  else
    package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.so;"..package.cpath
  end
end

if myenv.target_os  ~= "win32"  and  myenv.target_os  ~= "macos" then
--  http = require("socket.http")
end


function get_weather()
  while true do
  
    --use dummy data above if using windows until bug is fixed
    if myenv.target_os  == "win32"  or  myenv.target_os  == "macos" then
      TODAY = json.decode(today_string)       
      return
    end

    local url_current = string.format("http://api.openweathermap.org/data/2.5/weather?q=%s&units=imperial",ACTIVE_CITY)
    
    b, c, h = http.request(url_current)
    TODAY = json.decode(b)
    
    --get an update every 10 mins
    os.sleep(60 * 10)
  end
end


function local_weather_get_weather()
  gre.thread_create(get_weather)
end


function local_weather_fill_weather()

  local data = {}

  data["thermo_layer.localWeather.local_status.text"] = TODAY.weather[1].description
  data["thermo_layer.localWeather.local_pressure_icon.text"] = math.floor(TODAY.main.pressure/10 + 0.5).." kPa"
  data["thermo_layer.localWeather.local_rain_icon.text"] = math.floor(TODAY.main.humidity + 0.5).." %"
  data["thermo_layer.localWeather.local_wind_icon.text"] = math.floor(TODAY.wind.speed + 0.5).." mph "..get_wind_direction(tonumber(TODAY.wind.deg))
  data["thermo_layer.localWeather.local_highlow.text"] = math.floor(TODAY.main.temp + 0.5).."° F"

  gre.set_data(data)
end