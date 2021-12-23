--variables related to the pressing and movement of the finger, as well as the position of the sliders
local homeSliderPressed = false
local snappingToNearest = false
local homePressedX, motionX
local sliderLeft, sliderMid
local direction
local activeScreen

local idleTime = 30000
local idleTimer = {}
local homeIdleTimer = {}

local pressPos, releasePos
local extremeHigh, extremeLow

--variables related to the snapping and the placement of the sliders
local sliderResetAmount = 1600
local sliderOffMax = 800
local sliderOffMin = -2000
local sliderButtonSize = 200

local midSliderResetAmount = 2400
local midSliderOffMax = 1200
local midSliderOffMin = -3000
local midSliderButtonSize = 300

local boundLeft = 400
local boundLeftFar = 125
local boundRight = 880
local boundRightFar = 1150

local oldVelPos, curVelPos
local velTimerTime = 250
local velBounds = 100
local velPosTimer = nil
local velControl

function setupInteractionSizeOffsets(incSize)
  if incSize == smallAppSize then
    sliderResetAmount = math.floor(sliderResetAmount * smallAppRatio)
    sliderOffMax = math.floor(sliderOffMax * smallAppRatio)
    sliderOffMin = math.floor(sliderOffMin * smallAppRatio)
    sliderButtonSize = math.floor(sliderButtonSize * smallAppRatio)
    midSliderResetAmount = 1496
    midSliderOffMax = 748
    midSliderOffMin = -870
    midSliderButtonSize = math.floor(midSliderButtonSize * smallAppRatio)
    boundLeft = math.floor(boundLeft * smallAppRatio)
    boundLeftFar = math.floor(boundLeftFar * smallAppRatio)
    boundRight = math.floor(boundRight * smallAppRatio)
    boundRightFar = math.floor(boundRightFar * smallAppRatio)
    velBounds = math.floor(velBounds * smallAppRatio)
  end
end

local function getXPos(mapargs)
  
  local evData = mapargs.context_event_data
  return evData.x

end

local function setVelDirection()
  oldVelPos = curVelPos
  curVelPos = getXPos(velControl)
  
  if(math.abs(oldVelPos - curVelPos) > velBounds)then
    --print('movingFast')
  end
  
  --if the difference is a lot, we have it move to the next, if its a little we dont
  --print('cur', curVelPos, 'old',  oldVelPos)
end

local function setHomeLayerPosition(incSliderPos, sliderNewMidPos)
  local layerData = {}
  layerData["xoffset"] = incSliderPos
  gre.set_layer_attrs("homeSliderLeft",layerData)
  gre.set_layer_attrs("homeSliderRight",layerData)
  
  layerData["xoffset"] = sliderNewMidPos
  gre.set_layer_attrs("homeSliderMid",layerData)
end

--- @param gre#context mapargs
function CBHomeSliderPress(mapargs) 
  if(snappingToNearest == true)then
    return
  end
  
  gre.animation_trigger('HOME_sliderPress')
  homePressedX = getXPos(mapargs)
  sliderLeft = gre.get_layer_attrs("homeSliderLeft", "xoffset")
  sliderMid = gre.get_layer_attrs("homeSliderMid", "xoffset")
  homeSliderPressed = true
  
  extremeHigh = homePressedX
  extremeLow = homePressedX
  
  --start velPosTimer
  velControl = mapargs
  curVelPos = getXPos(velControl)
  setVelDirection()
  velPosTimer = gre.timer_set_interval(setVelDirection, velTimerTime)
end


function CBHomeSliderMotion(mapargs)

  if(homeSliderPressed == false)then
    return
  end
  --reset the idle timer
  CBIdlePress()
  
  --find the offset of the motion
  velControl = mapargs
  motionX = getXPos(mapargs)
  
  local offset = homePressedX - motionX
  if(math.abs(offset) < 3)then
    return
  end
  --use the offset times 1.5 because the size of the mid is 1.5x the size of the regular offset
  local midOffset = math.floor((offset*1.5) + 0.5)
  
  --setup extreme high and lows to make sure the have pressed or just released at said point
  if(motionX > extremeHigh)then
    extremeHigh = motionX
  elseif(motionX < extremeLow)then
    extremeLow = motionX
  end 
  
  --both layers have the same offset so can use 1 layer for both
  local sliderNewPos = sliderLeft.xoffset - offset
  local sliderNewMidPos = sliderMid.xoffset - midOffset
  
  local layerData = {}
  
  --bounds for the sliders, left and right share the same, mid is larger
  if(sliderNewPos > sliderOffMax)then
    sliderNewPos = sliderNewPos - sliderResetAmount
  elseif(sliderNewPos < sliderOffMin)then
    sliderNewPos = sliderNewPos + sliderResetAmount
  end
  
  if(sliderNewMidPos > midSliderOffMax)then
    sliderNewMidPos = sliderNewMidPos - midSliderResetAmount
  elseif(sliderNewMidPos < midSliderOffMin)then
    sliderNewMidPos = sliderNewMidPos + midSliderResetAmount
  end
  --print(sliderMidNewPos)
  --print(sliderNewPos)
  
  setHomeLayerPosition(sliderNewPos, sliderNewMidPos)
  setSelectedCookMode(sliderNewPos)
  
end

local function quickPressNavigation(incSide)

    local releasedLeftSlider = gre.get_layer_attrs("homeSliderLeft", "xoffset")
    local releasedMidSlider = gre.get_layer_attrs("homeSliderMid","xoffset")
  
    local sliderOldPos = releasedLeftSlider.xoffset
    local sliderMidOldPos = releasedMidSlider.xoffset
  
    --reset them if they are too far gone
    --bounds for the sliders, left and right share the same, mid is larger
    if(sliderOldPos > sliderOffMax)then
      sliderOldPos = sliderOldPos - sliderResetAmount
    elseif(sliderOldPos < sliderOffMin)then
      sliderOldPos = sliderOldPos + sliderResetAmount
    end
  
    if(sliderMidOldPos > midSliderOffMax)then
      sliderMidOldPos = sliderMidOldPos - midSliderResetAmount
    elseif(sliderMidOldPos < midSliderOffMin)then
      sliderMidOldPos = sliderMidOldPos + midSliderResetAmount
    end
    
    local sliderNewPos, sliderMidNewPos
    
    if(incSide == 'right')then
      sliderNewPos = sliderOldPos - sliderButtonSize
      sliderMidNewPos = sliderMidOldPos - midSliderButtonSize
    elseif(incSide == 'rightFar')then 
      sliderNewPos = sliderOldPos - (sliderButtonSize *2)
      sliderMidNewPos = sliderMidOldPos - (midSliderButtonSize*2)
    elseif(incSide == 'leftFar')then
      sliderNewPos = sliderOldPos + (sliderButtonSize *2)
      sliderMidNewPos = sliderMidOldPos + (midSliderButtonSize *2)
    else
      sliderNewPos = sliderOldPos + sliderButtonSize
      sliderMidNewPos = sliderMidOldPos + midSliderButtonSize
    end
    --print(sliderMidNewPos, midSliderButtonSize)
    setSelectedCookMode(sliderNewPos)


    homeSliderPressed = false
    gre.animation_trigger('HOME_sliderRelease')
    snappingToNearest = true  
    anim_HomeLayerSnap(sliderOldPos, sliderNewPos, sliderMidOldPos, sliderMidNewPos)
    gre.timer_set_timeout(function()
      snappingToNearest = false
      direction = nil
    end,250)
  
end

function CBHomeSliderReleased(mapargs)
  
  if(homeSliderPressed == false)then
    return
  end
  
  --clear the velocity timer
  if(velPosTimer ~= nil)then
    setVelDirection()
    gre.timer_clear_timeout(velPosTimer)
    velPosTimer = nil
  end
  
  if(math.abs(curVelPos-oldVelPos)>5)then
    if(curVelPos > oldVelPos)then
      direction = 'right'
    else
      direction = 'left'
    end
  else
    if(math.abs(extremeHigh - extremeLow) > 5)then
      direction = 'held'
    else
      direction = nil
    end
    
  end
  --both share the same offset so we can easily just use the same number

  local sliderNewPos, sliderOldPos
  local sliderMidNewPos, sliderMidOldPos

  local releasedLeftSlider = gre.get_layer_attrs("homeSliderLeft", "xoffset")
  local releasedMidSlider = gre.get_layer_attrs("homeSliderMid","xoffset")
  
  sliderOldPos = releasedLeftSlider.xoffset
  sliderMidOldPos = releasedMidSlider.xoffset
  
  local closestIcon = sliderOldPos/sliderButtonSize
  local closestIconMid = sliderMidOldPos/midSliderButtonSize
  
  if(direction == "left")then
    sliderNewPos = math.floor(closestIcon) * sliderButtonSize
    sliderMidNewPos = math.floor(closestIconMid) * midSliderButtonSize
  elseif(direction == "right")then
    sliderNewPos = math.ceil(closestIcon) * sliderButtonSize
    sliderMidNewPos = math.ceil(closestIconMid) * midSliderButtonSize
  else
  
    sliderNewPos = math.floor(closestIcon + 0.5)  * sliderButtonSize
    sliderMidNewPos = math.floor(closestIconMid + 0.5) * midSliderButtonSize
 
  end
  
  --print('sliderPositions:',direction, sliderNewPos, sliderMidNewPos)
  
  --print(sliderMidNewPos, midSliderButtonSize)
  setSelectedCookMode(sliderNewPos)
  
  if(direction == nil and homeSliderPressed == true)then
    --print('pressing for setup')
    local releasePos = getXPos(mapargs)
    if(releasePos > boundLeft and releasePos < boundRight)then
      --check to see the press position, if it falls inside the bounds itll trigger
      CBHomeOpenSetup()
      homeSliderPressed = false
      gre.animation_trigger('HOME_sliderRelease')
    elseif(releasePos > boundRight)then
      quickPressNavigation('right')
      gre.animation_trigger('HOME_right')
    elseif(releasePos < boundLeft)then
      quickPressNavigation('left')
      gre.animation_trigger('HOME_left')
    end
    return
  end
  
  if(homeSliderPressed == true)then
    homeSliderPressed = false
    gre.animation_trigger('HOME_sliderRelease')
    snappingToNearest = true  
    anim_HomeLayerSnap(sliderOldPos, sliderNewPos, sliderMidOldPos, sliderMidNewPos)
    gre.timer_set_timeout(function()
      snappingToNearest = false
      direction = nil
    end,250)
  end
end

function CBHomeQuickPress(mapargs)
  
  --press with an animation to make lines move around it?
  local animData = {}
  animData['id'] = math.random(0,1000)
  animData['context'] = mapargs.context_group
  gre.animation_trigger('HOME_quickPress', animData)
  --start at the 18th number to get only the name of the group from the mapargs passed through
  local name = string.sub(mapargs.context_group, 18)
  --always use the first sliderPos in the table to snap to
  local sliderNewPos = cookModes[name].sliderPos[1]
  --use the offset times 1.5 because the size of the mid is 1.5x the size of the regular offset
  local sliderMidNewPos = sliderNewPos * 1.5
  
  local curLeftSlider = gre.get_layer_attrs("homeSliderLeft", "xoffset")
  local curMidSlider = gre.get_layer_attrs("homeSliderMid","xoffset")
  
  local sliderOldPos = curLeftSlider.xoffset
  local sliderMidOldPos = curMidSlider.xoffset
    
  setSelectedCookMode(sliderNewPos)
  
  homeSliderPressed = false
  snappingToNearest = true  
  anim_HomeLayerSnap(sliderOldPos, sliderNewPos, sliderMidOldPos, sliderMidNewPos)
  
  gre.timer_set_timeout(function()
    snappingToNearest = false
  end,250)
end

local function closeHomePopup()
  local layerData = {}
  layerData ['hidden'] = 1
  --gre.set_layer_attrs('popupBG',layerData)
  gre.set_layer_attrs('setupBroil',layerData)
  gre.set_layer_attrs('setupTempOverlay',layerData)
  gre.set_layer_attrs('setupTimeOverlay',layerData)
  gre.set_layer_attrs('setupWarm',layerData)
  gre.set_layer_attrs('setupToggles',layerData)
  gre.set_layer_attrs('timerExpiredOverlay',layerData)
  
  CBResetSetup()
end

local function closeCookingPopup()
  local layerData = {}
  layerData ['hidden'] = 1
  gre.set_layer_attrs('popupBG',layerData)
  gre.set_layer_attrs('timerExpiredOverlay',layerData)
end

function closeRecipePopup()
  local layerData = {}
  layerData ['hidden'] = 1
  
  gre.set_layer_attrs("ingredientList",layerData)
  gre.set_layer_attrs("smallRecipeIngredients",layerData)
  gre.timer_set_timeout(function()
    gre.set_layer_attrs('popupBG',layerData)
  end ,500)
  --gre.set_layer_attrs('timerExpiredOverlay',layerData)
end

--- @param gre#context mapargs
function CBClosePopup(mapargs) 
  --fix the quick close things that are happening
--  gre.animation_stop('POPUP_open')
--  gre.animation_stop('SETUP_showTemp')
--  gre.animation_stop('SETUP_showTime')
--  gre.animation_stop('POPUP_showBroil')
--  gre.animation_stop('POPUP_showWarm')
  
  gre.animation_trigger('POPUP_close')
  if(mapargs.context_screen == 'homeScreen')then
    closeHomePopup()
  elseif(mapargs.context_screen == 'cookingScreen')then
    closeCookingPopup()
  elseif(mapargs.context_screen == 'recipeScreen')then
    closeRecipePopup()
  end
end

function showTimerExpired(incTotalTimer)
  local layerData = {}
  local data = {}
  layerData['hidden'] = 0
  gre.animation_trigger('POPUP_timerOpen')
  
  local h = math.floor(incTotalTimer / 3600)
  local m = math.floor((incTotalTimer - (h * 3600)) / 60)
  local s = math.floor(incTotalTimer - ((h * 3600) + (m * 60)))
  
  if(string.len(h) == 1)then
    h = '0'..h
  end
  
  if(string.len(m) == 1)then
    m = '0'..m
  end
  
  if(string.len(s) == 1)then
    s = '0'..s
  end
  
  data["timerExpiredOverlay.totalCookTime.text"] = 'TOTAL COOK TIME '..h..":"..m..":"..s
  gre.set_data(data)
  
  gre.timer_set_timeout(function()
    gre.set_layer_attrs("timerExpiredOverlay",layerData)
  end,500)
  
  CBIdlePress()
  
end

--BELOW IS ALL THE INTERACTIONS THAT THE SYSTEM WILL MAKE WHEN IDLE

local function homeIdleStart()
  --get the location of the actual screen, find the correct thing we are on from there, cycle to the next one
  --always go left
  
  homeIdleTimer = gre.timer_set_interval(function()
    local releasedLeftSlider = gre.get_layer_attrs("homeSliderLeft", "xoffset")
    local releasedMidSlider = gre.get_layer_attrs("homeSliderMid","xoffset")
  
    local sliderOldPos = releasedLeftSlider.xoffset
    local sliderMidOldPos = releasedMidSlider.xoffset
  
  
    --reset them if they are too far gone
    --bounds for the sliders, left and right share the same, mid is larger
    if(sliderOldPos > sliderOffMax)then
      sliderOldPos = sliderOldPos - sliderResetAmount
    elseif(sliderOldPos < sliderOffMin)then
      sliderOldPos = sliderOldPos + sliderResetAmount
    end
  
    if(sliderMidOldPos > midSliderOffMax)then
      sliderMidOldPos = sliderMidOldPos - midSliderResetAmount
    elseif(sliderMidOldPos < midSliderOffMin)then
      sliderMidOldPos = sliderMidOldPos + midSliderResetAmount
    end
  
    local sliderNewPos = sliderOldPos - sliderButtonSize
    local sliderMidNewPos = sliderMidOldPos - midSliderButtonSize
  
    --print(sliderMidOldPos, sliderMidNewPos, midSliderButtonSize)
    anim_HomeLayerSnap(sliderOldPos, sliderNewPos, sliderMidOldPos, sliderMidNewPos)
    setSelectedCookMode(sliderNewPos)
  end,2500)

end

local function startIdleMovements()
  if(activeScreen == 'homeScreen')then
    homeIdleStart()
  elseif(activeScreen == 'cookingScreen')then
    cookIdleCancel()
    --start movements
  elseif(activeScreen == 'recipeScreen')then
    recipeIdleCancel()
  end
  gre.set_value("breadcrumb.voiceInfoOverlay.grd_hidden",1)
  idleTimer = nil
end

function CBIdlePress()
  if(idleTimer ~= nil)then
    gre.timer_clear_timeout(idleTimer)
  end
  
  if(homeIdleTimer~=nil)then
    gre.timer_clear_timeout(homeIdleTimer)
    homeIdleTimer = nil
  end
  
  idleTimer = gre.timer_set_timeout(startIdleMovements, idleTime)
end

function CBSetActiveScreen(mapargs)

  activeScreen = mapargs.context_screen
  CBIdlePress()
  --print('active Screen = '..activeScreen)
end

function CBHidePopUps(mapargs)
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs_global("setupInvalid",layerData)
  gre.set_layer_attrs_global("cookRunning",layerData)
  gre.set_layer_attrs_global("timerExpiredOverlay",layerData)
end


--- @param gre#context mapargs
function CBPressScreen(mapargs) 
  --setup the location
  --start the animation
  local evData = mapargs.context_event_data
  
  local size = gre.get_control_attrs("breadcrumb.pressLocation", "width", "height")
  
  local pos = {}
  pos["x"] = evData.x - (size.width / 2)
  pos["y"] = evData.y -  (size.height / 2)
  
  gre.set_control_attrs("breadcrumb.pressLocation", pos)
  gre.animation_trigger("APP_pressLoc")
end

