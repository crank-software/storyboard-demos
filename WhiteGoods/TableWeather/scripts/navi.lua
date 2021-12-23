ACTIVE_VIEW = 0

local city_drawer_toggle = 0

function toggle_city_drawer(mapargs) 

  if(city_drawer_toggle == 0)then
    city_drawer_toggle = 1
    gre.animation_trigger("show_city_drawer")
  else
    city_drawer_toggle = 0
    gre.animation_trigger("show_city_drawer_reversed")
  end

end


function toggle_city_selection(mapargs)

  local data = {}
  data["cities_drawer.Beijing__CH.colour"] = 0xffffff
  data["cities_drawer.London__GB.colour"] = 0xffffff
  data["cities_drawer.Washington__US.colour"] = 0xffffff
  data["cities_drawer.Riyadh__ARB.colour"] = 0xffffff
  data["cities_drawer.Moscow__RUS.colour"] = 0xffffff
  data["cities_drawer.Berlin__GER.colour"] = 0xffffff
  data["cities_drawer.Ottawa__CA.colour"] = 0xffffff

  data[mapargs.context_control..".colour"] = 0x0882a4
  
  gre.set_data(data)

end

function app_set_active_view(mapargs)
 
  gre.animation_trigger("close_circle_around")
  gre.timer_set_timeout(navi_open_anim,630)
  
  local dk_data = {}
  
  if(mapargs.context_control == "navigation.Week")then
    ACTIVE_VIEW = 1
    dk_data["hidden"] = 0
    gre.set_control_attrs("navigation.navi_bg_right", dk_data) 
    dk_data["hidden"] = 1
    gre.set_control_attrs("navigation.navi_bg_left", dk_data) 
  else
    ACTIVE_VIEW = 0
    dk_data["hidden"] = 0
    gre.set_control_attrs("navigation.navi_bg_left", dk_data) 
    dk_data["hidden"] = 1
    gre.set_control_attrs("navigation.navi_bg_right", dk_data) 
  end
  
end

function navi_open_anim()
  gre.animation_trigger("open_circle_around")
end

function navi_button_press(mapargs) 
  
  local dk_data = {}
  local data = {}
  
  dk_data = gre.get_control_attrs(mapargs.context_control, "x", "y")
  
  data["x"] = dk_data["x"] - 17
  data["y"] = dk_data["y"] - 17
  
  if(mapargs.context_control == "outer_circles.outer_circle_4_bg")then
    data["x"] = dk_data["x"] + 37
    data["y"] = dk_data["y"] - 18
  end
  
  if( mapargs.context_control == "outer_circles.outer_circle_5_bg")then
    data["x"] = dk_data["x"] + 31
    data["y"] = dk_data["y"] - 18
  end
  
  gre.set_control_attrs("outer_circles.touch", data)  
  
  gre.animation_trigger("button_press")
  
  
end
