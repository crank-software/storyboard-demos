function cbResetStart(mapargs) 
local resetStart = {}
  resetStart["start_layer.start_blocker.grd_hidden"] = 1
  resetStart["size_layer.cup_md_control.alpha"] = 0
  resetStart["size_layer.cup_md_control.grd_y"] = 270--[153
  resetStart["start_layer.start.grd_y"] = 343 --[204
  resetStart["start_layer.start_glow.grd_y"] = 316--[189
  resetStart["start_layer.coffee.grd_y"] = 21--[12
  resetStart["start_layer.start_circle.grd_y"] = 65--[37
  resetStart["start_layer.start_blur.grd_y"] = 3--[2

  gre.set_data(resetStart)

end

function cbResetSizes(mapargs) 
local resetSizes = {}
  resetSizes["size_layer.size_blocker.grd_hidden"] = 0
  resetSizes["size_layer.select_size.alpha"] = 0

  resetSizes["size_layer.cup_sm_control.alpha"] = 0
  resetSizes["size_layer.cup_sm_control.alpha1"] = 0
  resetSizes["size_layer.cup_sm_control.alpha2"] = 0
  resetSizes["size_layer.cup_sm_control.alpha3"] = 255
  resetSizes["size_layer.cup_sm_control.alpha4"] = 178
  resetSizes["size_layer.cup_sm_control.grd_x"] = 150
  resetSizes["size_layer.cup_sm_control.grd_y"] = 270
  resetSizes["size_layer.cup_sm_control.grd_width"] = 0
  resetSizes["size_layer.cup_sm_control.grd_height"] = 0
  
  resetSizes["size_layer.cup_md_control.alpha"] = 0
  resetSizes["size_layer.cup_md_control.alpha1"] = 0
  resetSizes["size_layer.cup_md_control.alpha2"] = 0
  resetSizes["size_layer.cup_md_control.alpha3"] = 255
  resetSizes["size_layer.cup_md_control.alpha4"] = 178
  resetSizes["size_layer.cup_md_control.grd_x"] = 400
  resetSizes["size_layer.cup_md_control.grd_y"] = 270
  resetSizes["size_layer.cup_md_control.grd_width"] = 0
  resetSizes["size_layer.cup_md_control.grd_height"] = 0 

  resetSizes["size_layer.cup_lg_control.alpha"] = 0
  resetSizes["size_layer.cup_lg_control.alpha1"] = 0
  resetSizes["size_layer.cup_lg_control.alpha2"] = 0
  resetSizes["size_layer.cup_lg_control.alpha3"] = 255
  resetSizes["size_layer.cup_lg_control.alpha4"] = 178
  resetSizes["size_layer.cup_lg_control.grd_x"] = 648
  resetSizes["size_layer.cup_lg_control.grd_y"] = 270
  resetSizes["size_layer.cup_lg_control.grd_width"] = 0
  resetSizes["size_layer.cup_lg_control.grd_height"] = 0 
  
  gre.set_data(resetSizes)

end

function cbResetBrew(mapargs) 
local resetBrew = {}
  resetBrew["brew_layer.brew_blocker.grd_hidden"] = 0
  resetBrew["brew_layer.brew_cup.alpha"] = 255
  resetBrew["brew_layer.brew_control.endAngle"] = -90
  resetBrew["brew_layer.brew_control.y"] = 57
  resetBrew["brew_layer.brew_control.width"] = 0
  resetBrew["brew_layer.brew_control.height"] = 0
  resetBrew["brew_layer.brew_control.alpha"] = 0
  resetBrew["brew_layer.brew_control.alpha1"] = 0
  resetBrew["brew_layer.brew_control.alpha2"] = 0
  resetBrew["brew_layer.brew_control.alpha3"] = 0
  resetBrew["brew_layer.brew_control.alpha4"] = 0

  resetBrew["brew_layer.direction_control.alpha"] = 0
  resetBrew["brew_layer.direction_control.alpha1"] = 0
  resetBrew["brew_layer.direction_control.alpha2"] = 0
  
  resetBrew["brew_base_layer.bottom_bar.grd_y"] = 340
  resetBrew["brew_base_layer.bottom_bar.grd_height"] = 0
  resetBrew["brew_base_layer.back_control.grd_y"] = 280
  resetBrew["brew_base_layer.crank.grd_y"] = 203
    
  resetBrew["brew_layer.cup_small.grd_hidden"] = 1
  resetBrew["brew_layer.cup_small.alpha"] = 255
  resetBrew["brew_layer.cup_small.alpha1"] = 255
  resetBrew["brew_layer.cup_small.alpha2"] = 255

  resetBrew["brew_layer.cup_medium.grd_hidden"] = 1
  resetBrew["brew_layer.cup_medium.alpha"] = 255
  resetBrew["brew_layer.cup_medium.alpha1"] = 255
  resetBrew["brew_layer.cup_medium.alpha2"] = 255
    
  resetBrew["brew_layer.cup_large.grd_hidden"] = 1
  resetBrew["brew_layer.cup_large.alpha"] = 255
  resetBrew["brew_layer.cup_large.alpha1"] = 255
  resetBrew["brew_layer.cup_large.alpha2"] = 255
  
  resetBrew["brew_layer.underline.alpha"] = 255
  resetBrew["brew_layer.cup_copy.x"] = 344--[200
  resetBrew["brew_layer.brew_control.grd_x"] = 545--[327

  gre.set_data(resetBrew)

end

function cbResetBrewing(mapargs) 
local resetBrewing = {}
  resetBrewing["start_layer.start_blocker.grd_hidden"] = 1
  resetBrewing["size_layer.cup_md_control.alpha"] = 0
  resetBrewing["size_layer.cup_md_control.grd_y"] = 270--[153

  resetBrewing["brewing_layer.glow.alpha"] = 0
  resetBrewing["brewing_layer.ready.alpha"] = 0
  resetBrewing["brewing_layer.ready.y"] = 1300
  resetBrewing["brewing_layer.enjoy.alpha"] = 255
  resetBrewing["brewing_layer.enjoy.alpha1"] = 0
  resetBrewing["brewing_layer.brewing_control.alpha"] = 255
  resetBrewing["brewing_layer.brewing_control.alpha1"] = 255
  resetBrewing["brewing_layer.brewing_control.alpha2"] = 64
  resetBrewing["brewing_layer.brewing_control.endAngle"] = 270
  resetBrewing["brewing_layer.cup.alpha"] = 255
  resetBrewing["brewing_layer.cup_fill_control.alpha"] = 255
  resetBrewing["brewing_layer.cup_fill_control.alpha1"] = 255
  resetBrewing["brewing_layer.cup_fill_control.alpha2"] = 255
  resetBrewing["brewing_layer.cup_fill_control.alpha3"] = 255
  resetBrewing["brewing_layer.cup_fill_control.x"] = -73--[-44
  resetBrewing["brewing_layer.cup_fill_control.x1"] = 88--[53
  resetBrewing["brewing_layer.cup_fill_control.x2"] = 218--[131
  resetBrewing["brewing_layer.cup_fill_control.y"] = 147--[83
  resetBrewing["brewing_layer.cup_fill_control.y1"] = 147--[83

  gre.set_data(resetBrewing)

end