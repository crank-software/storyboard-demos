--Script for switch template

function switchToggle(mapargs)
  print(mapargs.context_group..".toggle")
  local key = mapargs.context_group..".toggle"
  local id = mapargs.context_group..".animID"
  local dk_data = {}
  local data = {}
  local toggle
  local animData = {}
  
  dk_data = gre.get_data(key)
  toggle = dk_data[key]
  
  if(toggle == 0)then
    --gre.send_event_target("switchOn", mapargs.context_group)
    animData["context"] = mapargs.context_group
    animData["id"] = id
    gre.animation_trigger("switchOn", animData)
    toggle = 1
    --Call function for toggleOn state
  else
    --gre.send_event_target("switchOff", mapargs.context_group)
    animData["context"] = mapargs.context_group
    animData["id"] = id
    gre.animation_trigger("switchOff", animData)
    toggle = 0
    --Call function for toggleOff state
  end
  
  data[key] = toggle
  gre.set_data(data)

end