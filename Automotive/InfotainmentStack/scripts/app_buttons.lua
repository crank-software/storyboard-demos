local shutdown_animation_active = 0

function phidget_button(mapargs) 
  if(shutdown_animation_active == 0)then
    local ev = mapargs.context_event_data
    
    local phidget_id = tostring(ev["phidget_id"])
    local button_id = tostring(ev["button_id"])
    local button_value = tostring(ev["button_val"]) 
    
    if(button_id == "1" and button_value == "1")then
      gre.send_event("app_to_home")
    elseif(button_id == "3" and button_value == "1")then
      gre.send_event("app_to_media")
    elseif(button_id == "5" and button_value == "1")then
      gre.send_event("app_to_navi")
    elseif(button_id == "4" and button_value == "1")then
      gre.send_event("app_to_climate")
    elseif(button_id == "2" and button_value == "1")then
      gre.send_event("app_to_phone")
    elseif(button_id == "0" and button_value == "1" and phidget_id == "80096")then
      gre.send_event("app_to_settings")
    else             
    
    end 
    
    if(phidget_id == "78856" and button_value == "1")then
      gre.animation_trigger("app_shutdown")
      gre.timer_set_timeout(app_activate_buttons,8000)
      shutdown_animation_active = 1
    end
    
    if(phidget_id == "77872" and button_value == "1" and mapargs.context_screen == "climate_screen")then
      climate_active_display()
    end
    
    if(phidget_id == "77872" and button_value == "1" and mapargs.context_screen == "media_screen" and radio_toggle == 1)then
      media_radio_fm_am_toggle()
    end
    
    if(phidget_id == "77872" and button_value == "1" and mapargs.context_screen == "home_screen")then
      home_goto_screen()
    end
  end
end

function phidget_encoder(mapargs) 
  if(shutdown_animation_active == 0)then
    local ev = mapargs.context_event_data
    
    local phidget_id = tostring(ev["phidget_id"])
    local encoder_id = tostring(ev["encoder_id"])
    local encoder_value = tostring(ev["encoder_val"])
    
    --Volume Button Turning
    if(phidget_id == "78856")then
    
      if(encoder_value == "1" or encoder_value == "2")then
        app_change_volume(0)
      elseif(encoder_value == "4294967295" or encoder_value == "4294967294")then
        app_change_volume(1) 
      end
      
    end
  
    --Climate increase and decrease things
    if(mapargs.context_screen == "climate_screen" and phidget_id == "77872")then
       
      if(encoder_value == "1" or encoder_value == "2")then
        climate_fan_decrease(1)
        climate_temp_decrease(1)
      elseif(encoder_value == "4294967295" or encoder_value == "4294967294")then
        climate_fan_increase(1)
        climate_temp_increase(1)
      end 
    
    end
    --Home Screen Selections
    if(mapargs.context_screen == "home_screen" and phidget_id == "77872")then
       
      if(encoder_value == "1" or encoder_value == "2")then
        home_get_active_location(1)
      elseif(encoder_value == "4294967295" or encoder_value == "4294967294")then
        home_get_active_location(0)
      end 
    
    end
    
        --Climate increase and decrease things
    if(mapargs.context_screen == "media_screen" and phidget_id == "77872" and radio_toggle == 1)then
       
      if(encoder_value == "1" or encoder_value == "2")then
        media_controls_prev()
      elseif(encoder_value == "4294967295" or encoder_value == "4294967294")then
        media_controls_next()
      end 
    
    end
    
    
  end
end 

function app_activate_buttons()
  shutdown_animation_active = 0
end