local DEMO_MODE = 0

function cb_demo_init(mapargs) 
  local demo_value = os.getenv("SB_DEMO")
  
  if demo_value ~= nil or DEMO_MODE == 1 then
    if demo_value == "1" or DEMO_MODE == 1 then
      local sdata = {}
      sdata["hidden"] = 0
      gre.set_layer_attrs_global("homeScreen.closeButton_layer",sdata)
    end
  end
end

function cb_close_button(mapargs) 
  gre.quit() 
end