--List of active screens

--1: Climate
--2: Navi
--3: Oil
--4: Music
--5: Phone

home_active_screen = 0
local new_screen = 1
local active_location = 0

function home_get_active_location(mapargs)

  if(mapargs == 0)then
    active_location = active_location + 4
    
    if(active_location > 359)then
      active_location = active_location - 360
    end
    
  end
  
  if(mapargs == 1)then
    active_location = active_location - 4
    
    if(active_location < 1)then
      active_location = active_location + 360
    end
    
  end
  
  home_set_location()

end

function home_set_location()

  if(active_location > 36 and active_location <= 108)then
    new_screen = 2
  elseif(active_location > 108 and active_location <= 180)then
    new_screen = 3
  elseif(active_location > 180 and active_location <= 252)then
    new_screen = 4
  elseif(active_location > 252 and active_location <= 324)then
    new_screen = 5
  else
    new_screen = 1
  end

  if(new_screen ~= home_active_screen)then
    home_change_modules()
  end

end

function home_change_modules()
  
  if(home_active_screen == 1)then
    gre.animation_trigger("home_close_climate")
  elseif(home_active_screen == 2)then
    gre.animation_trigger("home_close_navi")
  elseif(home_active_screen == 3)then
    gre.animation_trigger("home_close_vm")
  elseif(home_active_screen == 4)then
    gre.animation_trigger("home_close_music")
  elseif(home_active_screen == 5)then
    gre.animation_trigger("home_close_phone")
  else
      print("no animation")
  end
  
  if(new_screen == 1)then
    gre.animation_trigger("home_show_climate")
  elseif(new_screen == 2)then
    gre.animation_trigger("home_show_navi")
  elseif(new_screen == 3)then
    gre.animation_trigger("home_show_vm")
  elseif(new_screen == 4)then
    gre.animation_trigger("home_show_music") 
  elseif(new_screen == 5)then
    gre.animation_trigger("home_show_phone") 
  else
    print("no animation")
  end
  
  home_active_screen = new_screen
end


function home_goto_screen()

  if(home_active_screen == 1)then
    gre.send_event("app_to_climate")
  elseif(home_active_screen == 2)then
    gre.send_event("app_to_navi")
  elseif(home_active_screen == 3)then
    gre.send_event("app_to_vm")
  elseif(home_active_screen == 4)then
    gre.send_event("app_to_media")
  elseif(home_active_screen == 5)then
    gre.send_event("app_to_phone")
  else
      print("no animation")
  end

end