local cur_volume = 30
local mute = 0

function cb_volume_slider(mapargs)
	local ev = mapargs.context_event_data
	local gdata = {}
	local data = {}
	
	gdata = gre.get_control_attrs(mapargs.context_control, "x")
	local x_pos = ev["x"] - gdata["x"]
	local speed = math.ceil(x_pos / 18)

	local fill_x = (speed * 18)
	data["media_layer.vol_slider.grd_width"] = fill_x
	gre.set_data(data)	
	
	cur_volume = fill_x*100/180
	
	if (mute == 1) then
		-- unmute
		cb_volume_mute()
	else 
		set_volume(cur_volume)
	end
end

function cb_volume_mute(mapargs)
	local data = {}
	
	if (mute == 1) then
		data["media_layer.vol_icon.image"] = "images/vol_icon1.png"
		mute = 0
		set_volume(cur_volume)
	else
		data["media_layer.vol_icon.image"] = "images/vol_icon_mute.png"
		mute = 1
		set_volume(0)
	end
	gre.set_data(data)
end
