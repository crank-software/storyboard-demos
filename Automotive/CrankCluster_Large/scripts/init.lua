function cb_init(mapargs)
	local data = {}
	
	data["city"] = "Las Vegas"
	data["temperature"] = "17"
	
	data["background"] = "images/dash_overlay_bg.png"
	data["glow_image"] = "images/red_glow_merged.png"
	data["Layer.dash_overlay_bg.grd_y"] = -4
	data["lights_layer.time_control.grd_y"] = 70
	gre.set_data(data)
	
	cb_update_time()
end

function cb_update_time(mapargs)
	local date = os.date("*t")
	local data = {}
	local extra = "am"
	
	if (date.hour > 12) then
		date.hour = date.hour - 12
		extra = "pm"
	end
	if (date.min < 10) then
		date.min = "0"..date.min
	end
	data["time"] = date.hour..":"..date.min.." "..extra
	gre.set_data(data)
end
