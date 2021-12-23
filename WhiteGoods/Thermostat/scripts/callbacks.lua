THERMOSTAT_MODE = 'heatcool' --modes are heat, cool, heatcool

local scheduleMode -- to check if the thing is scheduling or not, will save them to a schedule
local scheduleText = 0

local activeSlider = nil
local grabbedHandle = nil

local boundOneControl = "sliderControl.boundsOne"
local boundTwoControl = "sliderControl.boundsTwo"

local lowerExtreme = 50
local upperExtreme = 643
local whiteBackgroundOffset = 4 --since the white background is a little off of the lower extreme, make sure to offset it for the calculation to keep the image in place

local blueColour = 0x028bf4
local orangeColour = 0xfe9100

local selectedSchedule, timeSelection, tempSelection

local function grabNearestHandle(incYPos)
  
  --get the current position of both handles
  local controlSize = gre.get_value("sliderControl.boundsOne.grd_height")
  local boundOne = gre.get_value("sliderControl.boundsOne.grd_y")
  local boundTwo = gre.get_value("sliderControl.boundsTwo.grd_y")
  
  --find which one is closer by minusing the yPos(plus 1/2 control size) to the press Position
  local distOne = math.abs(incYPos - (boundOne + (controlSize/2)))
  local distTwo = math.abs(incYPos - (boundTwo + (controlSize/2)))
  
  --correcty set up the zpos of them to make the grabbe one always on top
  local id
  if(distOne < distTwo)then
    id = 10
    grabbedHandle = boundOneControl
    gre.set_value(boundOneControl..".grd_zindex",5)
    gre.set_value(boundTwoControl..".grd_zindex",4)
  else
    id = 20
    grabbedHandle = boundTwoControl
    gre.set_value(boundOneControl..".grd_zindex",4)
    gre.set_value(boundTwoControl..".grd_zindex",5)
  end
  
  local animData = {}
  animData['id'] = id
  animData['context'] = grabbedHandle
  gre.animation_trigger('THERMO_tempPress', animData)
  
end

--TODO:Fix magic numbers
local function digitsTempSetup(incTemp, incOffset)
  --find percentage of the position
  local per = ((incTemp - lowerExtreme)/(upperExtreme - lowerExtreme - incOffset)) * 100
  
  if(per < 0)then 
    per = 0
  elseif(per> 100)then
    per = 100
  end
  
  local temp = math.floor((per/5)+0.5)
  temp = 35-temp
  return temp
end

local function setupSliderDisplay(upperSlider, lowerSlider, upperSliderPos, lowerSliderPos, controlSize)
  
  --this should change if heat, cool, heatcool
  
  local data = {}
  data[upperSlider..".color"] = blueColour
  data[lowerSlider..".color"] = orangeColour
  data[upperSlider..".image"] = 'images/circleLow.png'
  data[lowerSlider..".image"] = 'images/circleHigh.png'
  
  --setting up upperBackground Stuff
  --height is the position of the upper slider - the actual point of the position
  data["sliderControl.backgroundHigh.grd_height"] = upperSliderPos +  (-lowerExtreme) + controlSize/2
  --want the bottom to end up at 670
  data["sliderControl.backgroundLow.grd_y"] = lowerSliderPos + controlSize/2
  data["sliderControl.backgroundLow.grd_height"] = upperExtreme - lowerSliderPos - controlSize/2
  --setting up the middle part
  data['sliderControl.backgroundMid.grd_y'] = upperSliderPos + controlSize/2
  data['sliderControl.backgroundMid.grd_height'] = lowerSliderPos - upperSliderPos
  data['sliderControl.backgroundMid.yPos'] = -(upperSliderPos  + controlSize/2) + lowerExtreme + whiteBackgroundOffset
  gre.set_data(data)
  
  --check if we are in the schedule thingy and then save it to the correct position
  if(scheduleMode == 1 and scheduleText == 0)then
    local coolTo = digitsTempSetup(upperSliderPos, controlSize/2)
    local warmTo = digitsTempSetup(lowerSliderPos, controlSize/2)
    selectedSchedule.high = coolTo
    selectedSchedule.low = warmTo
  end
end

local function setHandlePosition(incYPos)

--if outside of the bounds move it to the bounds
  if(incYPos < lowerExtreme)then
    incYPos = lowerExtreme
  elseif(incYPos > upperExtreme)then
    incYPos = upperExtreme
  end
  
  local controlSize = gre.get_value("sliderControl.boundsOne.grd_height")
  local handlePos = incYPos - (controlSize/2)
  gre.set_value(grabbedHandle..".grd_y", handlePos)
  --TODO: fix magic numbers
  gre.set_value("sliderControl.backgroundAnim.grd_y", handlePos - 107)
  
  local boundOne = gre.get_value("sliderControl.boundsOne.grd_y")
  local boundTwo = gre.get_value("sliderControl.boundsTwo.grd_y")
  --setup the correct upper or lower bounds by checking if its higer or lower then the other one
  local upperSlider, lowerSlider, upperSliderPos, lowerSliderPos
  
  if(boundOne < boundTwo)then
    upperSlider = boundOneControl
    upperSliderPos = boundOne
    lowerSlider = boundTwoControl
    lowerSliderPos = boundTwo
    
    if(grabbedHandle == boundOneControl)then
      gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",0)
      gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",1)
    else
      gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",1)
      gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",0)
    end
    
  else
    upperSlider = boundTwoControl
    upperSliderPos = boundTwo
    lowerSlider = boundOneControl
    lowerSliderPos = boundOne
    
    if(grabbedHandle == boundOneControl)then
      gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",1)
      gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",0)
    else
      gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",0)
      gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",1)    
    end
    
  end
  
  if(scheduleText == 0)then
    gre.set_value(grabbedHandle..".text", digitsTempSetup(handlePos, controlSize/2))
  end
    
  setupSliderDisplay(upperSlider, lowerSlider, upperSliderPos, lowerSliderPos, controlSize)
end

--- @param gre#context mapargs
function CBSliderPress(mapargs) 
  activeSlider = mapargs.context_control
  local yPos = mapargs.context_event_data.y
  grabNearestHandle(yPos)
  setHandlePosition(yPos)
  
  gre.animation_trigger(coolAnimation)
  gre.animation_trigger(warmAnimation)
end

function CBSliderMotion(mapargs)
  
  if(activeSlider == nil)then
    return
  end
  
  if(mapargs.context_control == activeSlider)then
    local yPos = mapargs.context_event_data.y
    setHandlePosition(yPos)
  end

end

function CBSliderRelease(mapargs)
  
  if(activeSlider == nil)then
    return
  end

  gre.animation_stop(coolAnimation)
  gre.animation_stop(warmAnimation)
  gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",1)
  gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",1)
  
  local animData = {}
  animData['id'] = 1
  animData['context'] = grabbedHandle
  gre.animation_trigger('THERMO_tempRelease', animData)

  activeSlider = nil
  grabbedHandle = nil  
end

--fix magic numbers
local function setupModeDisplay()
  gre.set_value("sliderTempControlLayer.modeGroup.modeIcon.image","images/"..THERMOSTAT_MODE..".png")
  local handleYPos = gre.get_value(boundOneControl..".grd_y")
  local controlSize = gre.get_value(boundOneControl..".grd_height")
  grabbedHandle = boundOneControl 
  if(THERMOSTAT_MODE == 'heat')then
    gre.set_value(boundTwoControl..".grd_y",-800)
    gre.set_value(boundTwoControl..".grd_hidden",1)
    setHandlePosition(handleYPos + (controlSize/2))
  elseif(THERMOSTAT_MODE == 'cool')then
    gre.set_value(boundTwoControl..".grd_y",1600)
    gre.set_value(boundTwoControl..".grd_hidden",1)
    setHandlePosition(handleYPos + (controlSize/2))
  elseif(THERMOSTAT_MODE == 'heatcool')then
    gre.set_value(boundOneControl..".grd_y",200)
    gre.set_value(boundTwoControl..".grd_y",400)
    grabbedHandle = boundOneControl
    setHandlePosition(200)
    grabbedHandle = boundTwoControl
    setHandlePosition(400)    
    gre.set_value(boundTwoControl..".grd_hidden",0)

  end

  gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",1)
  gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",1)
  grabbedHandle = nil
end

function initDisplay()
  THERMOSTAT_MODE = 'heatcool'
  setupModeDisplay()
end

function CBModeToggle(mapargs)
  gre.animation_trigger('THERMO_modePress')
  if(THERMOSTAT_MODE == 'heat')then
    THERMOSTAT_MODE = 'cool'
  elseif(THERMOSTAT_MODE == 'cool')then
    THERMOSTAT_MODE = 'heatcool'
  elseif(THERMOSTAT_MODE == 'heatcool')then
    THERMOSTAT_MODE = 'heat'
  end
  setupModeDisplay()
end


local scheduleHome =    {['high'] = 30, ['low'] = 20}
local scheduleSleep =   {['high'] = 30, ['low'] = 20, ['start'] = '11:30 PM', ['stop'] = '05:30 AM'}
local scheduleAway =    {['high'] = 30, ['low'] = 20, ['start'] = '11:30 AM', ['stop'] = '05:30 PM'}

--TODO: Fix magic numbers for below 2 numbers
local function setupTempScheduleSliders(incSlider)
  
  --need to flip high and low
  
  local tempPerHigh = (20 - (incSlider.high - 15)) / 20 
  local tempPerLow = (20-(incSlider.low - 15)) / 20
  
  --upper and lower extremes
  local highOffset = (tempPerHigh * (upperExtreme - lowerExtreme)) + lowerExtreme
  local lowOffset = (tempPerLow * (upperExtreme - lowerExtreme)) + lowerExtreme
    
  scheduleText = 1
  
  grabbedHandle = boundOneControl
  setHandlePosition(highOffset)
  gre.set_value(grabbedHandle..".text", incSlider.high)
    
  grabbedHandle = boundTwoControl
  setHandlePosition(lowOffset)
  gre.set_value(grabbedHandle..".text", incSlider.low) 
    
  scheduleText = 0
  
  --hide the background anims
  gre.set_value("sliderControl.backgroundAnim.cold.grd_hidden",1)
  gre.set_value("sliderControl.backgroundAnim.hot.grd_hidden",1)
  
  gre.set_value("sliderControl.boundsOne.grd_hidden",0)
  gre.set_value("sliderControl.boundsTwo.grd_hidden",0)

end

local function setupTimeScheduleSliders(incTime)
  local hour = tonumber(string.sub(incTime,0, 2))
  local min = tonumber(string.sub(incTime,4, 5))
  local period = string.sub(incTime,7)

  if(period == 'PM')then
    hour = hour + 12
  end
  
  --change it to where there are 48 options
  local cellPosition = (hour*2) + 1
  
  if(min == 30)then
    cellPosition = cellPosition + 1
  end
  
  local offset = -(cellPosition*75 + (75*43))
  --set the yOffset
  gre.set_value("timeSelect.timeTable.grd_yoffset", offset)
  
end

local incSchedule
function CBStartSchedule(mapargs)
  incSchedule = mapargs.mode
  if(incSchedule == 'home')then
    selectedSchedule = scheduleHome
    gre.set_value("tempSelect.nextText.image","images/scheduleNext.png")
  elseif(incSchedule == 'away')then
    selectedSchedule = scheduleAway
    gre.set_value("tempSelect.nextText.image","images/startTimeNext.png")
  elseif(incSchedule == 'sleep')then
    selectedSchedule = scheduleSleep
    gre.set_value("tempSelect.nextText.image","images/startTimeNext.png")
  end
  timeSelection = 'start'
  scheduleMode = 1
  setupTempScheduleSliders(selectedSchedule)
end

local function animateTableSnap(incStart, incEnd, incControl)

  local key = (incControl)
  local anim_data = {}
  
  local myAnimation = gre.animation_create(60, 1)
  
  anim_data["key"] = key
  anim_data["rate"] = "linear"
  anim_data["duration"] = 250
  anim_data["offset"] = 0
  anim_data["from"] = incStart
  anim_data["to"] = incEnd
  gre.animation_add_step(myAnimation, anim_data)
  
  gre.animation_trigger(myAnimation)
end

local function insertTime(incRow)

  local selectedTime = gre.get_value("timeSelect.timeTable.text."..incRow..".1")
  if(timeSelection == 'start')then
    selectedSchedule.start = selectedTime
  else
    selectedSchedule.stop = selectedTime
  end

end

function CBTimeTable(mapargs) 
  local upperBounds = -(48*75)
  local lowerBounds = -(48*75*2)
  local yOffset = gre.get_value("timeSelect.timeTable.grd_yoffset")
  
  if(yOffset < lowerBounds)then
    gre.set_value("timeSelect.timeTable.grd_yoffset", upperBounds)
  elseif(yOffset > upperBounds)then
    gre.set_value("timeSelect.timeTable.grd_yoffset", lowerBounds)
  end
end

function CBSnapTimeTable(mapargs)
  gre.timer_set_timeout(function()
    local yOffset = gre.get_value("timeSelect.timeTable.grd_yoffset")
    local nearestCell = (math.floor((yOffset / 75) + 0.5) * 75)
    local row = math.abs(math.floor((yOffset / 75) + 0.5)) + 3
    insertTime(row)
    animateTableSnap(yOffset, nearestCell, "timeSelect.timeTable.grd_yoffset")
  end, 500)
end

local function tempNext(mapargs)
  print(incSchedule)
  if(incSchedule == 'home')then
    scheduleHome = selectedSchedule
    gre.send_event('toScheduleScreen')
  else    
    local lowerBounds = setupTimeScheduleSliders(selectedSchedule.start)
    gre.set_value("timeSelect.timeTable.grd_yoffset", lowerBounds)
    gre.set_value("timeSelect.instruction.text", 'set '..incSchedule..' start time')
    gre.set_value("tempSelect.nextText.image","images/endTimeNext.png")
    gre.send_event('toTimeScreen')
  end
end

local function timeNext(mapargs) 
  if(timeSelection == 'start')then
    timeSelection = 'stop'
    local lowerBounds = setupTimeScheduleSliders(selectedSchedule.stop)
    gre.set_value("timeSelect.timeTable.grd_yoffset", lowerBounds)
    gre.set_value("timeSelect.instruction.text", 'set '..incSchedule..' end time')
    gre.set_value("tempSelect.nextText.image","images/scheduleNext.png")
  else
    if(incSchedule == 'away')then
       scheduleAway = selectedSchedule
    elseif(incSchedule == 'sleep')then
       scheduleSleep = selectedSchedule
    end
    gre.send_event('toScheduleScreen')
  end
end

function CBScheduleNext(mapargs)
  gre.animation_trigger('SCHEDULE_next')
  if(mapargs.context_screen == 'scheduleTempScreen')then
    tempNext(mapargs)
  else
    timeNext(mapargs)
  end

end



function CBSetupScheduleScreen(mapargs)
  local data = {}
  data["scheduleSelectLayer.sleepGroup.time.text"] = string.lower(scheduleSleep.start..' - '..scheduleSleep.stop)
  data["scheduleSelectLayer.sleepGroup.heatTemp.text"]= scheduleSleep.low
  data["scheduleSelectLayer.sleepGroup.coolTemp.text"]= scheduleSleep.high
  data["scheduleSelectLayer.awayGroup.time.text"]= string.lower(scheduleAway.start..' - '..scheduleAway.stop)
  data["scheduleSelectLayer.awayGroup.heatTemp.text"]= scheduleAway.low
  data["scheduleSelectLayer.awayGroup.coolTemp.text"]= scheduleAway.high
  data["scheduleSelectLayer.homeGroup.heatTemp.text"]= scheduleHome.low
  data["scheduleSelectLayer.homeGroup.coolTemp.text"]= scheduleHome.high
  gre.set_data(data)
end

local newScreen
local prevScreen = 'thermo'

--- @param gre#context mapargs
function CBMenuAnimationSetup(mapargs) 
  
  if(mapargs.screen == prevScreen)then
    return
  end
  
  newScreen = mapargs.screen
  if(prevScreen == 'schedule')then
    gre.animation_trigger(scheduleDeselect)
  elseif(prevScreen == 'thermo')then
    gre.animation_trigger(thermostatDeselect)
  elseif(prevScreen == 'weather')then
    gre.animation_trigger(weatherDeselect)
  end
  
  if(newScreen == 'schedule')then
    gre.animation_trigger(scheduleSelect)
  elseif(newScreen == 'thermo')then
    gre.animation_trigger(thermostatSelect)
  elseif(newScreen == 'weather')then
    gre.animation_trigger(weatherSelect)
  end
  
  prevScreen = newScreen
end
