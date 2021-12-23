local stopwatchToggle = 0
local stopwatchTimer

local startTime = 0
local accumulatedTime = 0
local minutes = 0
local seconds = 0
local milliseconds = 0

local mins_key = "stopwatch_layer.stopw_value.minutes"
local secs_key = "stopwatch_layer.stopw_value.seconds"
local millisecs_key = "stopwatch_layer.stopw_value.milliseconds"
local endangle_key = "stopw_frame_layer.fill_10px.endAngle"

function CBStopwatchToggle(mapargs) 
  local data = {}

  if (stopwatchToggle == 0) then
    data["stopwatch_layer.btn_start.image"] = ("images/btn_stop.png")
    data["stopw_frame_layer.fill_10px.fill_col"] = 0xf06b6c
    
    stopwatchToggle = 1
    startTime = gre.mstime() - accumulatedTime
    stopwatchTimer = gre.timer_set_interval(CBStopwatchUpdate,16)
  else
    if(stopwatchTimer ~= nil) then
      stopwatchTimer = gre.timer_clear_interval(stopwatchTimer)
    end
    data["stopwatch_layer.btn_start.image"] = ("images/btn_start.png")
    data["stopw_frame_layer.fill_10px.fill_col"] = 0x509892
    stopwatchToggle = 0
  end
  gre.set_data(data)
end

function CBStopwatchReset(mapargs)
  if(stopwatchTimer ~= nil) then
    stopwatchTimer = gre.timer_clear_timeout(stopwatchTimer)
  end

  stopwatchToggle = 0
  startTime = 0
  accumulatedTime = 0
  minutes = 0
  seconds = 0
  milliseconds = 0 
  stopwatchToggle = 0

  
  local data = {}
  data[mins_key] = "00"
  data[secs_key] = "00"
  data[millisecs_key] = "00"
  data[endangle_key] = -90
  data["stopwatch_layer.btn_start.image"] = ("images/btn_start.png")
  data["stopw_frame_layer.stopw_fill_control.fill_col"] = 0x509892

  gre.set_data(data)
end

function CBStopwatchUpdate()
  accumulatedTime = (gre.mstime() - startTime) % 6000000 --roll over at 100 hours.
    
  local time = accumulatedTime
  local minutes = math.floor(time / 60000)
  time = time - minutes * 60000
  minutes = MakeDoubleDigit(minutes)

  local angle = 0
  if(time ~= 0) then 
    angle = (time/ 60000) * 360 - 90
  end
    
  local seconds = math.floor(time / 1000)
  time = time - seconds * 1000 

  seconds = MakeDoubleDigit(seconds)

  local milliseconds = math.floor(time / 10)
  milliseconds = MakeDoubleDigit(milliseconds)
  
  local data = {}
  data[mins_key] = minutes
  data[secs_key] = seconds
  data[millisecs_key] = milliseconds
  data[endangle_key] = angle
  gre.set_data(data)
end