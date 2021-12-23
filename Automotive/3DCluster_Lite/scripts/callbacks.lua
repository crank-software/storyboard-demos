local GLOBAL_prevRPM = 0
local GLOBAL_prevSpeed = 0

function updateSpeed(mapargs)
  
  local data = {}
  local text1, text2, text3 = 0
  
  local data_table = gre.get_data("speed")
  local value = tonumber(data_table["speed"])
  local rawSpeed = (value)  
  
  if(value < 160)then
    data["dials.speed.colour"] = 0xFFFFFF
    data["dials.speedFaded.colour"] = 0xFFFFFF
  else
    data["dials.speed.colour"] = 0xE52C2C
    data["dials.speedFaded.colour"] = 0xE52C2C 
  end
    
  value = (value*-160)/240
  data["dials.speedometer.needleControl_RZ"] = value
  data["dials.speedometerSmall.needleControl_RZ"] = value
  
  rawSpeed = math.floor(rawSpeed)
  rawSpeed = tostring(rawSpeed)
  --start of string manipulation for speed
  
  if(string.len(rawSpeed) == 1)then

    for i = 1, #rawSpeed do
      local c = rawSpeed:sub(i,i)
      text3 = c
    end
    text2 = 0
    text1 = 0
    
  elseif(string.len(rawSpeed) == 2)then
   
    for i = 1, #rawSpeed do
      local c = rawSpeed:sub(i,i)
      if(i == 1)then
        text2 = c
      else
        text3 = c
      end
    end
    text1 = 0
    
  elseif(string.len(rawSpeed) == 3)then

    for i = 1, #rawSpeed do
      local c = rawSpeed:sub(i,i)
      if(i == 1)then
        text1 = c
      elseif(i == 2)then
        text2 = c
      else
        text3 = c
      end
    end
    
  else
    print("update Speed error")
  end
  
  data["dials.speed.text1"] = text1
  data["dials.speed.text2"] = text2
  data["dials.speed.text3"] = text3
  data["dials.speedFaded.text1"] = text1
  data["dials.speedFaded.text2"] = text2
  data["dials.speedFaded.text3"] = text3
   
   
  --end of string manipulation
    
  gre.set_data(data)
  

end

function updateRPM(mapargs)
  
  local text1, text2, text3 = 0
  
  local data = {}
  local data_table = gre.get_data("rpm")
  local value = tonumber(data_table["rpm"])
  
  local rawRPM = value  
  rawRPM = string.sub(rawRPM, 0, 3)  
    
  for i = 1, #rawRPM do
    local c = rawRPM:sub(i,i)
    if(i == 1)then
      text1 = c
    elseif(i == 2)then
    else
      text3 = c
    end
  end
  
  data["dials.rpm.text1"] = text1
  data["dials.rpm.text3"] = text3
  data["dials.rpmFaded.text1"] = text1
  data["dials.rpmFaded.text3"] = text3
  
  if(value < 5.5)then
    data["dials.rpm.colour"] = 0xFFFFFF
    data["dials.rpmFaded.colour"] = 0xFFFFFF
  else
    data["dials.rpm.colour"] = 0xE52C2C
    data["dials.rpmFaded.colour"] = 0xE52C2C
  end
  
  value = (value*160)/8
  data["dials.tachometer.needleControl_RZ"] = value
  data["dials.tachometerSmall.needleControl_RZ"] = value
  
  gre.set_data(data)
  
end

function dialsUp(mapargs)
  gre.animation_trigger("showSmallTBT")
  gre.animation_trigger("dialsUp")
end

function dialsBack(mapargs)
  gre.animation_trigger("showLargeTBT")
  gre.animation_trigger("dialsBack")
end

function updateGear(mapargs)
  local data = {}
  local data_table = gre.get_data("gear")
  local value = tonumber(data_table["gear"])
  
  print(value)
  
  if(value == 1)then
    data["bottomInfo.gearGroup.6.colour"] =  0x777777
    data["bottomInfo.gearGroup.1.colour"] =  0xffffff
    data["bottomInfo.gearGroup.fillBottom.grd_x"] = 0
  elseif(value == 2)then
    data["bottomInfo.gearGroup.1.colour"] =  0x777777
    data["bottomInfo.gearGroup.2.colour"] =  0xffffff
    data["bottomInfo.gearGroup.fillBottom.grd_x"] = 26
  elseif(value == 3)then 
    data["bottomInfo.gearGroup.2.colour"] =  0x777777
    data["bottomInfo.gearGroup.3.colour"] =  0xffffff
    data["bottomInfo.gearGroup.fillBottom.grd_x"] = 52
  elseif(value == 4)then 
    data["bottomInfo.gearGroup.3.colour"] =  0x777777
    data["bottomInfo.gearGroup.4.colour"] =  0xffffff
    data["bottomInfo.gearGroup.fillBottom.grd_x"] = 78
  elseif(value == 5)then 
    data["bottomInfo.gearGroup.4.colour"] =  0x777777
    data["bottomInfo.gearGroup.5.colour"] =  0xffffff
    data["bottomInfo.gearGroup.fillBottom.grd_x"] = 104
  elseif(value == 6)then 
    data["bottomInfo.gearGroup.5.colour"] =  0x777777
    data["bottomInfo.gearGroup.6.colour"] =  0xffffff
    data["bottomInfo.gearGroup.fillBottom.grd_x"] = 130
  end
  gre.set_data(data)
  
end