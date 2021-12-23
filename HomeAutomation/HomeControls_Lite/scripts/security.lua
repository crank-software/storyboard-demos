local passcode = ""

function cb_keypad_press(mapargs) 
  local data = {}
  local gdata = {}
  
  gdata = gre.get_control_attrs(mapargs.context_control,"x", "y")
  
  data["sec_keypad_layer.keypad_highlight.grd_y"] = gdata["y"]
  data["sec_keypad_layer.keypad_highlight.grd_x"] =  gdata["x"]
  data["sec_keypad_layer.key_y"] = gdata["y"] - 15
  data["sec_keypad_layer.key_x"] = gdata["x"] - 15
  

  if string.len(passcode) < 8 then
    passcode = passcode.."*"
    data["password_layer.pass_control.text"] = passcode
  end
  
  gre.set_data(data)
  gre.animation_trigger("key_highlight")
end

function cb_clear_passcode(mapargs)
  local data = {}
  
  passcode = ""
  data["password_layer.pass_control.text"] = passcode
  
  gre.set_data(data)
end

function cb_clear_passcode(mapargs)
  local data = {}
  
  passcode = ""
  data["password_layer.pass_control.text"] = passcode
  gre.set_data(data)
end