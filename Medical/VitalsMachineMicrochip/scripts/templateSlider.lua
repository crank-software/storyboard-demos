--Script for slider template
local ACTIVE_SLIDER

function sliderPress(mapargs)

  ACTIVE_SLIDER = mapargs.context_group
  sliderSetup(mapargs)
  
end

function sliderMotion(mapargs)
  if (ACTIVE_SLIDER == nil) then
    return
  end
  
  if (ACTIVE_SLIDER == mapargs.context_group) then
    sliderSetup(mapargs)
  end
  
end


function sliderRelease(mapargs)

  ACTIVE_SLIDER = nil

end

function sliderSetup(mapargs)

  local dk_data = {}
  local data = {}
  local ev_data = {}
  local press_pos, group_pos, slider_width, percentage
  
  dk_data = gre.get_data(ACTIVE_SLIDER..".grd_x", ACTIVE_SLIDER..".sliderBG.grd_width")
  
  group_pos = dk_data[ACTIVE_SLIDER..".grd_x"]
  slider_width = dk_data[ACTIVE_SLIDER..".sliderBG.grd_width"]
    
  ev_data = mapargs.context_event_data   
  press_pos = ev_data.x - group_pos

  if(press_pos < 20)then
    press_pos = 20
  elseif(press_pos > slider_width + 12)then
    press_pos = slider_width + 12
  end

  data[ACTIVE_SLIDER..".sliderBG.width"] = press_pos - 12
  data[ACTIVE_SLIDER..".sliderDot.grd_x"] = press_pos - 8
  data[ACTIVE_SLIDER..".sliderPressedOverlay.grd_x"] = press_pos - 21
  
  gre.set_data(data)
  
  --The percentage of the slider that is filled up
  --Pass this into fucntions using the slider
  percentage = math.floor(((press_pos - 20) / (slider_width - 10)) * 10)
  gre.set_value("patient_layer.pat_detail_group.pain_score.pain_score", percentage.."/10")
  
end