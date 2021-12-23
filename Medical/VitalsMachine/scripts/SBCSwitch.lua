
-- Callback handler for the slider button
function SBCSwitchToggle(mapargs)
  local cbVar = mapargs.context_group..".callback"
  local cbName = gre.get_value(cbVar)
  local dk_data = {}
  local toggleKey = mapargs.context_group..".toggle"
  local toggle
  local animationName
  local data = {}
  local animationKey = mapargs.context_group..".animationName"
  
  dk_data = gre.get_data(toggleKey)
  toggle = dk_data[toggleKey]
  
  if(toggle == 0) then
    toggle = 1
    animationName = "SBCSwitchToggleOn";
  else
    toggle = 0
    animationName = "SBCSwitchToggleOff";
  end
  
  data[toggleKey] = toggle
  data[animationKey] = animationName;
  gre.set_data(data)
  
  -- call the callback function, if specified
  if(cbName == nil or cbName == "") then
    return
  end
  
  local cbFn = _G[cbName]
  if(cbFn == nil or type(cbFn) ~= "function") then
    return
  end
  
  cbFn(mapargs.context_group, toggle)
end
