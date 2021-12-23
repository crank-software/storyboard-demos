local ACTIVE_CONSOLE = 3
local NEEDLE_MOVEMENT_ACTIVE = 1

--CAR = 1
--MAP = 2
--MEDIA = 3
function reset_telematics_console(mapargs)
  ACTIVE_CONSOLE = 3
end


function cycle_telematics_console(mapargs)

  ACTIVE_CONSOLE = ACTIVE_CONSOLE + 1

  if(ACTIVE_CONSOLE == 4)then
    ACTIVE_CONSOLE = 1
  end
  
  if(ACTIVE_CONSOLE == 1)then
    gre.animation_trigger("transition_layer_car_to_map")
  elseif(ACTIVE_CONSOLE == 2)then
    gre.animation_trigger("transition_layer_map_to_media")  
  elseif(ACTIVE_CONSOLE == 3)then
    gre.animation_trigger("transition_layer_media_to_car")  
  end

end


function select_telematics_animation(mapargs)

  local keycode = mapargs.context_event_data.code
  print(keycode)
  --1
  if(keycode == 49)then
    gre.animation_trigger("3D_car_rotation")
  --2
  elseif(keycode == 50)then
    gre.animation_trigger("transition_layer_car_to_map")
  --3
  elseif(keycode == 51)then
    gre.animation_trigger("map_rotation")
  --4
  elseif(keycode == 52)then
    gre.animation_trigger("transition_layer_map_to_media")
  --5
  elseif(keycode == 53)then
    gre.animation_trigger("media_to_next")
  --6
  elseif(keycode == 54)then
    gre.animation_trigger("transition_layer_media_to_car")
  --7
  elseif(keycode == 55)then
    gre.animation_trigger("3D_warning_blip_tire")
  --8
  elseif(keycode == 56)then
    gre.animation_trigger("continuous_anim_telltale")
  --9
  elseif(keycode == 57)then
    gre.animation_trigger("media_to_prev")
  --r
  elseif(keycode == 114)then
    gre.animation_trigger("closing_animation_full")
    NEEDLE_MOVEMENT_ACTIVE = 0
  elseif(keycode == 108)then
    gre.send_event("keydown_init")
  end
  
end




function toggle_needle_movement_on(mapargs)
    NEEDLE_MOVEMENT_ACTIVE = 1
end

function toggle_needle_movement_off(mapargs)
    NEEDLE_MOVEMENT_ACTIVE = 0
end

function loop_needle_movement(mapargs)

  if(NEEDLE_MOVEMENT_ACTIVE == 1)then
    gre.animation_trigger("needles")
  end

end

function loop_needledown_movement(mapargs)
    gre.animation_trigger("needles_down")  
end