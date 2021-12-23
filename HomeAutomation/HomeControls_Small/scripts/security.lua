local passcode = ""
local armed = 1
local state = "armed"

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


function cb_armed(mapargs) 
    local data = {}

    if armed == 1 then
       gre.animation_trigger("shield_armed")
       gre.animation_trigger("shield")
       gre.animation_trigger("btn_pulse")
    else
       gre.send_event("disarm_animation")
     end

  gre.set_data(data)
end


function cb_state(mapargs)
    local data = {}
    
    if armed == 1 then
       armed = 0 
       data["sec_status_layer.status_control.status"] = "ONLINE"
    else
       armed = 1
       data["sec_status_layer.status_control.status"] = "ARMED"
    end

    gre.set_data(data)
    cb_armed() 
end