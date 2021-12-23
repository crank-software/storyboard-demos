device = {}
device.__index = device

-- syntax equivalent to "device.new = function..."
function device.new(deviceType,did,propertiesTable,controlTable,updateFunction)

  local self = setmetatable({}, device)

  if (deviceType ~= controlTable.controlType) then
  	print("That control is not the right type for the Device")
  	return false
  end

  self.controlData = controlTable
  self.type = type
  self.did = did
  self.properties = {}
  self.update=updateFunction

  --clone the properties table over to the object instead of referencing
  for k,v in pairs(propertiesTable) do
	self.properties[k] = v
  end

  return self
end


function device:get_did()
  return self.did
end

function device:get_properties()
  return self.properties
end

function device:get_controlData()
  return self.controlData
end

function device:set_property(property, newVal)
  if self.properties[property] == nil then
    print("Warning ("..self.controlData.controlType..") : New unknown property -> "..property.." ("..tostring(newVal)..")")
  end
  self.properties[property] = newVal
end

