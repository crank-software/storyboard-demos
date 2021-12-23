local current_volume = 5 
local prev_volume
local max_volume = 10
local max_angle = 250
local end_angle = "volume_layer.volume_arc_control.endAngle"
local mute_icon = "images/mute_icon.png"
local volume_icon = "images/volume_icon_big.png"

function cb_increase_volume(mapargs)
  prev_volume = current_volume
  current_volume = current_volume + 1
  gre.set_value("volume_layer.volume_arc_control.to_angle", (max_angle / max_volume) * current_volume)
  gre.animation_trigger("volume_arc_animation")
  if current_volume == max_volume then
    gre.set_value("volume_layer.plus_button.grd_active", false)
    gre.set_value("volume_layer.plus_button.alpha", 128)
  elseif current_volume == 1 then 
    gre.set_value("volume_layer.minus_button.grd_active", true)
    gre.set_value("volume_layer.minus_button.alpha", 255)
    gre.set_value("volume_layer.volume_control.image", volume_icon)
  end
end

function cb_decrease_volume(mapargs)
  prev_volume = current_volume
  current_volume = current_volume - 1
  gre.set_value("volume_layer.volume_arc_control.to_angle", (max_angle / max_volume) * current_volume)
  gre.animation_trigger("volume_arc_animation")
  
  if current_volume == 0 then
    gre.set_value("volume_layer.minus_button.grd_active", false)
    gre.set_value("volume_layer.minus_button.alpha", 128)
    gre.set_value("volume_layer.volume_control.image", mute_icon)
  elseif current_volume == max_volume - 1 then
    gre.set_value("volume_layer.plus_button.grd_active", true)
    gre.set_value("volume_layer.plus_button.alpha", 255)
  end
end

function cb_mute_volume(mapargs) 
  if current_volume == 0 then 
    gre.set_value("volume_layer.minus_button.grd_active", true)
    gre.set_value("volume_layer.minus_button.alpha", 255)
    gre.set_value("volume_layer.volume_control.image", volume_icon)
    gre.set_value("volume_layer.volume_arc_control.to_angle", (max_angle / max_volume) * prev_volume)
    gre.animation_trigger("volume_arc_animation")
    current_volume = prev_volume
  else
    gre.set_value("volume_layer.minus_button.grd_active", false)
    gre.set_value("volume_layer.minus_button.alpha", 128)
    gre.set_value("volume_layer.volume_control.image", mute_icon)
    gre.set_value("volume_layer.volume_arc_control.to_angle", 0)
    gre.animation_trigger("volume_arc_animation")
    prev_volume = current_volume
    current_volume = 0
  end
end

function cb_enter_volume_screen(mapargs) 
  if gre.get_value("music_playing") == 1 then
    gre.animation_trigger("volume_bars")
  end
end
