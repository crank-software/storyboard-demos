local timer_edit_position = "M"
local timer_edit_postions = {H=0, M10=68, M=94}

local set_mins_key = "tm_set_layer.set_count_control.mins"
local set_hrs_key = "tm_set_layer.set_count_control.hrs"
local hrs_key = "tm_count_layer.countdown_control.hours"
local mins_key = "tm_count_layer.countdown_control.minutes"
local secs_key = "tm_count_layer.countdown_control.seconds"

local initialTimeoutTime = 0
local timeoutTime = 0
local startTime = 0

---[[
-- "STOPPED"
-- "RUNNING"
-- "PAUSED"
-- "IDLE"
--]]
local timerState = "STOPPED"
local timerTimer

local function StartTimer(restart)
  timerState = "RUNNING"
  local data = {}
  if(restart == nil or restart == false) then
    local hrs, mins = gre.get_value(set_hrs_key, set_mins_key)
    
    hrs = tonumber(hrs)
    mins = tonumber(mins)

    initialTimeoutTime = hrs*3600000 + mins*60000
    timeoutTime = initialTimeoutTime
    
    data[hrs_key] = MakeDoubleDigit(hrs)
    data[mins_key] = MakeDoubleDigit(mins)
  end
  if(timeoutTime == 0) then
    timerState = "STOPPED"
    return
  end

  startTime = gre.mstime()
  
  CBTimerUpdate()
  
  data["tm_base_layer.start_btn.alarm"] = ("images/stop_btn.png")
  data["timer_sc.tm_set_layer.grd_hidden"] = 1
  data["timer_sc.tm_count_layer.grd_hidden"] = 0
  gre.set_data(data)

  timerTimer = gre.timer_set_interval(CBTimerUpdate,150)
end

local function PauseTimer()
  gre.timer_clear_interval(timerTimer)

  timerState = "PAUSED"
  
  local accumulatedTime = (gre.mstime() - startTime) % 6000000 --roll over at 100 hours.
  timeoutTime = timeoutTime - accumulatedTime

  local data = {}
  data["tm_base_layer.start_btn.alarm"] = ("images/start_btn.png")
  gre.set_data(data)
  
end

local function TimerTimeout()

  gre.timer_clear_interval(timerTimer)
  
  timerState = "STOPPED"
  
  local data = {}
  data["tm_base_layer.start_btn.alarm"] = ("images/start_btn.png")
  data["timer_sc.tm_set_layer.grd_hidden"] = 0
  data["timer_sc.tm_count_layer.grd_hidden"] = 1
  gre.animation_trigger("show_tm_alert")
  gre.set_data(data)
end

function CBTimerToggle(mapargs) 
  if(timerState == "STOPPED") then -->RUN
    StartTimer(false)
  elseif(timerState == "RUNNING") then -->PAUSE
    PauseTimer()
  elseif(timerState == "PAUSED") then -->RUN
    StartTimer(true)
  end
end

function CBTimerReset()
  timerState = "STOPPED"
  initialTimeoutTime = 0
  timeoutTime = 0
  startTime = 0
  
  local data = {}
  data["timer_sc.tm_set_layer.grd_hidden"] = 0
  data["timer_sc.tm_count_layer.grd_hidden"] = 1
  data["tm_base_layer.start_btn.alarm"] = ("images/start_btn.png")
  gre.set_data(data)
end

function CBTimerUpdate()
  local accumulatedTime = (gre.mstime() - startTime) % 6000000 --roll over at 100 hours.
  
  local time = timeoutTime - accumulatedTime
  if(time <= 0) then
    TimerTimeout()
    return
  end
  
  --We add a second for rounding purposes but we never want the time
  --To show as larger than the initialTimeoutTime.
  if(time + 1000 < initialTimeoutTime + 999) then
    time = time + 1000
  end
  
  local hours = math.floor(time / 3600000)
  time = time - hours * 3600000 
  hours = MakeDoubleDigit(hours)
  
  local minutes = math.floor(time / 60000)
  time = time - minutes * 60000
  minutes = MakeDoubleDigit(minutes)

  local seconds = math.floor(time / 1000)
  time = time - seconds * 1000

  seconds = MakeDoubleDigit(seconds)

  local data = {}
  data[hrs_key] = hours
  data[mins_key] = minutes
  data[secs_key] = seconds
  gre.set_data(data)
end

function CBTimerScreenshow()
  timer_edit_position = "M"
end

function CBTimerEditPlus()
  if(timer_edit_position == "M") then
    local mins_value = gre.get_value(set_mins_key)
    mins_value = mins_value + 1
    
    local data = {}
    if(mins_value >= 60) then
      mins_value = mins_value - 60
      
      local hrs_value = gre.get_value(set_hrs_key)
      hrs_value = hrs_value + 1
      data[set_hrs_key] = hrs_value
    end
    mins_value = MakeDoubleDigit(mins_value)
    data[set_mins_key] = mins_value
    gre.set_data(data)
  elseif(timer_edit_position == "M10") then
    local mins_value = gre.get_value(set_mins_key)
    mins_value = mins_value + 10
    
    local data = {}
    if(mins_value >= 60) then
      mins_value = mins_value - 60
      
      local hrs_value = gre.get_value(set_hrs_key)
      hrs_value = hrs_value + 1
      data[set_hrs_key] = hrs_value
      
    end
    mins_value = MakeDoubleDigit(mins_value)
    data[set_mins_key] = mins_value
    gre.set_data(data)
  elseif(timer_edit_position == "H") then
    local hrs_value = gre.get_value(set_hrs_key)
    hrs_value = hrs_value + 1
    if(hrs_value >= 10) then
      hrs_value = 0
    end
        
    gre.set_value(set_hrs_key, hrs_value)
  end
end

function CBTimerEditMinus()
  if(timer_edit_position == "M") then
    local mins_value = gre.get_value(set_mins_key)
    mins_value = mins_value - 1
    
    local data = {}
    if(mins_value < 0) then
      mins_value = mins_value + 60
      
      local hrs_value = gre.get_value(set_hrs_key)
      hrs_value = hrs_value - 1
      data[set_hrs_key] = hrs_value
    end
    mins_value = MakeDoubleDigit(mins_value)
    data[set_mins_key] = mins_value
    gre.set_data(data)
  elseif(timer_edit_position == "M10") then
    local mins_value = gre.get_value(set_mins_key)
    mins_value = mins_value - 10
    
    local data = {}
    if(mins_value < 0) then
      mins_value = mins_value + 60
      
      local hrs_value = gre.get_value(set_hrs_key)
      hrs_value = hrs_value - 1
      data[set_hrs_key] = hrs_value
      
    end
    mins_value = MakeDoubleDigit(mins_value)
    data[set_mins_key] = mins_value
    gre.set_data(data)
  elseif(timer_edit_position == "H") then
    local hrs_value = gre.get_value(set_hrs_key)
    hrs_value = hrs_value - 1
    if(hrs_value < 0) then
      hrs_value = 9
    end
        
    gre.set_value(set_hrs_key, hrs_value)
  end
end

function CBTimerEditSelectLeft()
  if(timer_edit_position == "M") then
    timer_edit_position = "M10"
  elseif(timer_edit_position == "M10") then
    timer_edit_position = "H"
  else
    timer_edit_position = "M"
  end
  
  gre.set_value("tm_set_layer.set_select_control.dest_x", timer_edit_postions[timer_edit_position])
  
  gre.animation_trigger("timer_set_select")
end

function CBTimerEditSelectRight()
  if(timer_edit_position == "H") then
    timer_edit_position = "M10"
  elseif(timer_edit_position == "M10") then
    timer_edit_position = "M"
  else
    timer_edit_position = "H"
  end
  
  gre.set_value("tm_set_layer.set_select_control.dest_x", timer_edit_postions[timer_edit_position])
  
  gre.animation_trigger("timer_set_select")
end


