function animation_navi_location_select(mapargs)
  local index = mapargs.context_row
  local key = (mapargs.context_control)
  local anim_data = {}
  
  local navi_location_select = gre.animation_create(60, 1)
  
  anim_data["key"] = key..".fill_alpha."..index..".1"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 155
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 100
  gre.animation_add_step(navi_location_select, anim_data)
  
  anim_data["duration"] = 300
  anim_data["offset"] = 77
  anim_data["from"] = 100
  anim_data["to"] = 0
  gre.animation_add_step(navi_location_select, anim_data)
  
  anim_data["key"] = key..".fill_width."..index..".1"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 500
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 279
  gre.animation_add_step(navi_location_select, anim_data)
  
  gre.animation_trigger(navi_location_select)
  
end

function animation_library_select(mapargs)
  local index = mapargs.context_row
  local key = (mapargs.context_control)
  local anim_data = {}
  
  local navi_location_select = gre.animation_create(60, 1)
  
  anim_data["key"] = key..".fill_alpha."..index..".2"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 155
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 100
  gre.animation_add_step(navi_location_select, anim_data)
  
  anim_data["duration"] = 300
  anim_data["offset"] = 77
  anim_data["from"] = 100
  anim_data["to"] = 0
  gre.animation_add_step(navi_location_select, anim_data)
  
  anim_data["key"] = key..".fill_width."..index..".2"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 500
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 279
  gre.animation_add_step(navi_location_select, anim_data)
  
  gre.animation_trigger(navi_location_select)
  
end