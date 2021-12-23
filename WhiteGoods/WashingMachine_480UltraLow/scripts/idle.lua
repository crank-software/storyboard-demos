IDLE_TIME = 30000
local idleTimer = nil
IDLE_ANIMATION= 0

local function idleApp()
  --if app is in the middle of something then we do not go idles
  --if the app is automated, we do not idle
  if(AUTOMATED_MODE == 1)then
    return
  end
  gre.send_event('goToHomeScreen')
  gre.animation_trigger('IDLE_loop')
  hideCustomizeGlobal()
  IDLE_ANIMATION = 1
  --start the whole scrolling animation
  print('app is now idle')
end


function CBPressAppIdle()

  if(idleTimer ~= nil)then
    gre.timer_clear_timeout(idleTimer)
  end  
  
  if(IDLE_ANIMATION == 1)then
    gre.animation_stop('IDLE_loop')
  end
  
  idleTimer = gre.timer_set_timeout(idleApp,IDLE_TIME)
  IDLE_ANIMATION = 0
end