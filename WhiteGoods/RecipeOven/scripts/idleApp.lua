local gidleTime = 15000
local gIdleTimer
local gScreenPressed = 0
local currentScreen = 1


--on release we call this
function cb_appIdle(mapargs)
  --clearAppIdle()
  if(gScreenPressed == 1)then
    --print("11  --  app has started timer")
    gIdleTimer = gre.timer_set_timeout(appIdle, gidleTime)
    gScreenPressed = 0
  end
end

--what happens when it is idle
function appIdle()
  if(gScreenPressed ~= 1)then
    --print("22  --  app has fired timer")
  end
  
  currentScreen = gre.get_value("currentScreen")  
  if(currentScreen ~= 1)then
    gre.send_event("goToAppIdle")
  end
  
  
  
end

--on press we call this
function clearAppIdle()
  
  gScreenPressed = 1
  
  local data
  --print("00 -- app has been pressed")
  if(gIdleTimer ~= nil)then
    data = gre.timer_clear_timeout(gIdleTimer)
  end
  
  
end