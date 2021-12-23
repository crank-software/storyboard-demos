require "phone_tables"

keypad_toggle = 0
contacts_toggle = 0
phone_recent_toggle = 0
phone_favorites_toggle = 0

phone_toggle_animation_active = 0
local phone_animation_timer = {}

phone_active_call_timer = {}

local active_contact = ""


local phone_number = ""
local ndigits = 0

phone_call_time = 0

function phone_keypad_press(mapargs)
  local data = {}
  
  if(ndigits < 10)then
    ndigits = ndigits + 1
    if (ndigits == 4) then
      phone_number = phone_number.." "..mapargs.number
    elseif (ndigits == 7) then
      phone_number = phone_number.." "..mapargs.number 
    else
      phone_number = phone_number..mapargs.number
    end
  end
  
  data["phone_keypad_drawer_layer.keypad_drawer_number_input.phone_number"] = phone_number
  gre.set_data(data)
  
  local dk_data = {}
  local data = {}
  
  dk_data = gre.get_control_attrs(mapargs.context_control, "x", "y")
  
  data["x"] = dk_data["x"] - 20
  data["y"] = dk_data["y"] - 15
  
  gre.set_control_attrs("phone_keypad_drawer_layer.keypad_drawer_button_press", data)  
  
  gre.animation_trigger("phone_keypad_button_press")
end

function phone_keypad_delete(mapargs)
  local data = {}
  
  if (ndigits == 0) then
    return 0
  end
  
  ndigits = ndigits - 1
  local len = string.len(phone_number)
  if (len == 5) then
    len = len - 2
  elseif (len == 9) then
    len = len - 2
  else
    len = len - 1
  end
  local new = string.format("%s", string.sub(phone_number,1,len))
  phone_number = new
  
  data["phone_keypad_drawer_layer.keypad_drawer_number_input.phone_number"] = phone_number
  gre.set_data(data)
  
end

function phone_keypad_clear(mapargs)
  local data = {}
  
  phone_number = ""
  ndigits = 0
  
  data["phone_keypad_drawer_layer.keypad_drawer_number_input.phone_number"] = phone_number
  gre.set_data(data)  
  
end

function phone_keypad_call(mapargs) 

  if (phone_call_active == 1)then
    phone_control_end_call(1)
  end

  local data = {}
  
  data["phone_main_layer.phone_main_active_text.name"] = phone_number
  data["phone_main_layer.phone_main_active_text.time"] = "00:00"
  
  gre.set_data(data)
  
  gre.animation_trigger("phone_keypad_close")
  keypad_toggle = 0
  gre.animation_trigger("phone_show_phone_icons")
  gre.animation_trigger("phone_main_layer_move_left")
  
  phone_call_active = 1
  phone_call_contin_animation()
  
  phone_active_call_timer = gre.timer_set_interval(phone_timer_counter, 1000)
  
end


--TOGGLE FOR THE CLIMATE EXTERIOR DRAWER
function phone_contacts_toggle(mapargs)
  
  --IF THE DRAWER IS HIDDEN
  if(contacts_toggle == 0)then
  
    if(phone_toggle_animation_active == 0)then
    
      phone_fill_contacts_table()
      if(keypad_toggle == 1)then
        gre.animation_trigger("phone_keypad_close")
        keypad_toggle = 0
      end
      if(phone_recent_toggle == 1)then
        gre.animation_trigger("phone_recent_close")
        phone_recent_toggle = 0
      end
      if(phone_favorites_toggle == 1)then
        gre.animation_trigger("phone_favorites_close")
        phone_favorites_toggle = 0
      end
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end    
      gre.animation_trigger("phone_contacts_open")
      contacts_toggle = 1
      
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
    
      gre.animation_trigger("phone_main_layer_move_left")
    
    end
            
  else
    if(phone_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("phone_contacts_close")
      contacts_toggle = 0
      
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
      gre.animation_trigger("phone_main_layer_move_left")
    end
  end
  
end

function phone_keypad_toggle(mapargs)

  --IF THE DRAWER IS HIDDEN
  if(keypad_toggle == 0)then
    
    if(phone_toggle_animation_active == 0)then
    
      if(contacts_toggle == 1)then
        gre.animation_trigger("phone_contacts_close")
        contacts_toggle = 0
      end
      if(phone_recent_toggle == 1)then
        gre.animation_trigger("phone_recent_close")
        phone_recent_toggle = 0
      end
      if(phone_favorites_toggle == 1)then
        gre.animation_trigger("phone_favorites_close")
        phone_favorites_toggle = 0
      end
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end    
      gre.animation_trigger("phone_keypad_open")
      keypad_toggle = 1
      
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
      
      gre.animation_trigger("phone_main_layer_move_right")
      
    end   
         
  else
    if(phone_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("phone_keypad_close")
     keypad_toggle = 0
    
      gre.animation_trigger("phone_main_layer_move_left")
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
    end
  end
  
end

function phone_recenticon_toggle(mapargs)

  --IF THE DRAWER IS HIDDEN
  phone_fill_recent()
  if(phone_recent_toggle == 0)then
  
    if(phone_toggle_animation_active == 0)then
      
      if(contacts_toggle == 1)then
        gre.animation_trigger("phone_contacts_close")
        contacts_toggle = 0
      end
      if(keypad_toggle == 1)then
        gre.animation_trigger("phone_keypad_close")
        keypad_toggle = 0
      end
      if(phone_favorites_toggle == 1)then
        gre.animation_trigger("phone_favorites_close")
        phone_favorites_toggle = 0
      end
       if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end   
      gre.animation_trigger("phone_recent_open")
      phone_recent_toggle = 1
      
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
      
      gre.animation_trigger("phone_main_layer_move_right")
      
    end
            
  else
    if(phone_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("phone_recent_close")
      phone_recent_toggle = 0
      
      gre.animation_trigger("phone_main_layer_move_left")
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
    end
  end
  
end

function phone_favoritesicon_toggle(mapargs)
  
  phone_fill_favorites()
  --IF THE DRAWER IS HIDDEN
  if(phone_favorites_toggle == 0)then
    
    if(phone_toggle_animation_active == 0)then
    
      if(contacts_toggle == 1)then
        gre.animation_trigger("phone_contacts_close")
        contacts_toggle = 0
      end
      if(keypad_toggle == 1)then
        gre.animation_trigger("phone_keypad_close")
        keypad_toggle = 0
      end
      if(phone_recent_toggle == 1)then
        gre.animation_trigger("phone_recent_close")
        phone_recent_toggle = 0
      end
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end    
      gre.animation_trigger("phone_favorites_open")
      phone_favorites_toggle = 1
      
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
      
      gre.animation_trigger("phone_main_layer_move_right")
      
    end
            
  else
    if(phone_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("phone_favorites_close")
      phone_favorites_toggle = 0
      
      gre.animation_trigger("phone_main_layer_move_left")
      phone_toggle_animation_active = 1
      phone_animation_timer = gre.timer_set_timeout(phone_toggle_anim_complete, 400)
    end    
  end
  
end

function phone_toggle_anim_complete(mapargs)
  phone_toggle_animation_active = 0
end

function phone_fill_contacts_table()

  local data = {}
  
  for i=1, table.maxn(contacts) do
    data["phone_contacts_drawer_layer.contacts_drawer_contacts_table.text."..i..".2"] = contacts[i].name
    data["phone_contacts_drawer_layer.contacts_drawer_contacts_table.image."..i..".1"] = contacts[i].image
    if(contacts[i].favorite == 1)then
      data["phone_contacts_drawer_layer.contacts_drawer_contacts_table.favorite."..i..".3"] = "images/contacts_drawer_contacts_favoritepink.png"
    else
      data["phone_contacts_drawer_layer.contacts_drawer_contacts_table.favorite."..i..".3"] = "images/contacts_drawer_contacts_favoritegrey.png"
    end    
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = table.maxn(contacts) 
  gre.set_table_attrs("phone_contacts_drawer_layer.contacts_drawer_contacts_table", data)
  
end

function phone_all_contact_press(mapargs)
  local key = "phone_contacts_drawer_layer.contacts_drawer_contacts_table.text."..mapargs.context_row..'.2'
  local contact_name = gre.get_data(key)
  phone_select_contact(contact_name[key])
  
end

function phone_fav_contact_press(mapargs)
  if (phone_call_active == 1)then
    phone_control_end_call(1)
  end
 
  local key = "phone_favorites_drawer_layer.favorites_drawer_contacts_table.name."..mapargs.context_row..'.2'
  local contact_name = gre.get_data(key)  
  local data = {}
  
  data["phone_main_layer.phone_main_active_text.name"] = contact_name[key]
  data["phone_main_layer.phone_main_active_text.time"] = "00:00"
  
  gre.animation_trigger("phone_favorites_close")
  gre.animation_trigger("phone_show_phone_icons")
  phone_favorites_toggle = 0
  gre.set_data(data)
  
  phone_call_active = 1
  phone_call_contin_animation()
  gre.animation_trigger("phone_main_layer_move_left")
  
  phone_active_call_timer = gre.timer_set_interval(phone_timer_counter, 1000)
  
end

function phone_recent_contact_press(mapargs)
  if (phone_call_active == 1)then
    phone_control_end_call(1)
  end
 
  local key = "phone_recent_drawer_layer.recent_drawer_contacts_table.name."..mapargs.context_row..'.2'
  local contact_name = gre.get_data(key)
  local data = {}
 
  data["phone_main_layer.phone_main_active_text.name"] = contact_name[key]
  data["phone_main_layer.phone_main_active_text.time"] = "00:00"
  
  gre.animation_trigger("phone_recent_close")
  gre.animation_trigger("phone_show_phone_icons")
  phone_recent_toggle = 0
  gre.set_data(data)
  
  phone_call_active = 1
  phone_call_contin_animation()
  gre.animation_trigger("phone_main_layer_move_left")  

  phone_active_call_timer = gre.timer_set_interval(phone_timer_counter, 1000)
 
end

function phone_select_contact(filter)
  --Type (All, FAvorite, Recent)--Do we need it?
  --Filter (Name)
  local name = filter
  --Go through the table, if the name matches, then display it
  for i=1, table.maxn(contacts) do
    if(contacts[i].name == name)then
      local data = {}
      
      active_contact = contacts[i].name 
      data["phone_contacts_drawer_layer.contacts_drawer_details_picture.image"] = contacts[i].banner
      data["phone_contacts_drawer_layer.contacts_drawer_details_name.text"] = contacts[i].name
      data["phone_contacts_drawer_layer.contacts_drawer_details_phone.text"] = contacts[i].mobile
      data["phone_contacts_drawer_layer.contacts_drawer_details_phone1.text"] = contacts[i].work
      
      if(contacts[i].recent ~= 0)then
        data["phone_contacts_drawer_layer.contacts_drawer_details_recent.text"] = contacts[i].recent.." min ago"
        data["phone_contacts_drawer_layer.contacts_drawer_details_recent.number"] = contacts[i].mobile.." ("..contacts[i].recent_time..")"
      end
      
      gre.set_data(data)
    end
  end
end

function phone_favorite_toggle(mapargs)
  
  local key
  local index = 0
  
  if(mapargs.context_control == "phone_recent_drawer_layer.recent_drawer_contacts_table")then
    key = "phone_recent_drawer_layer.recent_drawer_contacts_table.name."..mapargs.context_row..'.2'
  elseif(mapargs.context_control == "phone_favorites_drawer_layer.favorites_drawer_contacts_table")then
    key = "phone_favorites_drawer_layer.favorites_drawer_contacts_table.name."..mapargs.context_row..'.2'
  else
    key = "phone_contacts_drawer_layer.contacts_drawer_contacts_table.text."..mapargs.context_row..'.2'
  end
  
  local contact_name = gre.get_data(key)
  
  for i=1, table.maxn(contacts) do
    if(contacts[i].name == contact_name[key])then
      local data = {}
      local index = index + 1
      
      if (contacts[i].favorite == 0)  then
        contacts[i].favorite = 1
        data["phone_contacts_drawer_layer.contacts_drawer_contacts_table.favorite."..mapargs.context_row..".3"] = "images/contacts_drawer_contacts_favoritepink.png"
        data["phone_favorites_drawer_layer.favorites_drawer_contacts_table.favorite."..mapargs.context_row..".3"] = "images/contacts_drawer_contacts_favoritepink.png"
      else
        contacts[i].favorite = 0
        data["phone_contacts_drawer_layer.contacts_drawer_contacts_table.favorite."..mapargs.context_row..".3"] = "images/contacts_drawer_contacts_favoritegrey.png"
        data["phone_favorites_drawer_layer.favorites_drawer_contacts_table.favorite."..mapargs.context_row..".3"] = "images/contacts_drawer_contacts_favoritegrey.png"
      end
      
      gre.set_data(data)
    end
  end
end

function phone_fill_favorites()

  local data = {}
  local index = 0
  
  for i=1, table.maxn(contacts) do
    if(contacts[i].favorite == 1)then
      index = index + 1
      data["phone_favorites_drawer_layer.favorites_drawer_contacts_table.name."..index..".2"] = contacts[i].name
      data["phone_favorites_drawer_layer.favorites_drawer_contacts_table.image."..index..".1"] = contacts[i].image
      data["phone_favorites_drawer_layer.favorites_drawer_contacts_table.favorite."..index..".3"] = "images/contacts_drawer_contacts_favoritepink.png"
    end    
  end
  
  gre.set_data(data)
  
    data = {}
    if (index == 0)then
      data["hidden"] = 1
      gre.set_table_attrs("phone_favorites_drawer_layer.favorites_drawer_contacts_table", data)
      data["hidden"] = 0
      gre.set_control_attrs("phone_favorites_drawer_layer.favorites_drawer_prompt", data)  
    else
      data["hidden"] = 1
      gre.set_control_attrs("phone_favorites_drawer_layer.favorites_drawer_prompt", data)  
      data["hidden"] = 0
      data["rows"] = index
      gre.set_table_attrs("phone_favorites_drawer_layer.favorites_drawer_contacts_table", data)
    end
  
end

function phone_fill_recent(mapargs)

  local data = {}
  local index = 0
  
  for i=1, table.maxn(contacts) do
    if(contacts[i].recent ~= 0)then
      index = index + 1
      data["phone_recent_drawer_layer.recent_drawer_contacts_table.name."..index..".2"] = contacts[i].name
      data["phone_recent_drawer_layer.recent_drawer_contacts_table.image."..index..".1"] = contacts[i].image
      data["phone_recent_drawer_layer.recent_drawer_contacts_table.favorite."..index..".3"] = "images/recent_drawer_recent_icon.png"
    end    
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = index
  gre.set_table_attrs("phone_recent_drawer_layer.recent_drawer_contacts_table", data)
  
end

function phone_call_contact(mapargs)
  
  if (phone_call_active == 1)then
    phone_control_end_call(1)
  end

  local data = {}
  
  data["phone_main_layer.phone_main_active_text.name"] = active_contact
  data["phone_main_layer.phone_main_active_text.time"] = "00:00"
  
  gre.set_data(data)
  
  gre.animation_trigger("phone_contacts_close")
  gre.animation_trigger("phone_show_phone_icons")
    

  
  phone_call_active = 1
  phone_call_contin_animation()
  gre.animation_trigger("phone_main_layer_move_left")
  
  contacts_toggle = 0
  
  phone_active_call_timer = gre.timer_set_interval(phone_timer_counter, 1000)
end

function phone_quickcall_contact(mapargs)
    
  if (phone_call_active == 1)then
    phone_control_end_call(1)
  end
  
  local data = {}
  
  data["phone_main_layer.phone_main_active_text.name"] = contacts[mapargs.context_row].name
  data["phone_main_layer.phone_main_active_text.time"] = "00:00"
  
  gre.set_data(data)
  
  gre.animation_trigger("phone_contacts_close")
  gre.animation_trigger("phone_show_phone_icons")
  
  phone_call_active = 1
  phone_call_contin_animation()
  gre.animation_trigger("phone_main_layer_move_left")
      
  contacts_toggle = 0

  phone_active_call_timer = gre.timer_set_interval(phone_timer_counter, 1000)

end
 
local inc_call_timer = {}

function phone_incoming_call(mapargs)

  gre.animation_trigger("app_incoming_call")
  
  inc_call_timer = gre.timer_set_timeout(phone_incoming_decline, 10000)
  
end


function phone_incoming_decline(mapargs)

  gre.animation_trigger("app_incoming_call_close")
  
  local data
  data = gre.timer_clear_interval(inc_call_timer)

end

function phone_incoming_accept(mapargs)
  
  local data
  data = gre.timer_clear_interval(inc_call_timer)
  
  if (phone_call_active == 1)then
    phone_control_end_call()
  end
  
  data = {}
  
  data["phone_main_layer.phone_main_active_text.name"] = "Kenny Rogers"
  data["phone_main_layer.phone_main_active_text.time"] = "00:00"
  
  gre.set_data(data)
  
  gre.animation_trigger("phone_show_phone_icons")
  gre.animation_trigger("app_incoming_call_close")
    
  phone_call_active = 1
  phone_call_contin_animation()
  
  contacts_toggle = 0
  gre.animation_trigger("phone_main_layer_move_left")

  phone_active_call_timer = gre.timer_set_interval(phone_timer_counter, 1000)

end

function phone_timer_counter(mapargs)  
  
  phone_call_time = phone_call_time + 1
  
  local min = math.floor(phone_call_time / 60)
  local sec = phone_call_time - (min * 60)
  
  local data = {}
  
  if(min == 0)then
    min = "00"
  elseif(string.len(min) == 1)then
    min = "0"..min  
  end
  
  if(string.len(sec) == 1)then
    sec = "0"..sec  
  end
  
  data["phone_main_layer.phone_main_active_text.time"] = min..":"..sec
  gre.set_data(data)
  
end
