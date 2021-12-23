-- TODO clean-up unused variables
local startx = 0
local starty = 65
local amplitude = 10
local freq = 10
local incx = 0
local incy = 0
local max_idx = 280
local cur_w_idx = 1

local cur_rad = 1
local x = {}
local y = {}

local TRACE_RATE_ZOOM = 1
local TRACE_RATE_MS = 25
local NUMERIC_RATE_MS = 1000

local ecgTrace = {}
local ecgTracePoints = {}
local plethTrace = {}
local plethTracePoints = {}
local tempTrace = {}
local tempTracePoints = {}

local g_scale_rpm = 1.0   --no scaling
local g_scale_bpm = 1.0   --no scaling
local g_scale_temp = 1.0   --no scaling

-- Here's a generator widely used for Monte-Carlo calculations:
-- Culled from stack overflow it returns a number between 0 and 1 that you can scale
-- appropriately
local A1, A2 = 727595, 798405  -- 5^17=D20*A1+A2
local D20, D40 = 1048576, 1099511627776  -- 2^20, 2^40
local X1, X2 = 0, 1
function mc_rand()
    local U = X2*A2
    local V = (X1*A2 + X2*A1) % D20
    V = (V*D20 + U) % D40
    X1 = math.floor(V/D20)
    X2 = V - X1*D20
    return V/D40
end
--[[
function CBInitTraces()

Called on screen show pre to load-up all the fake data ready for display. The source data is  cached
--]]

function CBInitTraces(mapargs)
  local data = {}
  local ecgData = {79 ,79 ,79 ,78 ,78 ,77 ,77 ,77 ,77 ,77 ,76 ,76 ,76 ,76 ,76 ,75 ,75 ,75 ,75 ,74 ,73 ,71 ,68 ,66 ,63 ,60 ,59 ,59 ,60 ,62 ,65 ,68 ,71 ,73 ,75 ,75 ,76 ,78 ,82 ,78 ,56 ,27 ,13 ,17 ,38 ,70 ,88 ,83 ,78 ,76 ,76 ,75 ,75 ,74 ,72 ,71 ,69 ,66 ,64 ,61 ,58 ,55 ,53 ,52 ,51 ,52 ,53 ,55 ,57 ,60 ,63 ,66 ,69 ,72 ,75 ,76 ,77 ,78 ,78 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,78 ,78 ,76 ,74 ,72 ,69 ,67 ,64 ,63 ,63 ,65 ,67 ,70 ,73 ,76 ,78 ,79 ,80 ,81 ,83 ,87 ,80 ,56 ,29 ,17 ,25 ,50 ,80 ,92 ,86 ,82 ,81 ,80 ,80 ,80 ,79 ,77 ,75 ,73 ,71 ,68 ,65 ,62 ,59 ,58 ,57 ,57 ,57 ,59 ,61 ,63 ,66 ,69 ,72 ,75 ,78 ,80 ,81 ,82 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,82 ,82 ,82 ,82 ,82 ,81 ,80 ,78 ,76 ,74 ,71 ,68 ,67 ,66 ,67 ,69 ,71 ,74 ,77 ,80 ,81 ,81 ,82 ,84 ,88 ,85 ,64 ,35 ,21 ,25 ,45 ,76 ,95 ,90 ,85 ,83 ,82 ,82 ,81 ,80 ,78 ,77 ,75 ,72 ,69 ,66 ,63 ,60 ,58 ,57 ,56 ,56 ,57 ,59 ,61 ,64 ,67 ,70 ,73 ,76 ,78 ,79 ,80 ,81 ,81 ,82 ,82 ,81 ,81 ,81 ,81 ,81 ,81 ,81 ,80 ,80 ,80 ,80 ,80 ,80 ,79 ,79 ,79 ,79 ,78 ,78 ,76 ,74 ,72 ,69 ,66 ,63 ,62 ,62 ,63 ,65 ,67 ,70 ,73 ,75 ,77 ,77 ,78 ,80 ,83 ,80 ,60 ,31 ,16 ,19 ,17 ,28 ,56 ,84 ,93 ,87 ,83 ,82 ,81 ,81 ,80 ,79 ,77 ,75 ,73 ,70 ,68 ,65 ,62 ,59 ,57 ,56 ,55 ,56 ,57 ,59 ,62 ,64 ,67 ,70 ,73 ,76 ,77 ,78 ,78 ,79 ,79}
  local plethData = {88 ,88 ,89 ,90 ,90 ,91 ,92 ,92 ,93 ,93 ,94 ,94 ,95 ,96 ,97 ,98 ,99 ,99 ,100 ,100 ,101 ,101 ,101 ,101 ,101 ,100 ,100 ,99 ,98 ,96 ,94 ,92 ,90 ,86 ,82 ,78 ,72 ,66 ,61 ,55 ,50 ,45 ,40 ,36 ,32 ,31 ,30 ,31 ,33 ,36 ,40 ,44 ,48 ,52 ,57 ,62 ,67 ,71 ,74 ,77 ,80 ,81 ,82 ,82 ,82 ,81 ,80 ,79 ,78 ,77 ,76 ,75 ,75 ,75 ,76 ,76 ,77 ,78 ,80 ,81 ,83 ,84 ,86 ,87 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,96 ,97 ,97 ,98 ,98 ,98 ,98 ,98 ,97 ,97 ,96 ,95 ,94 ,93 ,91 ,89 ,86 ,82 ,78 ,74 ,69 ,63 ,57 ,51 ,46 ,41 ,36 ,33 ,30 ,28 ,28 ,29 ,31 ,34 ,38 ,42 ,46 ,51 ,56 ,60 ,65 ,69 ,73 ,76 ,78 ,79 ,80 ,80 ,80 ,79 ,78 ,77 ,76 ,75 ,74 ,74 ,73 ,73 ,74 ,74 ,75 ,77 ,78 ,80 ,81 ,83 ,84 ,86 ,87 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,95 ,96 ,96 ,96 ,95 ,95 ,95 ,95 ,94 ,94 ,93 ,92 ,91 ,89 ,87 ,84 ,80 ,76 ,72 ,66 ,60 ,54 ,49 ,43 ,38 ,33 ,30 ,27 ,25 ,25 ,26 ,28 ,30 ,34 ,38 ,42 ,47 ,51 ,56 ,61 ,66 ,69 ,72 ,74 ,75 ,76 ,77 ,76 ,76 ,75 ,74 ,73 ,72 ,71 ,70 ,70 ,70 ,71 ,71 ,72 ,73 ,74 ,75 ,77 ,78 ,80 ,81 ,83 ,84 ,85 ,86 ,88 ,89 ,89 ,90 ,91 ,91 ,92 ,92 ,92 ,92 ,92 ,92 ,92 ,91 ,90 ,89 ,87 ,85 ,83 ,80 ,76 ,72 ,67 ,61 ,55 ,49 ,43 ,37 ,32 ,28 ,24 ,21 ,19 ,19 ,20 ,22 ,25 ,29 ,33 ,37 ,42 ,47 ,52 ,57 ,62 ,66 ,69 ,71 ,73 ,74 ,74 ,74 ,73 ,72 ,71 ,70 ,69 ,69 ,68 ,68 ,69 ,70 ,71 ,72 ,73 ,75 ,76 ,78 ,80 ,81 ,82 ,83 ,84 ,85 ,85 ,86 ,86 ,87 ,87 ,87 ,87 ,87}
  local tempData = {36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,37.0 ,37.0 ,37.1 ,37.1 ,37.0 ,37.0 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,37.0 ,37.0 ,37.1 ,37.1 ,37.0 ,37.0 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.7 ,36.7 ,36.7 ,36.7 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,37.1 ,37.1 ,37.1 ,37.1 ,37.1 ,37.1 ,37.1 ,37.1 ,37.0 ,37.0 ,37.0 ,37.0 ,37.0 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.6 ,36.6 ,36.6 ,36.6 ,36.6 ,36.5 ,36.5 ,36.5 ,36.6 ,36.6 ,36.6 ,36.6 ,36.6 ,36.6 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.7 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.9 ,36.8 ,36.8 ,36.8 ,36.8 ,36.8}
  local n = 0
  local i = 0
  local nn = 0
  local v
  local temp = 0
  local ecgDataPoint = 0

  ecgTracePoints = {}
  plethTracePoints = {}
  tempTracePoints = {}
  
  -- scale data 
  n = table.getn(ecgData)
  
  for i = 1, n, 1 do
    --temp = 36.8 + (mc_rand() - 0.5) * 0.2
    ecgData[i] = (ecgData[i] * g_scale_bpm) 
    plethData[i] = (plethData[i] * g_scale_rpm)
    tempData[i] = (tempData[i] * g_scale_temp)
  end
  
  for i = 1, n/2, 1 do
    ecgTrace[i] = ecgData[i]--*2] 
    plethTrace[i] = plethData[i]--*2]
    tempTrace[i] = ((tempData[i] - 36.0) * 45) 
  end
  
  -- shameless code optimisation by assuming the trace canvasses are all the same size
  local canvas = gre.get_canvas("heartRateTrend")
  local size = canvas:get_dimensions()
  
  -- Shrink the bounds to make the lines visible
  size.height = size.height - 2
  size.width = size.width - 2
  max_idx = size.width
    
  -- pre-fill the trace polygon points table with a full data trace, based on the size of the canvas
  -- we are using a standard polygon here due to aliasing and multisampling support
  local datapoint = {}
  local point
  for i = 1, max_idx-1, TRACE_RATE_ZOOM do
    -- Get the next datapoint to plot and insert into table at the next trace point
    datapoint = get_datapoint()
    cur_rad = cur_rad + 1
    
    point = string.format("%.0f:%.0f", i, datapoint[1].ecg)
    table.insert(ecgTracePoints, point)
    
    point = string.format("%.0f:%.0f", i, datapoint[1].pleth)
    table.insert(plethTracePoints, point)

    point = string.format("%.0f:%.0f", i, datapoint[1].temp)
    table.insert(tempTracePoints, point)    
  end
  
end

--[[
function get_datapoint()

In a real application this would be a fetch (or push event) via SBIO for
acquired dataset instance to render.  In this case we will just fetch simulated from
pre-calulated buffers for each data quantity.
--]]
local lastDatapoint = {}

function get_datapoint()
  local n = 0
  local datapoint = {}
  
  -- pre-cached trace data
  n = table.getn(ecgTrace)
  if(cur_rad >n) then
    cur_rad = 1
  end
  
  -- simulate by returning the next datapoint from our trace 
  table.insert(datapoint, { ecg = ecgTrace[cur_rad], pleth = plethTrace[cur_rad], temp = tempTrace[cur_rad] } )
  
  -- Cache last read datapoint to avoid re-reading raw data and messing up display
  lastDatapoint = datapoint
  
  return datapoint
end

--[[
function get_numeric_data()

In a real application this would be a fetch (or push event) via SBIO for
acquired dataset instance to render in the statistical data displayed.  
In this case we will manufacture values with an amount of variance.
--]]
local lastNumericData = {}
local pulseMax
local pressSysMax
local pressDiaMin
local tempMin
local tempMax
local minmax_reset_count = 0

function get_numeric_data()
  local temp
  local numericData = {}
  
  -- Clear the min-max values every n iterations to show variance over time
  if( minmax_reset_count == 0 ) then
    pulseMax = 96
    pressSysMax = 121
    pressDiaMin = 75
    tempMin = 37.4
    tempMax = 37.4
    minmax_reset_count = 20
  end
  
  -- simulate by returning the next datapoint from our trace 
  table.insert(numericData, { pulse = 96, pulseHigh = 96, pulseLow = 51, 
                              pressSys = 121, pressDia = 75, pressSysTrend = 121, pressDiaTrend = 75, 
                              temp = 37.1, tempHigh = 37.4, tempLow = 36.7 } )
  
  numericData[1].pulse = numericData[1].pulse + ((mc_rand() - 0.5) *3)
  if( numericData[1].pulse > pulseMax ) then 
    pulseMax = numericData[1].pulse
    numericData[1].pulseHigh = pulseMax
  end
  
  numericData[1].pressDia = numericData[1].pressDia + ((mc_rand() - 0.5) *1)
  numericData[1].pressSys = numericData[1].pressSys + ((mc_rand() - 0.5) *2)
  if( numericData[1].pressSys > pressSysMax ) then 
    pressSysMax = numericData[1].pressSys
    numericData[1].pressSysTrend = pressSysMax
  end
  if( numericData[1].pressDia < pressDiaMin ) then 
    pressDiaMin = numericData[1].pressDia
    numericData[1].pressDiaTrend = pressDiaMin
  end
  
  temp = numericData[1].temp + ((mc_rand() - 0.5) *1)
  numericData[1].temp = temp
  if( temp > tempMax ) then 
    tempMax = temp
    numericData[1].tempHigh = tempMax
  end
  if( temp < tempMin ) then 
    tempMin = temp
    numericData[1].tempLow = tempMin
  end
  
  minmax_reset_count = minmax_reset_count - 1
    
  -- Cache last read datapoint to avoid re-reading raw data and messing up display
  lastNumericData = numericData
  
  return numericData
end

--- @param gre#context maparg
function draw_trend_trace(canvas,tracePoints)

  local datapoint = {}
  local point
  local tracePoint = {}

  -- Dynamically size the number of points for the polygon fill based on the canvas
  local use_canvas = gre.get_canvas( canvas )
  local size = use_canvas:get_dimensions()
  
  -- Shrink the bounds to make the lines visible
  size.height = size.height - 2
  size.width = size.width - 2
  max_idx = size.width
    
  -- fill with correct background colour - can I read this dynamically?
  -- set canvas line draw thickness to 2 px
  use_canvas:fill(0x14161C)
  
  -- Use a circular buffer to keep points in the trace, adjusting position in screen
  -- and then change points into a polygon string  
  if ( cur_w_idx > max_idx / TRACE_RATE_ZOOM ) then
    cur_w_idx = 1
  end   
 
  -- Get the next datapoint to plot and insert into table at the next trace point
  datapoint = get_datapoint()
  
  -- trace polygon points table has been filled with a full data trace, based on the size of the canvas
  local data = {}
  local trendPoints
  local trendLine
  
  if (canvas == "heartRateTrend" ) then
    point = datapoint[1].ecg
    trendLine = "trends.trendLine01"
  elseif (canvas == "bloodPressureTrend" ) then
    point = datapoint[1].pleth
    trendLine = "trends.trendLine02"
  elseif (canvas == "bodyTemperatureTrend" ) then
    point = datapoint[1].temp
    trendLine = "trends.trendLine03"
  else
    print("draw_trend_trace() - Unrecognised canvas name")
    return
  end

  -- insert a single updated datapoint at the drawpoint and update the display
  tracePoints[cur_w_idx] = string.format("%.0f:%.0f", cur_w_idx * TRACE_RATE_ZOOM, point)
  trendPoints = table.concat(tracePoints, " ")
  data[trendLine .. ".points"] = trendPoints
  
  -- add leading trace blanking bar to show separation between new and old data
  data[trendLine .. ".blank_x"] =  (cur_w_idx * TRACE_RATE_ZOOM) - 1   
  
  -- add a leading graphic 'dot' at the draw point
  data[trendLine .. ".dot_x"] = (cur_w_idx * TRACE_RATE_ZOOM ) - 6
  data[trendLine .. ".dot_y"] = point - 6
 
  gre.set_data(data)
 
end

--[[ =======Data refreh section=====
Note: We will use 2 timers each with different rates to update the screen vitals data
Trace data will need to be fast update whereas other numerics not so 
]]--
--- @param gre#context mapargs
function CBUpdateNumbers(mapargs)

  local numericData
  
  numericData = get_numeric_data()
  
  -- Update the UI display to act as a data refresh on numeric values - work in progress
  local data = {}

  
  data["trends.numbers01.pulse.text"] = string.format("%3d", numericData[1].pulse)
  data["trends.numbers01.highLow.text"] = string.format("%3d | %3d", numericData[1].pulseLow, numericData[1].pulseHigh)
  
  data["trends.numbers02.bloodPressure.text"] = string.format("%3d/%3d", numericData[1].pressSys, numericData[1].pressDia)
  data["trends.numbers02.highLow.text"] = string.format("%3d | %3d", numericData[1].pressSysTrend, numericData[1].pressDiaTrend)

  data["trends.numbers03.temp.text"] = string.format("%2.1f", numericData[1].temp)
  data["trends.numbers03.highLow.text"] = string.format("%2.1f | %2.1f", numericData[1].tempLow, numericData[1].tempHigh)
  
  gre.set_data(data);
    
end

--- @param gre#context mapargs
function CBUpdateTrends(mapargs)
  
  --draw_trend_scrolling()
  draw_trend_trace("heartRateTrend",ecgTracePoints)
  draw_trend_trace("bloodPressureTrend",plethTracePoints)
  draw_trend_trace("bodyTemperatureTrend",tempTracePoints)
  
  --StrokeRedTrianglePoly()
  -- Increment the polygon trace data point position and to next plot point
  cur_rad = cur_rad + 1
  cur_w_idx = cur_w_idx + 1  
  
end

local timer_idval_trace = nil
local timer_idval_numbers = nil

--- @param gre#context mapargs
function CBVitalsStart(mapargs) 
  
  --clear_trend_trace("heartRateTrend")
  --clear_trend_trace("bloodPressureTrend")
  --clear_trend_trace("bodyTemperatureTrend")
  
  -- Kick-off timers to start data refresh on screan show
  if (timer_idval_trace) == nil then
    timer_idval_trace = gre.timer_set_interval(CBUpdateTrends, TRACE_RATE_MS)
  end
  
  if (timer_idval_numbers) == nil then
    timer_idval_numbers = gre.timer_set_interval(CBUpdateNumbers, NUMERIC_RATE_MS)
  end

  --StrokeRedTrianglePoly(mapargs)
  
end

--- @param gre#context mapargs
function CBVitalsStop(mapargs) 
  -- Kill timers to release on screen transition
  if (timer_idval_trace) ~= nil then
    gre.timer_clear_interval(timer_idval_trace)
    timer_idval_trace = nil
  end 
  
  if (timer_idval_numbers) ~= nil then
    gre.timer_clear_interval(timer_idval_numbers)
    timer_idval_numbers = nil
  end 
    
  -- Reset iterators too to default start values
  cur_rad = 1
  cur_w_idx = 1    
end

-- Stroke a triangle using a polygon
function StrokeRedTrianglePoly(mapargs)
    local canvas = gre.get_canvas("heartRateTrend")
    local size = canvas:get_dimensions()
    local mid = size.width / 2

    -- Shrink the bounds to make the lines visible
    size.height = size.height - 2
    size.width = size.width - 2

    --local pts = {}
    --table.insert(pts, {x=2,y=2})
    --table.insert(pts, {x=mid,y=size.height})
    --table.insert(pts, {x=size.width,y=2})
    --table.insert(pts, pts[1])               --Close the polygon
    --canvas:stroke_poly(pts, 0xff0000)
    local point
    local pointData = {}
    local data = {}
    
    point = string.format("%.0f:%.0f", 2, 2)
    table.insert(pointData, point)
    point = string.format("%.0f:%.0f", mid, size.height)
    table.insert(pointData, point)
    point = string.format("%.0f:%.0f", size.width, 2)
    table.insert(pointData, point)
    point = string.format("%.0f:%.0f", 2, 2)
    table.insert(pointData, point)  --Close the polygon
        
    local trendPoints = table.concat(pointData, " ")
    data["trends.trendLine01.points"] = trendPoints
    data["trends.trendLine02.points"] = trendPoints
    data["trends.trendLine03.points"] = trendPoints
    
   gre.set_data(data)
end