local ACTIVE_SLIDER = nil


function settings_slider_position(mapargs)
  local data = {}

  local press_x = mapargs.context_event_data.x
  local control = gre.get_control_attrs(mapargs.context_control, "x")
  
  if (press_x > 496 and press_x < 749) then
    data["submenu_drawer_options_layer.brightness_thumb_stroke.grd_x"] = press_x  - 12
    data["submenu_drawer_options_layer.brightness_fg.grd_width"] = press_x - control["x"] - 23
  end
  
  gre.set_data(data)
end

function settings_slider_press(mapargs)
  ACTIVE_SLIDER = mapargs.context_control
  
  settings_slider_position(mapargs)
end


function settings_slider_motion(mapargs)
  
  if ACTIVE_SLIDER == nil then
    return
  end
  
  if ACTIVE_SLIDER == mapargs.context_control then
    settings_slider_position(mapargs)
  end
end


function settings_slider_release(mapargs)

  ACTIVE_SLIDER = nil 
end