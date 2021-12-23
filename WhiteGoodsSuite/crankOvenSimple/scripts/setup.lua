--default temps for broil/warm/etc. Want to keep these as numbers so the cook screen is always doing something instead of just
--showing a word
--variables need to be global as they are the min and max oven temp and will be used to check things on multiple screens
MIN_OVEN_TEMP = 175
MAX_OVEN_TEMP = 600
SELF_CLEAN_ACTIVE = 0

local defaultCookTemp = 350
local defaultBroilTemp = 550
local defaultWarmTemp = 200
local selfCleanTime = 180

cookingRequest = {
  mode = nil,
  temperature = nil,
  timer = nil,
}

local inputTempNumber = ''
local inputTimeNumber = ''
local inputBroilLevel = ''
local inputWarmLevel = ''

local formattedTime = {
  hour = nil,
  min = nil
}

function sendDefaults()
  local defaults = {}
  defaults.cook = defaultCookTemp
  defaults.broil = defaultBroilTemp
  defaults.warm = defaultWarmTemp
  return defaults
end

local function tempNumberSetupDisplay()

  local data = {}
  local formattedNum
  local numLen = string.len(inputTempNumber)
  local one, ten, hun
  
  if(numLen == 0)then
    formattedNum = '000'
    one = '0'
    ten = '0'
    hun = '0'
  elseif(numLen == 1)then
    formattedNum = '00'..inputTempNumber
    one = inputTempNumber
    ten = '0'
    hun = '0'
  elseif(numLen == 2)then
    formattedNum = '0'..inputTempNumber
    one = string.sub(inputTempNumber,2,2)
    ten = string.sub(inputTempNumber,1,1)
    hun = '0'
  elseif(numLen == 3)then
    formattedNum = inputTempNumber
    one = string.sub(inputTempNumber,3,3)
    ten = string.sub(inputTempNumber,2,2)
    hun = string.sub(inputTempNumber,1,1)
  end
  
  --data["setupToggles.cookMode.text"] = formattedNum
  data["setupToggles.cookMode.one"] = one
  data["setupToggles.cookMode.ten"] = ten
  data["setupToggles.cookMode.hun"] = hun
  data["setupTempOverlay.inputTemp.one"] = one
  data["setupTempOverlay.inputTemp.ten"] = ten
  data["setupTempOverlay.inputTemp.hun"] = hun
  --data["setupTempOverlay.inputTemp.text"] = formattedNum
  gre.set_data(data)
  
end

function CBInputTempNumber(mapargs)
  
  local incNum = mapargs.num
  --use 11 as a 'digit' to mean clear
  if(incNum == '11')then
    inputTempNumber = ''
    tempNumberSetupDisplay()
    return
  end

  if(string.len(inputTempNumber) >= 3)then
    return
  end
      
  if(inputTempNumber ~= nil)then
    inputTempNumber = inputTempNumber..incNum
  else
    inputTempNumber = incNum
  end
  
  tempNumberSetupDisplay()

end

local function timeNumberSetupDisplay()

  local data = {}
  --local formattedMin, formattedHour
  local numLen = string.len(inputTimeNumber)
  local minOne,minTen,HourOne,HourTen
  
  if(numLen == 0)then
    formattedTime.min = '00'
    formattedTime.hour = '00'
    minOne = '0'
    minTen = '0'
    HourOne = '0'
    HourTen = '0'
  elseif(numLen == 1)then
    formattedTime.min = '0'..inputTimeNumber
    formattedTime.hour = '00'
    minOne = inputTimeNumber
    minTen = '0'
    HourOne = '0'
    HourTen = '0'
  elseif(numLen == 2)then
    formattedTime.min = inputTimeNumber
    formattedTime.hour = '00'
    minOne = string.sub(inputTimeNumber,2,2)
    minTen = string.sub(inputTimeNumber,1,1)
    HourOne = '0'
    HourTen = '0'
  elseif(numLen == 3)then
    formattedTime.min = string.sub(inputTimeNumber,-2)
    formattedTime.hour = '0'..string.sub(inputTimeNumber,1,1)
    minOne = string.sub(inputTimeNumber,3,3)
    minTen = string.sub(inputTimeNumber,2,2)
    HourOne = string.sub(inputTimeNumber,1,1)
    HourTen = '0'
  elseif(numLen == 4)then
    formattedTime.min = string.sub(inputTimeNumber,-2)
    formattedTime.hour = string.sub(inputTimeNumber,1,2)
    minOne = string.sub(inputTimeNumber,4,4)
    minTen = string.sub(inputTimeNumber,3,3)
    HourOne = string.sub(inputTimeNumber,2,2)
    HourTen = string.sub(inputTimeNumber,1,1)
  end
  
  --data["setupToggles.timer.text"] = formattedTime.hour..":"..formattedTime.min
  --data["setupTimeOverlay.timeNum.textMin"] = formattedTime.min
  --data["setupTimeOverlay.timeNum.textHour"] = formattedTime.hour
  data["setupTimeOverlay.timeNum.hourOne"] = HourOne
  data["setupTimeOverlay.timeNum.hourTen"] = HourTen
  data["setupTimeOverlay.timeNum.minOne"] = minOne
  data["setupTimeOverlay.timeNum.minTen"] = minTen
  data["setupToggles.timer.secOne"] = minOne
  data["setupToggles.timer.secTen"] = minTen
  data["setupToggles.timer.minOne"] = HourOne
  data["setupToggles.timer.minTen"] = HourTen
  gre.set_data(data)
  
end

function CBInputTimeNumber(mapargs)
  
  local incNum = mapargs.num
  --use 11 as a 'digit' to mean clear
  if(incNum == '11')then
    inputTimeNumber = ''
    timeNumberSetupDisplay()
    return
  end

  if(string.len(inputTimeNumber) >= 4)then
    return
  end
      
  if(inputTimeNumber ~= nil)then
    inputTimeNumber = inputTimeNumber..incNum
  else
    inputTimeNumber = incNum
  end
  
  --print(inputTimeNumber)
  timeNumberSetupDisplay()

end

function CBToggleBroil(mapargs)
  local incLevel = mapargs.level
  if(inputBroilLevel == incLevel)then
    return
  end
  local animData = {}
  
  animData['context'] = "setupBroil."..inputBroilLevel
  gre.animation_trigger('SETUP_optionUnselect', animData)
  animData['context'] = mapargs.context_group
  gre.animation_trigger('SETUP_optionSelect', animData)
  
  inputBroilLevel = incLevel
end

function CBToggleWarm(mapargs)
  local incLevel = mapargs.level
  if(inputWarmLevel == incLevel)then
    return
  end
  local animData = {}
  
  animData['context'] = "setupWarm."..inputWarmLevel
  gre.animation_trigger('SETUP_optionUnselect', animData)
  animData['context'] = mapargs.context_group
  gre.animation_trigger('SETUP_optionSelect', animData)
  
  inputWarmLevel = incLevel
end

local function formatTimerForRequest()
  local numLen
  numLen = string.len(inputTimeNumber)
  
  cookingRequest.timer = (tonumber(formattedTime.hour) * 3600) + (tonumber(formattedTime.min) * 60)
  --print(cookingRequest.timer)
  
  activeCookingValues.timer = tonumber(cookingRequest.timer)

end

local function bakeTempValid()
  if(inputTempNumber == '')then
    return
  end
  
  if(tonumber(inputTempNumber) > MAX_OVEN_TEMP or tonumber(inputTempNumber) < MIN_OVEN_TEMP)then
    --print('temperature out of bounds')
    return false
  else
    return true
  end
end

local function formatTemperatureForRequest()
  --check the mode
  --based on the mode set the temperature
  --print(cookingRequest.mode)
  if(cookingRequest.mode == 'bake' or cookingRequest.mode == 'smartCook' or cookingRequest.mode == 'convBake' or cookingRequest.mode == 'roast')then
    if(bakeTempValid())then
      cookingRequest.temperature = inputTempNumber
    else
      cookingRequest.temperature = ''
    end
    
  elseif(cookingRequest.mode == 'broil')then
    cookingRequest.temperature = defaultBroilTemp
  elseif(cookingRequest.mode == 'warm')then
   cookingRequest.temperature = defaultWarmTemp
  end
end

function showInvalidTemp()
  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs_global("setupInvalid",layerData)
  
  gre.timer_set_timeout(function()
    local layerData = {}
    layerData['hidden'] = 1
    gre.set_layer_attrs_global("setupInvalid",layerData) 
  end,  5000)

end

local cookingRequestSent = 0

function CBSendStartRequest(mapargs)

  if(cookingRequestSent == 1)then
    --print('cookingRequestSent')
    return
  end
  
  formatTemperatureForRequest()
  --after formatting if the temp is '' then we back out of allowing user to set temp
  if(cookingRequest.temperature == '')then
    showInvalidTemp()
    --print('please enter a temperature')
    return  
  end
  
  
  --print(formattedTime.hour, formattedTime.min)
  if((formattedTime.hour == nil and formattedTime.min == nil) or (formattedTime.hour == '00' and formattedTime.min == '00'))then
    --print('setup for a 0 timer, still allow them to add time like usual')
  else
    formatTimerForRequest()
    startOvenTimer()
  end
  
  startOvenHeating()
  cookingRequestSent = 1
  --go to the screen after the animation is done
  gre.animation_trigger('SETUP_pressStart')
  gre.timer_set_timeout(function()
    CBHideCookingLayer()
    gre.send_event('goToCookScreen')
    cookingRequestSent = 0
  end,250)


end

function CBResetSetup()
  --reset the setup when the oven is cancelled, or when the close button is hit
  cookingRequest = {
    mode = nil,
    temperature = nil,
    timer = nil,
  }

  inputTempNumber = ''
  inputTimeNumber = ''
  inputBroilLevel = ''
  inputWarmLevel = ''

  formattedTime = {
    hour = nil,
    min = nil
  }
  
  gre.animation_trigger('SETUP_toggleCooking')
  
  local data = {}
  data["setupToggles.cookMode.one"] = '0'
  data["setupToggles.cookMode.ten"] = '0'
  data["setupToggles.cookMode.hun"] = '0'
  data["setupToggles.timer.text"] = '00:00'
  data["setupTempOverlay.inputTemp.text"] = '000'
  data["setupTempOverlay.inputTemp.one"] = '0'
  data["setupTempOverlay.inputTemp.ten"] = '0'
  data["setupTempOverlay.inputTemp.hun"] = '0'
  data["setupTimeOverlay.timeNum.hourOne"] = '0'
  data["setupTimeOverlay.timeNum.hourTen"] = '0'
  data["setupTimeOverlay.timeNum.minOne"] = '0'
  data["setupTimeOverlay.timeNum.minTen"] = '0'
  data["setupToggles.timer.secOne"] = '0'
  data["setupToggles.timer.secTen"] = '0'
  data["setupToggles.timer.minOne"] = '0'
  data["setupToggles.timer.minTen"] = '0'
  data["setupTimeOverlay.timeNum.textHour"] ='00'
  data["setupTimeOverlay.timeNum.textMin"] = '00'
  gre.set_data(data)
end

function CBQuickStart(mapargs)

  cookingRequest.mode = getSelectedCookMode()
  local temp = cookModes[cookingRequest.mode].quickStartValue
  setupMorphStartingTimerNumbers(0)
  clearTimerValues()
  gre.set_value("cooking.smartToggle.timer.text", 'timer 00:00')
  --print(cookingRequest.mode)
  
  if(cookingRequest.mode == 'bake' or cookingRequest.mode == 'smartCook' or cookingRequest.mode == 'convBake' or cookingRequest.mode == 'roast')then
    cookingRequest.temperature = temp
  elseif(cookingRequest.mode == 'broil')then
    cookingRequest.temperature = defaultBroilTemp
  elseif(cookingRequest.mode == 'warm')then
   cookingRequest.temperature = defaultWarmTemp
  elseif(cookingRequest.mode == 'selfClean')then
    startSelfClean()
    return
  elseif(cookingRequest.mode == 'energy')then
    cookingRequest.mode = 'bake'
    cookingRequest.temperature = 400
  end
  
  startOvenHeating()
  CBHideCookingLayer()
  CBSmartToggleToCook()
  gre.send_event('goToCookScreen')
  
end

function setupToggles(incSetup)
  local animData = {}
  if(incSetup == 'broil')then
    inputBroilLevel = 'high'
    
    animData['context'] = "setupBroil.crisp"
    gre.animation_trigger('SETUP_optionUnselect', animData)
    animData['context'] = "setupBroil.high"
    gre.animation_trigger('SETUP_optionSelect', animData)
    animData['context'] = "setupBroil.low"
    gre.animation_trigger('SETUP_optionUnselect', animData)
    
  elseif(incSetup == 'warm')then
    inputWarmLevel = 'moist'
    
    animData['context'] = "setupWarm.crisp"
    gre.animation_trigger('SETUP_optionUnselect', animData)
    animData['context'] = "setupWarm.moist"
    gre.animation_trigger('SETUP_optionSelect', animData)
  end
end

function startSelfClean()
    activeCookingValues.timer = selfCleanTime
    startOvenTimer()
    --setup for all of the stuff to be the correct alphas/etc
    
    SELF_CLEAN_ACTIVE = 1
    CBHideCookingLayer()
    gre.send_event('goToSelfCleanScreen')
end