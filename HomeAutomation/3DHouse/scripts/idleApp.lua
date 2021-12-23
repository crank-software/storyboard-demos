local gidleTime = 15000
local gIdleTimer
local gScreenPressed = 0

function cb_screenIdleClears(mapargs)
  clearAppIdle()
  cb_appIdle()
end

function cb_appIdle(mapargs)
  --clearAppIdle()
  if(gScreenPressed == 1)then
    --print("11  --  app has started timer")
    gIdleTimer = gre.timer_set_timeout(appIdle, gidleTime)
    gScreenPressed = 0
  end
end

function appIdle()
  if(gScreenPressed ~= 1)then
    --print("22  --  app has fired timer")
  
  local dk_data = {}
  dk_data = gre.get_data("activeScreen")
  local activeScreen = dk_data["activeScreen"]
  
  if(activeScreen == "idleScreen")then
  return
  end
  
  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN..".auto_close")
  end
  CURRENT_OPEN=nil
  
  --call an animation that will reset the model
  --after the animation is called, swap to idle screen
  --on idle screen start the idle animation
  
  gre.animation_trigger("HOUSE_RoofOn")
  end
end


function clearAppIdle()
  
  gScreenPressed = 1
  
  local data
  --print(gIdleTimer)
  if(gIdleTimer ~= nil)then
    --print("00 -- app has cleared timer")
    data = gre.timer_clear_timeout(gIdleTimer)
  end
  
  
end


function cb_checkIdleAnim()
  
  local dk_data = {}
  dk_data = gre.get_data("idleScreen.idleActive")
  local idle = dk_data["idleScreen.idleActive"]
  
  if(idle == 1)then
    --gre.animation_trigger("IDLESCREEN_iconsCarosel")
    --send event to trigger a press event
    --match press to send same event
    gre.send_event("swapIdleScreen")
  else
  end

end