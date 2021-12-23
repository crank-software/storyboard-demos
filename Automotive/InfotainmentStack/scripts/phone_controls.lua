local phone_bluetooth_toggle = 0
local phone_mute_toggle = 0
phone_call_active = 0

function phone_control_conference(mapargs)
  phone_contacts_toggle()
end

function phone_control_mute_toggle(mapargs)
  local data = {}
  
  if(phone_mute_toggle == 0)then
    data["phone_main_layer.phone_main_active_mute_toggle.image"] = "images/phone_main_active_mute_toggle_on.png"
    phone_mute_toggle = 1  
  else
    data["phone_main_layer.phone_main_active_mute_toggle.image"] = "images/phone_main_active_mute_toggle.png"
    phone_mute_toggle = 0 
  end
  
  gre.set_data(data)
end

function phone_control_bluetooth_toggle(mapargs)
  local data = {}
  
  if(phone_bluetooth_toggle == 0)then
    phone_bluetooth_toggle = 1
    data["phone_main_layer.phone_main_active_bluetooth_toggle.image"] = "images/phone_main_active_bluetooth_toggle_on.png"  
  else
    phone_bluetooth_toggle = 0 
    data["phone_main_layer.phone_main_active_bluetooth_toggle.image"] = "images/phone_main_active_bluetooth_toggle.png"
  end
  
  gre.set_data(data)
end

function phone_control_end_call(mapargs)
  
  local data = {}
  local dk_data
  
  data["phone_main_layer.phone_main_active_mute_toggle.image"] = "images/phone_main_active_mute_toggle.png"  
  data["phone_main_layer.phone_main_active_bluetooth_toggle.image"] = "images/phone_main_active_bluetooth_toggle.png"
  
  data["phone_main_layer.phone_main_active_text.name"] = "Call Ended"
  
  --END THE TIMER, STOP THE ANIMATION AND STOP THE REPEATING ANIMATION
  
  local phone_bluetooth_toggle = 0
  local phone_mute_toggle = 0
  
  gre.set_data(data)  
  
  phone_call_active = 0
  if(mapargs ~= 1)then
    gre.animation_trigger("phone_end_call_button")
  end
  gre.animation_trigger("phone_active_call_end")
  
  
  dk_data = gre.timer_clear_timeout(phone_active_call_timer)
  phone_call_time = 0
  
end

function phone_call_contin_animation()
  
  if(phone_call_active == 1)then
    gre.animation_trigger("phone_active_call_animation")
  end

end