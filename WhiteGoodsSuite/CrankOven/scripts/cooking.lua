local preheatProgressHeight = 534
local heatingTimer = nil
local ovenTimer = nil
local totalTimer = 0

local toggleTimer = nil

local activeTimer = 0
local activePreheat = 0

activeCookingValues = {
  mode = nil,
  temperature = 200,
  timer = nil
}

--timer with each of the numbers (without leading 0s), used for calculations on the flipping numbers
local activeSplitTimer = {
  hour = '',
  min = '',
  second = ''
}

--timer with each of the numebrs with leading 0s. Used for the text inputs
local activeFormattedTimer = {
  hour = '',
  min = '',
  second = ''
}

--can either be cook or time
local activeCookingDisplay = 'cook'

function CBSmartToggleToCook(mapargs)
  if(activeCookingDisplay == 'cook')then
    return
  end
  
  local data = {}
  gre.animation_trigger('COOK_toggleTemp')
  
  local toggleTemp = 'temp'
  local toggleTime
  if(activeCookingValues.timer ~= nil)then
  --set the timer to the formatted temperature
    toggleTime = 'timer '..activeFormattedTimer.hour..":"..activeFormattedTimer.min
  else
    toggleTime = 'timer 00:00'
  end
  
  data["cooking.smartToggle.temp.text"] = toggleTemp
  data["cooking.smartToggle.timer.text"] = toggleTime
  gre.animation_stop('COOK_tempToTimer')
  gre.animation_trigger('COOK_timerToTemp')
  gre.timer_set_timeout(function()
    gre.set_data(data)
  end,200)
  
  
  activeCookingDisplay = 'cook'
  
  if(toggleTimer ~= nil)then
    gre.timer_clear_timeout(toggleTimer)
    toggleTimer = nil
  end
  --after 5 seconds test out the smart toggle
  if(activePreheat == 0)then
    toggleTimer = gre.timer_set_timeout(CBSmartToggle,5000)
  end
end

function CBSmartToggleToTime(mapargs)
  if(activeCookingDisplay == 'time')then
    return
  end
  
  local data = {}
  gre.animation_trigger('COOK_toggleTime')
  gre.animation_stop('COOK_timerToTemp')

  local toggleTemp = 'temp '..activeCookingValues.temperature
  local toggleTime = 'timer'
  
  data["cooking.smartToggle.temp.text"] = toggleTemp
  data["cooking.smartToggle.timer.text"] = toggleTime
  --TODO:SETUP FOR ANIMATION
--  data["cooking.incrementUp.min.grd_hidden"] = 0
--  data["cooking.incrementUp.deg.grd_hidden"] = 1
--  data["cooking.incrementDown.min.grd_hidden"] = 0
--  data["cooking.incrementDown.deg.grd_hidden"] = 1
--  data["cooking.temperatureMid.grd_hidden"] = 1
--  data["cooking.timeMid.grd_hidden"] = 0

  gre.animation_trigger('COOK_tempToTimer')
  gre.timer_set_timeout(function()
    gre.set_data(data)
  end,200)
  
  activeCookingDisplay = 'time'
  
  if(toggleTimer ~= nil)then
    gre.timer_clear_timeout(toggleTimer)
    toggleTimer = nil
  end
  
  if(activeTimer == 0)then
    toggleTimer = gre.timer_set_timeout(CBSmartToggle,5000)
  end
  
end

function voiceCookUpdateTemp(incTemp)
  local data = {}
  cookingRequest.temperature = incTemp
  activeCookingValues.temperature = math.floor((activeCookingValues.temperature / 5)+0.5)*5
  data["cooking.temperatureMid.preheatText.text"] = incTemp
  gre.set_data(data)
  if(heatingTimer == nil)then
    startOvenHeating()
  end
end

function voiceCookUpdateTime(incTime)

  activeCookingValues.timer = incTime
  setupMorphStartingTimerNumbers(activeCookingValues.timer)
    
  if(ovenTimer == nil)then
    startOvenTimer()
  end
end

function CBIncrementTempTime(mapargs)
  local increment
  
  local data = {}
  
  if(activeCookingDisplay == 'cook')then
    if(mapargs.context_group == "cooking.incrementDown")then
      increment = -5
    else
      increment = 5
    end
    
    gre.animation_trigger('COOK_preheatFlash')
    
    cookingRequest.temperature = (math.floor((cookingRequest.temperature / 5)+0.5)*5) + increment
    activeCookingValues.temperature = math.floor((activeCookingValues.temperature / 5)+0.5)*5
    data["cooking.temperatureMid.preheatText.text"] = cookingRequest.temperature
    
    if(heatingTimer == nil)then
      startOvenHeating()
    end
    
  else
    
    if(activeCookingValues.timer == nil)then
      activeCookingValues.timer = 0
    end
        
    if(mapargs.context_group == "cooking.incrementDown")then
      if(activeCookingValues.timer <= 60)then
        --print('cancelling timer')
      else
        increment = -60
      end
      activeCookingValues.timer = activeCookingValues.timer + increment
    else
      increment = 60
      activeCookingValues.timer = activeCookingValues.timer + increment
    end
    
    setupMorphStartingTimerNumbers(activeCookingValues.timer)
    
    if(ovenTimer == nil)then
      startOvenTimer()
    end
    
  end

  gre.set_data(data)
  
end

local function setupPreheatOuterArc(incActive, incTarget)

--534 is the height of the elapsed time
  --find the percentage the active Temp is of the target temp and 175 (the lowest temperature)
  local percentage = (incActive - MIN_OVEN_TEMP)/(incTarget - MIN_OVEN_TEMP)
  local newHeight = math.floor(percentage * preheatProgressHeight)
  
  anim_preheatOuterArc(preheatProgressHeight, newHeight)
end

local function updateHeatingNumber()
    
  local activeTemp = tonumber(activeCookingValues.temperature)
  local targetTemp = tonumber(cookingRequest.temperature)
  
  activePreheat = 1
  
  if(activeTemp == targetTemp)then
    gre.timer_clear_interval(heatingTimer)
    heatingTimer = nil
    activePreheat = 0
    CBSmartToggle()
    CBIdlePress()
    return
  end
  
  local data = {}
  
  if(math.abs(activeTemp - targetTemp) > 5)then
    if(activeTemp > targetTemp)then
      activeTemp = activeTemp - 5
    else
      activeTemp = activeTemp + 5
    end
  else
    if(activeTemp > targetTemp)then
      activeTemp = activeTemp - 1
    else
      activeTemp = activeTemp + 1
    end
  end
  
  checkCookNumbersMorph(activeCookingValues.temperature, activeTemp)
  
  --if the smart toggle is on the opposite one, we update the text to match the new temp
  if(activeCookingDisplay ~= 'cook')then
    data["cooking.smartToggle.temp.text"] = 'temp '..activeTemp  
  end
  
  gre.set_data(data)
  setupPreheatOuterArc(activeTemp, targetTemp)
  activeCookingValues.temperature = activeTemp  
end

function startOvenHeating()

  local data = {}
  
  data["cooking.temperatureMid.preheatText.text"] = cookingRequest.temperature

  --setup the outside arcs so they never animate downards
  local percentage = (activeCookingValues.temperature - MIN_OVEN_TEMP)/(cookingRequest.temperature - MIN_OVEN_TEMP)
  local newHeight = math.floor(percentage * preheatProgressHeight)
  data["cooking.preheatProgressBar.elapsed.grd_height"] = newHeight
  data["cooking.preheatProgressBar.elapsed.grd_y"] = preheatProgressHeight - newHeight
  data["cooking.bakeUpper.cookTypeTextPlaceholder.image"] = "images/titles/"..cookingRequest.mode..".png"
  gre.set_data(data)
  
  
  setupMorphStartingTempNumbers(activeCookingValues.temperature)
  updateHeatingNumber()
  
  heatingTimer = gre.timer_set_interval(updateHeatingNumber,700)

end

local function setupTimerTables()
  local formattedTime = activeCookingValues.timer
  
  local h = math.floor(formattedTime / 3600)
  local m = math.floor((formattedTime - (h * 3600)) / 60)
  local s = math.floor(formattedTime - ((h * 3600) + (m * 60)))
  
  activeSplitTimer.hour = h
  activeSplitTimer.min = m
  activeSplitTimer.second = s
  
  if(h < 10)then
    activeFormattedTimer.hour = '0'..h
  elseif(h == 0)then
    activeFormattedTimer.hour = '00'
  else
    activeFormattedTimer.hour = h
  end

  if(m < 10)then
    activeFormattedTimer.min = '0'..m
  elseif(m == 0)then
    activeFormattedTimer.min = '00'
  else
    activeFormattedTimer.min = m
  end
  
  if(s < 10)then
    activeFormattedTimer.second = '0'..s
  elseif(s == 0)then
    activeFormattedTimer.second = '00'
  else
    activeFormattedTimer.second = s
  end
  
end

local function updateTimerNumber()
  activeTimer = 1
  --hold the previous number so we can animate from it in the number morph
  local prevTimerNumber = activeCookingValues.timer

  if(activeCookingValues.timer == 0)then
    if(SELF_CLEAN_ACTIVE == 1)then
      CBSmartToggle()
      SELF_CLEAN_ACTIVE = 0
      CBCancelCooking()
    else
      showTimerExpired(totalTimer)
    end
    gre.timer_clear_interval(ovenTimer)
    ovenTimer = nil
    activeCookingValues.timer = nil
    activeTimer = 0
    CBSmartToggle()
    return
  end

  local data = {}

  activeCookingValues.timer = activeCookingValues.timer - 1
  totalTimer = totalTimer + 1
  setupTimerTables()
  
  checkTimerNumbersMorph(prevTimerNumber, activeCookingValues.timer)
  
  if(activeCookingDisplay ~= 'time')then
    data["cooking.smartToggle.timer.text"] = 'timer '..activeFormattedTimer.hour..":"..activeFormattedTimer.min
  end
  
  gre.set_data(data)

end

function startOvenTimer()

  --every second, drop down 1 second?
  --before we start we have to set up all of the numbers to the proper ones since we are using images (keep these seperate maybe)
  setupMorphStartingTimerNumbers(activeCookingValues.timer)
  --start the total timer number
  ovenTimer = gre.timer_set_interval(updateTimerNumber,1000)

end

local cancellingPress = 0

function CBPressCancel()
  if(cancellingPress == 1)then
    return
  end
  
  cancellingPress = 1
  gre.animation_trigger('COOK_pressCancel')
  gre.animation_trigger('APP_cookScreenHide')
  gre.timer_set_timeout(CBCancelCooking,500)
  
end

function CBCancelCooking()
  --go to home screen
  --clear timers
  cancellingPress = 0
  gre.timer_clear_interval(heatingTimer)
  gre.timer_clear_interval(ovenTimer)
  --reset the total timer back to 0
  totalTimer = 0
  resetCookingScreen()
  SELF_CLEAN_ACTIVE = 0
  CBHideHomeLayers()
  clearTimerValues()
  --clear out the formatted time
  gre.send_event('goToHomeScreen')
end

function resetCookingScreen()
  --print('resetting Cooking Screen')
  --resets to make the popup setup to hide before we go back
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs_global("popupBG",layerData)
  gre.set_layer_attrs_global("setupBroil",layerData)
  gre.set_layer_attrs_global("setupTimeOverlay",layerData)
  gre.set_layer_attrs_global("setupTempOverlay",layerData)
  gre.set_layer_attrs_global("setupWarm",layerData)
  gre.set_layer_attrs_global("setupToggles",layerData)
  
  activeCookingValues.mode = nil
  activeCookingValues.temperature = 200
  activeCookingValues.timer = nil
  
  ovenTimer = nil
  heatingTimer = nil
  --reset the timer numbers to teh start
  CBResetSetup()
end

function CBAddTimerMin(mapargs)
--hide the layers, add 1 min to the timer, start the countdown
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs("timerExpiredOverlay",layerData)
  gre.set_layer_attrs("popupBG",layerData)
  activeCookingValues.timer = 60
  startOvenTimer()
  CBSmartToggleToTime()
end

function CBSmartToggle(mapargs)

  --if there is a timer and a preheat then we go to the preheat automatically
  --if there is a timer and preheat is done, we go to the timer
  --if the timer is done and we close out the timer button, go to the cooking button

  if(activeTimer == 1 and activePreheat == 1)then
    CBSmartToggleToCook()
  elseif(activeTimer == 1 and activePreheat == 0)then
    CBSmartToggleToTime()
  elseif(activeTimer == 0 and activePreheat == 1)then
    CBSmartToggleToCook()
  elseif(activeTimer == 0 and activePreheat == 0)then
    CBSmartToggleToCook()
  end

end

function cookIdleCancel()
  if(activeTimer == 0 and activePreheat == 0)then
    CBCancelCooking()
    CBHidePopUps()
  end
end

function clearTimerValues()
  activeFormattedTimer.hour = nil
  activeFormattedTimer.min = nil
  activeFormattedTimer.second = nil
  activeTimer = 0
end