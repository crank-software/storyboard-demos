--Global Variables Listings

local ACTIVE_MODULE = 1
local ADAS_ACTIVE = 0

--This function resets the module to the maintenence one for shutdown and the adas module to off
function reset_module_position(mapargs)
  ACTIVE_MODULE = 1
  ADAS_ACTIVE = 0
end

--LIST OF MODULES
--module 1:maintenance
--module 2:climate
--module 3:phone
--module 4:media
--module 5:navigation


--This function goes to the next module with the animation depending on which module it is on
--Layers Affected: module_navi_cluster, module_media_cluster, module_phone_cluster, module_climate_cluster, module_media_cluster, center_stack_lines_layer
--Global Variables Used/Defined: ACTIVE_MODULE


function next_module(mapargs)
  if(ACTIVE_MODULE == 1)then
    gre.animation_trigger("transition_n1_maintenance_to_climate")
    print("Hide module 1")
    print("Show module 2")
  elseif(ACTIVE_MODULE == 2)then
    gre.animation_trigger("transition_n2_climate_to_phone")
    print("Hide module 2")
    print("Show module 3")
    elseif(ACTIVE_MODULE == 3)then
    gre.animation_trigger("transition_n3_phone_to_media")
    print("Hide module 3")
    print("Show module 4")
    elseif(ACTIVE_MODULE == 4)then
    gre.animation_trigger("transition_n4_media_to_navi")
    print("Hide module 4")
    print("Show module 5")
    elseif(ACTIVE_MODULE == 5)then
    gre.animation_trigger("transition_n5_navi_to_maintenance")
    print("Hide module 5")
    print("Show module 1")
  else
    print("next module function borked (line 24)")
  end
  
  gre.animation_trigger("transition_next_module_lines")
  
  ACTIVE_MODULE = ACTIVE_MODULE + 1
  if(ACTIVE_MODULE > 5)then
    ACTIVE_MODULE = 1
  end
  
end

--This function goes to the previous module with the animation depending on which module it is on
--Layers Affected: module_navi_cluster, module_media_cluster, module_phone_cluster, module_climate_cluster, module_media_cluster, center_stack_lines_layer
--Global Variables Used/Defined: ACTIVE_MODULE

function prev_module(mapargs)
  
  if(ACTIVE_MODULE == 1)then
    gre.animation_trigger("transition_r1_maintenance_to_navi")
    print("Hide module 1")
    print("Show module 5")
  elseif(ACTIVE_MODULE == 2)then
    gre.animation_trigger("transition_r2_climate_to_maintenance")
    print("Hide module 2")
    print("Show module 1")
    elseif(ACTIVE_MODULE == 3)then
    gre.animation_trigger("transition_r3_phone_to_climate")
    print("Hide module 3")
    print("Show module 2")
    elseif(ACTIVE_MODULE == 4)then
    gre.animation_trigger("transition_r4_media_to_phone")
    print("Hide module 4")
    print("Show module 3")
    elseif(ACTIVE_MODULE == 5)then
    gre.animation_trigger("transition_r5_navi_to_media")
    print("Hide module 5")
    print("Show module 4")
  else
    print("prev module function borked (line 62)")
  end
  
  gre.animation_trigger("transition_prev_module_lines")
  
  ACTIVE_MODULE = ACTIVE_MODULE - 1
  if(ACTIVE_MODULE < 1)then
    ACTIVE_MODULE = 5
  end
end


--This function checks which module was active and animates the correct module in
--Layers Affected: module_navi_cluster, module_media_cluster, module_phone_cluster, module_climate_cluster, module_media_cluster, center_stack_lines_layer, adas_layer
--Global Variables Used/Defined: ACTIVE_MODULE

function to_navigation(mapargs)
  if(ACTIVE_MODULE ==5)then
    print("at navi")
  else
    gre.animation_trigger("transition_to_navi")
    print("go to navigation")
    ACTIVE_MODULE = 5
  end 
end


--This function checks which module was active and animates the correct module in
--Layers Affected: module_navi_cluster, module_media_cluster, module_phone_cluster, module_climate_cluster, module_media_cluster, center_stack_lines_layer, adas_layer
--Global Variables Used/Defined: ACTIVE_MODULE

function adas_to_module(mapargs)
  if(ACTIVE_MODULE == 1)then
    gre.animation_trigger("transition_a1_return_to_maintenance")
  elseif(ACTIVE_MODULE == 2)then
    gre.animation_trigger("transition_a2_return_to_climate")
    elseif(ACTIVE_MODULE == 3)then
    gre.animation_trigger("transition_a3_return_to_phone")
    elseif(ACTIVE_MODULE == 4)then
    gre.animation_trigger("transition_a4_return_to_media")
    elseif(ACTIVE_MODULE == 5)then
    gre.animation_trigger("transition_a5_return_to_navigation")
  else
    print("adas_to_module borked (line 101)")
  end
end

--This function checks if the adas module is up or not and either hides or shows it
--Layers Affected: 
--Global Variables Used/Defined: ADAS_ACTIVE
function toggle_adas(mapargs) 
  if(ADAS_ACTIVE == 0)then
    gre.animation_trigger("transition_to_adas")
    gre.animation_trigger("transition_to_adas_compass")
    ADAS_ACTIVE = 1
  else
    adas_to_module()
    gre.animation_trigger("transition_to_module_compass")
    ADAS_ACTIVE = 0
  end
end
