--Screen List


ACTIVE_SCREEN = nil
TO_SCREEN = nil

function navigation_switch_screen(mapargs)

  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN)
  end
  
  ACTIVE_SCREEN = mapargs.context_screen
  TO_SCREEN = mapargs.toscreen
  
  if(ACTIVE_SCREEN == "Overall_House")then
    print("Overall to "..TO_SCREEN)
    gre.animation_trigger("3D_overall_to_"..TO_SCREEN)
    gre.timer_set_timeout(navigation_swap_screen,1500)
  
  elseif(ACTIVE_SCREEN == "Bedroom")then
    print("Bedroom to "..TO_SCREEN)
    if(TO_SCREEN ~= "bedroom")then   
      if(TO_SCREEN == "house")then
        gre.timer_set_timeout(navigation_swap_screen,1)   
        gre.animation_trigger("3D_bedroom_to_overall")
      else
        gre.send_event("to_screen_overall")
        gre.animation_trigger("3D_bedroom_to_overall")     
        gre.timer_set_timeout(navigation_animation,1500)    
      end
    end
  elseif(ACTIVE_SCREEN == "Kitchen")then
    print("Kitchen to "..TO_SCREEN)    
    
    if(TO_SCREEN ~= "kitchen")then
      if(TO_SCREEN == "house")then
        gre.timer_set_timeout(navigation_swap_screen,1) 
        gre.animation_trigger("3D_kitchen_to_overall")  
      else
        gre.send_event("to_screen_overall")
        gre.animation_trigger("3D_kitchen_to_overall")
        gre.timer_set_timeout(navigation_animation,1500)           
      end
    end
    
  elseif(ACTIVE_SCREEN == "Livingroom")then
    print("Living Room to "..TO_SCREEN)
    if(TO_SCREEN ~= "livingroom")then    
      if(TO_SCREEN == "house")then
        gre.timer_set_timeout(navigation_swap_screen,1)  
        gre.animation_trigger("3D_livingroom_to_overall")
      else
        gre.send_event("to_screen_overall")
        gre.animation_trigger("3D_livingroom_to_overall") 
        gre.timer_set_timeout(navigation_animation,1500)     
      end
    end
    
    elseif(ACTIVE_SCREEN == "Entryway")then
    print("Entryway to "..TO_SCREEN)
    if(TO_SCREEN ~= "entryway")then    
      if(TO_SCREEN == "house")then
        gre.timer_set_timeout(navigation_swap_screen,1)  
        gre.animation_trigger("3D_entryway_to_overall")
      else
        gre.send_event("to_screen_overall")
        gre.animation_trigger("3D_entryway_to_overall") 
        gre.timer_set_timeout(navigation_animation,1500)     
      end
    end
      
  end

end

function navigation_animation(mapargs)
    gre.animation_trigger("3D_overall_to_"..TO_SCREEN)
    gre.timer_set_timeout(navigation_swap_screen,1500)
end

function navigation_swap_screen(mapargs)
  if(TO_SCREEN == "house")then
    gre.send_event("to_screen_overall")
  elseif(TO_SCREEN == "bedroom")then
    gre.send_event("to_screen_bedroom")
  elseif(TO_SCREEN == "kitchen")then
    gre.send_event("to_screen_kitchen")
  elseif(TO_SCREEN == "livingroom")then
    gre.send_event("to_screen_livingroom") 
  elseif(TO_SCREEN == "entryway")then
    gre.send_event("to_screen_entryway") 
  end
  
  print("called to screen event: "..TO_SCREEN)
  
end

function cb_screen_to_home(mapargs)

  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN..".auto_close")
  end
  CURRENT_OPEN=nil

  local active_screen = mapargs.context_screen
  
  if(active_screen == "Bedroom")then
    gre.send_event("to_screen_overall")
    gre.animation_trigger("HOUSE_BedroomClose")
  elseif(active_screen == "Entryway")then
    gre.send_event("to_screen_overall")
    gre.animation_trigger("HOUSE_BackClose")
  elseif(active_screen == "Kitchen")then
    gre.send_event("to_screen_overall")
    gre.animation_trigger("HOUSE_KitchenClose")
  elseif(active_screen == "Livingroom")then
    gre.send_event("to_screen_overall")
    gre.animation_trigger("HOUSE_LivingClose")
  elseif(active_screen == "outdoor")then
    gre.send_event("to_screen_overall")
    gre.animation_trigger("HOUSE_FrontClose")
  end
  
end