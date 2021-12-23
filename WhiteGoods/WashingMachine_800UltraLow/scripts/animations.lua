function animateTables(midPos, topPos, botPos, newPosMid, newPosTop, newPosBot)
  
  local animData = {}  
  local myAnimation = gre.animation_create(60, 1)
  
  animData["key"] = "homeSlider.topIcons.grd_yoffset"
  animData["rate"] = "linear"
  animData["duration"] = 200
  animData["offset"] = 0
  animData["from"] = topPos
  animData["to"] = newPosTop
  gre.animation_add_step(myAnimation, animData)
  
  animData["key"] = "homeSlider.botIcons.grd_yoffset"
  animData["from"] = botPos
  animData["to"] = newPosBot
  gre.animation_add_step(myAnimation, animData)
  
  animData["key"] = "homeSlider.midIcons.grd_yoffset"
  animData["from"] = midPos
  animData["to"] = newPosMid
  gre.animation_add_step(myAnimation, animData)
  
  gre.animation_trigger(myAnimation)
end


local frameCount = 40
drumAnimation = {}
local drumRunning = 0

function callDrumAnimation()
  if(drumRunning == 0)then
    return
  end
  gre.animation_trigger(drumAnimation)
end

function CBStopDrumAnimation()
  drumRunning = 0
  gre.animation_stop(drumAnimation)
end

function CBTriggerDrumAnimation()
  drumRunning = 1
  gre.animation_trigger(drumAnimation)
  if(SIMPLE_MODE == 1)then
    gre.animation_trigger('WASHING_outerArcSimple')
  else
    gre.animation_trigger('WASHING_outerArc')
  end
end

function animateRotatingDrum()

  local animData = {}  
  drumAnimation = gre.animation_create(60, 0, callDrumAnimation)
  
  animData["key"] = "washing.rotatingWater.image"
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 1, frameCount do
    animData["offset"] = i*30
    animData["to"] = 'images/animation/'..i..'.jpg'
    gre.animation_add_step(drumAnimation, animData)
  end

end