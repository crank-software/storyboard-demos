local cur_message = nil

function show_message(mapargs)
	local data = {}
	local navi_event = nil

	if (cur_message == mapargs.context_event_data.message) then
		return
	end

	-- hide current message
	if (cur_message ~= nil) then
		data["hide_message"] = "hide_warning_"..cur_message
	else
		data["hide_message"] = ""
	end
	
	if (mapargs.context_event_data.message == "navigation") then
		data["show_message"] = ""
		cur_message = nil
		navi_event = "show_navigation"
	else
		data["show_message"] = "warning_"..mapargs.context_event_data.message
		cur_message = mapargs.context_event_data.message
	end
	
	gre.set_data(data)
	gre.send_event("show_message_animation")

	if (navi_event) then
		gre.send_event(navi_event)
	end
end

function hide_message(mapargs)
	local data = {}

	-- hide current message
	if (cur_message ~= nil) then
		data["hide_message"] = "hide_warning_"..cur_message
	end
	
	data["show_message"] = ""
	gre.set_data(data)
	
	gre.send_event("hide_message_animation")
	cur_message = nil	
end

local ebrake = {
control = "indicators_layer.ebrake_control1",
on = "images/ebrake_on1.png",
off = "images/ebrake_off1.png",
state = 0 
}

local highbeam = {
control = "indicators_layer.highbeam_control1",
on = "images/highbeam_off.png",
off = "images/highbeam_on.png",
state = 0 
}

local engine = {
control = "indicators_layer.engine_control2",
on = "images/engine_on1.png",
off = "images/engine_off1.png",
state = 0
}

local oil = {
control = "indicators_layer.oil_control1",
on = "images/oil_on1.png",
off = "images/oil_off1.png",
state = 0
}

local battery = {
control = "indicators_layer.battery_control1",
on = "images/battery_on1.png",
off = "images/battery_off1.png",
state = 0
}

local seatbelt = {
control = "indicators_layer.seatbelt_control1",
on = "images/seatbelt_on1.png",
off = "images/seatbelt_off1.png",
state = 0
}

local abs = {
control = "indicators_layer.ABS_control1",
on = "images/ABS_on1.png",
off = "images/ABS_off1.png",
state = 0
}

local warnings = {
["ebrake"] = ebrake,
["highbeam"] = highbeam,
["engine"] = engine,
["oil"] = oil,
["battery"] = battery,
["seatbelt"] = seatbelt,
["abs"] = abs,
}

function show_warning(mapargs)
	local data = {}
	local warn = mapargs.context_event_data.warning
	
	if (warn == "signals") then
		print("show_signals")
		gre.send_event("show_signals")
		return
	end
	
	if (warnings[warn].state == 0) then
		-- turn it on
		warnings[warn].state = 1
		data[warnings[warn].control..".image"] = warnings[warn].on
	else 
		warnings[warn].state = 0
		data[warnings[warn].control..".image"] = warnings[warn].off
	end
	
	gre.set_data(data)
end
