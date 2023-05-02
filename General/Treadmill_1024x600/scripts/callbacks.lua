local speed = 900
local incline = 0

local speedInitialTimer
local inclineInitialTimer

local speedRapidTimer
local inclineRapidTimer

local speedHeldDir, inclineHeldDir

function cb_Speed(mapargs)
  local incDir = tonumber(mapargs.direction)
  speedHeldDir = incDir
  localSpeed()
  
  if(speedInitialTimer ~= nil)then
    gre.timer_clear_timeout(speedInitialTimer)
    speedInitialTimer = nil
  end
  
  speedInitialTimer = gre.timer_set_timeout(rapidSpeed,500)
end

function cb_Incline(mapargs)
  local incDir = tonumber(mapargs.direction)
  inclineHeldDir = incDir
  localIncline()
  
  if(inclineInitialTimer ~= nil)then
    gre.timer_clear_timeout(inclineInitialTimer)
    inclineInitialTimer = nil
  end
  
  inclineInitialTimer = gre.timer_set_timeout(rapidIncline,500)
end

function rapidIncline()
  inclineRapidTimer = gre.timer_set_interval(localIncline,150)
  speedRapidTimer = nil
end

function rapidSpeed()
  speedRapidTimer = gre.timer_set_interval(localSpeed,50)
  speedInitialTimer = nil
end

--on release clear timers and stop
function cb_SpeedRelease()
  if(speedInitialTimer ~= nil)then
    gre.timer_clear_timeout(speedInitialTimer)
    speedInitialTimer = nil
  end
  if(speedRapidTimer ~= nil)then
    gre.timer_clear_interval(speedRapidTimer)
    speedRapidTimer = nil
  end
  
end

function cb_InclineRelease()
  if(inclineInitialTimer ~= nil)then
    gre.timer_clear_timeout(inclineInitialTimer)
    inclineInitialTimer = nil
  end
  if(inclineRapidTimer ~= nil)then
    gre.timer_clear_interval(inclineRapidTimer)
    inclineRapidTimer = nil
  end
end

function localSpeed()
  
  local dir = speedHeldDir
  
  if(dir == 1)then
    speed = speed + 10
  else
    speed = speed - 10
  end

  if(speed < 0)then
    speed = 0
  elseif(speed > 1500)then
    speed = 1500
  end
    
  local data = {}
  local printSpeed = speed/100
  if(string.len(printSpeed)<3)then
    printSpeed = printSpeed..".0"
  end
  data["bottomControls.speedIncline.speedData.text"] = printSpeed
  gre.set_data(data)
end


function localIncline()
  
  local dir = inclineHeldDir
  
  if(dir == 1)then
    incline = incline + 50
  else
    incline = incline - 50
  end
  
  if(incline < 0)then
    incline = 0
  elseif(incline > 1500)then
    incline = 1500
  end
  
  local data = {}
  local printIncline = incline/100
  if(string.len(printIncline)<3)then
    printIncline = printIncline..".0"
  end
  data["bottomControls.speedIncline.inclineData.text"] = printIncline
  gre.set_data(data)
end

function cb_startHomeVideo(mapargs)  
--        print("Start home screen video")
--        os.execute(gre.SCRIPT_ROOT.."/run-home-video.sh &")
end                                            
          
function cb_startTrailVideo(mapargs)                                 
--        print("Start trail screen video")
--        os.execute(gre.SCRIPT_ROOT.."/run-trail-video.sh &")
end

function cb_stopVideo(mapargs)
--    os.execute("killall gst-launch-1.0")
--    os.execute("dd if=/dev/zero of=/dev/fb0")
end

local heldAnimID, heldAnimControl
local pressedControl

function cb_runningControlsAnim(mapargs)

  local linkedControl = gre.get_value(mapargs.context_control..".control")
  local animID = gre.get_value(mapargs.context_control..".id")
  
  heldAnimID = animID
  heldAnimControl = linkedControl
  
  local animData = {}
  animData["context"] = linkedControl
  animData["id"] = animID
  
  if(tonumber(mapargs.toggle) == 1)then
    gre.animation_trigger("RUNNING_controlsPressed", animData)
    pressedControl = 1
  elseif(tonumber(mapargs.toggle) == 0)then
    if(pressedControl ~= 0)then
      gre.animation_trigger("RUNNING_controlsReleased", animData)
    end
    pressedControl = 0
  end
end


local prevRow = 0
--- @param gre#context mapargs
function cb_selectLocation(mapargs) 
  if(prevRow == mapargs.context_row)then
    return
  end
  
  local row = mapargs.context_row
  local data = {}
  
  data["selectLocation.location.image."..row..".1"] = "images/location"..row.."_on.png"
  data["selectLocation.location.image."..prevRow..".1"] = "images/location"..prevRow.."_off.png"
  gre.set_data(data)
  prevRow = row
end

local prevCustGroup = "customizeLayer.selectLocation"
--- @param gre#context mapargs
function cb_selectCustomize(mapargs) 
  
  local incCustGroup = mapargs.context_group
  
  if(incCustGroup == prevCustGroup)then
    return
  end
  
  local animData = {}
  animData["context"] = incCustGroup
  gre.animation_trigger("CUSTOMIZE_pressMainButton", animData)
  animData["context"] = prevCustGroup
  gre.animation_trigger("CUSTOMIZE_unpressMainButton", animData)  
  prevCustGroup = incCustGroup

end

local currentSlider = nil
local currentID = nil

function cb_pressSlider(mapargs)
  currentSlider = mapargs.context_group
  currentID = gre.get_value(mapargs.context_group..".id")
  
  local animData = {}
  animData["context"] = currentSlider
  animData["id"] = currentID
  gre.animation_trigger("CUSTOMIZE_PressSlider", animData)  
  
  
end

function cb_sliderMotion(mapargs)
  if(currentSlider == nil)then
    return
  end
  
  local locX = mapargs.context_event_data.x
  local control = gre.get_control_attrs(currentSlider..".scrollBarTouchzone", "x")
  local controlX = control["x"] + 500
  local offset = locX - controlX
  
  sliderCalc(offset)
end

function cb_releaseSlider()

  if(currentSlider ~= nil)then
  local animData = {}
  animData["context"] = currentSlider
  animData["id"] = currentID
  gre.animation_trigger("CUSTOMIZE_unpressSlider", animData)  
  end
  
  currentSlider = nil
end

function sliderCalc(incOffset)
  --offset is between (0-50) and (390-440)
  --center the block on the finger
  
  local controlPosition = incOffset -15
  if(controlPosition < 30)then
    controlPosition = 30
  elseif(controlPosition > 430)then
    controlPosition = 430
  end
  
  local percent = (controlPosition - 30)/400
  --print(percent)
  
  local sliderData
  if(currentSlider == "runSettings.setting1")then
    local weight = (math.floor(percent*200)) + 50
    sliderData = weight.." lbs"
  elseif(currentSlider == "runSettings.setting2")then
    local age = (math.floor(percent*75)) + 5
    sliderData = age.." years"
  elseif(currentSlider == "runSettings.setting3")then
    local intensity = math.floor(percent * 10)
    sliderData = intensity
  end
  
  
  local ctrlData = {}
  local data = {}
  
  ctrlData["x"] = controlPosition
  data[currentSlider..".scrollbar.width"] = controlPosition
  data[currentSlider..".data.text"] =sliderData

  gre.set_control_attrs(currentSlider..".scrollbarControl",ctrlData)
  gre.set_data(data)
end


local prevERow = 0
--- @param gre#context mapargs
function cb_selectElevation(mapargs) 
  if(prevERow == mapargs.context_row)then
    return
  end
  
  local row = mapargs.context_row
  local data = {}
  
  data["selectElevation.elevation.image."..row..".1"] = "images/elevation"..row.."_on.png"
  data["selectElevation.elevation.image."..prevERow..".1"] = "images/elevation"..prevERow.."_off.png"
  gre.set_data(data)
  prevERow = row
end


local runningTimer = {}
local runningNumber = 0
--- @param gre#context mapargsss
function cb_runningScreenNumbers(mapargs) 
  runningNumber = 0
  runningTimer = gre.timer_set_interval(runningNumbers,1000)
  local data = {}
  data["upperControls.time.text"] = "00:00:00"
  gre.set_data(data)
end

function runningNumbers()
  runningNumber = runningNumber + 1
  
  
  local data = {}
  
  local min = math.floor(runningNumber / 60)
  local sec = runningNumber - (min * 60)
  if(string.len(min) == 1)then
    min = "0"..min
  end
  if(string.len(sec) == 1)then
    sec = "0"..sec
  end
  
  local distance = (runningNumber*20 / 300)*10
  distance = math.floor(distance)/10
  
  if(string.len(distance) < 4)then
    local stringlength = string.len(distance)
    if(stringlength == 3)then
      distance = "0"..distance
    elseif(stringlength == 1)then
      distance = "0"..distance..".0"
    end
  end
   
  data["upperControls.time.text"] = "00:"..min..":"..sec
  data["upperControls.distance.text"] = distance.." km"
  gre.set_data(data)
end

function cb_runningEnd()
  gre.timer_clear_interval(runningTimer)
end

function cb_resetCustomization()
 prevEle = nil
 prevEleID = nil
 prevPath = nil
 previd = nil
 prevCustGroup = "customizeLayer.selectLocation"
end