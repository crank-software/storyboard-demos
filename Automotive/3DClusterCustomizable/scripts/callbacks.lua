local rpmMax = 8
local rpmMin = 0
local speedMax = 160
local speedMin = 0
local songTimer = {}
local songTime = 0
local songLength = 225

local function mapNumbers(incNum, incMax, incMin, outMax, outMin)
  --make a percentatce of the incNum based on the max an min
  local percentage = incNum / (incMax-incMin)
  local output = (percentage * (outMax-outMin)) + outMin
  return output
end

local function setupDigiNumbers(incNum)
  local rawString = tostring(incNum)
  local text = {}
    
  if(string.len(rawString) == 1)then
    for i = 1, #rawString do
      local c = rawString:sub(i,i)
      text[3] = c
    end
    text[2] = 0
    text[1] = 0
    text[4] = 1
  elseif(string.len(rawString) == 2)then
    for i = 1, #rawString do
      local c = rawString:sub(i,i)
      if(i == 1)then
        text[2] = c
      else
        text[3] = c
      end
    end
    text[1] = 0
    text[4] = 2
  elseif(string.len(rawString) == 3)then
    for i = 1, #rawString do
      local c = rawString:sub(i,i)
      if(i == 1)then
        text[1] = c
      elseif(i == 2)then
        text[2] = c
      else
        text[3] = c
      end
    end
    text[4] = 3
  end
  
  
  return text

end

function setDigiText(incSpeed, incRPM)

  local speedAlpha = {}
  local rpmAlpha = {}
  
  if(incSpeed[4] == 1)then
    speedAlpha[1] = 100
    speedAlpha[2] = 100
    speedAlpha[3] = 255
  elseif(incSpeed[4] == 2)then
    speedAlpha[1] = 100
    speedAlpha[2] = 255
    speedAlpha[3] = 255
  elseif(incSpeed[4] == 3)then
    speedAlpha[1] = 255
    speedAlpha[2] = 255
    speedAlpha[3] = 255
  end
    
  if(incRPM[4] == 1)then
    rpmAlpha[1] = 100
    rpmAlpha[2] = 100
    rpmAlpha[3] = 255
  elseif(incRPM[4] == 2)then
    rpmAlpha[1] = 100
    rpmAlpha[2] = 255
    rpmAlpha[3] = 255
  elseif(incRPM[4] == 3)then
    rpmAlpha[1] = 255
    rpmAlpha[2] = 255
    rpmAlpha[3] = 255
  end
  
  local data = {}
  
  --specific case for the QPIC cluster since there is nothing fancy in this one
  if(gre.get_value('QPIC') == 1)then
    data["background.digiOne.text"] = incSpeed[3]
    data["background.digiTen.text"] = incSpeed[2]
    gre.set_data(data)
    return
  end
  
  
  data["speedometerSingle.digitalSpeed.digiOne.text"] = incSpeed[3]
  data["speedometerSingle.digitalSpeed.digiTen.text"] = incSpeed[2]
  data["speedometerSingle.digitalSpeed.digiHundred.text"] = incSpeed[1]
  data["speedometerDouble.digitalSpeed.digiOne.text"]= incSpeed[3]
  data["speedometerDouble.digitalSpeed.digiTen.text"]= incSpeed[2]
  data["speedometerDouble.digitalSpeed.digiHundred.text"]= incSpeed[1]  
  data["speedometerDouble.digitalRPM.digiOne.text"]= incRPM[3]
  data["speedometerDouble.digitalRPM.digiTen.text"]= incRPM[2]
  data["speedometerDouble.digitalRPM.digiHundred.text"]= incRPM[1]  

  data["speedometerSingle.digitalSpeed.digiOne.alpha"] = speedAlpha[3]
  data["speedometerSingle.digitalSpeed.digiTen.alpha"] = speedAlpha[2]
  data["speedometerSingle.digitalSpeed.digiHundred.alpha"] = speedAlpha[1]
  data["speedometerDouble.digitalSpeed.digiOne.alpha"]= speedAlpha[3]
  data["speedometerDouble.digitalSpeed.digiTen.alpha"]= speedAlpha[2]
  data["speedometerDouble.digitalSpeed.digiHundred.alpha"]= speedAlpha[1] 
  data["speedometerDouble.digitalRPM.digiOne.alpha"]= rpmAlpha[3]
  data["speedometerDouble.digitalRPM.digiTen.alpha"]= rpmAlpha[2]
  data["speedometerDouble.digitalRPM.digiHundred.alpha"]= rpmAlpha[1]  
  
  gre.set_data(data)
end

--- @param gre#context mapargs
function CBUpdateDials(mapargs) 
  local rpm = gre.get_value("rpm")
  local speed = gre.get_value("speed")
  
  local digiSpeed  = setupDigiNumbers(speed)
  --setup to make it that the raw digital rpm is a 2 digit number between 0-80. Currently a number between 0-8
  local digiRPMRaw = math.floor((rpm * 10)+0.5)
  local digiRPM = setupDigiNumbers(digiRPMRaw)
  
  setDigiText(digiSpeed, digiRPM)
  
  if(gre.get_value("QPIC") == 1)then
    local rpmArc = mapNumbers(rpm, rpmMax, rpmMin, 360, 0)
    animateQPICDial (rpmArc)
    return
  end
  
  local rpmRotation =   mapNumbers(rpm, rpmMax, rpmMin, -360, 0)
  local rpmArc =        mapNumbers(rpm, rpmMax, rpmMin, 360, 0)
  
  local smallNeedleRPM = mapNumbers(rpm, rpmMax, rpmMin, -180, 0)
  local smallArcRPM = mapNumbers(rpm, rpmMax, rpmMin, -90, 90)
  
  local smallNeedleSpeed = mapNumbers(speed, speedMax, speedMin, 180, 0)
  local smallArcSpeed = mapNumbers(speed, speedMax, speedMin, 276, 96)
  
--get the position for the high and low needles based upon the rpm rotation of the main single dial
--get the new position for the high and low needles based upon the rpm and speed rotaiton of the small 'speed' ones
--set the positions of both start and end in the 2 controls, and use this for the animation in the animation editor
  local data = {}
  data["speedometerTransition.startNeedlePos"] = rpmArc
  data["speedometerTransition.endRPMPos"] = smallNeedleRPM
  data["speedometerTransition.endSpeedPos"] = smallNeedleSpeed
  gre.set_data(data)
  
  animateRPMDials(rpmRotation, rpmArc, smallNeedleRPM, smallArcRPM, smallNeedleSpeed, smallArcSpeed)
end

--stop the song timer ever time it hides just so we can have less events firing
local function songTimeDisplay()
  if(songTime >= songLength)then
  songTime = 0
  end
  songTime = songTime + 1
  
  local data = {}
  data["smallMedia.aboutSong.elapsedTime.text"] = formatSeconds(songTime)
  local elapsedWidth = mapNumbers(songTime, songLength, 0, 375, 25) 
  animateSongWidth("smallMedia.aboutSong.elapsed.grd_width", elapsedWidth)
  gre.set_data(data)
end

function songStart(mapargs)
  songTimer = gre.timer_set_interval(songTimeDisplay,1000)
end

function songClearTimer()
  gre.timer_clear_interval(songTimer)
end

function swapMode(incMode)
  if(incMode == 'eco')then
  elseif(incMode == 'sport')then
  elseif(incMode == 'comfort')then
  end
end