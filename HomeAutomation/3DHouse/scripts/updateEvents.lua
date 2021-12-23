local bulbs={"BULB-ee0f1a4fbc6cd62dc361feba7faf6243","BULB-03a57e1aa9c10cf3837f5c562e611119","BULB-210adf36f6aa4b6357261142a5476f62","BULB-fe980ecf80bfbfa7629659b0a5ea8d34"}
local locks={"0001C014F4A7-FIDO-1","00049F020A41003B"}
local windoors={"00049F02FC31002E-MainDoor","00049F020A41003B-BackDoor","00049F02FC31002E-KitchenWindow","00049F02FC31002E-LivingRoomWindow"}

function sendUpdates(message)
  local data={}
  data["message"]=message
  gre.send_event_data("updateMessage","1s0 message",data)
end

function setEveryItemOnce()
	local datagram = ""
	for i=1,#bulbs do
		local val="true"
		if(i%2==1)then
			val="true"
		else
			val="false"
		end
		datagram='{"notif":"property_update","property":{"value":'..val..',"id":{"name":"on","did":"'..bulbs[i]..'"}}}'
		sendUpdates(datagram)
		--os.usleep(2000)
	end
	for i=1,#locks do
		datagram='{"notif":"property_update","property":{"value":true,"id":{"name":"locked","did":"'..locks[i]..'"}}}'
		sendUpdates(datagram)
		--os.usleep(2000)
	end
	for i=1,#windoors do
		datagram = '{"notif":"property_update","property":{"value":false,"id":{"name":"open","did":"'..windoors[i]..'"}}}'
		sendUpdates(datagram)
		--os.usleep(2000)
	end
	datagram='{"notif":"property_update","property":{"value":"on","id":{"name":"pump_status","did":"00049F028D81003D"}}}'
	sendUpdates(datagram)
  datagram='{"notif":"property_update","property":{"value":"busy","id":{"name":"coffee_status","did":"0001C014F4A7-mBedCoffeeMachine-00049F024661"}}}'
  sendUpdates(datagram)
  datagram='{"notif":"property_update","property":{"value":"start","id":{"name":"coffee_status","did":"0001C014F4A7-IS2TCoffeeMachine-c4d9873fc6f4"}}}'
  sendUpdates(datagram)
  datagram='{"notif":"property_update","property":{"value":"livanto","id":{"name":"coffee_program","did":"0001C014F4A7-mBedCoffeeMachine-00049F024661"}}}'
  sendUpdates(datagram)
	datagram='{"notif":"property_update","property":{"value":"boiling","id":{"name":"stove_status","did":"00049F027FB1002F"}}}'
	sendUpdates(datagram)
	datagram='{"notif":"property_update","property":{"value":"couple","id":{"name":"coffee_program","did":"0001C014F4A7-IS2TCoffeeMachine-c4d9873fc6f4"}}}'
	sendUpdates(datagram)
end


local function parseNotification(jsonTable)
  print(jsonTable.device.did)
  if(jsonTable.notif=="device_connected")then
    print("New device connected, getting properties...")
    if not(getObjectByDid(jsonTable.device.did))then
      print("The new device was not found in known controls, ignoring")
      return
    else
        local datagram={req="get_all_properties",
          details= {id= {did=jsonTable.device.did}  }
          }
          sendUDPDatagram(datagram)
    end
  end

  local notifyObject=getObjectByDid(jsonTable.device.did)
  local name=jsonTable.device.did
  if(notifyObject) then

    name = notifyObject:get_controlData().room.." "..notifyObject:get_controlData().title
  end

  local title = name
  print("TITLE:"..name)
  local time = os.date("*t")
  local t=string.format("%02d:%02d:%02d",time.hour,time.min,time.sec)

  local details= string.format("%s %s",t,jsonTable.notif)

  --notification_incoming(title,details)
end


local function updatePropertyNotif( jsonTable )
  local updateObject= getObjectByDid(jsonTable.property.id.did)
  if not (updateObject) then
    print("The DID:"..jsonTable.property.id.did.." was not found on the registered device list. check controls.lua")
  else
    updateObject:set_property(jsonTable.property.id.name, jsonTable.property.value)

    if(jsonTable.property.id.name=="setpoint_temp")then
      notification_incoming(updateObject.controlData.title,"Set to "..updateObject.properties.setpoint_temp.." degrees")
    end

    if(jsonTable.property.id.name=="open")then
      local room=updateObject.controlData.room
      if(updateObject.properties.open=="true")then updateObject.properties.open=true end
      if(updateObject.properties.open=="false")then updateObject.properties.open=false end

      if(updateObject.properties.open==true) then
        notification_incoming(room:gsub("^%l", string.upper).." "..updateObject.controlData.title,"Opened")
      elseif(updateObject.properties.open==false) then
        notification_incoming(room:gsub("^%l", string.upper).." "..updateObject.controlData.title,"Closed")
      else
        error("Door or window was set to non-boolean value")
      end
    end

    if(jsonTable.property.id.name=="fan_mode")then
      str = string.gsub (updateObject.properties.fan_mode, "%f[%a]%u+%f[%A]", string.lower)
      notification_incoming(updateObject.controlData.title,"Fan: "..str:gsub("^%l", string.upper))
    end

    if(jsonTable.property.id.name=="hvac_mode")then
      str = string.gsub (updateObject.properties.hvac_mode, "%f[%a]%u+%f[%A]", string.lower)
      notification_incoming(updateObject.controlData.title,str:gsub("^%l", string.upper))
    end

    if(jsonTable.property.id.name=="pump_status")then
      str = updateObject.properties.pump_status
      notification_incoming(updateObject.controlData.title,str:gsub("^%l", string.upper))
    end

    if(jsonTable.property.id.name=="stove_status")then
      if(updateObject.properties.stove_status=="boiling")then
        notification_incoming(updateObject.controlData.title,"Boiling")
      elseif(updateObject.properties.stove_status=="stop")then
        notification_incoming(updateObject.controlData.title,"Idle")
      elseif(updateObject.properties.stove_status=="simmer")then
        notification_incoming(updateObject.controlData.title,"Simmering")
      end
    end

    if(jsonTable.property.id.name=="coffee_status")then
      notification_incoming(updateObject.controlData.title,"Program: ".. updateObject.properties.coffee_program..", Status: ".. updateObject.properties.coffee_status)
    end

    updateObject:update()
  end
end

function cb_gotUpdateMessage(mapargs)
  local ev_data = mapargs.context_event_data
  --print(ev_data.message)
  local jsonTable = json.decode(ev_data.message)

  if (jsonTable.notif) then
    if ( jsonTable.notif=="property_update" ) then
      updatePropertyNotif(jsonTable)
      return
    end
    parseNotification(jsonTable)
    return
  end
end
