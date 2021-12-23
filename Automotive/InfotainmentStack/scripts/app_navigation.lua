local navigation_open = 0
local animation_active = 0

function app_toggle_navigation(mapargs)

  if(animation_active == 0)then
    if(navigation_open == 0)then
      navigation_open = 1
      gre.animation_trigger("app_navigation_new_open")
    else
      navigation_open = 0
      gre.animation_trigger("app_navigation_new_close")
    end 

    
    if(mapargs.context_control == "top_navi_layer_new.circle_bg")then
      animation_active = 1
      gre.timer_set_timeout(app_screen_navigation_active, 500)
    end
    
  end
end

function app_screen_navigation()

  if(navigation_open == 1)then
    navigation_open = 0
    gre.animation_trigger("app_navigation_new_close")
  end 
  
end

function app_on_phone_navigation(mapargs)
  if(mapargs.context_screen == "phone_screen")then
    navigation_open = 0
    gre.animation_trigger("app_navigation_new_close")
  end 
end

function app_on_vm_navigation(mapargs)
  if(mapargs.context_screen == "vm_screen")then
    navigation_open = 0
    gre.animation_trigger("app_navigation_new_close")
  end 
end

function app_on_navi_navigation(mapargs)
  if(mapargs.context_screen == "navigation_screen")then
    navigation_open = 0
    gre.animation_trigger("app_navigation_new_close")
  end 
end

function app_on_media_navigation(mapargs)
  if(mapargs.context_screen == "media_screen")then
    navigation_open = 0
    gre.animation_trigger("app_navigation_new_close")
  end 
end

function app_on_climate_navigation(mapargs)
  if(mapargs.context_screen == "climate_screen")then
    navigation_open = 0
    gre.animation_trigger("app_navigation_new_close")
  end 
end

function app_screen_navigation_active()
  animation_active = 0
end