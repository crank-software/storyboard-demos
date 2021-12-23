local myenv = gre.env({ "target_os", "target_cpu" })
package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.so;" .. package.cpath

local override_env = os.getenv("GRE_LUA_MODULES")
if (override_env) then
	package.cpath = override_env .."/?.so;" .. package.cpath
end

require"lqnx_pps"

local SENSOR_PATH = "/pps/qnxcar/sensors"

function update_tire_pressure(sensor)
	local data = {}
	
	if (sensor["tire_pressure_fl"] ~= nil) then
		data["tire_layer.FL_tire_control.text"] = sensor["tire_pressure_fl"]
	end
	if (sensor["tire_pressure_fr"] ~= nil) then
		data["tire_layer.FR_tire_control.text"] = sensor["tire_pressure_fr"]
	end
	if (sensor["tire_pressure_rl"] ~= nil) then
		data["tire_layer.BL_tire_control.text"] = sensor["tire_pressure_rl"]
	end
	if (sensor["tire_pressure_rr"] ~= nil) then
		data["tire_layer.BR_tire_control.text"] = sensor["tire_pressure_rr"]
	end
	gre.set_data(data)
end

local PROGRESS_WIDTH = 125

function update_fluids(sensor)
	local data = {}
	local FUEL_WIDTH = 299
	
	if (sensor["brakeFluid_level"] ~= nil) then
		data["fluids_layer.brake_fluid_control.value"] = tonumber(sensor["brakeFluid_level"])*PROGRESS_WIDTH/100
	end
	if (sensor["transmissionFluid_level"] ~= nil) then
		data["fluids_layer.engine_oil_control.value"] = tonumber(sensor["transmissionFluid_level"])*PROGRESS_WIDTH/100
	end
	if (sensor["engineCoolant_level"] ~= nil) then
		data["fluids_layer.engine_coolant_control.value"] = tonumber(sensor["engineCoolant_level"])*PROGRESS_WIDTH/100
	end
	if (sensor["washerFluid_level"] ~= nil) then
		data["fluids_layer.washer_fluid_control.value"] = tonumber(sensor["washerFluid_level"])*PROGRESS_WIDTH/100
	end
--	if (sensor["fuel_level"] ~= nil) then
--		data["fluids_layer.engine_oil_control.value"] = tonumber(sensor["fuel_level"])*FUEL_WIDTH/100
--	end

	gre.set_data(data)
end

function get_value(i, alert, caution)
	if (i <= alert) then
		return "Alert"
	elseif (i <= caution)  then
		return "Caution"
	end
	return "Nominal"
end

function get_image_value(i, alert, caution)
	if (i <= alert) then
		return "images/status_engine_red.png"
	elseif (i <= caution)  then
		return "images/status_engine_amber.png"
	end
	return "images/status_engine_green.png"
end

function update_transmision(sensor)
	local data = {}
	
	if (sensor["transmission_temperature"] ~= nil) then
		data["engine_layer.engine_status_control.status_transmission"] = get_image_value(tonumber(sensor["engineOil_level"]), 75, 85)
	end
	if (sensor["transmission_clutchWear"] ~= nil) then
		data["engine_layer.engine_status_control.status_clutch"] = get_image_value(tonumber(sensor["transmission_clutchWear"]), 40, 60)
	end
	if (sensor["engineOil_pressure"] ~= nil) then
		data["engine_layer.engine_status_control.status_oil_pressure"] = get_image_value(tonumber(sensor["engineOil_pressure"]), 75, 85)
	end
	gre.set_data(data)
end

function update_braking(sensor)
	local data = {}
	
	if (sensor["brake_wear_rl"] ~= nil) then
		data["braking_layer.RL_brake_control.value"] = get_value(tonumber(sensor["brake_wear_rl"]), 20, 40)
	end
	if (sensor["brake_wear_rr"] ~= nil) then
		data["braking_layer.RR_brake_control.value"] = get_value(tonumber(sensor["brake_wear_rr"]), 20, 40)
	end
	if (sensor["brake_wear_fl"] ~= nil) then
		data["braking_layer.FL_brake_control.value"] = get_value(tonumber(sensor["brake_wear_fl"]), 20, 40)
	end
	if (sensor["brake_wear_fr"] ~= nil) then
		data["braking_layer.FR_brake_control.value"] = get_value(tonumber(sensor["brake_wear_fr"]), 20, 40)
	end
	gre.set_data(data)
end

function sensor_register()
	SENSOR_PATH = lqnx_pps.monitor_register_event(SENSOR_PATH, "qnxcar.sensor.update", "attrs")
end

function sensor_init()
	-- grab initial data
	cb_sensor_update()
end

function cb_sensor_update(mapargs)
	local sensor = {}

	sensor = lqnx_pps.get(SENSOR_PATH, SENSOR_ATTRS)
	if sensor == nil then
		return
	end

	update_tire_pressure(sensor)
	update_fluids(sensor)
	update_transmision(sensor)
	update_braking(sensor)

--    for a, b in pairs(sensor) do
--        print(a, b)
--    end
end
