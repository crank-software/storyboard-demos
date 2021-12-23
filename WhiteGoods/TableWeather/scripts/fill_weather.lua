local global_data = {}
local global_i
FIRST_FIRE = 1

function daily_fill_weather(mapargs)

  gre.timer_set_timeout(timer_daily_fill_weather,630)
  local dk_data = {}

  dk_data["active"] = 1
  
  for i=1, 5 do
  
    gre.set_control_attrs("outer_circles.outer_circle_"..i.."_bg",dk_data)
  
  end

  gre.set_control_attrs("navigation.Day", dk_data)
  gre.set_control_attrs("navigation.Week", dk_data)
  
end

function timer_daily_fill_weather(mapargs)

  local degree_pos
  local data = {}
  
  data["inner_circle.current_temp.text"] = math.floor(TODAY.main.temp + 0.5)
  data["inner_circle.high_temp.text"] = math.floor(TODAY.main.temp_max + 0.5)
  data["inner_circle.low_temp.text"] = math.floor(TODAY.main.temp_min + 0.5)
  data["inner_circle.description.text"] = string.lower(TODAY.weather[1].description)
  data["inner_circle.weather_icon.image"] = get_icon(TODAY.weather[1].id, 50)
  
  degree_pos = gre.get_string_size("fonts/Roboto-Regular.ttf", 24, tostring(math.floor(TODAY.main.temp_max + 0.5)))
  data["inner_circle.high_temp.x_pos"] = degree_pos.width + 3
  
  for i=1, 5 do
  
    data["outer_circles.outer_circle_"..i.."_bg.time"] = os.date("%H:%M", TWELVE_HOUR.list[i].dt)
    data["outer_circles.outer_circle_"..i.."_icon.image"] = get_icon(TWELVE_HOUR.list[i].weather[1].id, 30)
  
  end
  gre.set_data(data)
  
  local dk_data = {}
  
  ACTIVE_VIEW = 0
  dk_data["hidden"] = 0
  gre.set_control_attrs("navigation.navi_bg_left", dk_data) 
  dk_data["hidden"] = 1
  gre.set_control_attrs("navigation.navi_bg_right", dk_data) 
  
  if(FIRST_FIRE == 1)then
    gre.animation_trigger("open_circle_around")
    FIRST_FIRE = 0
  else
    gre.timer_set_timeout(open_circle,700)
  end

end


function daily_fill_details(mapargs)

  global_i = tonumber(mapargs.module)
  
  gre.animation_trigger("show_details")  
  gre.timer_set_timeout(set_details_timer, 250)

end

function week_fill_weather(mapargs)

  gre.timer_set_timeout(timer_week_fill_weather,630)

end

function timer_week_fill_weather()
  
  local data = {}
  
  data["inner_circle.current_temp.text"] = math.floor(TODAY.main.temp + 0.5)
  data["inner_circle.high_temp.text"] = math.floor(TODAY.main.temp_max)
  data["inner_circle.low_temp.text"] = math.floor(TODAY.main.temp_min)
  data["inner_circle.description.text"] = string.lower(TODAY.weather[1].description)
  data["inner_circle.weather_icon.image"] = get_icon(TODAY.weather[1].id, 50)  
  
  for i=1, 5 do
  
    data["outer_circles.outer_circle_"..i.."_bg.time"] = os.date("%a", SEVEN_DAY.list[i].dt)
    data["outer_circles.outer_circle_"..i.."_icon.image"] = get_icon(SEVEN_DAY.list[i].weather[1].id, 30)
    --rain bg(low priority)
  
  end
  
  
  gre.set_data(data)

end

function set_details_timer(data)
  local degree_pos

  if(ACTIVE_VIEW == 0)then
    global_data["inner_circle.current_temp.text"] = math.floor(TWELVE_HOUR.list[global_i].main.temp)
    global_data["inner_circle.high_temp.text"] = math.floor(TWELVE_HOUR.list[global_i].main.temp_max)
    global_data["inner_circle.low_temp.text"] = math.floor(TWELVE_HOUR.list[global_i].main.temp_min)
    
    global_data["inner_circle.description.text"] = string.lower(TWELVE_HOUR.list[global_i].weather[1].description)
    global_data["inner_circle.weather_icon.image"] = get_icon(TWELVE_HOUR.list[global_i].weather[1].id, 50) 
    
    degree_pos = gre.get_string_size("fonts/Roboto-Regular.ttf", 24, tostring(math.floor(TWELVE_HOUR.list[global_i].main.temp_max)))
    
  else
    global_data["inner_circle.current_temp.text"] = math.floor(SEVEN_DAY.list[global_i].temp.day)
    global_data["inner_circle.high_temp.text"] = math.floor(SEVEN_DAY.list[global_i].temp.max)
    global_data["inner_circle.low_temp.text"] = math.floor(SEVEN_DAY.list[global_i].temp.min)
    
    global_data["inner_circle.description.text"] = string.lower(SEVEN_DAY.list[global_i].weather[1].description)
    global_data["inner_circle.weather_icon.image"] = get_icon(SEVEN_DAY.list[global_i].weather[1].id, 50)
    
    degree_pos = gre.get_string_size("fonts/Roboto-Regular.ttf", 24, tostring(math.floor(SEVEN_DAY.list[global_i].temp.max)))
         
  end
  
  
  global_data["inner_circle.high_temp.x_pos"] = degree_pos.width + 3
  
  gre.set_data(global_data)
end