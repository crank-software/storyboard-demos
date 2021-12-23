local stopped = false
local runToggle = 0
local doubletapTimer = nil
local runTimer
local startTime = nil
local minutes = 0
local seconds = 0
local milliseconds = 0
local accumulatedTime = 0

local hrs_key = "fit_run_layer.running_time.hours"
local mins_key = "fit_run_layer.running_time.minutes"
local secs_key = "fit_run_layer.running_time.seconds"
local endangle_key = "fit_run_layer.run_fill.end_angle"

--Update the run tracker
function CBRunUpdate()
  if(startTime == nil) then
    CBRunStop()
    return
  end
  local accumulatedTime = (gre.mstime() - startTime) % 6000000 --roll over at 100 hours.
    
  local time = accumulatedTime
  local hours = math.floor(time / 3600000)
  time = time - hours * 3600000
  hours = MakeDoubleDigit(hours)

  local minutes = math.floor(time / 60000)
  local angle = ((time/3600000) * 360 ) - 90
  time = time - minutes * 60000
  minutes = MakeDoubleDigit(minutes)

  local seconds = math.floor(time / 1000)
  time = time - seconds * 1000 
  seconds = MakeDoubleDigit(seconds)
  
  local data = {}
  data[hrs_key] = hours
  data[mins_key] = minutes
  data[secs_key] = seconds
  data[endangle_key] = angle

  gre.set_data(data)
end

--Start the run tracker
function CBRunStart(mapargs)
  local data = {}
  
  startTime = gre.mstime() - accumulatedTime
  runTimer = gre.timer_set_interval(CBRunUpdate,50)
  
  
  data["fit_run_layer.btn_stop.grd_hidden"] = 0
  data["fit_run_layer.btn_start.grd_hidden"] = 1
  gre.set_data(data)
end

--Stop the run tracker
function CBRunStop(mapargs)
  if(startTime ~= nil) then
  	accumulatedTime = (gre.mstime() - startTime) % 6000000 --roll over at 100 hours.
  end
  	
	local data = {}
	
	gre.timer_clear_interval(runTimer)
	runTimer = nil
	
	data["fit_run_layer.btn_stop.grd_hidden"] = 1
  data["fit_run_layer.btn_start.grd_hidden"] = 0
	
	gre.set_data(data)
end

--Reset the run tracker
function CBRunReset()
  CBRunStop()
  runToggle = 0
  startTime = nil
  minutes = 0
  seconds = 0
  milliseconds = 0 
  runToggle = 0
  accumulatedTime = 0
  
  local data = {}
  data[hrs_key] = "00"
  data[mins_key] = "00"
  data[secs_key] = "00"
  data[endangle_key] = -90

  data["fit_run_layer.btn_stop.grd_hidden"] = 1
  data["fit_run_layer.btn_start.grd_hidden"] = 0

  gre.set_data(data)
end