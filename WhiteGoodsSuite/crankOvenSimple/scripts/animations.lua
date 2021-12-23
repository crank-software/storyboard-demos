function anim_HomeLayerSnap(fromPos, toPos, midFromPos, midToPos)
  local key1 = "homeScreen.homeSliderLeft.grd_xoffset"
  local key2 = "homeScreen.homeSliderRight.grd_xoffset"
  local key_mid = "homeScreen.homeSliderMid.grd_xoffset"
  
  local anim_data = {}
  
  local homeLayerSnap = gre.animation_create(30, 1)
  
  anim_data["key"] = key1
  anim_data["rate"] = "linear"
  anim_data["duration"] = 250
  anim_data["offset"] = 0
  anim_data["from"] = fromPos
  anim_data["to"] = toPos
  gre.animation_add_step(homeLayerSnap, anim_data)
  
  anim_data["key"] = key2
  anim_data["rate"] = "linear"
  anim_data["duration"] = 250
  anim_data["offset"] = 0
  anim_data["from"] = fromPos
  anim_data["to"] = toPos
  gre.animation_add_step(homeLayerSnap, anim_data)
  
  anim_data["key"] = key_mid
  anim_data["rate"] = "linear"
  anim_data["duration"] = 250
  anim_data["offset"] = 0
  anim_data["from"] = midFromPos
  anim_data["to"] = midToPos
  gre.animation_add_step(homeLayerSnap, anim_data)
  
  gre.animation_trigger(homeLayerSnap)
end

function anim_cookModesBannerFade(incNew, incPrev)

  local key1_1 = "homeAllCookModes."..incNew..".selected.alpha"
  local key1_2 = "homeAllCookModes."..incNew..".unselected.alpha"
  local key2_1 = "homeAllCookModes."..incPrev..".selected.alpha"
  local key2_2 = "homeAllCookModes."..incPrev..".unselected.alpha"
  local anim_data = {}
  
  local homeBannerFade = gre.animation_create(30, 1)
  
  anim_data["key"] = key1_1
  anim_data["rate"] = "linear"
  anim_data["duration"] = 150
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 255
  gre.animation_add_step(homeBannerFade, anim_data)
  
  anim_data["key"] = key1_2
  anim_data["rate"] = "linear"
  anim_data["duration"] = 150
  anim_data["offset"] = 0
  anim_data["from"] = 255
  anim_data["to"] = 0
  gre.animation_add_step(homeBannerFade, anim_data)
  
  anim_data["key"] = key2_1
  anim_data["rate"] = "linear"
  anim_data["duration"] = 150
  anim_data["offset"] = 50
  anim_data["from"] = 255
  anim_data["to"] = 0
  gre.animation_add_step(homeBannerFade, anim_data)
    
  anim_data["key"] = key2_2
  anim_data["rate"] = "linear"
  anim_data["duration"] = 150
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 255
  gre.animation_add_step(homeBannerFade, anim_data)
  
  gre.animation_trigger(homeBannerFade)

end

function anim_preheatOuterArc(ctrlHeight, preheatHeight)
  local key = "cooking.preheatProgressBar.elapsed"
  local anim_data = {}

  local preheatArc = gre.animation_create(30, 1)

  anim_data["key"] = key..".grd_height"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 3500
  anim_data["offset"] = 0
  anim_data["to"] = preheatHeight
  gre.animation_add_step(preheatArc, anim_data)
  
  anim_data["key"] = key..".grd_y"
  anim_data["rate"] = "linear"
  anim_data["to"] = ctrlHeight - preheatHeight
  gre.animation_add_step(preheatArc, anim_data)
  
  gre.animation_trigger(preheatArc)

end

loopingVoiceLines = {}
loopingVoiceDots = {}

function create_voiceAnim()
  loopingVoiceLines = gre.animation_create(30, 0, triggerVoiceLinesAnim)
  loopingVoiceDots = gre.animation_create(30, 0, triggerVoiceDotsAnim)
end

function anim_voiceLines()

  local key = "voiceActivationHeader.talkingLinesPlaceholder.image"
  local animData = {}
  
  --local loopingVoiceLines = gre.animation_create(60, 1) -- add in function to call the actual animation. Only make the animation
  --once then trigger it multiple times
  
  animData["key"] = key
  animData["rate"] = "linear"
  animData["duration"] = 0
  
  --animation of the forward lines, then reverse
  for x = 0, 59 do
    animData["offset"] = x*30
    local img = x+150
    animData["to"] = "images/voiceLines/voiceLine_00"..img..".png"
    gre.animation_add_step(loopingVoiceLines,animData)
  end
  
  for x = 0,59 do
    animData["offset"] = x*30 + (59*30)
    local img = 209-x
    animData["to"] = "images/voiceLines/voiceLine_00"..img..".png"
    gre.animation_add_step(loopingVoiceLines,animData)
  end

end

function anim_voiceDots()

  local key1 = "voiceTalking.rightImage.image"
  local key2 = "voiceTalking.leftImage.image"
  local animData = {}
  
  --local loopingVoiceLines = gre.animation_create(60, 1) -- add in function to call the actual animation. Only make the animation
  --once then trigger it multiple times
  
  
  animData["rate"] = "linear"
  animData["duration"] = 0
  
  --animation of the forward lines, then reverse
  for i = 1, 2 do
    
    if(i == 1)then
      animData["key"] = key1
    elseif(i == 2)then
      animData["key"] = key2
    end
    
    for x = 0, 29 do
      animData["offset"] = x*30
      local img = x
      animData["to"] = "images/voiceDots/"..img..".png"
      gre.animation_add_step(loopingVoiceDots,animData)
    end
    
    for x = 0,29 do
      animData["offset"] = x*30 + (29*30)
      local img = 29-x
      animData["to"] = "images/voiceDots/"..img..".png"
      gre.animation_add_step(loopingVoiceDots,animData)
    end
  end

end

homeExtrasAnimation = {}

function anim_homeExtras()

  local frameTime = 60
  local frameAmount = 30

  local key1 = "background.animExtra1.image"
  local key2 = "background.animExtra2.image"
  local key3 = "background.animExtra3.image"
  local key4 = "background.animExtra4.image"
  
  local anim_data = {}
  
  homeExtrasAnimation = gre.animation_create(30, 0, callExtrasAnimation)
  anim_data["rate"] = "linear"
  anim_data["duration"] = 0
  
  anim_data["key"] = key1
  for i = 1, frameAmount do
    anim_data["offset"] = (i-1)*frameTime
    anim_data["to"] = "images/homeMovement/"..i..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
  for i = 1, frameAmount do
    anim_data["offset"] = ((i-1)*frameTime) + (frameTime*frameAmount)
    local j = frameAmount-(i-1)
    anim_data["to"] = "images/homeMovement/"..j..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
  anim_data["key"] = key2
  for i = 1, frameAmount do
    anim_data["offset"] = ((i-1)*frameTime) + (frameTime*frameAmount)
    anim_data["to"] = "images/homeMovement/"..i..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
  for i = 1, frameAmount do
    anim_data["offset"] = (i-1)*frameTime
    local j = frameAmount-(i-1)
    anim_data["to"] = "images/homeMovement/"..j..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end

  anim_data["key"] = key3
  for i = 1, frameAmount do
    anim_data["offset"] = (i-1)*frameTime
    anim_data["to"] = "images/homeMovement2/"..i..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
  for i = 1, frameAmount do
    anim_data["offset"] = ((i-1)*frameTime) + (frameTime*frameAmount)
    local j = frameAmount-(i-1)
    anim_data["to"] = "images/homeMovement2/"..j..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
  anim_data["key"] = key4
  for i = 1, frameAmount do
    anim_data["offset"] = ((i-1)*frameTime) + (frameTime*frameAmount)
    anim_data["to"] = "images/homeMovement2/"..i..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
  for i = 1, frameAmount do
    anim_data["offset"] = (i-1)*frameTime
    local j = frameAmount-(i-1)
    anim_data["to"] = "images/homeMovement2/"..j..".png"
    gre.animation_add_step(homeExtrasAnimation, anim_data)
  end
  
end

function callExtrasAnimation()
  gre.animation_trigger(homeExtrasAnimation)
end

--BELOW ARE TEH NUMBER MORPH ANIMATIONS, SET ASIDE AS THERE ARE A LOT

--seconds animation declarations
anim_BackSecOne = {}
anim_BackSecTen = {}
anim_BackSecLoop = {}
--minute animation declarations
anim_BackMinOne = {}
anim_BackMinTen = {}
anim_BackMinLoop = {}
--hour animation declarations
anim_BackHourOne = {}
anim_BackHourTen = {}
-- temp animation declarations
--basic
anim_ForTempHun = {}
anim_ForTempTen = {}
anim_ForTempOne = {}
anim_BackTempHun = {}
anim_BackTempTen = {}
anim_BackTempOne = {}
--byFive (Will only happen on the ones)
anim_FiveToZero = {}
anim_ZeroToFive = {}

function createForwardAnimations()
  for i = 1, 10 do
    anim_BackSecOne[i] = gre.animation_create(30, 0)
    anim_BackSecTen[i] = gre.animation_create(30, 0)
    
    anim_BackMinOne[i] = gre.animation_create(30, 0)
    anim_BackMinTen[i] = gre.animation_create(30, 0)
    
    anim_BackHourOne[i] = gre.animation_create(30, 0)
    anim_BackHourTen[i] = gre.animation_create(30, 0)
  end
  
  anim_BackSecLoop = gre.animation_create(30, 0)
  anim_BackMinLoop = gre.animation_create(30, 0)
end

function createTempAnimations()
  for i = 1, 10 do
    anim_ForTempHun[i] = gre.animation_create(30, 0)
    anim_ForTempTen[i] = gre.animation_create(30, 0)
    anim_ForTempOne[i] = gre.animation_create(30, 0)
    
    anim_BackTempHun[i] = gre.animation_create(30, 0)
    anim_BackTempTen[i] = gre.animation_create(30, 0)
    anim_BackTempOne[i] = gre.animation_create(30, 0)
  end
  
  anim_FiveToZero = gre.animation_create(30, 0)
  anim_ZeroToFive = gre.animation_create(30, 0)
  
end

function numberSwitchAnimationSetup()
  
  for x = 1, 6 do
    --list of images matched to numbers 
    --1 == secondOne, 2 == secondTen, 3 == minuteOne, 4 == minuteTen, 5 == hourOne, 6 == hourTen
    local key
    if(x==1)then
      key = "cooking.timeMid.secOne.image"
    elseif(x==2)then
      key = "cooking.timeMid.secTen.image"
    elseif(x==3)then
      key = "cooking.timeMid.minOne.image"
    elseif(x==4)then
      key = "cooking.timeMid.minTen.image"
    elseif(x==5)then
      key = "cooking.timeMid.hourOne.image"
    elseif(x==6)then
      key = "cooking.timeMid.hourTen.image"
    end
  
    local animData = {}
      
    animData["key"] = key
    animData["rate"] = "linear"
    animData["duration"] = 0
    animData["from"] = ''
    
    for i = 0, 10 do
    
    --reverse numbers will have to go backwards, below code is for image sequenceing in reverse
      local rev_i = 10-i
--      if(rev_i<10)then
--        rev_i = '0'..rev_i
--      end
      
      --make sure that the i is set up to match with our image directory
      if(i<10)then
        i = '0'..i
      end
      
      animData["offset"] = i*30
      --do this for each number and animation
      for j = 1, 10 do
        --since reverse we want to go from the upper number to the lower number have to add 1 to the reverse number to pull from
        local new_j = j + 1
        if(new_j == 11)then
          new_j = 1
        end
        --if in the seconds, x = 1 or 2, we use a different image
        animData["to"] = "images/numberMorph/timeLarge/num"..new_j.."/"..rev_i..".png"
        if(x==1)then
          animData["to"] = "images/numberMorph/timeSmall/num"..new_j.."/"..rev_i..".png"
          gre.animation_add_step(anim_BackSecOne[j], animData)
        elseif(x==2)then
          animData["to"] = "images/numberMorph/timeSmall/num"..new_j.."/"..rev_i..".png"
          gre.animation_add_step(anim_BackSecTen[j], animData)
        elseif(x==3)then
          gre.animation_add_step(anim_BackMinOne[j], animData)
        elseif(x==4)then
          gre.animation_add_step(anim_BackMinTen[j], animData)
        elseif(x==5)then
          gre.animation_add_step(anim_BackHourOne[j], animData)
        elseif(x==6)then
          gre.animation_add_step(anim_BackHourTen[j], animData)
        end
      end
    end    
  end
end

function tempNumberSwitchAnimSetup()
  for x = 1, 3 do
    --list of images matched to numbers 
    --1 == temp1, 2 == temp10, 3 == temp100
    local key
    if(x==1)then
      key = "cooking.temperatureMid.tempOne.image"
    elseif(x==2)then
      key = "cooking.temperatureMid.tempTen.image"
    elseif(x==3)then
      key = "cooking.temperatureMid.tempHun.image"
    end
  
    local animData = {}
      
    animData["key"] = key
    animData["rate"] = "linear"
    animData["duration"] = 0
    animData["from"] = ''
    
    for i = 0, 10 do
    
      --reverse numbers will have to go backwards, below code is for image sequenceing in reverse
      local rev_i = 10-i
      
      animData["offset"] = i*30
      --do this for each number and animation
      for j = 1, 10 do
        animData["to"] = "images/numberMorph/temp/num"..j.."/"..i..".png"
        if(x==1)then
          gre.animation_add_step(anim_ForTempOne[j], animData)
        elseif(x==2)then
          gre.animation_add_step(anim_ForTempTen[j], animData)
        elseif(x==3)then
          gre.animation_add_step(anim_ForTempHun[j], animData)
        end
        --since reverse we want to go from the upper number to the lower number have to add 1 to the reverse number to pull from
        local new_j = j + 1
        if(new_j == 11)then
          new_j = 1
        end
        animData["to"] = "images/numberMorph/temp/num"..new_j.."/"..rev_i..".png"
        if(x==1)then
          gre.animation_add_step(anim_BackTempOne[j], animData)
        elseif(x==2)then
          gre.animation_add_step(anim_BackTempTen[j], animData)
        elseif(x==3)then
          gre.animation_add_step(anim_BackTempHun[j], animData)
        end
      end
    end  
  
  end
end

function tempNumberSpecialAnimSetup()
  local key = "cooking.temperatureMid.tempOne.image"
  local animData = {}
  
  animData["key"] = key
  animData["rate"] = "linear"
  animData["duration"] = 0
  animData["from"] = ''
  
  for i = 1, 10 do
    animData["offset"] = i*30
    animData["to"] = "images/numberMorph/temp/special10/"..i..".png"
    gre.animation_add_step(anim_FiveToZero, animData)
    animData["to"] = "images/numberMorph/temp/special5/"..i..".png"
    gre.animation_add_step(anim_ZeroToFive, animData)
  end
end

function timeNumberSpecialAnimSetuo()
  local key1 = "cooking.timeMid.secTen.image"
  local key2 =  "cooking.timeMid.minTen.image"

  local animData = {}

  animData["key"] = key2
  animData["rate"] = "linear"
  animData["duration"] = 0
  animData["from"] = ''
  
  for i = 1, 10 do
    animData["offset"] = i*30
    animData["key"] = key1
    animData["to"] = "images/numberMorph/timeSmall/special5/"..i..".png"
    gre.animation_add_step(anim_BackSecLoop, animData)
    animData["key"] = key2
    animData["to"] = "images/numberMorph/timeLarge/special5/"..i..".png"
    gre.animation_add_step(anim_BackMinLoop, animData)
  end
end