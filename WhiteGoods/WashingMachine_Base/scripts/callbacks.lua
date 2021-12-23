local pressed = 0
local overallLocation = 0
local releaseX, currentX, pressX
local screenActive = 1
local movementPress = 0
local movementBuffer = 5

--- @param gre#context mapargs
function cb_resetHome(mapargs) 
  local dk_data = {}
  
  --setup the x location of all of the layers (4 of them, with each being 800 more over then the previous)
  --depending on the active screen set it up to have the active screen beind offset to the correct one
  local offset1 = 0
  local offset2 = 800
  local offset3 = 1600
  local offset4 = 2400
  dk_data["x"] = offset1 
  gre.set_layer_attrs_global("chips1",dk_data)
  dk_data["x"] = offset2 
  gre.set_layer_attrs_global("chips2",dk_data)
  dk_data["x"] = offset3 
  gre.set_layer_attrs_global("chips3",dk_data)
  dk_data["x"] = offset4 
  gre.set_layer_attrs_global("chips4",dk_data)
  screenActive = 1
  
  dk_data["x"] = 0
  dk_data["hidden"] = 1
  gre.set_control_attrs("bg.staticBG", dk_data)
  local data = {}
  data["washingButtons.pause.toggle"] = 1
  gre.set_data(data)
end

function cb_chipsNavigationPress(mapargs)
  local ev_data = mapargs.context_event_data;
  pressX = ev_data.x
  
  pressed = 1
  --reset the movement press
  movementPress = 0
end

function cb_chipsNavigationMotion(mapargs)
  
  if(pressed == 0)then
    return
  end
    
  local ev_data = mapargs.context_event_data;
  currentX = ev_data.x

  local movement = currentX - pressX
  
  --if the person moved more then 3, overall we cuond it as a movement or flick
  if(math.abs(movement) > movementBuffer)then
    movementPress = 1
  end
  
  parralaxLayers(movement)
  --move the layers in the correct area, parralx with something else

end

function parralaxLayers(incOffset)
  
  local offset1, offset2, offset3, offset4, offset5
  
  if(screenActive == 1)then
    offset1 = 0
    offset2 = 800
    offset3 = 1600
    offset4 = 2400
    offset5 = -150
  elseif(screenActive == 2)then
    offset1 = -800
    offset2 = 0
    offset3 = 800
    offset4 = 1600  
    offset5 = -300
  elseif(screenActive == 3)then
    offset1 = -1600
    offset2 = -800
    offset3 = 0
    offset4 = 800  
    offset5 = -450 
  elseif(screenActive == 4)then
    offset1 = -2400
    offset2 = -1600
    offset3 = -800
    offset4 = 0    
    offset5 = -600
  end

  local dk_data = {}
  
  --setup the x location of all of the layers (4 of them, with each being 800 more over then the previous)
  --depending on the active screen set it up to have the active screen beind offset to the correct one
  dk_data["x"] = offset1 + incOffset 
  gre.set_layer_attrs_global("chips1",dk_data)
  dk_data["x"] = offset2 + incOffset 
  gre.set_layer_attrs_global("chips2",dk_data)
  dk_data["x"] = offset3 + incOffset 
  gre.set_layer_attrs_global("chips3",dk_data)
  dk_data["x"] = offset4 + incOffset 
  gre.set_layer_attrs_global("chips4",dk_data)
  dk_data["x"] = offset5 + incOffset/(800/150)
  gre.set_control_attrs("bg.background",dk_data)

end

function cb_chipsNavigationRelease(mapargs)
  
  if(pressed == 0)then
    return
  end
  pressed = 0

  local ev_data = mapargs.context_event_data;
  releaseX = ev_data.x
  
  if(math.abs(pressX-releaseX) < 30)then
    setupScreens()
    return
  end
  
  if(pressX < releaseX)then
    screenActive = screenActive - 1
  elseif(pressX > releaseX)then
    screenActive = screenActive + 1
  end
  
  if(screenActive < 1)then
    screenActive = 1
  elseif(screenActive >4)then
    screenActive = 4
  end
  setupScreens()
end


function setupScreens()
  local offset1, offset2, offset3, offset4, offset5, alpha1, alpha2, alpha3, alpha4
  
  if(screenActive == 1)then
    offset1 = 0
    offset2 = 800
    offset3 = 1600
    offset4 = 2400
    offset5 = -150
    
    alpha1 = 255
    alpha2 = 117
    alpha3 = 117
    alpha4 = 117
  elseif(screenActive == 2)then
    offset1 = -800
    offset2 = 0
    offset3 = 800
    offset4 = 1600  
    offset5 = -300
    
    alpha1 = 117
    alpha2 = 255
    alpha3 = 117
    alpha4 = 117
  elseif(screenActive == 3)then
    offset1 = -1600
    offset2 = -800
    offset3 = 0
    offset4 = 800
    offset5 = -450
    
    alpha1 = 117
    alpha2 = 117
    alpha3 = 255
    alpha4 = 117  
  elseif(screenActive == 4)then
    offset1 = -2400
    offset2 = -1600
    offset3 = -800
    offset4 = 0
    offset5 = -600
    
    alpha1 = 117
    alpha2 = 117
    alpha3 = 117
    alpha4 = 255 
  end
  
  local data = {}
  data["startScreen.chips1Offset"] = offset1
  data["startScreen.chips2Offset"] = offset2
  data["startScreen.chips3Offset"] = offset3
  data["startScreen.chips4Offset"] = offset4
  data["startScreen.bgOffset"] = offset5
  
  data["drag.chipNavigation.dot1.alpha"] = alpha1
  data["drag.chipNavigation.dot2.alpha"] = alpha2
  data["drag.chipNavigation.dot3.alpha"] = alpha3
  data["drag.chipNavigation.dot4.alpha"] = alpha4
  gre.set_data(data)
  
  gre.animation_trigger("HOME_chipsSetup")
end

function cb_pressChip(mapargs)

  if(movementPress == 1)then
    return
  end
  
  local selectedChip = mapargs.context_group
  
  --sets up the position of the circle press
  local ctrlData = {}
  ctrlData = gre.get_control_attrs(selectedChip,"x")
  local chipOffsetX = ctrlData["x"] + 8
  local chipOffsetY = 295
  
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  
  local data = {}
  data[selectedChip..".circleOverlay.x"] = chipPressX - chipOffsetX - 90
  data[selectedChip..".circleOverlay.y"] = chipPressY - chipOffsetY - 73
  gre.set_data(data)
  
  local animData = {}
  animData["context"] = selectedChip
  gre.animation_trigger("HOME_chipsPress", animData)
  
  --check the active screen, hide all of the chips except of the one you pressed
  
  setupHomeTransition(selectedChip)
  
end


function setupHomeTransition(incGroup)

  local chip = incGroup

  local imagePath = "images/backgrounds/"..(string.sub(chip, 13))..".png"
  local buttonPath = "images/backgrounds/"..(string.sub(chip, 13)).."ButtonArea.png"
  local settingsTitle = "- "..(string.sub(chip, 13)).." -"
  local data = {}
  data["bg.staticBG.image"] = imagePath
  data["setupButtons.title.titleText.text"] = settingsTitle
  data["setupButtons.startButton.blur.image"] = buttonPath
  data["washingButtons.pause.blurBG.image"] = buttonPath
  data["finishedButtons.reset.blur.image"] = buttonPath
  
  gre.set_data(data)
  
  
end

--each selection has a seperate function for each of the options
function cb_optionsPressSize(mapargs)

  local pressedGroup = mapargs.context_group
  local ctrlData = {}
  ctrlData = gre.get_control_attrs(pressedGroup, "y")
  
  local OffsetY = ctrlData["y"]+15
  local OffsetX = 15
  
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  
  local incomingSize = "images/settingsText/"..gre.get_value(pressedGroup..".size")..".png"
  
  local data = {}
  data[pressedGroup..".overlay.x"] = chipPressX - OffsetX - 85
  data[pressedGroup..".overlay.y"] = chipPressY - OffsetY - 38
  data["options.sizeText.image"] = incomingSize
  
  gre.set_data(data)
  
  data = {}
  data["hidden"] = 0
  gre.set_control_attrs("optionsSize.optionsBlocker",data)
  data["hidden"] = 1
  gre.set_control_attrs("optionsSize.optionsOutPress",data)
  
  local animData = {}
  animData["context"] = pressedGroup
  gre.animation_trigger("SETTINGS_pressButton", animData)
  gre.timer_set_timeout(sizeCloseAnimation, 400)

end

function sizeCloseAnimation()
  gre.animation_trigger("SETTINGS_sizeHide")
end

--each selection has a seperate function for each of the options
function cb_optionsPressTemp(mapargs)

  local pressedGroup = mapargs.context_group
  local ctrlData = {}
  ctrlData = gre.get_control_attrs(pressedGroup, "y")
  
  local OffsetY = ctrlData["y"]+15
  local OffsetX = 215
  
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  
  local incomingTemp = "images/settingsText/"..gre.get_value(pressedGroup..".temp")..".png"
  
  local data = {}
  data[pressedGroup..".overlay.x"] = chipPressX - OffsetX - 85
  data[pressedGroup..".overlay.y"] = chipPressY - OffsetY - 38
  data["options.tempText.image"] = incomingTemp
  
  gre.set_data(data)
  
  data = {}
  data["hidden"] = 0
  gre.set_control_attrs("optionsTemp.optionsBlocker",data)
  data["hidden"] = 1
  gre.set_control_attrs("optionsTemp.optionsOutPress",data)
  
  local animData = {}
  animData["context"] = pressedGroup
  gre.animation_trigger("SETTINGS_pressButton", animData)
  gre.timer_set_timeout(tempCloseAnimation, 400)

end

function tempCloseAnimation()
  gre.animation_trigger("SETTINGS_tempHide")
end


--each selection has a seperate function for each of the options
function cb_optionsPressSpin(mapargs)

  local pressedGroup = mapargs.context_group
  local ctrlData = {}
  ctrlData = gre.get_control_attrs(pressedGroup, "y")
  
  local OffsetY = ctrlData["y"]+15
  local OffsetX = 416
  
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  
  local incomingTemp = "images/settingsText/"..gre.get_value(pressedGroup..".spin")..".png"
  
  local data = {}
  data[pressedGroup..".overlay.x"] = chipPressX - OffsetX - 85
  data[pressedGroup..".overlay.y"] = chipPressY - OffsetY - 38
  data["options.spinText.image"] = incomingTemp
  
  gre.set_data(data)
  
  data = {}
  data["hidden"] = 0
  gre.set_control_attrs("optionsSpin.optionsBlocker",data)
  data["hidden"] = 1
  gre.set_control_attrs("optionsSpin.optionsOutPress",data)
  
  local animData = {}
  animData["context"] = pressedGroup
  gre.animation_trigger("SETTINGS_pressButton", animData)
  gre.timer_set_timeout(spinCloseAnimation, 400)

end

function spinCloseAnimation()
  gre.animation_trigger("SETTINGS_spinHide")
end

function cb_OptionsToggleExtra(mapargs)
  
  local pressedGroup = mapargs.context_group
  local ctrlData = {}
  ctrlData = gre.get_control_attrs(pressedGroup, "y")
  
  local OffsetY = ctrlData["y"]+15
  local OffsetX = 616
  
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  
  
  local incomingToggle = gre.get_value(pressedGroup..".toggle")
  local incID = gre.get_value(pressedGroup..".id")
  local extra = gre.get_value(pressedGroup..".extra")  
  
  local data = {}
  local animData = {}
  animData["context"] = pressedGroup
  animData["id"] = incID
  
  local extraControl = "options.extrasGroup."..extra..".image"
  
  if(incomingToggle == 1)then
    data[pressedGroup..".toggle"] = 0
    gre.animation_trigger("SETTINGS_toggleOff", animData)
    data[extraControl] = "images/settingsText/"..extra.."Off.png"
  else
    data[pressedGroup..".toggle"] = 1
    gre.animation_trigger("SETTINGS_toggleOn", animData)
    data[extraControl] = "images/settingsText/"..extra.."On.png"
  end
  
  data[pressedGroup..".overlay.x"] = chipPressX - OffsetX - 85
  data[pressedGroup..".overlay.y"] = chipPressY - OffsetY - 38
  --data["options.spinText.image"] = incomingTemp
  
  gre.set_data(data)

end

function cb_toggleWash(mapargs)
  
  local pressedGroup = mapargs.context_group
  
  --position of the control
  local OffsetY = 354
  local OffsetX = 291
  
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  
  
  local incomingToggle = gre.get_value(pressedGroup..".toggle")
  
  local data = {}
  data[pressedGroup..".pressOverlay.x"] = chipPressX - OffsetX - 109
  data[pressedGroup..".pressOverlay.y"] = chipPressY - OffsetY - 38

  
  if(incomingToggle == 1)then
    data[pressedGroup..".toggle"] = 0
    gre.animation_trigger("WASH_toggleOff")
    gre.animation_pause("WASH_washing")
  else
    data[pressedGroup..".toggle"] = 1
    gre.animation_trigger("WASH_toggleOn")
    gre.animation_resume("WASH_washing")
  end
  
  gre.set_data(data) 

end

--- @param gre#context mapargs
function cb_washTimeUpdate(mapargs) 
  local percentage = gre.get_value("washingScreen.timeRemaining")
  local newTime = 400*(percentage/175)
  
  local min = math.floor(newTime / 60)
  local sec = math.floor(newTime - (min * 60))
  
  if(string.len(min) == 1)then
    min = "0"..min
  end

  if(string.len(sec) == 1)then
    sec = "0"..sec
  end
    
  local data = {}
  data["washingButtons.title.title.text"] = "- "..min..":"..sec.." -"
  gre.set_data(data)
end

local appIdleTimer = nil
local passedScreen
--- @param gre#context mapargs
function cb_setupIdleTimer(mapargs)

  if(appIdleTimer ~= nil)then
    gre.timer_clear_timeout(appIdleTimer)
    appIdleTimer = nil
    --print("clearingTimeout")
  end
  
  --print(mapargs.context_screen)
  local timer = gre.get_value("appIdleTimer")
  local screen = mapargs.context_screen
  passedScreen = screen
  --print(screen, timer)
  
  if(screen == "startScreen")then
    return
  end
  
  appIdleTimer = gre.timer_set_timeout(idleTimeout,timer)
end

function idleTimeout()

  --print("timeout")
  appIdleTimer = nil
  --check if on the washing screen to play around with the time
  if(passedScreen == "washingScreen")then
    
    local check = gre.get_value("washingButtons.pause.toggle")
    if(check == 1)then
      return
    end
    
    local data = {}
    data["washingButtons.pause.toggle"] = 1
    gre.animation_trigger("WASH_toggleOn")
    gre.animation_resume("WASH_washing")
    gre.set_data(data)
    return
    
  end
  gre.send_event("toHome")
  cb_resetHome()
  gre.animation_trigger("SETTINGS_reset")
end


--clearing timeout

--- @param gre#context mapargs
function cb_rippleEffect(mapargs) 
  local ev_data = mapargs.context_event_data;
  local chipPressX = ev_data.x
  local chipPressY = ev_data.y
  local data = {}
  data["bg.staticBG.xPress"] = chipPressX/800
  data["bg.staticBG.yPress"] = chipPressY/480
  gre.set_data(data)
  gre.animation_trigger("EFFECT_ripple")
end
