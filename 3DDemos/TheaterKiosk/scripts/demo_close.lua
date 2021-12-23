local DEMO_MODE = 0
gVideoSupport = nil

function cb_demo_init(mapargs) 
  local demo_value = os.getenv("SB_DEMO")
  
  if demo_value ~= nil or DEMO_MODE == 1 then
    if demo_value == "1" or DEMO_MODE == 1 then
      local sdata = {}
      sdata["hidden"] = 0
      gre.set_layer_attrs_global("selectMovieScreen.closeButton_layer",sdata)
    end
  end
  
  local video_value = os.getenv("SB_VIDEO")
  if(video_value == "0")then
    gVideoSupport = 0
  else
    gVideoSupport = 1
  end
  
  APP_INIT()
  
end

function cb_close_button(mapargs) 
  gre.quit()
end