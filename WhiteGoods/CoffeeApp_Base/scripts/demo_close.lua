local DEMO_MODE = 0
local AUTOMATED = 0

function cb_demo_init(mapargs) 
  local demo_value = os.getenv("SB_DEMO")
  local automated_value = os.getenv("SB_AUTO")
  
  if demo_value ~= nil or DEMO_MODE == 1 then
    if demo_value == "1" or DEMO_MODE == 1 then
      local sdata = {}
      sdata["hidden"] = 0
      gre.set_layer_attrs_global("start_sc.closeButton_layer",sdata)
    end
  end
  if automated_value ~= nil or AUTOMATED == 1 then
    if automated_value == "1" or AUTOMATED == 1 then
      gre.set_value("playback", string.format("%s/../home.txt", gre.SCRIPT_ROOT))
      print("playback: ", gre.get_value("playback"))
      gre.send_event("startPlayback")
    end
  end
end

function cb_close_button(mapargs) 
  gre.quit() 
end