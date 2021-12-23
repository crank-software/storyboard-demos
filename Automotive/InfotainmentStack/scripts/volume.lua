app_volume = 0
local app_volume_active = {}

function app_change_volume(direction)

  if(direction == 1)then
    app_volume = app_volume + 1
  end

  if(direction == 0)then
    app_volume = app_volume - 1
  end

  if(app_volume > 100)then
    app_volume = 100
  end
  
  if(app_volume < 0)then
    app_volume = 0
  end
  
  app_volume_graphics_update()
  
  print(app_volume)
  

  local dk_data = {}
  local data = {}
  local data_tim
  -- check if my_layer is currently hidden
  dk_data = gre.get_layer_attrs("volume_overlay_layer", "hidden")
  if dk_data["hidden"] == 1 then
    data["hidden"] = 0
  else
    print("volume is already visible is currently visible")
  end
  
  

  
  gre.set_layer_attrs("volume_overlay_layer", data)
  
  data_tim = gre.timer_clear_timeout(app_volume_active)
  app_volume_active = gre.timer_set_timeout(volume_hide_volume, 500)


end

function volume_hide_volume()

  local data = {}
  data["hidden"] = 1
  gre.set_layer_attrs("volume_overlay_layer", data)
  
end

function app_volume_graphics_update()

  local data = {}
  local writtenapp_volume = math.floor(app_volume/4)
  
  
  data["volume_overlay_layer.volume_overlay_circle_black.angle"] = app_volume * 3.6
  data["volume_overlay_layer.volume_overlay_volume.text"] = writtenapp_volume
  data["top_status_layer.volume_fg.width"] = writtenapp_volume
  data["volume_overlay_layer.volume_overlay_circle_black.end_indicator_angle"] = (app_volume * 3.6) - 90
  
  gre.set_data(data)

end