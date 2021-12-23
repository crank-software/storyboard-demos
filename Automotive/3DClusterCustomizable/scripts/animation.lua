clusterParticlesSport = {}
clusterParticlesComfort = {}
clusterParticlesEco = {}
--check to see if the particles are running because we then eitehr start or resume the animation
local sportParticlesRunning = 0
local comfortParticlesRunning = 0
local ecoParticlesRunning = 0

local frameCount = 87

function animateRPMDials(incPos, incArcPos, incSmallNeedleRPM, incSmallArcRPM, incSmallNeedleSpeed, incSmallArcSpeed)
  
  local key1 = "speedometerSingle.3D.3DDial.needleRoot_RZ"
  local key2 = "speedometerSingle.3D.3DDial.dialsRoot_RX"
  local key3 = "speedometerSingle.3D.3DBackground.grd_y"
  local key4 = "speedometerSingle.odo.grd_y"
  local key5 = "speedometerSingle.mode.grd_y"
  local key6 = "speedometerSingle.3D.speedArc.endAngle"
  local key7 = "speedometerSingle.3D.speedArc.grd_y"
  local key8 = "speedometerSingle.3D.particles.grd_y"
  
  local smallKey1 = "speedometerDouble.rpm3D.rightArc.endAngle"
  local smallKey2 = "speedometerDouble.rpm3D.rightDial.needleLow_RY"
  local smallKey3 = "speedometerDouble.speed3D.rightArc.endAngle"
  local smallKey4 = "speedometerDouble.speed3D.leftDial.needleHigh_RY"
  
  local transKey1 = "speedometerTransition.leftDial.needleHigh_RY"
  local transKey2 = "speedometerTransition.rightDial.needleLow_RY"
  
  local animData = {}
  
  local rpmAnim = gre.animation_create(60, 1)
  --singleDialsAnimation
  animData["key"] = key1
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incPos
  gre.animation_add_step(rpmAnim, animData)
    
  animData = {}
  animData["key"] = key6
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incArcPos
  gre.animation_add_step(rpmAnim, animData)

  --double Dials animations
  animData = {}
  animData["key"] = smallKey1
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incSmallArcRPM
  gre.animation_add_step(rpmAnim, animData)
  
  animData = {}
  animData["key"] = smallKey2
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incSmallNeedleRPM
  gre.animation_add_step(rpmAnim, animData)
  
  animData = {}
  animData["key"] = smallKey3
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incSmallArcSpeed
  gre.animation_add_step(rpmAnim, animData)
  
  animData = {}
  animData["key"] = smallKey4
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incSmallNeedleSpeed
  gre.animation_add_step(rpmAnim, animData)
  
  local transitionStart = gre.get_value("speedometerTransition.transitionStart")
  if(transitionStart == 1)then
    animData = {}
    animData["key"] = transKey1
    animData["rate"] = "linear"
    animData["duration"] = 100
    animData["offset"] = 0
    animData["to"] = incSmallNeedleSpeed
    gre.animation_add_step(rpmAnim, animData)
    
    animData = {}
    animData["key"] = transKey2
    animData["rate"] = "linear"
    animData["duration"] = 100
    animData["offset"] = 0
    animData["to"] = incSmallNeedleRPM
    gre.animation_add_step(rpmAnim, animData)
  end
    
  gre.animation_trigger(rpmAnim)

end

function animateSongWidth(incControl, incWidth)
  
  local animData = {}
  
  local songAnim = gre.animation_create(60, 1)
  --singleDialsAnimation
  animData["key"] = incControl
  animData["rate"] = "linear"
  animData["duration"] = 1000
  animData["offset"] = 0
  animData["to"] = incWidth
  gre.animation_add_step(songAnim, animData)
  gre.animation_trigger(songAnim)
end

function animateQPICDial(incRPM)

  local animData = {}
  
  local QPICAnim = gre.animation_create(60, 1)
  --singleDialsAnimation
  animData["key"] = "background.rpmArc.endAngle"
  animData["rate"] = "linear"
  animData["duration"] = 100
  animData["offset"] = 0
  animData["to"] = incRPM
  gre.animation_add_step(QPICAnim, animData)
  gre.animation_trigger(QPICAnim)
end

local function callClusterParticlesSport()
  gre.animation_trigger(clusterParticlesSport)
end

function innerClusterParticlesSport(mapargs)

  local appSize = gre.get_value('appSize') 
  local animData = {}  
  clusterParticlesSport = gre.animation_create(60, 0, callClusterParticlesSport)
  
  animData["key"] = "speedometerSingle.3D.particles.image"
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 1, frameCount do
    animData["offset"] = i*40
    animData["to"] = 'images/sportComp'..appSize..'/'..i..'.png'
    gre.animation_add_step(clusterParticlesSport, animData)
  end
  
  --gre.animation_trigger(clusterParticlesSport)
end

local function callClusterParticlesComfort()
  gre.animation_trigger(clusterParticlesComfort)
end

function innerClusterParticlesComfort(mapargs)

  local appSize = gre.get_value('appSize') 
  local animData = {}  
  clusterParticlesComfort = gre.animation_create(60, 0, callClusterParticlesComfort)
  
  animData["key"] = "speedometerSingle.3D.particles.image"
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 1, frameCount do
    animData["offset"] = i*40
    animData["to"] = 'images/comfortComp'..appSize..'/'..i..'.png'
    gre.animation_add_step(clusterParticlesComfort, animData)
  end
  
  --gre.animation_trigger(clusterParticlesComfort)
end

local function callClusterParticlesEco()
  gre.animation_trigger(clusterParticlesEco)
end

function innerClusterParticlesEco(mapargs)

  local appSize = gre.get_value('appSize') 
  local animData = {}  
  clusterParticlesEco = gre.animation_create(60, 0, callClusterParticlesEco)
  
  animData["key"] = "speedometerSingle.3D.particles.image"
  animData["rate"] = "linear"
  animData["duration"] = 0

  for i = 1, frameCount do
    animData["offset"] = i*40
    animData["to"] = 'images/ecoComp'..appSize..'/'..i..'.png'
    gre.animation_add_step(clusterParticlesEco, animData)
  end
  
  --gre.animation_trigger(clusterParticlesEco)
end

function manageParticleAnimation(incCommand)

  if(configTable.particleAnimation == 'off')then
    return
  end
    
  local mode  = gre.get_value('mode')
  if(mode == 'sport')then
    if(incCommand == 'resume')then
      if(sportParticlesRunning == 0)then
        gre.animation_trigger(clusterParticlesSport)
        sportParticlesRunning = 1
      else
        gre.animation_resume(clusterParticlesSport)
      end
    elseif(incCommand == 'pause')then
      gre.animation_pause(clusterParticlesSport)
    end
  elseif(mode == 'eco')then
    if(incCommand == 'resume')then
      if(ecoParticlesRunning == 0)then
        gre.animation_trigger(clusterParticlesEco)
        ecoParticlesRunning = 1
      else
        gre.animation_resume(clusterParticlesEco)
      end
    elseif(incCommand == 'pause')then
      gre.animation_pause(clusterParticlesEco)
    end
  elseif(mode == 'comfort')then
    if(incCommand == 'resume')then
      if(comfortParticlesRunning == 0)then
        gre.animation_trigger(clusterParticlesComfort)
        comfortParticlesRunning = 1
      else
        gre.animation_resume(clusterParticlesComfort)
      end
    elseif(incCommand == 'pause')then
      gre.animation_pause(clusterParticlesComfort)
    end
  end
  
end