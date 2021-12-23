local function preloadingAnims()
  


end

function CBinignitionLoads(mapargs)

--  load all of the models and stuff here
--easiest way is to have a screen with everything on it and unhidden. On screenshow post of that screen we transition to the other things

  --start a thread and do an animation
  print('ignition loads')
  local appSize = gre.get_value('appSize')  
  local mode = configTable.mode
  local autoSwap = configTable.autoSwap
  local particleAnimation = configTable.particleAnimation
  
  print(appSize, mode, autoSwap, particleAnimation)
  
  --loading particle images
  --only load the proper images, depending on the config file and gde
  if(particleAnimation == 'on')then
    if(autoSwap == 'on')then
      for i = 1, 87 do
        --gre.load_resource('image', 'images/sportComp'..appSize..'/'..i..'.png',pool_parameters)
        gre.load_image('images/sportComp'..appSize..'/'..i..'.png')
        gre.load_image('images/ecoComp'..appSize..'/'..i..'.png')
        gre.load_image('images/comfortComp'..appSize..'/'..i..'.png')
      end
    else
      if(mode == 'eco')then
        for i = 1, 87 do
          gre.load_image('images/ecoComp'..appSize..'/'..i..'.png')
        end
      elseif(mode == ' comfort')then
        for i = 1, 87 do
          gre.load_image('images/comfortComp'..appSize..'/'..i..'.png')
        end
      elseif(mode == 'sport')then
        for i = 1, 87 do
          gre.load_image('images/sportComp'..appSize..'/'..i..'.png')
        end
      end
    end
  end

  --loading the seperate coloured images for differing sizes and stuff
--  for i = 1, 3 do
--    local folder
--    if(i == 1)then
--      folder = 'modeSport'..appSize
--    elseif(i == 2)then
--      folder = 'modeComfort'..appSize
--    elseif(i == 3)then
--      folder = 'modeEco'..appSize
--    end
  local folder
  folder = 'modeEco'..appSize
  gre.load_image("images/"..folder.."/3DBackground.png")
  gre.load_image("images/"..folder.."/overlay.png")
--  end
  
  gre.load_image("images/bg.png")
  gre.load_image("images/albumArt.png")
  gre.load_image("images/reflection.png")
  gre.load_image("images/overlay.png")
  gre.load_image("images/3D_CarPlaceholder.png")
  gre.load_image("images/mapRightOverlay.png")
  gre.load_image("images/mapLeftOverlay.png")
  
  --load in the models
  if(autoSwap == 'on')then
    for i = 1, 3 do
      if(i == 1)then
        gre.set_value("speedometerSingle.3D.3DDial.model", 'models/dialSingleSport/dialSingleSport.ssg')
        gre.set_value("speedometerDouble.speed3D.leftDial.model", 'models/dialLeftSport/dialLeftSport.ssg')
        gre.set_value("speedometerDouble.rpm3D.rightDial.model", 'models/dialRightSport/dialRightSport.ssg')
        gre.set_value("largeMapNav.mapPlaceholder.model",'models/mapSport/mapSport.ssg')
      elseif(i == 2)then
        gre.set_value("speedometerSingle.3D.3DDial.model", 'models/dialSingleComfort/dialSingleComfort.ssg')
        gre.set_value("speedometerDouble.speed3D.leftDial.model", 'models/dialLeftComfort/dialLeftComfort.ssg')
        gre.set_value("speedometerDouble.rpm3D.rightDial.model", 'models/dialRightComfort/dialRightComfort.ssg')
        gre.set_value("largeMapNav.mapPlaceholder.model",'models/mapComfort/mapComfort.ssg')
      elseif(i == 3)then
        gre.set_value("speedometerSingle.3D.3DDial.model", 'models/dialSingleEco/dialSingleEco.ssg')
        gre.set_value("speedometerDouble.speed3D.leftDial.model", 'models/dialLeftEco/dialLeftEco.ssg')
        gre.set_value("speedometerDouble.rpm3D.rightDial.model", 'models/dialRightEco/dialRightEco.ssg')
        gre.set_value("largeMapNav.mapPlaceholder.model",'models/mapEco/mapEco.ssg')
      end
    end
  else
    if(mode == 'sport')then
      gre.set_value("speedometerSingle.3D.3DDial.model", 'models/dialSingleSport/dialSingleSport.ssg')
      gre.set_value("speedometerDouble.speed3D.leftDial.model", 'models/dialLeftSport/dialLeftSport.ssg')
      gre.set_value("speedometerDouble.rpm3D.rightDial.model", 'models/dialRightSport/dialRightSport.ssg')
      gre.set_value("largeMapNav.mapPlaceholder.model",'models/mapSport/mapSport.ssg')
    elseif(mode == 'comfort')then
      gre.set_value("speedometerSingle.3D.3DDial.model", 'models/dialSingleComfort/dialSingleComfort.ssg')
      gre.set_value("speedometerDouble.speed3D.leftDial.model", 'models/dialLeftComfort/dialLeftComfort.ssg')
      gre.set_value("speedometerDouble.rpm3D.rightDial.model", 'models/dialRightComfort/dialRightComfort.ssg')
      gre.set_value("largeMapNav.mapPlaceholder.model",'models/mapComfort/mapComfort.ssg')
    elseif(mode == 'eco')then
      gre.set_value("speedometerSingle.3D.3DDial.model", 'models/dialSingleEco/dialSingleEco.ssg')
      gre.set_value("speedometerDouble.speed3D.leftDial.model", 'models/dialLeftEco/dialLeftEco.ssg')
      gre.set_value("speedometerDouble.rpm3D.rightDial.model", 'models/dialRightEco/dialRightEco.ssg')
      gre.set_value("largeMapNav.mapPlaceholder.model",'models/mapEco/mapEco.ssg')
    end 
  end
      
  CBInit()    
  gre.send_event('preloadingComplete')
  
end

function CBInit(mapargs)
--change the mode based on the app size and the config file
  local size = gre.get_value('appSize')
  local mode = configTable.mode
  
  local initFile = tostring(mode..size)
  CBChangeMode(initFile)
  
  if(configTable.particleAnimation == 'on')then
    innerClusterParticlesSport()
    innerClusterParticlesComfort()
    innerClusterParticlesEco()
  else
    --hide the particle image
    gre.set_value("speedometerSingle.3D.particles.grd_hidden", 1)
  end
  
  --automatically make the 2D version single Dial only
  if(configTable.TwoDOnly == 'on')then
    configTable.singleDialOnly = 'on'
    TwoDDial()
  end
  
  if(configTable.singleDialOnly == 'on')then
    animTimingsSingle()
    animStep1Single()
  else
    animTimings()
    animStep1()
  end

  gre.animation_trigger('APP_dialsData')
end