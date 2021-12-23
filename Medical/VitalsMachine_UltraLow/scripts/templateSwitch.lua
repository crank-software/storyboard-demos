--Script for switch template

function switchToggle(mapargs)

  local key = mapargs.context_group..".toggle"
  local dk_data = {}
  local data = {}
  local toggle
  
  dk_data = gre.get_data(key)
  toggle = dk_data[key]
  
  local animData = {}
  animData["context"] = mapargs.context_group
  
  if(toggle == 0)then
    gre.animation_trigger("switchOn", animData)
    --gre.send_event_target("switchOn", mapargs.context_group)
    toggle = 1
    --Call function for toggleOn state
  else
    gre.animation_trigger("switchOff", animData)
    --gre.send_event_target("switchOff", mapargs.context_group)
    toggle = 0
    --Call function for toggleOff state
  end
  
  data[key] = toggle
  gre.set_data(data)

end