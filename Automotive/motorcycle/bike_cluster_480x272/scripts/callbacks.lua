local tickBase = "ticks_layer.tick"
local maxTicks = 81
local minTicks = 1
local maxRPM = 16000
local minSpeed = 0

--- @param gre#context mapargs
function CBUpdateSpeed(mapargs)
  local data = {}
  local speed = mapargs.speed
  local hundreds, tens, ones
  
  hundreds = math.floor(speed / 100)
  data["speed_layer.speed.hundreds"] = hundreds
  speed = (speed - (hundreds * 100))
  tens = math.floor(speed / 10)
  data["speed_layer.speed.tens"] = tens
  ones  = (speed - (tens * 10))
  data["speed_layer.speed.ones"] = ones
  
  gre.set_data(data)
end

--- @param gre#context mapargs
function CBUpdateRpm(mapargs) 
  SetTicks(mapargs.rpm)
end

--TODO fix this to actually use rpm, using speed for now
function SetTicks(currentRpm)
  local highestTick = math.floor(((currentRpm/maxRPM) * maxTicks) + 0.5)
  local data = {}
  for i = minTicks, highestTick do
    data[string.format("%s%d.grd_hidden",tickBase,i)] = 0
  end
  
  for i=highestTick, maxTicks do
  	data[string.format("%s%d.grd_hidden",tickBase,i)] = 1
  end
  
  gre.set_data(data)
end




