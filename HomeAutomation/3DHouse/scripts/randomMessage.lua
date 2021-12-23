
local randomCounter=1

function SendRandomMessage()
  if(math.random(1,100)>10)then
    return false
  end
  
  if (randomCounter==5) then randomCounter=1 end
  local data={}
  if(randomCounter==1)then
    data=randomCoffee()
  elseif(randomCounter==2)then
    data=randomWindowDoor()
  elseif(randomCounter==3)then
    data=randomPump()
  else
    data=randomStove()
  end

  local datagram= string.format('{"notif":"property_update","property":{"value":"%s","id":{"name":"%s","did":"%s"}}}',data[1],data[2],data[3])
  sendUpdates(datagram)
  randomCounter=randomCounter+1
end

function randomCoffee()
  local data = {}
  local machines={"0001C014F4A7-mBedCoffeeMachine-00049F024661","0001C014F4A7-mBedCoffeeMachine-00049F024661"}
  local types={"coffee_program","coffee_status"}
  local mbedPrograms = {"arpeggio", "decaffeinato_intenso", "livanto", "roma", "vivalto_lungo"}
  local mbedStatus={"busy","idle"}
  local is2tPrograms = {"single","couple","lungo"}
  local is2tStatus={"stop","start"}

  data[2]= types[math.random(1, 2)]
  data[3]=machines[math.random(1, 2)]

  if (data[2]=="coffee_program") then
    if (data[3]=="0001C014F4A7-mBedCoffeeMachine-00049F024661") then
      data[1] = mbedPrograms[math.random(1, #mbedPrograms)]
    else
      data[1] = is2tPrograms[math.random(1, #is2tPrograms)]
    end
  else
    if (data[3]=="0001C014F4A7-mBedCoffeeMachine-00049F024661") then
      data[1] = mbedStatus[math.random(1, #mbedStatus)]
    else
      data[1] = is2tStatus[math.random(1, #is2tStatus)]
    end
  end

  return data
end

function randomWindowDoor()
  local data = {}
  local windowDoors = {"00049F02FC31002E-KitchenWindow","00049F02FC31002E-LivingRoomWindow","00049F02FC31002E-MainDoor","00049F020A41003B-BackDoor"}
  local options = {"true","false"}

  data[1]=options[math.random(1,2)]
  data[2]="open"
  data[3]=windowDoors[math.random(1,4)]
  return data
end

function randomPump()
  local data = {}
  local options = {"on","blocked","off"}
  data[1] = options[math.random(1,3)]
  data[2] = "pump_status"
  data[3] = "00049F028D81003D"
  return data

end

function randomStove()
  local data = {}
  local options={"boiling","stop","simmer"}
  data[1] = options[math.random(1,3)]
  data[2] = "stove_status"
  data[3] = "00049F027FB1002F"
  return data
end
