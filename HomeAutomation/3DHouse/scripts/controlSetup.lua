require("devices")
require("controls")

G_deviceTable={}

initDeviceProperties={}

function getInitProps(incDid)
	local datagram={req="get_all_properties",
	details= {id= {did=incDid}	}
	}
	--table.insert(initDeviceProperties,datagram)
end


function populateLists(mapargs)
	local layerName="house_overall_controls_layer"
	local rooms={"kitchen","bedroom","livingroom","front","back"}

	for i=1,#rooms do
		local room=rooms[i]
		local Itemnumbers=0
		local tableName=layerName.."."..rooms[i].."_group.device_table"
		local data={}

		--get all controls for that room
		local roomItems={}
		for i=1,#controlSettings do
			if (controlSettings[i].room==room) then
				table.insert(roomItems,controlSettings[i])
				--print("found: "..room.." "..controlSettings[i].controlType)
				getInitProps(controlSettings[i].did)
			end
		end

		--populate the overall tables
		for i=1,#roomItems do
			if(roomItems[i].controlType~="door")then
				Itemnumbers=Itemnumbers+1
				data[tableName..".value."..i..".1"]=""
				data[tableName..".title."..i..".1"]=roomItems[i].title
				--print(roomItems[i].title.." "..i)
			end
			local thisDid=roomItems[i].did
			local valueTarget=tableName..".value."..i..".1"
				--send the label name over to the contolSettings
			for i=1,#controlSettings do
				if (controlSettings[i].did==thisDid) then
					controlSettings[i].overallDisplay=valueTarget
					--print(tableName..".value."..i..".1")
				end
			end


		end

		gre.set_data(data)

    local dk_data = {}
    dk_data["rows"] = Itemnumbers
    gre.set_table_attrs(tableName, dk_data)
	end
end


function cb_initDevices()

	populateLists()

	for i=1,#controlSettings do

		local properties
		if(controlSettings[i].controlType=="thermostat")then
			properties=thermostatProps
			update=updateThermoUI
		elseif(controlSettings[i].controlType=="light")then
			properties=lightProps
			update=updateLightUI
		elseif(controlSettings[i].controlType=="window")then
			properties=windowDoorProps
			update=updateStatusUI
		elseif(controlSettings[i].controlType=="door")then
			properties=windowDoorProps
			update=updateDoorUI
		elseif(controlSettings[i].controlType=="lock")then
			properties=lockProps
			update=updateLockUI
		elseif(controlSettings[i].controlType=="coffee_machine")then
			properties=coffeePropsMbed
			update=updateCoffeeUI
    elseif(controlSettings[i].controlType=="coffee_is2t")then
      properties=coffeeProps
      update=updateCoffeeUI
		elseif(controlSettings[i].controlType=="stove_top")then
			properties=stovetopProps
			update=updateStatusUI
		elseif(controlSettings[i].controlType=="solar_panel")then
			properties=energyProps
			update=updateLightUI
		elseif(controlSettings[i].controlType=="weather_station")then
			properties=weatherStationProps
			update=updateWeatherStationUI
    		elseif(controlSettings[i].controlType=="pump")then
		      properties=pumpProps
		      update=updateStatusUI
    		else
			print("Unrecognized Device type: "..controlSettings[i].type)
			return false
		end

		local item=device.new(controlSettings[i].controlType,controlSettings[i].did,properties,controlSettings[i],update)
		table.insert(G_deviceTable,item)
	end

	for i=1,#G_deviceTable do
	print("Registered: "..G_deviceTable[i]:get_controlData().title.." typeof: "..G_deviceTable[i]:get_controlData().controlType)
	end

	setEveryItemOnce()--Send the initial device states
	--gre.timer_set_interval(SendRandomMessage, 1000) --start random event coming in

end




local deviceTypes={
	"MONOCHROMATIC_LIGHT_BULB",
	"COLOR_LIGHT_BULB",
	"MAIN_DOOR",
	"BACK_DOOR",
	"WINDOW",
	"THERMOSTAT",
	"STOVE_TOP",
	"COFFEE_MACHINE",
	"CAMERA",
	"WEATHER_STATION",
	"SOLAR_PANEL"
    }
