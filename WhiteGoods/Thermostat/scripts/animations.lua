local function callCoolAnimation()
  gre.animation_trigger(coolAnimation)
end

local function callWarmAnimation()
  gre.animation_trigger(warmAnimation)
end

function initFlipbookAnimations()

  local animData = {}  
  local frameCount = 9
  coolAnimation = gre.animation_create(30, 0, callCoolAnimation)
  warmAnimation = gre.animation_create(30, 0, callWarmAnimation)
 
  animData["key"] = "sliderControl.backgroundAnim.cold.image"
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 0, frameCount do
    animData["offset"] = i*45
    animData["to"] = 'images/animations/Cold/coldBG_0'..i..'.png'
    gre.animation_add_step(coolAnimation, animData)
  end

  animData = {}
  
  animData["key"] = "sliderControl.backgroundAnim.hot.image"
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 0, frameCount do
    animData["offset"] = i*45
    animData["to"] = 'images/animations/Warm/warmBG_0'..i..'.png'
    gre.animation_add_step(warmAnimation, animData)
  end
  
end

function initIconAnimations()

  local animData = {}  
  
  local frameCountSelect = 28
  local frameCountDeselect = 10
  
  weatherSelect = gre.animation_create(30, 0)
  thermostatSelect = gre.animation_create(30, 0)
  scheduleSelect = gre.animation_create(30, 0)
  
  weatherDeselect = gre.animation_create(30, 0)
  thermostatDeselect = gre.animation_create(30, 0)
  scheduleDeselect = gre.animation_create(30, 0) 

  local weatherKey = "menu.weather.image"
  local thermostatKey = "menu.thermostat.image"
  local scheduleKey = "menu.schedule.image"
  
  
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 1, 3 do
    
    local selectAnim, deselectAnim, folder, key
    
    if i == 1 then
      folder = 'raindropIcon'
      selectAnim = weatherSelect
      deselectAnim = weatherDeselect
      key = weatherKey
    elseif i == 2 then
      folder = 'thermoIcon'
      selectAnim = thermostatSelect
      deselectAnim = thermostatDeselect
      key = thermostatKey
    elseif i == 3 then
      folder = 'timeIcon'
      selectAnim = scheduleSelect
      deselectAnim = scheduleDeselect
      key = scheduleKey
    end
    
    animData["key"] = key
    
    for i = 0, frameCountSelect do
      animData["offset"] = i*15
      local j = i
      if(j < 10)then
        j = '0'..j
      end
      animData["to"] = "images/animations/"..folder.."/frame_"..j..".png"
      gre.animation_add_step(selectAnim, animData)
    end
    
    for i = 0, frameCountDeselect do
      animData["offset"] = i*15
      local j = i + 60
      animData["to"] = "images/animations/"..folder.."/frame_"..j..".png"
      gre.animation_add_step(deselectAnim, animData)
    end
  
  end
end