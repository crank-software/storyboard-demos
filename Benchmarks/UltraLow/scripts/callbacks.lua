local function setSpeed(incControl, incValue)

  local startPos = -125
  local size = 250
  
  local rotation = (incValue/100 * size) + startPos
  local data = {}
  data[incControl..".angle"] = rotation
  data[incControl..".text"] = incValue.." mph"
  gre.set_data(data)
end

function CBUpdateSpeedSmall(mapargs)
  local control = "dialsAndNeedles.100px"
  local speed = gre.get_value(control..".speed")
  setSpeed(control, speed)
end

function CBUpdateSpeedMedium(mapargs)
  local control = "dialsAndNeedles.250px"
  local speed = gre.get_value(control..".speed")
  setSpeed(control, speed)
end

function CBUpdateSpeedLarge(mapargs)
  local control = "dialsAndNeedles.400px"
  local speed = gre.get_value(control..".speed")
  setSpeed(control, speed)
end