exterior_toggle = 0
road_toggle = 0

local ac_toggle = 0
local fdefrost_toggle = 0
local rdefrost_toggle = 0
local recycleair_toggle = 0

local temp = 0
local fan = 0

--Checks if the fan or the temp is active
--0 for temp
--1 for fan
local active_display = 0

climate_toggle_animation_active = 0
local climate_animation_timer = {}

--TOGGLE FOR THE CLIMATE EXTERIOR DRAWER
function climate_exterior_toggle(mapargs)

  --IF THE DRAWER IS HIDDEN
  if(exterior_toggle == 0)then
    
    if(climate_toggle_animation_active == 0)then
    
      if(road_toggle == 1)then
        gre.animation_trigger("climate_road_close")
        road_toggle = 0
      end
      
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      
      gre.animation_trigger("climate_exterior_open")
      exterior_toggle = 1
    
      climate_toggle_animation_active = 1
      climate_animation_timer = gre.timer_set_timeout(climate_toggle_anim_complete, 400)
    
    end
            
  else
    --animation to hide drawers
    if(climate_toggle_animation_active == 0)then   
      gre.animation_trigger("climate_exterior_close")
      exterior_toggle = 0
      climate_toggle_animation_active = 1
      climate_animation_timer = gre.timer_set_timeout(climate_toggle_anim_complete, 400)
    end
  end
  
end

--TOGGLE FOR THE CLIMATE ROAD DRAWER
function climate_road_toggle(mapargs)
  
  --IF THE DRAWER IS HIDDEN  
  if(road_toggle == 0)then
  
    if(climate_toggle_animation_active == 0)then  
    
      if(exterior_toggle == 1)then
        gre.animation_trigger("climate_exterior_close")
        exterior_toggle = 0
      end
      
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
    
      gre.animation_trigger("climate_road_open")
      road_toggle = 1 
    
      climate_toggle_animation_active = 1
      climate_animation_timer = gre.timer_set_timeout(climate_toggle_anim_complete, 400)
   end
    
  else
    if(climate_toggle_animation_active == 0)then
      gre.animation_trigger("climate_road_close")
      road_toggle = 0
      climate_toggle_animation_active = 1
      climate_animation_timer = gre.timer_set_timeout(climate_toggle_anim_complete, 400)
    end
  end

end

function climate_interior_toggle(mapargs)

  if(climate_toggle_animation_active == 0)then  

    if(exterior_toggle == 1)then
      gre.animation_trigger("climate_exterior_close")
      exterior_toggle = 0
    end
    
    if(road_toggle == 1)then
      gre.animation_trigger("climate_road_close")
      road_toggle = 0    
    end
  
    climate_toggle_animation_active = 1
    climate_animation_timer = gre.timer_set_timeout(climate_toggle_anim_complete, 400)
  end
    
end

function climate_toggle_anim_complete(mapargs)
  climate_toggle_animation_active = 0
end

function climate_fan_position_toggle(mapargs) 
  local data = {}
  
  data["climate_main_layer.climate_main_feet_defrost.image"] = "images/climate_main_feet_defrost.png"
  data["climate_main_layer.climate_main_feet.image"] = "images/climate_main_feet.png"
  data["climate_main_layer.climate_main_feet_face.image"] = "images/climate_main_feet_face.png"
  data["climate_main_layer.climate_main_face.image"] = "images/climate_main_face.png"
  
  if(mapargs.context_control == "climate_main_layer.climate_main_feet_defrost")then
    data["climate_main_layer.climate_main_feet_defrost.image"] = "images/climate_main_feet_defrost_selected.png"
  elseif(mapargs.context_control == "climate_main_layer.climate_main_feet")then
    data["climate_main_layer.climate_main_feet.image"] = "images/climate_main_feet_selected.png"
  elseif(mapargs.context_control == "climate_main_layer.climate_main_feet_face")then
    data["climate_main_layer.climate_main_feet_face.image"] = "images/climate_main_feet_face_selected.png"
  elseif(mapargs.context_control == "climate_main_layer.climate_main_face")then
    data["climate_main_layer.climate_main_face.image"] = "images/climate_main_face_selected.png"
  else
  end
  gre.set_data(data)
  climate_button_press(mapargs)
end

function climate_fdefrost_toggle(mapargs)
  
  local data = {}
  
  if(fdefrost_toggle == 0)then
    data["climate_main_layer.climate_main_front_defrost.image"] = "images/climate_main_front_defrost_selected.png"
    fdefrost_toggle = 1
  else
    data["climate_main_layer.climate_main_front_defrost.image"] = "images/climate_main_front_defrost.png"
    fdefrost_toggle = 0
  end
  
  gre.set_data(data)
  climate_button_press(mapargs)
end

function climate_rdefrost_toggle(mapargs)
  
  local data = {}
  
  if(rdefrost_toggle == 0)then
    data["climate_main_layer.climate_main_rear_defrost.image"] = "images/climate_main_rear_defrost_selected.png"
    rdefrost_toggle = 1
  else
    data["climate_main_layer.climate_main_rear_defrost.image"] = "images/climate_main_rear_defrost.png"
    rdefrost_toggle = 0
  end
  
  gre.set_data(data)
  climate_button_press(mapargs)
end

function climate_ac_toggle(mapargs)
  
  local data = {}
  
  if(ac_toggle == 0)then
    data["climate_main_layer.climate_main_recycle_air.image"] = "images/climate_main_recycle_air_selected.png"
    data["climate_main_layer.climate_main_AC.image"] = "images/climate_main_AC_selected.png"
    ac_toggle = 1
    recycleair_toggle = 1
  else
    data["climate_main_layer.climate_main_AC.image"] = "images/climate_main_AC.png"
    ac_toggle = 0
  end
  
  gre.set_data(data)
  climate_button_press(mapargs)
end

function climate_recycleair_toggle(mapargs)
  
  local data = {}
  if(ac_toggle == 0)then
    if(recycleair_toggle == 0)then
      data["climate_main_layer.climate_main_recycle_air.image"] = "images/climate_main_recycle_air_selected.png"
      recycleair_toggle = 1
    else
      data["climate_main_layer.climate_main_recycle_air.image"] = "images/climate_main_recycle_air.png"
      recycleair_toggle = 0
    end
  else
     if(recycleair_toggle == 0)then
      data["climate_main_layer.climate_main_recycle_air.image"] = "images/climate_main_recycle_air_selected.png"
      data["climate_main_layer.climate_main_AC.image"] = "images/climate_main_AC.png"
      recycleair_toggle = 1
      ac_toggle = 0
    else
      data["climate_main_layer.climate_main_recycle_air.image"] = "images/climate_main_recycle_air.png"
      data["climate_main_layer.climate_main_AC.image"] = "images/climate_main_AC.png"
      recycleair_toggle = 0
      ac_toggle = 0
    end
  end
  
  gre.set_data(data)
  climate_button_press(mapargs)
end

function climate_temp_increase(mapargs)
  if(active_display == 0)then
    local data = {}
    
    if(mapargs == 1)then
      if(temp < 100)then
        temp = temp + 1
      end
    else
      if(temp < 100)then
        temp = temp + 5
      end
    end
    
    data["climate_main_layer.climate_main_temp_text.temperature"] = math.floor(temp / 5) + 20
    data["climate_main_layer.climate_main_outer_ring.end_angle"] = temp * 3.6
    data["climate_main_layer.climate_main_outer_ring.ind_angle"] = temp * 3.6
    data["climate_main_layer.climate_main_temp_text.text"] = "manual"    

    gre.set_data(data)
    if(mapargs ~= 1)then
      climate_button_press(mapargs)
    end
    
  end
end

function climate_temp_decrease(mapargs)
  if(active_display == 0)then
    local data = {}
    if(mapargs == 1)then
      if(temp > 0)then
        temp = temp - 1
      end
    else
      if(temp > 0)then
        temp = temp - 5
      end
    end
    
    data["climate_main_layer.climate_main_temp_text.temperature"] = math.floor(temp / 5) + 20
    data["climate_main_layer.climate_main_outer_ring.end_angle"] = temp * 3.6
    data["climate_main_layer.climate_main_outer_ring.ind_angle"] = temp * 3.6
    data["climate_main_layer.climate_main_temp_text.text"] = "manual"    

    gre.set_data(data)
    if(mapargs ~= 1)then
      climate_button_press(mapargs)
    end
  end
end

function climate_fan_increase(mapargs)
  if(active_display == 1)then
    local data = {}
    
    if(mapargs == 1)then
      if(fan < 100)then
        fan = fan + 1
      end
    else
      if(fan < 100)then
        fan = fan + 10
      end
    end
    
    data["climate_main_layer.climate_main_temp_text_copy.fan"] = math.floor(fan / 10)
    data["climate_main_layer.climate_main_outer_ring.end_angle"] = fan * 3.6
    data["climate_main_layer.climate_main_outer_ring.ind_angle"] = fan * 3.6
    data["climate_main_layer.climate_main_temp_text.text"] = "manual"    

    gre.set_data(data)
    if(mapargs ~= 1)then
      climate_button_press(mapargs)
    end  
  end
end

function climate_fan_decrease(mapargs)
  if(active_display == 1)then
    local data = {}
    
    if(mapargs == 1)then
      if(fan > 0)then
        fan = fan - 1
      end
    else
      if(fan > 0)then
        fan = fan - 10
      end
    end
    
    data["climate_main_layer.climate_main_temp_text_copy.fan"] = math.floor(fan / 10)
    data["climate_main_layer.climate_main_outer_ring.end_angle"] = fan * 3.6
    data["climate_main_layer.climate_main_outer_ring.ind_angle"] = fan * 3.6
    data["climate_main_layer.climate_main_temp_text.text"] = "manual"    

    gre.set_data(data)
    if(mapargs ~= 1)then
      climate_button_press(mapargs)
    end  
  end
end

function climate_active_display(mapargs)
  local data = {}
  
  if(active_display == 0)then

    data["climate_main_layer.climate_main_outer_ring.end_angle"] = fan * 3.6
    data["climate_main_layer.climate_main_outer_ring.ind_angle"] = fan * 3.6
  
    gre.animation_trigger("climate_tofan")
    active_display = 1
  else
  
    data["climate_main_layer.climate_main_outer_ring.end_angle"] = temp * 3.6
    data["climate_main_layer.climate_main_outer_ring.ind_angle"] = temp * 3.6
  
    gre.animation_trigger("climate_totemp")
    active_display = 0
  end

  gre.set_data(data)
  climate_button_press(mapargs)
end

function climate_set_automatic(mapargs)
  local data = {}
  
  temp = 40
  
  data["climate_main_layer.climate_main_temp_text.temperature"] = math.floor(temp / 5) + 20
  data["climate_main_layer.climate_main_outer_ring.end_angle"] = temp * 3.6
  data["climate_main_layer.climate_main_outer_ring.ind_angle"] = temp * 3.6
  data["climate_main_layer.climate_main_temp_text.text"] = "automatic"   
  
  gre.set_data(data) 
  climate_button_press(mapargs)
end

function climate_button_press(mapargs)
  
  local dk_data = {}
  local data = {}
  
  dk_data = gre.get_control_attrs(mapargs.context_control, "x", "y")
  
  data["x"] = dk_data["x"] - 10
  data["y"] = dk_data["y"] - 10
  
  if(mapargs.context_control == "climate_main_layer.climate_main_increase_temp" or mapargs.context_control =="climate_main_layer.climate_main_decrease_temp" or mapargs.context_control =="climate_main_layer.climate_main_decrease_fan" or mapargs.context_control =="climate_main_layer.climate_main_increase_fan")then
    data["x"] = dk_data["x"] - 20
    data["y"] = dk_data["y"] - 20
  end
  
  gre.set_control_attrs("climate_main_layer.climate_main_button_press", data)  
  
  gre.animation_trigger("climate_main_button_press")
  
end