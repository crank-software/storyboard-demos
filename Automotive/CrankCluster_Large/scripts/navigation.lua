local turn1 = {
icon = "images/navi_arrows/nav_half_left.png",
direction = "300m Turn Left",
street = "March Road",
next = "400m"
}

local turn2 = {
icon = "images/navi_arrows/nav_keep_left.png",
direction = "400m Keep Left",
street = "Carling Avenue",
next = "500m"
}

local turn3 = {
icon = "images/navi_arrows/nav_exit.png",
direction = "500m Exit Right",
street = "Leggit Street",
next = "400m"
}

local turns = {
turn1,
turn2,
turn3
}

local cur_index = 1
local next_index = 2
local count = 0
local warning = 0

function cb_turn_by_turn(mapargs)
	local max = table.maxn(turns)
	local data = {}
	
	data["navigation_l.directional_arrow.image"] = turns[cur_index].icon
	data["navigation_l.distance_direction.text"] = turns[cur_index].direction
	data["navigation_l.destination_name.text"] = turns[cur_index].street
	
	data["navigation_l.next_directional_arrow.image"] = turns[next_index].icon
	data["navigation_l.next_control.text"] = turns[cur_index].next

	-- reset controls
	data["navigation_l.directional_arrow.alpha_value"] = 255
	data["navigation_l.next_directional_arrow.grd_x"] = 910
	data["navigation_l.next_directional_arrow.grd_y"] = 710
	data["navigation_l.next_directional_arrow.grd_height"] = 41
	data["navigation_l.next_directional_arrow.grd_width"] = 40

	gre.set_data(data)
	gre.send_event("show_turn")
	
	cur_index = cur_index + 1
	if (cur_index > max) then
		cur_index = 1
	end
	next_index = cur_index + 1

	if (next_index > max) then
		next_index = 1
	end
	
	count = count + 1
	if (count == 3) then
		-- show a warning
		data = {}
		if (warning == 0) then
			data["message_layer.phone_control.grd_hidden"] = 1
			data["message_layer.car.grd_hidden"] = 0
			data["message_layer.warning_gas_control.grd_hidden"] = 0
			warning = 1
		else
			data["message_layer.phone_control.grd_hidden"] = 0
			data["message_layer.car.grd_hidden"] = 1
			data["message_layer.warning_gas_control.grd_hidden"] = 1
			warning = 0
		end
		gre.set_data(data)
		gre.send_event("show_warning")
		count = 0
	end
end
