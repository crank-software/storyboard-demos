local function convertToTimeTable(incTime)
  local timeTable = {}

  local h = math.floor(incTime / 3600)
  local m = math.floor((incTime - (h * 3600)) / 60)
  local s = math.floor(incTime - ((h * 3600) + (m * 60)))
  
  if(string.len(h) == 1)then
    h = '0'..h
  end
  
  if(string.len(m) == 1)then
    m = '0'..m
  end
  
  if(string.len(s) == 1)then
    s = '0'..s
  end
  
  timeTable.h1 = tonumber(string.sub(h,1,1))
  timeTable.h2 = tonumber(string.sub(h,2,2))
  timeTable.m1 = tonumber(string.sub(m,1,1))
  timeTable.m2 = tonumber(string.sub(m,2,2))
  timeTable.s1 = tonumber(string.sub(s,1,1))
  timeTable.s2 = tonumber(string.sub(s,2,2))
  
  return timeTable
end

local function convertToTempTable(incTemp)
  local tempTable = {}
  tempTable.hun = tonumber(string.sub(incTemp,1,1))
  tempTable.ten = tonumber(string.sub(incTemp,2,2))
  tempTable.one= tonumber(string.sub(incTemp,3,3))
  return tempTable
end

function setupMorphStartingTimerNumbers(incTime)
  local timeTable = convertToTimeTable(incTime)
  --print(timeTable.s2, timeTable.s1)
    
  local data = {}
  data["cooking.timeMid.secOne.image"] = "images/numberMorph/timeSmall/starting/"..timeTable.s2..".png"
  data["cooking.timeMid.secTen.image"] = "images/numberMorph/timeSmall/starting/"..timeTable.s1..".png"
  data["cooking.timeMid.minOne.image"] = "images/numberMorph/timeLarge/starting/"..timeTable.m2..".png"
  data["cooking.timeMid.minTen.image"] = "images/numberMorph/timeLarge/starting/"..timeTable.m1..".png"
  data["cooking.timeMid.hourOne.image"] = "images/numberMorph/timeLarge/starting/"..timeTable.h2..".png"
  data["cooking.timeMid.hourTen.image"] = "images/numberMorph/timeLarge/starting/"..timeTable.h1..".png"
  gre.set_data(data)
end

function setupMorphStartingTempNumbers(incTemp)
  local tempTable = convertToTempTable(incTemp)
  
  local data = {}
  data["cooking.temperatureMid.tempOne.image"] = "images/numberMorph/temp/starting/"..tempTable.one..".png"
  data["cooking.temperatureMid.tempTen.image"] = "images/numberMorph/temp/starting/"..tempTable.ten..".png"
  data["cooking.temperatureMid.tempHun.image"] = "images/numberMorph/temp/starting/"..tempTable.hun..".png"
  gre.set_data(data)

end

function checkTimerNumbersMorph(incPrev, incNew)
  
  
  local prevTimeTable = convertToTimeTable(incPrev)
  local newTimeTable = convertToTimeTable(incNew)
  
  if(prevTimeTable.h1 ~= newTimeTable.h1)then
    local animNumber = tonumber(newTimeTable.h1)
    if(animNumber == 0)then
      animNumber = 10
    end
    gre.animation_trigger(anim_BackHourTen[animNumber])
  end
  
  if(prevTimeTable.h2 ~= newTimeTable.h2)then
    local animNumber = tonumber(newTimeTable.h2)
    if(animNumber == 0)then
      animNumber = 10
    end
    gre.animation_trigger(anim_BackHourOne[animNumber])
  end
  
  if(prevTimeTable.m1 ~= newTimeTable.m1)then
    local animNumber = tonumber(newTimeTable.m1)
    if(animNumber == 0)then
      animNumber = 10
    end
    if(prevTimeTable.m1 == 0 and newTimeTable.m1 == 5)then
      gre.animation_trigger(anim_BackMinLoop)
    else
      gre.animation_trigger(anim_BackMinTen[animNumber])
    end
  end
  
  if(prevTimeTable.m2 ~= newTimeTable.m2)then
    local animNumber = tonumber(newTimeTable.m2)
    if(animNumber == 0)then
      animNumber = 10
    end
    gre.animation_trigger(anim_BackMinOne[animNumber])
    
  end
  
  if(prevTimeTable.s1 ~= newTimeTable.s1)then
    local animNumber = tonumber(newTimeTable.s1)
    if(animNumber == 0)then
      animNumber = 10
    end
    if(prevTimeTable.s1 == 0 and newTimeTable.s1 == 5)then
      gre.animation_trigger(anim_BackSecLoop)
    else
      gre.animation_trigger(anim_BackSecTen[animNumber])
    end
  end
  
  if(prevTimeTable.s2 ~= newTimeTable.s2)then
    local animNumber = tonumber(newTimeTable.s2)
    if(animNumber == 0)then
      animNumber = 10
    end
    gre.animation_trigger(anim_BackSecOne[animNumber])
  end
  
end


function checkCookNumbersMorph(incPrev, incNew)

  local prevTempTable = convertToTempTable(incPrev)
  local newTempTable = convertToTempTable(incNew)
  
  if(prevTempTable.hun ~= newTempTable.hun)then
    local animNumber = tonumber(newTempTable.hun)
    if(animNumber == 0)then
      animNumber = 10
    end
    if(prevTempTable.hun < newTempTable.hun)then
      gre.animation_trigger(anim_ForTempHun[animNumber])
    else
      gre.animation_trigger(anim_BackTempHun[animNumber])
    end
  end
  
  if(prevTempTable.ten ~= newTempTable.ten)then
    local animNumber = tonumber(newTempTable.ten)
    if(animNumber == 0)then
      animNumber = 10
    end
    if(prevTempTable.ten < newTempTable.ten)then
      gre.animation_trigger(anim_ForTempTen[animNumber])
    else
      gre.animation_trigger(anim_BackTempTen[animNumber])
    end
  end
  
  if(prevTempTable.one ~= newTempTable.one)then
    local animNumber = tonumber(newTempTable.one)
    if(animNumber == 0)then
      animNumber = 10
    end
    
    --check if its a 0 to 5 or 5 to 0 animation
    if(prevTempTable.one == 5 and newTempTable.one == 0)then
      gre.animation_trigger(anim_FiveToZero)
      return
    elseif(prevTempTable.one == 0 and newTempTable.one == 5)then
      gre.animation_trigger(anim_ZeroToFive)
      return
    end
    
    if(prevTempTable.one < newTempTable.one)then
      gre.animation_trigger(anim_ForTempOne[animNumber])
    else
      gre.animation_trigger(anim_BackTempOne[animNumber])
    end
  end
end