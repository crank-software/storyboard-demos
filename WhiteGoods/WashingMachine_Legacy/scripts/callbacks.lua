--performance boosts. Set to 1 for lower end boards to get better performance
local PERFBOOST = 0


local ACTIVE_SLIDER = nil
local FABRIC
local SPIN = "extra high"
local TEMP = "hot / warm"
local RINSE = "on"
local BUZZER = "on"
local SANITIZE = "off"
local STEAM = "off"

function calcSelectionPosition(mapargs)
  local pressY = mapargs.context_event_data.y
  local data = {}
  --Setup top slider
  -- -60 = 480
  -- 200 = 0
  
  --Setup Bottom slider
  -- 0 = 480
  -- 260 = 0
  
  --Setup Main Middle
  -- -500 = 480
  -- 0 = 0
  
  
  local offsetY = math.floor((200 * pressY) / 480 )
  local largeOffsetY = math.floor((500*pressY) / 480)
  --print(largeOffsetY)
  
  if(mapargs.context_control == "settings.tempScrollMotionControl")then
    data["settings.tempScrollTableBot.ypos"] = -235 + offsetY
    data["settings.tempScrollTableTop.ypos"] = offsetY + 10
    data["settings.tempButton.tempStatus.yPos"] = largeOffsetY - 500
  elseif(mapargs.context_control == "settings.spinScrollMotionControl")then
    data["settings.spinScrollTableBot.ypos"] = -235 + offsetY
    data["settings.spinScrollTableTop.ypos"] = offsetY + 10
    data["settings.spinButton.spinStatus.yPos"] = largeOffsetY - 500  
  else
  end
  
  gre.set_data(data)
  
end

function selectionPress(mapargs)
  
  ACTIVE_SLIDER = mapargs.context_control
  --calcSelectionPosition(mapargs)
  if(ACTIVE_SLIDER == "settings.tempScrollMotionControl")then
    gre.animation_trigger("tempTitleAlphaOff")
  elseif(ACTIVE_SLIDER == "settings.spinScrollMotionControl")then
    gre.animation_trigger("spinTitleAlphaOff")
  end
  
end


function selectionMotion(mapargs)
  
  if ACTIVE_SLIDER == nil then
    return
  end
  
  if ACTIVE_SLIDER == mapargs.context_control then
    calcSelectionPosition(mapargs)
  end
  
end


function selectionRelease(mapargs)
  if(ACTIVE_SLIDER == nil)then
    return
  end
  
  local dataTable = {}
  local data = {}
  local currentPos, newPos, slider
  dataTable = gre.get_data("settings.spinButton.spinStatus.yPos", "settings.tempButton.tempStatus.yPos")
  
  if(ACTIVE_SLIDER == "settings.tempScrollMotionControl")then
    currentPos = dataTable["settings.tempButton.tempStatus.yPos"]
    slider = "temp"
    gre.animation_trigger("tempTitleAlphaOn")
  elseif(ACTIVE_SLIDER == "settings.spinScrollMotionControl")then
    currentPos = dataTable["settings.spinButton.spinStatus.yPos"]
    slider = "spin"
    gre.animation_trigger("spinTitleAlphaOn")
  end

--  if(currentPos )
  if(currentPos < 50 and currentPos > -51)then
    newPos = 0
    SPIN = "extra high"
    TEMP = "hot/warm"
  elseif(currentPos < -50 and currentPos > -151)then
    newPos = -100
    SPIN = "high"
    TEMP = "hot/cold"
  elseif(currentPos < -150 and currentPos > -251)then
    newPos = -200
    SPIN = "med. high"
    TEMP = "warm/cool"
  elseif(currentPos < -250 and currentPos > -351)then
    newPos = -300
    SPIN = "medium"
    TEMP = "warm/cold"
  elseif(currentPos < -350 and currentPos > -451)then
    newPos = -400
    SPIN = "low"
    TEMP = "cool/cold"
  elseif(currentPos < -450 and currentPos > -551)then
    SPIN = "extra low"
    TEMP = "cold/cold"
    newPos = -500
  end
  
  if(slider == "spin")then
    data["washingData.washSettings.SpinSetting.text"] = SPIN
  elseif(slider == "temp")then
    data["washingData.washSettings.tempSetting.text"] = TEMP
  end
  
  gre.set_data(data)
  setupSelectionAnimation(currentPos, newPos, slider)
  ACTIVE_SLIDER = nil
end

function setupSelectionAnimation(currentPos, newPos, slider)
  local key
  
  if(slider == "temp")then
    key = "settings.tempButton.tempStatus.yPos"
  elseif(slider == "spin")then
    key = "settings.spinButton.spinStatus.yPos"
  end
 
  local anim_data = {}
  local animation = gre.animation_create(30, 1)
  
  anim_data["key"] = key
  anim_data["rate"] = "linear"
  anim_data["duration"] = 150
  anim_data["offset"] = 0
  anim_data["from"] = currentPos
  anim_data["to"] = newPos
  gre.animation_add_step(animation, anim_data)
  
  gre.animation_trigger(animation)

  
end

function setupFabric(mapargs)
  local data = {}
  FABRIC = mapargs.fabric
  data["washingData.washSettings.fabricSetting.text"] = FABRIC
  data["settings.backButton.cycle.text"] = FABRIC
  if(FABRIC == "quick wash")then
    data["background.background.image"] = "images/Backgrounds/washerBG.png"
  elseif(FABRIC == "eco")then
    data["background.background.image"] = "images/Backgrounds/ecoBG.png"
  elseif(FABRIC == "heavy")then
    data["background.background.image"] = "images/Backgrounds/heavyBG.jpg"
  elseif(FABRIC == "bedding")then
    data["background.background.image"] = "images/Backgrounds/beddingBG.jpg"
  elseif(FABRIC == "wools")then
    data["background.background.image"] = "images/Backgrounds/woolBG.jpg"
  elseif(FABRIC == "perm. press")then
    data["background.background.image"] = "images/Backgrounds/permBG.jpg"
  elseif(FABRIC == "delicates")then
    data["background.background.image"] = "images/Backgrounds/delicatesBG.jpg"
  elseif(FABRIC == "cottons")then
    data["background.background.image"] = "images/Backgrounds/cottonBG.jpg"
  end
  
  gre.set_data(data)
end

function toggleExtraSettings(mapargs)
  local data = {}
  local control = mapargs.context_control
  if(control == "settings.extras.extraOptionSteam")then
    if(STEAM == "on")then
      STEAM = "off"
      data[control..".text"] = "OFF"
      data[control..".colour"] = 0xeeeeee
      data["settings.extrasButton.steamIcon.image"] = "images/SteamIconGrey.png"
    else
      STEAM = "on"
      data[control..".text"] = "ON"
      data[control..".colour"] = 0xffffff
      data["settings.extrasButton.steamIcon.image"] = "images/SteamIcon.png"
    end
  elseif(control == "settings.extras.extraOptionRinse")then
    if(RINSE == "on")then
      RINSE = "off"
      data[control..".text"] = "OFF"
      data[control..".colour"] = 0xeeeeee
      data["settings.extrasButton.rinseIcon.image"] = "images/rinseIconGrey.png"
    else
      RINSE = "on"
      data[control..".text"] = "ON"
      data[control..".colour"] = 0xffffff
      data["settings.extrasButton.rinseIcon.image"] = "images/rinseIcon.png"
    end
  elseif(control == "settings.extras.extraOptionBuzzer")then
    if(BUZZER == "on")then
      BUZZER = "off"
      data[control..".text"] = "OFF"
      data[control..".colour"] = 0xeeeeee
      data["settings.extrasButton.buzzerIcon.image"] = "images/buzzerIconGrey.png"
    else
      BUZZER = "on"
      data[control..".text"] = "ON"
      data[control..".colour"] = 0xffffff
      data["settings.extrasButton.buzzerIcon.image"] = "images/buzzerIcon.png"
    end
  elseif(control == "settings.extras.extraOptionSanatize")then
    if(SANITIZE == "on")then
      SANITIZE = "off"
      data[control..".text"] = "OFF"
      data[control..".colour"] = 0xeeeeee
      data["settings.extrasButton.sanatizeIcon.image"] = "images/sanatizeIconGrey.png"
    else
      SANITIZE = "on"
      data[control..".text"] = "ON"
      data[control..".colour"] = 0xffffff
      data["settings.extrasButton.sanatizeIcon.image"] = "images/sanatizeIcon.png"
    end
  end
  
  gre.set_data(data)
end

local idval = nil

function idleTimer(mapargs)
  local data
  if(idval ~= nil)then
    data = gre.timer_clear_timeout(idval)
  end
  idval = gre.timer_set_timeout(appTimeout,30000)
end

function appTimeout()
  gre.send_event("goToHomeScreen")
end

function CBCheckAnimationWater(mapargs)
  local dk_data = gre.get_data("activeScreen")
  local screen = dk_data["activeScreen"]
  if(screen == "startScreen")then
    gre.animation_trigger("water_bg")
  else
  end
end

function CBCheckAnimationBubbles(mapargs) 
  local dk_data = gre.get_data("activeScreen")
  local screen = dk_data["activeScreen"]
  if(screen == "startScreen")then
    gre.animation_trigger("bubbles1")
  else
  end
end


function cb_AppInit(mapargs) 
--  local dk_data = {}
--  if (PERFBOOST == 1)then
--    dk_data["hidden"] = 1
--  else
--    dk_data["hidden"] = 0
--  end
--  gre.set_control_attrs("dateLayer.botFade",dk_data)
--  gre.set_control_attrs("dateLayer.topFade",dk_data)
end

local dateScreenFade = 0

function cb_AnimToggle(mapargs) 
  local dk_data = {}
  local data = {}
  if(dateScreenFade == 0)then
    dk_data["hidden"] = 0
    gre.set_control_attrs("dateLayer.topFadeSmall",dk_data)
    gre.set_control_attrs("dateLayer.bottomFadeSmall",dk_data)
    dk_data["hidden"] = 1
    gre.set_control_attrs("dateLayer.topFadeLarge",dk_data)
    gre.set_control_attrs("dateLayer.bottomFadeLarge",dk_data)
    data["dateLayer.fadeChanger.img"] = "images/largeFades.png"
    dateScreenFade = 1
  else
    dk_data["hidden"] = 1
    gre.set_control_attrs("dateLayer.topFadeSmall",dk_data)
    gre.set_control_attrs("dateLayer.bottomFadeSmall",dk_data)
    dk_data["hidden"] = 0
    gre.set_control_attrs("dateLayer.topFadeLarge",dk_data)
    gre.set_control_attrs("dateLayer.bottomFadeLarge",dk_data)
    data["dateLayer.fadeChanger.img"] = "images/smallFades.png"
    dateScreenFade = 0
  end
  gre.set_data(data)
end
