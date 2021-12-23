settings_menu_toggle = 0
local settings_units_toggle = 0
local settings_phoneon_toggle = 0
local settings_weather_toggle = 0
local settings_fan_toggle = 0
local settings_navion_toggle = 0
local settings_vmon_toggle = 0
local settings_wifi_menu_toggle = 0
local settings_wifi_timer = {}
local settings_eq_timer = {}
local settings_phone_timer = {}
local settings_navi_timer = {}

local settings_animation_toggle = 0

function app_settings_menu_toggle()
  if(settings_animation_toggle == 0 and navi_toggle_animation_active == 0 and climate_toggle_animation_active == 0 and media_toggle_animation_active == 0 and phone_toggle_animation_active == 0)then
    if(settings_menu_toggle == 0)then
      gre.animation_trigger("app_settings_open")
      settings_menu_toggle = 1 
    else
      gre.animation_trigger("app_settings_close")
      settings_menu_toggle = 0
    end
    
    if(library_toggle == 1)then
      gre.animation_trigger("media_library_close")
      library_toggle = 0
    end
    
    if(cd_toggle == 1)then
      gre.animation_trigger("media_cd_close")
      cd_toggle = 0
    end
    
    if(road_toggle == 1)then
      gre.animation_trigger("climate_road_close")
      road_toggle = 0
    end
    
    if(exterior_toggle == 1)then
      gre.animation_trigger("climate_exterior_close")
      exterior_toggle = 0
    end
    
    if(direction_toggle == 1)then
      gre.animation_trigger("navi_directions_close")
      direction_toggle = 0
    end
    
    if(poi_toggle == 1)then
      gre.animation_trigger("navi_poi_close")
      poi_toggle = 0
    end
    
    if(navi_recent_toggle == 1)then
      gre.animation_trigger("navi_recent_close")
      navi_recent_toggle = 0
    end
    
    if(navi_favorites_toggle == 1)then
      gre.animation_trigger("navi_favorites_close")
      navi_favorites_toggle = 0
    end
      
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
     if(keypad_toggle == 1)then
      gre.animation_trigger("phone_keypad_close")
      keypad_toggle = 0
     end
     
     settings_animation_toggle = 1
     gre.timer_set_timeout(settings_animation_active, 400)
     
   end    
end

function settings_animation_active()

  settings_animation_toggle = 0

end


function app_settings_units_toggle()
-- settings_units_toggle = 0 (metric)
-- settings_units_toggle = 1 (imperial)

  if(settings_units_toggle == 0)then
    gre.animation_trigger("settings_units_toimperial")
    settings_units_toggle = 1
  else
    gre.animation_trigger("settings_units_tometric")
    settings_units_toggle = 0
  end
  
end

function app_settings_wifi_select(mapargs)


  local name = "submenu_drawer_options_layer.wifi_list_table.name." .. mapargs.context_row .. '.1'
  
  local wifi = gre.get_data(name)
  local data = {} 

  data["submenu_drawer_options_layer.wifi_dropdown_name.name"] = wifi[name]
  
  gre.set_data(data)
  
  animation_table_radial_deselect(mapargs)
  animation_table_radial_select(mapargs)

  settings_wifi_timer = gre.timer_set_timeout(settings_wifi_toggle, 100)
  
end

function app_settings_eq_select(mapargs)


  local name = "submenu_drawer_options_layer.media_eq_list.name." .. mapargs.context_row .. '.1'
  
  local eq = gre.get_data(name)
  local data = {} 

  data["submenu_drawer_options_layer.media_dropdown_name.name"] = eq[name]
  
  gre.set_data(data)
  
  animation_table_radial_deselect(mapargs)
  animation_table_radial_select(mapargs)

  settings_eq_timer = gre.timer_set_timeout(settings_close_eq_table, 100)
  
end

function app_settings_phone_select(mapargs)


  local name = "submenu_drawer_options_layer.phone_list_table.name." .. mapargs.context_row .. '.1'
  
  local phone = gre.get_data(name)
  local data = {} 

  data["submenu_drawer_options_layer.phone_dropdown_name.name"] = phone[name]
  
  gre.set_data(data)
  
  animation_table_radial_deselect(mapargs)
  animation_table_radial_select(mapargs)

  settings_phone_timer = gre.timer_set_timeout(settings_close_phone_table, 100)
  
end

function app_settings_navi_select(mapargs)


  local name = "submenu_drawer_options_layer.navi_list_table.name." .. mapargs.context_row .. '.1'
  
  local navi = gre.get_data(name)
  local data = {} 

  data["submenu_drawer_options_layer.navi_dropdown_name.name"] = navi[name]
  
  gre.set_data(data)
  
  animation_table_radial_deselect(mapargs)
  animation_table_radial_select(mapargs)

  settings_navi_timer = gre.timer_set_timeout(settings_close_navi_table, 100)
  
end

function settings_close_eq_table()
  gre.animation_trigger("settings_eq_hide")       
end

function settings_close_phone_table()
  gre.animation_trigger("settings_phone_hide")       
end

function settings_close_navi_table()
  gre.animation_trigger("settings_navi_hide")       
end

function settings_wifi_toggle(mapargs)
  if(settings_wifi_menu_toggle == 0) then
    settings_wifi_menu_toggle = 1
    gre.animation_trigger("settings_wifi_show")
  else
    settings_wifi_menu_toggle = 0
    gre.animation_trigger("settings_wifi_hide")
  end
end

function settings_phone_toggle(mapargs) 
  if(settings_phoneon_toggle == 0)then
    settings_phoneon_toggle = 1
    gre.animation_trigger("settings_phone_to_on")
  else
    settings_phoneon_toggle = 0
    gre.animation_trigger("settings_phone_to_off")
  end
end

function settings_climate_toggle1(mapargs) 
  if(settings_weather_toggle == 0)then
    settings_weather_toggle = 1
    gre.animation_trigger("settings_climate_to_on")
  else
    settings_weather_toggle = 0
    gre.animation_trigger("settings_climate_to_off")
  end
end

function settings_climate_toggle2(mapargs) 
  if(settings_fan_toggle == 0)then
    settings_fan_toggle = 1
    gre.animation_trigger("settings_climate_to_on1")
  else
    settings_fan_toggle = 0
    gre.animation_trigger("settings_climate_to_off1")
  end
end

function settings_navi_toggle(mapargs) 
  if(settings_navion_toggle == 0)then
    settings_navion_toggle = 1
    gre.animation_trigger("settings_navi_to_on")
  else
    settings_navion_toggle = 0
    gre.animation_trigger("settings_navi_to_off")
  end
end

function settings_vm_toggle(mapargs) 
  if(settings_vmon_toggle == 0)then
    settings_vmon_toggle = 1
    gre.animation_trigger("settings_vm_to_on")
  else
    settings_vmon_toggle = 0
    gre.animation_trigger("settings_vm_to_off")
  end
end

function animation_table_radial_select(mapargs)
  local index = mapargs.context_row
  local key = (mapargs.context_control)
  local anim_data = {}
  
  
  local radial_select = gre.animation_create(60, 1)
  
  anim_data["key"] = key..".fill_alpha."..index..".1"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 58
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 100
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["duration"] = 155
  anim_data["offset"] = 77
  anim_data["from"] = 100
  anim_data["to"] = 0
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".rad."..index..".1"
  anim_data["rate"] = "easein"
  anim_data["duration"] = 116
  anim_data["offset"] = 0
  anim_data["from"] = 14
  anim_data["to"] = 10
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["rate"] = "linear"
  anim_data["duration"] = 194
  anim_data["offset"] = 155
  anim_data["from"] = 10
  anim_data["to"] = 14
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".fill_width."..index..".1"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 311
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 279
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".fill_pos."..index..".1"
  anim_data["duration"] = 311
  anim_data["offset"] = 0
  anim_data["from"] = 279
  anim_data["to"] = 0
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".x_pos."..index..".1"
  anim_data["rate"] = "easein"
  anim_data["duration"] = 116
  anim_data["offset"] = 0
  anim_data["from"] = -18
  anim_data["to"] = -20
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["rate"] = "linear"
  anim_data["duration"] = 194
  anim_data["offset"] = 155
  anim_data["from"] = -20
  anim_data["to"] = -18
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".alpha."..index..".1"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 10
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 0
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["rate"] = "linear"
  anim_data["duration"] = 294
  anim_data["offset"] = 56
  anim_data["from"] = 0
  anim_data["to"] = 255
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".outer_rad."..index..".1"
  anim_data["rate"] = "easein"
  anim_data["duration"] = 116
  anim_data["offset"] = 0
  anim_data["from"] = 20
  anim_data["to"] = 16
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["rate"] = "linear"
  anim_data["duration"] = 194
  anim_data["offset"] = 155
  anim_data["from"] = 16
  anim_data["to"] = 20
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["key"] = key..".outer_xpos."..index..".1"
  anim_data["rate"] = "easein"
  anim_data["duration"] = 116
  anim_data["offset"] = 0
  anim_data["from"] = -15
  anim_data["to"] = -17
  gre.animation_add_step(radial_select, anim_data)
  
  anim_data["rate"] = "linear"
  anim_data["duration"] = 194
  anim_data["offset"] = 155
  anim_data["from"] = -17
  anim_data["to"] = -15
  gre.animation_add_step(radial_select, anim_data)
  
  gre.animation_trigger(radial_select)
  
end


function animation_table_radial_deselect(mapargs)


  local key = (mapargs.context_control)
  local anim_data = {}
  
  for i=1, 6 do
    local radial_deselect = gre.animation_create(60, 1)
    
    anim_data["key"] = key..".alpha."..i..".1"
    anim_data["rate"] = "linear"
    anim_data["duration"] = 150
    anim_data["offset"] = 0
    anim_data["to"] = 0
    gre.animation_add_step(radial_deselect, anim_data)
    
    gre.animation_trigger(radial_deselect)
  end
end



