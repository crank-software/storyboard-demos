
---This is where all UI controls are set up
---title=name of group from mapargs.context_group
controlSettings={
	--Thermostats
	{title="Thermostat",
	room="top",
	controlType="thermostat",
	groupName="thermo_layer.thermostat",
	did="0001C014F4A7-thermostat"
	},

	--Lights
	{title="Light",
	room="livingroom",
	controlType="light",
	groupName="house_foyer_controls_layer.light",
	did="BULB-ee0f1a4fbc6cd62dc361feba7faf6243"
	},
	{title="Light",
	room="front",
	controlType="light",
	groupName="house_outdoor_controls_layer.light",
	did="BULB-03a57e1aa9c10cf3837f5c562e611119"
	},
	{title="Desk Light",
	room="bedroom",
	controlType="light",
	groupName="house_bedroom_controls_layer.light2",
	did="BULB-210adf36f6aa4b6357261142a5476f62"
	},
	{title="Light",
	room="bedroom",	
	controlType="light",
	groupName="house_bedroom_controls_layer.light",
	did="BULB-fe980ecf80bfbfa7629659b0a5ea8d34"
	},
	


	--Coffee/stove
	{title="Stovetop",
	room="kitchen",
	controlType="stove_top",
	groupName="house_kitchen_controls_layer.cooktop",
	did="00049F027FB1002F"
	},
	{title="mbed Coffee",
	room="kitchen",
	controlType="coffee_machine",
	groupName="house_kitchen_controls_layer.coffee_maker2",
	did="0001C014F4A7-mBedCoffeeMachine-00049F024661"
	},
	 {title="IS2T Coffee",
	 room="kitchen",
	 controlType="coffee_is2t",
	 groupName="house_kitchen_controls_layer.coffee_maker",
	 did="0001C014F4A7-IS2TCoffeeMachine-c4d9873fc6f4"
	 },

	--Locks
	{title="Door Lock",
	room="front",
	controlType="lock",
	groupName="house_outdoor_controls_layer.lock",
	did="0001C014F4A7-FIDO-1",
	doorStatusLink="00049F02FC31002E-MainDoor"

	},
	{title="Door Lock",
	room="back",
	controlType="lock",
	groupName="house_entryway_controls_layer.lock",
	did="00049F020A41003B",
	doorStatusLink="00049F020A41003B-BackDoor"
	},

		-- pump
	{title="Pump",
	room="front",
	controlType="pump",
	groupName="house_outdoor_controls_layer.pump",
	did="00049F028D81003D"
	},    

	--Doors and Windows also known as windowDoor as they have basically the same properties 
	{title="Door",
	room="front",
	controlType="door",
	groupName="house_outdoor_controls_layer.lock",
	did="00049F02FC31002E-MainDoor",
	doorLockLink="0001C014F4A7-FIDO-1"
	},
	{title="Door",
	room="back",
	controlType="door",
	groupName="house_entryway_controls_layer.lock",
	did="00049F020A41003B-BackDoor",
	doorLockLink="00049F020A41003B"
	},

	{title="Window",
	room="kitchen",
	controlType="window",
	groupName="house_kitchen_controls_layer.status",
	did="00049F02FC31002E-KitchenWindow"
	},
	{title="Window",
	room="livingroom",
	controlType="window",
	groupName="house_foyer_controls_layer.status",
	did="00049F02FC31002E-LivingRoomWindow"
	},
	--weather station
	{title="Weather Station",
	room="thermostat",
	controlType="weather_station",
	groupName="thermo_layer.myWeather",
	did="00049F06C5E10006"
	},	

  
}


lightProps={
	on=false,
	brightness=100,
	pulse=false,
	hue=223,
	saturation=100,
	color_temperature=0
	}

thermostatProps={
	ambient_temp = 68,
	setpoint_temp = 68,
	hvac_mode = "HEATING",
	fan_mode = "ON"
	}

weatherStationProps = {
	temp=81,
	pressure = 120,
	wind_speed = 12,
	wind_direction = "north",
	daily_rainfall = 0,
	illuminance = 120
	}

energyProps={
	battery_level = 80,
	voltage = 24,
	current = 2,
	current_energy_consumption = 12,
	estimated_lifetime_on_battery = "200hrs"
	} 


stovetopProps={
	water_temp = 60,
	stove_status="stop",
	status="Off"
	}
	
pumpProps={
  pump_status="off",
  status="Off"
  }	

windowDoorProps={
	open = false
	}

lockProps={
	locked = false
	}

coffeeProps={
	coffee_program = "couple",
	coffee_status = "stop"
	}

coffeePropsMbed={
	coffee_program = "uninitialized",
	coffee_status = "idle"
	}



