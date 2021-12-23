function CBPressContact(mapargs)
  
  --get values for the thingies
  local data_table = {}
  data_table = gre.get_data(mapargs.context_group..".emailText", mapargs.context_group..".locationText", mapargs.context_group..".mobileText", mapargs.context_group..".nameText", mapargs.context_group..".numberText", mapargs.context_group..".image" )
  local email = data_table[mapargs.context_group..".emailText"]
  local location = data_table[mapargs.context_group..".locationText"]
  local mobile = data_table[mapargs.context_group..".mobileText"]
  local name = data_table[mapargs.context_group..".nameText"]
  local number = data_table[mapargs.context_group..".numberText"]
  local image = data_table[mapargs.context_group..".image"]
  
  local data = {}
  data["address.location.locationText.text"] = location
  data["address.phone.phoneText.text"] = number
  data["address.email.emailText.text"] = email
  data["address.mobile.mobileText.text"] = mobile
  data["address.profile.nameMain.text"] = name
  data["address.profile.profileImage.image"] = image
  
  gre.set_data(data)
  print("pressed")
end