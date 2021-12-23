local passcode = ""

function cb_keypad_press(mapargs) 
  local data = {}

  if string.len(passcode) < 8 then
    passcode = passcode.."*"
    data["password_layer.pass_control.text"] = passcode
    gre.set_data(data)
  end

end

function cb_clear_passcode(mapargs)
  local data = {}
  
  passcode = ""
  data["password_layer.pass_control.text"] = passcode
  gre.set_data(data)
end