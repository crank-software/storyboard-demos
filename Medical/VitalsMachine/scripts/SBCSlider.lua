local ACTIVE_SLIDER

-- Callback handler for the slider
function SBCSliderPress(mapargs)
  ACTIVE_SLIDER = mapargs.context_group
  SBCSliderSetup(mapargs)
end

function SBCSliderMotion(mapargs)
  if (ACTIVE_SLIDER == nil) then
    return
  end
  
  if (ACTIVE_SLIDER == mapargs.context_group) then
    SBCSliderSetup(mapargs)
  end
end

function SBCSliderRelease(mapargs)
  ACTIVE_SLIDER = nil
end

function SBCSliderSetup(mapargs)
  local dk_data = {}
  local pressPos, groupPos, sliderWidth, percentage 
  local eventData = mapargs.context_event_data 
  local data = {}
  local cbVar = mapargs.context_group .. ".callback"
  local cbName = gre.get_value(cbVar)
  
  dk_data = gre.get_data(ACTIVE_SLIDER..".grd_x", ACTIVE_SLIDER..".sliderBG.grd_width")
  
  groupPos = dk_data[ACTIVE_SLIDER..".grd_x"]
  sliderWidth = dk_data[ACTIVE_SLIDER..".sliderBG.grd_width"]
    
  pressPos = eventData.x - groupPos

  if(pressPos < 20)then
    pressPos = 20
  elseif(pressPos > sliderWidth + 12)then
    pressPos = sliderWidth + 12
  end

  data[ACTIVE_SLIDER..".sliderBG.width"] = pressPos - 12
  data[ACTIVE_SLIDER..".sliderDot.grd_x"] = pressPos - 8
  data[ACTIVE_SLIDER..".sliderPressedOverlay.grd_x"] = pressPos - 21
  gre.set_data(data)
  
  -- The percentage of the slider that is filled up
  -- Pass this into fucntions using the slider
  percentage = math.floor(((pressPos - 20) / (sliderWidth - 10)) * 100)

  -- call the callback function, if specified
  if (cbName == nil or cbName == "") then
    return
  end
  
  local cbFn = _G[cbName]
  if (cbFn == nil or type(cbFn) ~= "function") then
    return
  end
  
  cbFn(percentage)
end
