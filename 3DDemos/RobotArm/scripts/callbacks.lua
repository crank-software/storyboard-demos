
local ACTIVE_SLIDER

function cb_sliderPress(mapargs) 
  ACTIVE_SLIDER = mapargs.context_control
-- Your code goes here ...
  --setup the values for the press button
  local data = {}
  data[ACTIVE_SLIDER..".alphaDot"] = 255
  data[ACTIVE_SLIDER..".color"] = 0xBFD73D
  gre.set_data(data)
  cb_sliderMotion(mapargs)
end

function cb_sliderMotion(mapargs)
  if(ACTIVE_SLIDER == nil)then
    return
  end 
-- Your code goes here ...
  local dataTable = {}
  dataTable = gre.get_control_attrs(ACTIVE_SLIDER,"x", "width")
  
  local xPos = dataTable["x"]
  local width = dataTable["width"]
  local xPress = mapargs.context_event_data.x
  
--  print(xPos, width, xPress)
  
  local sliderWidth = xPress-xPos
  local name = gre.get_value(ACTIVE_SLIDER..".name")
  gre.set_value(ACTIVE_SLIDER..".width",sliderWidth)
  gre.set_value(ACTIVE_SLIDER..".xPos",sliderWidth-20)
  
  local percentage = math.ceil((sliderWidth/width)*100) 
  selectModelObject(name, percentage)

end

function cb_sliderLeave(mapargs)
  if(ACTIVE_SLIDER == nil)then
    return
  end

  local data = {}
  data[ACTIVE_SLIDER..".alphaDot"] = 0
  data[ACTIVE_SLIDER..".color"] = 0x999999
  gre.set_data(data)
  
  ACTIVE_SLIDER = nil
end

function selectModelObject(incName, incPercentage)

  local name = incName
  local per = incPercentage
  
  --print(name, per)

  if(name == "base")then
    setupBase(per)
  elseif(name == "arm01")then
    setupArm01(per)
  elseif(name == "arm02")then
    setupArm02(per)
  elseif(name == "arm03")then
    setupArm03(per)
  elseif(name == "extension")then
    setupExtension(per)
  elseif(name == "rotateHand01")then
    rotateHand01(per)
  elseif(name == "rotateHand02")then
    rotateHand02(per)
  elseif(name == "hands")then
    hands(per)
  elseif(name == "all")then
    all(per)
  else
  end
end

function setupBase(incPercentage)
  local per = incPercentage
  --between 0 and 360
  local position = per*3.6
  gre.set_value("model.model.RotatingBase_RZ", position)
  gre.set_value("controls.rotateBaseLabel.text",per.."%")
end

function setupArm01(incPercentage)
  local per = incPercentage
  --between 0 and 360
  local position = -50 +per*1.25
  gre.set_value("model.model.Arm01_RY", position)
  gre.set_value("controls.rotateArm01Label.text",per.."%")
end

function setupArm02(incPercentage)
  local per = incPercentage
  --between 0 and 360
  local position = -90 +per*1.5
  gre.set_value("model.model.Arm02_RY", position)
  gre.set_value("controls.rotateArm02Label.text",per.."%")
end

function setupArm03(incPercentage)
  local per = incPercentage
  --between 0 and 360
  local position = -90 +per*1.8
  gre.set_value("model.model.Arm03_RY", position)
  gre.set_value("controls.rotateArm03Label.text",per.."%")
end

function setupExtension(incPercentage)
  local per = incPercentage
  --between 0 and 360
  local position = per/30
  local pos02 = per/30
  local pos03 = per/30
  
  if(pos02 > 1.25)then
    pos02 = 1.25
  end
  
  if(pos03 > 2.5)then
    pos03 = 2.5
  end  
  
  gre.set_value("model.model.Extension_TX", position) 
  gre.set_value("model.model.Spacer01_TX", pos02) 
  gre.set_value("model.model.Spacer02_TX", pos03) 
  gre.set_value("controls.extensionLabel.text",per.."%")

end

function rotateHand01(incPercentage)
  local per = incPercentage
  --between 0 and 360
  local position = per*3.6
  gre.set_value("model.model.RotatingArm01_RX", position)
  gre.set_value("controls.rotateHand01Label.text",per.."%")
end

function rotateHand02(incPercentage)
  local per = incPercentage
  --between -45 and 45
  local position = per*.5 - 20
  gre.set_value("model.model.RotatingArm02_RX", position)
  gre.set_value("controls.rotateHand02Label.text",per.."%")
end

function hands(incPercentage)
  local per = incPercentage
  local position = -((per/20))
  gre.set_value("model.model.Hand01_TY", position)
  gre.set_value("model.model.Hand02_TY", -position)
  gre.set_value("controls.handsLabel.text",per.."%")
end

function all(incPercentage)

  local per = incPercentage
  --between 0 and 360
  local position = 100 + (-per * 1.7)
  gre.set_value("model.model.Arm01_RY", position)
  gre.set_value("controls.rotateArm01Label.text",per.."%")
  --move arm2 between x and y
  --between 0 and 360
  local position2 = -90 + (per * 1.8)
  gre.set_value("model.model.Arm02_RY", position2)
  gre.set_value("controls.rotateArm02Label.text",per.."%")
  gre.set_value("model.model.Arm03_RY", 0)
end


local controlsShown = 1
function toggleControls(mapargs) 
  if(controlsShown == 1)then
    gre.animation_trigger("HidePieces")
    gre.set_value("controls.toggleControls.text","Show Individual Piece Controls")
    controlsShown = 0
  else
    gre.animation_trigger("ShowPieces")
    gre.set_value("controls.toggleControls.text","Hide Individual Piece Controls")
    controlsShown = 1  
  end
end

local animationsShown = 1
function toggleAnimations(mapargs) 
  if(animationsShown == 1)then
    gre.animation_trigger("HideAnims")
    gre.set_value("animations.toggleAnimations.text","Show Animations")
    animationsShown = 0
  else
    gre.animation_trigger("ShowAnims")
    gre.set_value("animations.toggleAnimations.text","Hide Animations")
    animationsShown = 1  
  end
end

local currentCamera = "views.preset01"
local prevCamNum = nil
function cb_setCameraAngle(mapargs) 

  local newCamera = mapargs.context_control
  
  if(currentCamera == newCamera)then
    --print("already at camera "..newCamera)
    gre.animation_trigger("cameraActiveWarning")
    return
  end
  
  if(currentCamera ~= nil)then
    gre.set_value(currentCamera..".textColour",0x333333)  
  end
  
  gre.set_value(newCamera..".textColour",0x92AE03)  
  
  local dataTable = {}
  dataTable["hidden"] = 1
  gre.set_control_attrs("overlays.warning",dataTable)
  
  local id = gre.get_value(newCamera..".id")
  local animData = {}
  animData["context"] = newCamera
  animData["id"] = id
  gre.animation_trigger("pressCamera", animData)
  
  local camNum = gre.get_value(newCamera..".cam")
  local azim, elevation, camY, camZ
  if(camNum == 1)then
    azim = 0
    elevation = 35
    camY = 35
    camZ = 200
  elseif(camNum == 2)then
    azim = 90
    elevation = 15
    camY = 35
    camZ = 200
  elseif(camNum == 3)then
    azim = 45
    elevation = 75
    camY = -25
    camZ = 300
  elseif(camNum == 4)then
    azim = 180
    elevation = 0
    camY = 40
    camZ = 150
  elseif(camNum == 5)then
    azim = 0
    elevation = -20
    camY = 40
    camZ = 100
  else
  end
  
  cameraTransition(azim,elevation,camY,camZ)
  
  currentCamera = newCamera
  prevCamNum = camNum
end

function cameraTransition(azim, elevation, camY, camZ)

  local anim_data = {}
  
  local rotateCamera = gre.animation_create(60, 1)
  
  anim_data["key"] = "model.model.camY"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 750
  anim_data["offset"] = 0
  anim_data["to"] = camY
  gre.animation_add_step(rotateCamera, anim_data)
  
  anim_data["key"] = "model.model.camZ"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 750
  anim_data["offset"] = 0
  anim_data["to"] = camZ
  gre.animation_add_step(rotateCamera, anim_data)
  
  anim_data["key"] = "model.model.elevation"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 750
  anim_data["offset"] = 0
  anim_data["to"] = elevation
  gre.animation_add_step(rotateCamera, anim_data)
  
  anim_data["key"] = "model.model.azim"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 750
  anim_data["offset"] = 0
  anim_data["to"] = azim
  gre.animation_add_step(rotateCamera, anim_data)
  
  gre.animation_trigger(rotateCamera)
  
end

local APP_IDLE_TIME = 10000
local APP_IDLE = 0
local SCREEN_PRESSED
local idval = {}

local function idleApp()
  --print("app now idle")
  gre.animation_trigger("idleLoop")
  APP_IDLE = 1
end

function cb_AppPressed(mapargs) 
  if(APP_IDLE == 1)then
    gre.animation_stop("idleLoop")
  end
  APP_IDLE = 0
  local data
  data = gre.timer_clear_timeout(idval)
  SCREEN_PRESSED = 1
end

function cb_AppReleased(mapargs) 

  --print("idle timer started")
  if(SCREEN_PRESSED == 1)then
    idval = gre.timer_set_timeout(idleApp, APP_IDLE_TIME)
    SCREEN_PRESSED = 0
  end
end

function cb_appIdleInit()
  idval = gre.timer_set_timeout(idleApp, APP_IDLE_TIME)
end

function cb_checkAnimation()
  if(APP_IDLE == 0)then
    return
  end
  gre.animation_trigger("idleLoop")
end

local currentAnim
function cb_setupPresetAnim(mapargs) 

  if(currentAnim ~= nil)then
    if(currentAnim == 1)then
      gre.animation_stop("extension")
      gre.set_value("animations.extensionAnimation.width",2) 
    elseif(currentAnim == 2)then
      gre.animation_stop("pickup01")
      gre.set_value("animations.pickUp1.width",2) 
    elseif(currentAnim == 3)then
      gre.animation_stop("pickup02")
      gre.set_value("animations.pickUp2.width",2) 
    elseif(currentAnim == 4)then
      gre.animation_stop("rotateAndMove")
      gre.set_value("animations.rotateAndMove.width",2) 
    elseif(currentAnim == 5)then
      gre.animation_stop("Activate")
      gre.set_value("animations.Activate.width",2) 
    elseif(currentAnim == 6)then
      gre.animation_stop("Deactivate")
      gre.set_value("animations.Deactivate.width",2) 
    elseif(currentAnim == 7)then
      gre.animation_stop("hideAndShowPieces")
      gre.set_value("animations.HideAndShow.width",2) 
      --special use case because we want all the pieces shown even if the animation is stopped
      local data = {}
      data["model.model.Arm01_hidden"] = 0
      data["model.model.Arm02_hidden"] = 0
      data["model.model.Arm03_hidden"] = 0
      data["model.model.Base_hidden"] = 0
      data["model.model.Extension_hidden"] = 0
      data["model.model.Hand01_hidden"] = 0
      data["model.model.Hand02_hidden"] = 0
      data["model.model.RotatingArm01_hidden"] = 0
      data["model.model.RotatingArm02_hidden"] = 0
      data["model.model.RotatingBase_hidden"] = 0
      data["model.model.Spacer01_hidden"] = 0
      data["model.model.Spacer02_hidden"] = 0
      gre.set_data(data)
    else
    end 
  end

 
  
  local incAnim = gre.get_value(mapargs.context_control..".animNum")
  currentAnim = incAnim
  if(incAnim == 1)then
    gre.animation_trigger("extension")
  elseif(incAnim == 2)then
    gre.animation_trigger("pickup01")
  elseif(incAnim == 3)then
    gre.animation_trigger("pickup02")
  elseif(incAnim == 4)then
    gre.animation_trigger("rotateAndMove")
  elseif(incAnim == 5)then
    gre.animation_trigger("Activate")
  elseif(incAnim == 6)then
    gre.animation_trigger("Deactivate")
  elseif(incAnim == 7)then
    gre.animation_trigger("hideAndShowPieces")
  else
  end
  
  
  
end

function cb_PresetAnimDone(mapargs)
  currentAnim = nil
end