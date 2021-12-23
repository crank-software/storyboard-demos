local emphasisColour = '0xff7100'
local voiceColour = '0x999999'
local defaults = {}
--called when the user says hello Oven
function CBVoiceActivated(mapargs)

  local data = {}
  
  data["voiceActivationHeader.talkingLinesPlaceholder.grd_hidden"] = 0
  data["voiceActivationHeader.callToAction.grd_hidden"] = 1
  
  gre.set_data(data)
  triggerVoiceLinesAnim()
  
  --if the voice is still running, then we can do voice finished
  --hide the call to action
  --show animating lines

end

function CBVoiceResponding(mapargs)
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs_global("voiceActivationHeader", layerData)
  layerData['hidden'] = 0
  gre.set_layer_attrs_global("voiceTalking", layerData)
  gre.animation_stop(loopingVoiceLines)
  triggerVoiceDotsAnim()
end


function CBVoiceFinished(mapargs)
  local data = {}
  data["voiceActivationHeader.talkingLinesPlaceholder.grd_hidden"] = 1
  data["voiceActivationHeader.callToAction.grd_hidden"] = 0
  gre.set_data(data)
  
  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs_global("voiceActivationHeader", layerData)
  layerData['hidden'] = 1
  gre.set_layer_attrs_global("voiceTalking", layerData)
  
  gre.animation_stop(loopingVoiceDots)
end


function triggerVoiceLinesAnim()
  gre.animation_trigger(loopingVoiceLines)
end

function triggerVoiceDotsAnim()
  gre.animation_trigger(loopingVoiceDots)
end

local function formatVoiceTime(incTime)

  if(incTime)==nil or incTime == 0 then
    return nil
  end

  local h,m
  
  local h = math.floor(incTime / 3600)
  local m = math.floor((incTime - (h * 3600)) / 60)
  local timeString
  if(h == 0)then
  timeString = m..'M'
  else
  timeString = h..'H '..m..'M'
  end
  return timeString
  
end

local function CBFormRecipeVoiceReply(incRecipe)
  local data = {}
  local reply = '<span style="color:#'..emphasisColour..';">'..string.upper(incRecipe)..'</span>'
  data["voiceTalking.commentBlock.text"] = '<p style="color:#'..voiceColour..'; text-align:center;">Starting the oven for '..reply..'</p>'
  gre.set_data(data)
  
  CBVoiceResponding()
  gre.timer_set_timeout(function()
    CBVoiceFinished()
  end,5000)
end

function CBFormVoiceReply(incMode, incTemp, incTimer, incType)
  
  local mode = incMode
  local value = incTemp
  local timer = formatVoiceTime(incTimer)
  local type = incType
  local reply
  
  --print('formatVoice', incMode, incTemp, incTimer, incType)
  
  --setup timer into M and H and S
  
  
  local formattedType, formattedValue, formattedTime
  if(mode ~= nil)then
    formattedType = '<span style="color:#'..emphasisColour..';">'..string.upper(mode)..'</span>'
  end
  if(value ~= nil)then
    formattedValue = '<span style="color:#'..emphasisColour..';">'..value..'<i>°</i></span>'
  end
  if(timer ~= nil)then
    formattedTime = '<span style="color:#'..emphasisColour..';">'..timer..'</span>'
  end
  
  
  local data = {}
  --format a reply based upon what is availabe, and the modes and such
  
--  data["voiceTalking.commentBlock.text"] = '<p style="color:#'..voiceColour..'; text-align:center;">A REPLY '..formattedType..' IS '..formattedValue..' HERE</p>'
  --setup the mode and value
  if(type == 'start')then
    if(mode~= nil)then
      if(mode == 'cook' or mode == 'preheat')then
        reply = 'Preheating Oven To '..formattedValue
      else
        reply = 'Starting a '..formattedType 
      end
    else
      if(value~=nil)then
        reply = 'Starting a<span style="color:#'..emphasisColour..';"> Smart Cook</span>' 
      else
        reply = 'Starting a<span style="color:#'..emphasisColour..';"> Timer</span>' 
      end
    end
    if(value ~= nil)then
      reply = reply..' at '..formattedValue
    end
    if(timer ~= nil)then
      reply = reply..' for '..formattedTime
    end
  elseif(type == 'update')then
    if(value ~= nil and timer == nil)then
      reply = 'Updating cooking temperature to '..formattedValue
    elseif(timer ~= nil and value == nil)then
      reply = 'Setting timer for '..formattedTime
    elseif(timer ~= nil and value ~= nil)then
      reply = 'Updating temperature to '..formattedValue..' and timer for '..formattedTime
    elseif(mode ~= nil and timer == nil and value == nil)then
      return
    end
  end

  data["voiceTalking.commentBlock.text"] = '<p style="color:#'..voiceColour..'; text-align:center;">'..reply..'</p>'
  gre.set_data(data)
  
  CBVoiceResponding()
  gre.timer_set_timeout(function()
    CBVoiceFinished()
  end,5000)
end

local function cookModeRunning()

  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs_global('cookRunning', layerData)
  
  gre.timer_set_timeout(function()
    layerData['hidden'] = 1
    gre.set_layer_attrs_global('cookRunning', layerData)
  end, 5000)

end

function CBIncVoiceCommand(mapargs)
--reset the idle timer
  CBIdlePress()
  local mode, temp, timer, recipe, screen
  
  local evData = mapargs.context_event_data
  
  mode = evData.mode
  temp = evData.temp
  timer = evData.timer
  recipe = evData.recipe
  
  screen = mapargs.context_screen
  --choose a function based on the screen and which data is available
  --recipe starting will be handled differently
  
  if(mode == '')then
    mode = nil
  end
  if(recipe == '')then
    recipe = nil
  end
  if(temp == 0)then
    temp = nil
  end
  if(timer == 0)then
    timer = nil
  end
  
  if(recipe ~= nil)then
    if(screen == 'cookingScreen')then
      cookModeRunning()
      return
    end
    CBFormRecipeVoiceReply(recipe)
    if(temp ~= nil)then
      if(mode == nil)then
        cookingRequest.mode = 'bake'
      else
        cookingRequest.mode = string.lower(mode)
      end
      cookingRequest.temperature = temp
      startOvenHeating()
      CBSmartToggleToCook()
      CBHideCookingLayer()
      gre.send_event('goToCookScreen')
    else
      CBStartRecipe()
    end
    return
  end
  
  --check to see if the incoming temp is valid
  if(temp ~= nil)then
    if(temp > MAX_OVEN_TEMP or temp <MIN_OVEN_TEMP)then
      showInvalidTemp()
      return
    end
  end
  
  --print(mode, temp, timer)
  
  if(screen == 'selfCleanScreen')then
    SELF_CLEAN_ACTIVE = 0
  end
  
  if(screen == 'homeScreen' or screen == 'recipeScreen' or screen == 'timerScreen' or screen == 'selfCleanScreen')then
    CBFormVoiceReply(mode,temp,timer, 'start')
    --just a mode coming in
    if(mode ~= nil and temp == nil and timer == nil)then
      --when just a mode send it with the default temperature
      voiceSetupMode(mode, temp)
    --just temp
    elseif(mode == nil and temp ~= nil and timer == nil)then
      voiceSetupMode(mode, temp)
    --just timer
    elseif(mode == nil and temp == nil and timer ~= nil)then
      --voiceSetupTimer(mode,timer)
      voiceStartTimer(timer)
      --return out of this one since we only want a timer and not a cook
      return
    --mode and temp
    elseif(mode ~= nil and temp ~= nil and timer == nil)then
      voiceSetupMode(mode, temp)
    --mode and timer
    elseif(mode ~= nil and temp == nil and timer ~= nil)then
      voiceSetupMode(mode, temp)
      voiceSetupTimer(mode, timer)
    --temp and timer
    elseif(mode == nil and temp ~= nil and timer ~= nil)then
      mode = 'smartCook'
      voiceSetupMode(mode, temp)
      voiceSetupTimer(mode, timer)
    --mode, temp and timer
    elseif(mode ~= nil and temp ~= nil and timer ~= nil)then
      voiceSetupMode(mode, temp)
      voiceSetupTimer(mode, timer)
    else
    end
    voiceStartOven()
    return
  elseif(screen == 'cookingScreen')then
    CBFormVoiceReply(mode,temp,timer, 'update')
    --just a mode coming in
    if(mode ~= nil and temp == nil and timer == nil)then
      cookModeRunning()
    --just temp
    elseif(mode == nil and temp ~= nil and timer == nil)then
      voiceUpdateTemp(temp)
    --just timer
    elseif(mode == nil and temp == nil and timer ~= nil)then
      voiceUpdateTimer(timer)
    --mode and temp
    elseif(mode ~= nil and temp ~= nil and timer == nil)then
      cookModeRunning()
      voiceUpdateTemp(temp)
      --warn about the mode being started
    --mode and timer
    elseif(mode ~= nil and temp == nil and timer ~= nil)then
      cookModeRunning()
      voiceUpdateTimer(timer)
    --temp and timer
    elseif(mode == nil and temp ~= nil and timer ~= nil)then
      voiceUpdateTemp(temp)
      voiceUpdateTimer(timer)
    --mode, temp and timer
    elseif(mode ~= nil and temp ~= nil and timer ~= nil)then
      cookModeRunning()
      voiceUpdateTemp(temp)
      voiceUpdateTimer(timer)
    else
    end
  end
  
  mode = nil
  temp = nil
  timer = nil
end

function voiceSetupMode(incMode, incTemp)
  local mode, temp
--depending on the mode, the temperature will be different when incTemp is nil. Otherwise use the incoming temp
  defaults = sendDefaults()
  --print(defaults.broil, defaults.warm, defaults.cook, incMode, incTemp)
  --if its just a timer, then start a standard bake
  
  if(incMode == nil)then
    mode = 'bake'
  else
    mode = incMode
  end
  
  if(incTemp == nil)then
    if(mode == 'broil')then
      temp = defaults.broil
    elseif(mode == 'warm')then
      temp = defaults.warm
    else
      temp = defaults.cook
    end
  else
    temp = incTemp
  end
  
  --setting up the temps for the broil modes
  if(temp == 'high')then
    temp = 550
  elseif(temp == 'low')then
    temp = 450
  end
  --print(temp, mode)
  --send to a request table or something as the like
  cookingRequest.mode = string.lower(mode)
  cookingRequest.temperature = temp
end

function voiceSetupTimer(incMode, incTimer)
  if(incMode == nil)then
    --something but nothing right now
  else
    activeCookingValues.timer = tonumber(incTimer)
  end
  
end

function voiceUpdateTemp(incTemp)
--redirect to a function in cooking script to get access to those variables (timers)
  voiceCookUpdateTemp(incTemp)
end

function voiceUpdateTimer(incTimer)
  --print(incTimer)
--redirect to a function in cooking script to get access to those variables (timers)
  voiceCookUpdateTime(incTimer)
end

function voiceStartOven()
  startOvenHeating()
  if(activeCookingValues.timer ~= nil)then
    startOvenTimer()
  else
  --TODO:set timer to 0
  end
  CBSmartToggleToCook()
  CBHideCookingLayer()
  gre.send_event('goToCookScreen')
end

function voiceStartTimer(incTime)
    activeCookingValues.timer = incTime
    startOvenTimer()
    gre.send_event('goToTimerScreen')
end

function CBVoiceRepeat()
  local data = {}
  data["voiceTalking.commentBlock.text"] = '<p style="color:#'..voiceColour..'; text-align:center;">No <span style="color:#'..emphasisColour..';>command detected</span>, please check <span style="color:#'..emphasisColour..';>i</span> for information</p>'
  gre.set_data(data)
  CBVoiceResponding()
  gre.timer_set_timeout(function()
    CBVoiceFinished()
  end,5000)
end