require "navi_tables"

poi_toggle = 0
direction_toggle = 0
navi_recent_toggle = 0
navi_favorites_toggle = 0

local navi_selected_destination

navi_toggle_animation_active = 0
local navi_animation_timer = {}

--TOGGLE FOR THE CLIMATE EXTERIOR DRAWER
function navi_directions_toggle(mapargs)

  --IF THE DRAWER IS HIDDEN
  if(direction_toggle == 0)then
   
    if(navi_toggle_animation_active == 0)then
    
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
      
      gre.animation_trigger("navi_directions_open")
      direction_toggle = 1
      
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)
    
    end
            
  else
    if(navi_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("navi_directions_close")
      direction_toggle = 0
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)
    end
  end
  
end

function navi_poi_toggle(mapargs)

  --IF THE DRAWER IS HIDDEN
  if(poi_toggle == 0)then
  
    if(navi_toggle_animation_active == 0)then
    
      if(direction_toggle == 1)then
        gre.animation_trigger("navi_directions_close")
        direction_toggle = 0
      end
      if(navi_recent_toggle == 1)then
        gre.animation_trigger("navi_recent_close")
        navi_recent_toggle = 0
      end
      if(navi_favorites_toggle == 1)then
        gre.animation_trigger("navi_favorites_close")
        navi_favorites_toggle = 0
      end
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      gre.animation_trigger("navi_poi_open")
      poi_toggle = 1
    
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)
    
    end        
  else
    if(navi_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("navi_poi_close")
      poi_toggle = 0
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)
    end
  end
  
end

function navi_recenticon_toggle(mapargs)



  --IF THE DRAWER IS HIDDEN
  if(navi_recent_toggle == 0)then

    if(navi_toggle_animation_active == 0)then
    
      if(direction_toggle == 1)then
        gre.animation_trigger("navi_directions_close")
        direction_toggle = 0
      end
      if(poi_toggle == 1)then
        gre.animation_trigger("navi_poi_close")
        poi_toggle = 0
      end
      if(navi_favorites_toggle == 1)then
        gre.animation_trigger("navi_favorites_close")
        navi_favorites_toggle = 0
      end
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      gre.animation_trigger("navi_recent_open")
      navi_recent_toggle = 1
      
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)      
      
    end  
            
  else
    if(navi_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("navi_recent_close")
      navi_recent_toggle = 0
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)      
      
    end  
  end
  
end

function navi_favoritesicon_toggle(mapargs)



  --IF THE DRAWER IS HIDDEN
  if(navi_favorites_toggle == 0)then
    
    if(navi_toggle_animation_active == 0)then
    
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
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      
      gre.animation_trigger("navi_favorites_open")
      navi_favorites_toggle = 1
      
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)
      
    end
            
  else
    if(navi_toggle_animation_active == 0)then
      --animation to hide drawers
      gre.animation_trigger("navi_favorites_close")
      navi_favorites_toggle = 0
      navi_toggle_animation_active = 1
      navi_animation_timer = gre.timer_set_timeout(navi_toggle_anim_complete, 400)      
    end  
  end
  
end

function navi_toggle_anim_complete(mapargs)
  navi_toggle_animation_active = 0
end


function navi_poi_category_select(mapargs)
  local category

  if(mapargs.context_row == 1)then
    category = poi_restaurants
  elseif(mapargs.context_row == 2)then
    category = poi_reststops
  elseif(mapargs.context_row == 3)then
    category = poi_hotels
  elseif(mapargs.context_row == 4)then
    category = poi_gas
  elseif(mapargs.context_row == 5)then
    category = poi_museums
  else
  
  end
  
  animation_navi_location_select(mapargs)
  navi_fill_poi(category)

end

function navi_fill_poi(index)
  
  local category = index
  local data = {}
  
  for i=1, table.maxn(category) do
    data["navi_poi_drawer_layer.poi_drawer_available_table.name."..i..".1"] = category[i].name.." - "..category[i].money
    data["navi_poi_drawer_layer.poi_drawer_available_table.distance."..i..".1"] = category[i].distance.."   "..category[i].time
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = table.maxn(category) 
  gre.set_table_attrs("navi_poi_drawer_layer.poi_drawer_available_table", data)
  
end

function navi_fill_locations()
  local data = {}
  
  for i=1, table.maxn(directions_locations) do
    data["navi_find_directions_drawer_layer.find_directions_drawer_locations_table.address."..i..".1"] = directions_locations[i].name.." "..directions_locations[i].address
    data["navi_find_directions_drawer_layer.find_directions_drawer_locations_table.name."..i..".1"] = directions_locations[i].name
    
    if (directions_locations[i].favorite == 1) then
      data["navi_find_directions_drawer_layer.find_directions_drawer_locations_table.fav."..i..".2"] = "images/find_directions_drawer_locations_favoritepink.png"
    else
      data["navi_find_directions_drawer_layer.find_directions_drawer_locations_table.fav."..i..".2"] = "images/find_directions_drawer_locations_favoritegrey.png"
    end
  
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = table.maxn(directions_locations) 
  gre.set_table_attrs("navi_find_directions_drawer_layer.find_directions_drawer_locations_table", data)
  data["hidden"] = 0
  gre.set_control_attrs("navi_find_directions_drawer_layer.find_directions_drawer_locations_table", data)
  data["hidden"] = 1
  gre.set_control_attrs("navi_find_directions_drawer_layer.find_directions_drawer_available_prompt", data)

end

function navi_fill_favorites()
  local data = {}
  local index = 0
  
  for i=1, table.maxn(directions_locations) do
    if(directions_locations[i].favorite == 1)then
      index = index + 1
      data["navi_favorites_drawer_layer.favorites_drawer_locations_table.address."..index..".1"] = directions_locations[i].name.." "..directions_locations[i].address
      data["navi_favorites_drawer_layer.favorites_drawer_locations_table.name."..index..".1"] = directions_locations[i].name
      data["navi_favorites_drawer_layer.favorites_drawer_locations_table.fav."..index..".2"] = "images/find_directions_drawer_locations_favoritepink.png"
    end
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = index 
  gre.set_table_attrs("navi_favorites_drawer_layer.favorites_drawer_locations_table", data)
  
end

function navi_fill_recent()
  local data = {}
  local index = 0
  
  for i=1, table.maxn(directions_locations) do
    if(directions_locations[i].recent == 1)then
      index = index + 1
      data["navi_recent_drawer_layer.recent_drawer_locations_table.address."..index..".1"] = directions_locations[i].name.." "..directions_locations[i].address
      data["navi_recent_drawer_layer.recent_drawer_locations_table.name."..index..".1"] = directions_locations[i].name
    end
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = index 
  gre.set_table_attrs("navi_recent_drawer_layer.recent_drawer_locations_table", data)
  
end

function navi_recent_select(mapargs)

  local name = "navi_recent_drawer_layer.recent_drawer_locations_table.name." .. mapargs.context_row .. '.1'
  local place = "navi_recent_drawer_layer.recent_drawer_locations_table.address." .. mapargs.context_row .. '.1'
  local loc = gre.get_data(name)
  local add = gre.get_data(place)
  
  navi_selected_destination = 0
  gre.animation_trigger("navi_recent_select")
  
  navi_selected_destination = add[place]
  navi_fill_available_routes(loc[name], 3)
  
  animation_navi_location_select(mapargs)
end

function navi_favorites_select(mapargs)

  local name = "navi_favorites_drawer_layer.favorites_drawer_locations_table.name." .. mapargs.context_row .. '.1'
  local place = "navi_favorites_drawer_layer.favorites_drawer_locations_table.address." .. mapargs.context_row .. '.1'
  local loc = gre.get_data(name)
  local add = gre.get_data(place)
  
  navi_selected_destination = 0
  gre.animation_trigger("navi_favorites_select")
  
  navi_selected_destination = add[place]
  navi_fill_available_routes(loc[name], 2)
  
  animation_navi_location_select(mapargs)
  
end

function navi_location_select(mapargs)

  local name = "navi_find_directions_drawer_layer.find_directions_drawer_locations_table.name." .. mapargs.context_row .. '.1'
  local loc = gre.get_data(name)
  
  navi_selected_destination = 0
  gre.animation_trigger("navi_location_select")
  
  navi_selected_destination =  directions_locations[mapargs.context_row].name.." "..directions_locations[mapargs.context_row].address
  navi_fill_available_routes(loc[name], 1)
  
  animation_navi_location_select(mapargs)
  
end

function navi_fill_available_routes(loc_name, category)
  
  --Categories
  --1 is directions
  --2 is favorites
  --3 is recent
  
  local name = loc_name
  local submenu = category
  local index = 0
  local data = {}
  
  for i=1, table.maxn(directions_routes) do  
    if(name == directions_routes[i].name)then
      
      index = index + 1
      
      if (submenu == 1)then
        data["navi_find_directions_drawer_layer.find_directions_drawer_available_table.route."..index..".1"] = directions_routes[i].route
        data["navi_find_directions_drawer_layer.find_directions_drawer_available_table.dist."..index..".1"] = directions_routes[i].dist.." km     "..directions_routes[i].time.." min"
      elseif (submenu == 2)then
        data["navi_favorites_drawer_layer.favorites_drawer_available_table.route."..index..".1"] = directions_routes[i].route
        data["navi_favorites_drawer_layer.favorites_drawer_available_table.dist."..index..".1"] = directions_routes[i].dist.." km     "..directions_routes[i].time.." min"     
      else
        data["navi_recent_drawer_layer.recent_drawer_available_table.route."..index..".1"] = directions_routes[i].route
        data["navi_recent_drawer_layer.recent_drawer_available_table.dist."..index..".1"] = directions_routes[i].dist.." km     "..directions_routes[i].time.." min"
      end
      
    end
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = index
  if (submenu == 1)then
    gre.set_table_attrs("navi_find_directions_drawer_layer.find_directions_drawer_available_table", data)
    gre.animation_trigger("navi_location_select")
  elseif (submenu == 2)then
    gre.set_table_attrs("navi_favorites_drawer_layer.favorites_drawer_available_table", data)
    gre.animation_trigger("navi_favorite_select")
  else
    gre.set_table_attrs("navi_recent_drawer_layer.recent_drawer_available_table", data)
    gre.animation_trigger("navi_recent_select")
  end
  

  
end

function navi_route_select(mapargs)

  local data = {}
  
  direction_toggle = 0
  gre.animation_trigger("navi_directions_close")
  gre.animation_trigger("navi_route_onmap_show")
  
  data["navi_main_layer.navi_destination_text.name"] = navi_selected_destination
  
  gre.set_data(data)
end

function navi_favorites_route_select(mapargs) 
  local data = {}
  
  navi_favorites_toggle = 0
  gre.animation_trigger("navi_favorites_close")
  gre.animation_trigger("navi_route_onmap_show")
  
  data["navi_main_layer.navi_destination_text.name"] = navi_selected_destination
  gre.set_data(data)
end

function navi_poi_select(mapargs)

  local name = "navi_poi_drawer_layer.poi_drawer_available_table.name." .. mapargs.context_row .. '.1'
  local loc = gre.get_data(name)
  local data = {}
  
  navi_selected_destination = loc[name]
   
  poi_toggle = 0
  gre.animation_trigger("navi_poi_close")
  gre.animation_trigger("navi_route_onmap_show")
  
  data["navi_main_layer.navi_destination_text.name"] = navi_selected_destination
  gre.set_data(data)
  
  
end

function navi_recent_route_select(mapargs) 
  local data = {}
  
  navi_recent_toggle = 0
  gre.animation_trigger("navi_recent_close")
  gre.animation_trigger("navi_route_onmap_show")
  
  data["navi_main_layer.navi_destination_text.name"] = navi_selected_destination
  gre.set_data(data)
end

function navi_setfavorite_toggle(mapargs) 

  local key
  
  if(mapargs.context_control == "navi_find_directions_drawer_layer.find_directions_drawer_locations_table")then
    key = "navi_find_directions_drawer_layer.find_directions_drawer_locations_table.name."..mapargs.context_row..'.1'
  else
    key = "navi_favorites_drawer_layer.favorites_drawer_locations_table.name."..mapargs.context_row..'.1'
  end
  
  local location_name = gre.get_data(key)
  local data = {}
  for i=1, table.maxn(directions_locations) do
    if(directions_locations[i].name == location_name[key])then
      
      if (directions_locations[i].favorite == 0)  then
        directions_locations[i].favorite = 1
        data["navi_find_directions_drawer_layer.find_directions_drawer_locations_table.fav."..mapargs.context_row..'.2'] = "images/find_directions_drawer_locations_favoritepink.png"
        data["navi_favorites_drawer_layer.favorites_drawer_locations_table.fav."..mapargs.context_row..'.2'] = "images/find_directions_drawer_locations_favoritepink.png"
      else
        directions_locations[i].favorite = 0
        data["navi_find_directions_drawer_layer.find_directions_drawer_locations_table.fav."..mapargs.context_row..'.2'] = "images/find_directions_drawer_locations_favoritegrey.png"
        data["navi_favorites_drawer_layer.favorites_drawer_locations_table.fav."..mapargs.context_row..'.2'] = "images/find_directions_drawer_locations_favoritegrey.png"
      end
      
    end
    
  end
  gre.set_data(data)
end
