local pressed = 0
local sliderButtonSize = 90*.6
local sliderButtonSizeMid = 175*.6
local topSnapOffset = 210*.6
local pressedPos
local curPos
local startPressPos
local animatingSnap = 0

local oldVelPos, curVelPos
local extremeHigh, extremeLow
local velTimerTime = 250
local velBounds = 75
local velPosTimer = nil
local velControl
local direction

local pressStartBounds = 10

local pressPositionOffset = 88*.6
local activeWashMode = 'normal'

local customizeTimer = {}
local customizeTimerTime = 500
--bounds for start or customize. Above a line start, below the line customize?
local startBounds = {150*.6,290*.6}
local customizeBounds = {300*.6, 340*.6}

local startingPositions = {
  ['top'] = 0,
  ['bot'] = 0,
  ['mid'] = 0
}

local function setupStartingPositions()
  
  local midTable = gre.get_table_attrs("homeSlider.midIcons",'yoffset')
  local topTable = gre.get_table_attrs("homeSlider.topIcons",'yoffset')
  local botTable = gre.get_table_attrs("homeSlider.botIcons",'yoffset')
  
  startingPositions['mid'] = midTable['yoffset']
  startingPositions['top'] = topTable['yoffset']
  startingPositions['bot'] = botTable['yoffset']

end

local function setWashingMode(incPos)

  local selectedMin, selectedMax, activeTime, activeWashImg
  
  for wash, washData in pairs(washingModes) do    
    for i = 1, #washData.sliderPos do
      selectedMin = (washData.sliderPos[i]) - pressPositionOffset
      selectedMax = (washData.sliderPos[i]) + pressPositionOffset
      
      if(incPos > selectedMin and incPos < selectedMax)then
        activeWashMode = washData[1]
        activeTime = washData[2]
        activeWashImg = washData.img
      end
    end
  end

  gre.set_value("washMode",activeWashImg)
  gre.set_value("homeAbout.time.text",activeTime.." MIN")

end

local function setupTablePositions()
  
  local offset = curPos - pressedPos
  
  local tableDataMid = {}
  local tableDataTop = {}
  local tableDataBot = {}
  
  local midPos = startingPositions['mid'] + (offset * (sliderButtonSizeMid/sliderButtonSize))
  local topPos = startingPositions['top'] + offset
  local botPos = startingPositions['bot'] + offset
  
  if(midPos > -500*.6)then
    midPos = midPos - 1225*.6
    topPos = topPos - 630*.6
    botPos = botPos - 630*.6
  elseif(midPos < -2100*.6)then
    midPos = midPos + 1225*.6
    topPos = topPos + 630*.6
    botPos = botPos + 630*.6
  end
  
  setWashingMode(midPos)
    
  tableDataMid['yoffset'] = midPos
  tableDataTop['yoffset'] = topPos
  tableDataBot['yoffset'] = botPos
  
  gre.set_table_attrs("homeSlider.midIcons",tableDataMid)
  gre.set_table_attrs("homeSlider.topIcons",tableDataTop)
  gre.set_table_attrs("homeSlider.botIcons",tableDataBot)
  
  --print(startingMid, offset)
end

local function snapTablePositions()
  --get the table position.
  --round to the nearest correct position
  --animate to that position
  local midPos = startingPositions['mid']
  local topPos = startingPositions['top']
  local botPos = startingPositions['bot']
  
  local closestIconBot = botPos/sliderButtonSize
  local closestIconMid = midPos/sliderButtonSizeMid
  
  --if down its floor, if its up its ceil
  --cehck to see if its up or down
  
  local newPosBot, newPosTop, newPosMid
  
  if(direction == 'up')then
    --moved up
    newPosBot = math.ceil(closestIconBot) * sliderButtonSize
    newPosTop = newPosBot + topSnapOffset
    newPosMid = math.ceil(closestIconMid) * sliderButtonSizeMid
  elseif(direction == 'down')then
      --moved down
    newPosBot = math.floor(closestIconBot) * sliderButtonSize
    newPosTop = newPosBot + topSnapOffset
    newPosMid = math.floor(closestIconMid) * sliderButtonSizeMid
  else
    newPosBot = math.floor(closestIconBot + 0.5) * sliderButtonSize
    newPosTop = newPosBot + topSnapOffset
    newPosMid = math.floor(closestIconMid + 0.5) * sliderButtonSizeMid
  end
  
  animatingSnap = 1
  animateTables(midPos, topPos, botPos, newPosMid, newPosTop, newPosBot)
end

local function setVelDirection()
  local evData = velControl.context_event_data
  oldVelPos = curVelPos
  curVelPos = evData['y']
  
end

local function stopVelCalcs(mapargs)
  --clear the velocity timer
  if(velPosTimer ~= nil)then
    setVelDirection()
    gre.timer_clear_timeout(velPosTimer)
    velPosTimer = nil
  end
  
  if(math.abs(curVelPos-oldVelPos)>5)then
    if(curVelPos > oldVelPos)then
      direction = 'up'
    else
      direction = 'down'
    end
  else
    direction = 'held'    
  end
end

local customizeShown = 0
local customizeOpen = 0

local function showCustomize()
  customizeShown = 1
  customizeTimer = nil  
  local data = {}
  data["homeSlider.settingsTrigger.grd_hidden"] = 0
  data["homeSlider.midIcons.grd_hidden"] = 1
  gre.set_data(data)
end

local function hideCustomize()
  if(customizeShown == 0)then
    return
  end
  
  print('hiding customize')
  customizeTimer = nil  
  local data = {}
  data["homeSlider.settingsTrigger.grd_hidden"] = 1
  data["homeSlider.midIcons.grd_hidden"] = 0
  gre.set_data(data)
  
  if(SIMPLE_MODE == 1)then
    local layerData = {}
    layerData['hidden'] = 0
    gre.set_layer_attrs("homeAbout", layerData)
    layerData['hidden'] = 1
    gre.set_layer_attrs("homeCustomize", layerData)
  else
    gre.animation_trigger('HOME_reset')
  end
  customizeShown = 0
  customizeOpen = 0
end

function CBPressMenu(mapargs)
  if(customizeTimer ~= nil)then
    gre.timer_clear_timeout(customizeTimer)
  end

  local evData = mapargs.context_event_data
  pressedPos = evData['y']
  pressed = 1
  
  setupStartingPositions()
  
  extremeHigh = pressedPos
  extremeLow = pressedPos
  startPressPos = pressedPos
  
  curVelPos = pressedPos
  velControl = mapargs
  setVelDirection()
  velPosTimer = gre.timer_set_interval(setVelDirection, velTimerTime)
end

function CBDragMenu(mapargs)
  if(pressed == 0)then
    return
  end

  local evData = mapargs.context_event_data
  curPos = evData['y']
  
  --if the swipe has moved more then 15 px, then we hide customize
  if(math.abs(startPressPos - curPos) > pressStartBounds)then
    hideCustomize()
  end
  
  
  if(curPos > extremeHigh)then
    extremeHigh = curPos
  end
  
  if(curPos < extremeLow)then
    extremeLow = curPos
  end
    
  setupTablePositions()
  
end

local function startCycle()
  if(SIMPLE_MODE == 1)then
    gre.send_event('toWashScreenEvent')
  else
    gre.animation_trigger('TRANSITION_homeToWashing')
  end
end

local function pressCustomize()
  if(customizeShown == 0 or customizeOpen == 1)then
    return
  end

  customizeOpen = 1
  if(SIMPLE_MODE == 1)then
    local layerData = {}
    layerData['hidden'] = 1
    gre.set_layer_attrs("homeAbout", layerData)
    layerData['hidden'] = 0
    gre.set_layer_attrs("homeCustomize", layerData)
  else
    gre.animation_trigger('HOME_pressCustomize')
  end
end

function CBReleaseMenu(mapargs)
  if(pressed == 0)then
    return
  end

  local evData = {}
  evData = mapargs.context_event_data
  local releasePos = evData['y']

  pressed = 0
  stopVelCalcs()
  setupStartingPositions()
  snapTablePositions()

  customizeTimer = gre.timer_set_timeout(showCustomize,customizeTimerTime)
  
  if(gre.get_value("homeSlider.settingsTrigger.grd_hidden") == 1)then
    return
  end
  
  if(math.abs(extremeLow - extremeHigh) < pressStartBounds)then
    if(startBounds[2] > releasePos and  releasePos > startBounds[1])then
      startCycle()
    elseif(customizeBounds[2] > releasePos and releasePos > customizeBounds[1])then
      pressCustomize()
    end
  end
  
end

local function setupCycleSignal(incState)
  local data = {}
  if(incState == 1)then
    data["homeAbout.cycleSignal_group.on.grd_hidden"] = 0
    data["homeAbout.cycleSignal_group.off.grd_hidden"] = 1
    data["homeAbout.cycleSignal_group.switchFG.grd_x"] = 120
  else
    data["homeAbout.cycleSignal_group.on.grd_hidden"] = 1
    data["homeAbout.cycleSignal_group.off.grd_hidden"] = 0
    data["homeAbout.cycleSignal_group.switchFG.grd_x"] = 100
  end
  gre.set_data(data)
end

--- @param gre#context mapargs
function CBToggleCycleSignal(mapargs) 
  
  local toggle = mapargs.context_group..".toggle"
  local toggleState = gre.get_value(toggle)
  
  if (toggleState == 1) then
    gre.set_value(toggle, 0)
    setupCycleSignal(toggleState)
  else
    gre.set_value(toggle, 1)
    setupCycleSignal(toggleState) 
  end
end

function CBCancelCycle()
  CBStopDrumAnimation()
  gre.send_event('toEnergyScreenEvent')
end

local soilLevel = {'low', 'med', 'high'}
local spinLevel = {'low', 'med', 'high'}
local tempLevel = {'low', 'med', 'high'}
local soilPos = 1
local spinPos = 1
local tempPos = 1

function CBCycleSoil()
  soilPos = soilPos + 1
  if(soilPos > 3)then
    soilPos = 1
  end
  gre.set_value("homeCustomize.soil.image", 'images/customize/'..soilLevel[soilPos]..'.png')
end

function CBCycleSpin()
  spinPos = spinPos + 1
  if(spinPos > 3)then
    spinPos = 1
  end
  gre.set_value("homeCustomize.spin.image", 'images/customize/'..spinLevel[spinPos]..'.png')
end

function CBCycleTemp()
  tempPos = tempPos + 1
  if(tempPos > 3)then
    tempPos = 1
  end
  gre.set_value("homeCustomize.temp.image", 'images/customize/'..tempLevel[tempPos]..'.png')
end

--- @param gre#context mapargs
function CBEnergyScreenShow(mapargs) 
  if(SIMPLE_MODE == 1)then
    local data = {}
    data["text.aboutWash.grd_hidden"] = 0
    data["text.reset.grd_hidden"] = 0
    data["text.stars.grd_hidden"] = 0
    gre.set_data(data)
  else
    gre.animation_trigger('TRANSITION_energyShow')
  end
end

function CBIdleWashMode(mapargs)
  if(IDLE_ANIMATION == 0 and AUTOMATED_MODE == 0)then
    return
  end
  
  local pos = gre.get_value("homeSlider.midIcons.grd_yoffset")
  setWashingMode(pos)
end

function hideCustomizeGlobal()
  hideCustomize()
end

function CBAutomateCheck()
  if(AUTOMATED_MODE == 0)then
    return
  end
  
  gre.animation_trigger('AUTOMATE_loop')
  gre.timer_set_timeout(CBAutomatePressCustomize,12500)
  gre.timer_set_timeout(CBAutomatePressStart,17500)
  gre.timer_set_timeout(CBAutomatePressReset,45000)
end

function CBAutomatePressCustomize()
  customizeTimer = gre.timer_set_timeout(showCustomize,customizeTimerTime)
    print('opening Cucle')
end

function CBAutomatePressStart()
  print('starting Cycle')
  startCycle()
end

function CBAutomatePressReset()
  gre.send_event('autoResetEvent')
end