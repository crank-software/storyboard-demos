function cb_init(mapargs)
	local data = {}
	
	data["city"] = "Las Vegas"
	data["temperature"] = "18"
	gre.set_data(data)
	cb_update_time()
end

function cb_update_time(mapargs)
	local date = os.date("*t")
	local data = {}
	
	if (date.hour > 12) then
		date.hour = date.hour - 12
	end
	data["time"] = date.hour..":"..date.min
	gre.set_data(data)
end