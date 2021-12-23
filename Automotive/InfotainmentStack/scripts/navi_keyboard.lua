local address = ""
local ndigits = 0

function navi_keyboard_press(mapargs)
  local data = {}
  
  address = address..mapargs.char
  ndigits = ndigits + 1
  
  data["navi_keyboard_layer.navi_keyboard_layer_prompt.text"] = address
  data["navi_find_directions_drawer_layer.find_directions_drawer_prompt.text"] = address
  
  gre.set_data(data)
  if(mapargs.char ~= " ")then
    local dk_data = {}
    local data = {}
    
    dk_data = gre.get_control_attrs(mapargs.context_control, "x", "y")
    
    data["x"] = dk_data["x"] - 33
    data["y"] = dk_data["y"] - 33
    
    gre.set_control_attrs("navi_keyboard_layer.navi_keyboard_button_press", data)  
    
    gre.animation_trigger("navi_keyboard_button_press")
  end
end

function navi_keyboard_delete(mapargs)
  local data = {}
  
  if (ndigits == 0) then
    return 0
  end
  
  ndigits = ndigits - 1
  local len = string.len(address)
  len = len - 1
  local new = string.format("%s", string.sub(address,1,len))
  address = new
  
  data["navi_keyboard_layer.navi_keyboard_layer_prompt.text"] = address
  data["navi_find_directions_drawer_layer.find_directions_drawer_prompt.text"] = address
  
  gre.set_data(data)
  
  local dk_data = {}
  local data = {}
    
  dk_data = gre.get_control_attrs(mapargs.context_control, "x", "y")
    
  data["x"] = dk_data["x"] - 24
  data["y"] = dk_data["y"] - 24
    
  gre.set_control_attrs("navi_keyboard_layer.navi_keyboard_button_press", data)  
    
  gre.animation_trigger("navi_keyboard_button_press")
  
end

function phone_keypad_clear(mapargs)
  local data = {}
  
  address = ""
  ndigits = 0
  
  data["navi_keyboard_layer.navi_keyboard_layer_prompt.text"] = address
  data["navi_find_directions_drawer_layer.find_directions_drawer_prompt.text"] = address
  
  gre.set_data(data)  
  
end
