local turn1 = {
icon = "images/navi_arrows/nav_half_left.png",
direction = "300m Turn Left",
street = "March Road",
next = "400m"
}

local turn2 = {
icon = "images/navi_arrows/nav_turn_right.png",
direction = "400m Turn Right",
street = "Carling Avenue",
next = "500m"
}

local turn3 = {
icon = "images/navi_arrows/nav_stay_right.png",
direction = "300m Turn Left",
street = "Richard Road",
next = "200m"
}

local turn4 = {
icon = "images/navi_arrows/nav_exit.png",
direction = "500m Exit Right",
street = "Leggit Street",
next = "400m"
}

local turns = {
turn1,
turn2,
turn3,
turn4,
}

local messages = {
	"phone", "gas", "engine",
}

local cur_index = 1
local next_index = 2
local msg_index = 1

function cb_turn_by_turn(mapargs)
	local max = table.maxn(turns)
	local msg_max = table.maxn(messages)
	local data = {}
	local m = {}
			
	if (next_index == 1) then
		m["message"] = "navigation"
		gre.send_event_data("show_message", "1s0 message", m)
	end
	
	data["navigation_l.directional_arrow.image"] = turns[cur_index].icon
	data["navigation_l.distance_direction.text"] = turns[cur_index].direction
	data["navigation_l.destination_name.text"] = turns[cur_index].street
	
	data["navigation_l.next_directional_arrow.image"] = turns[next_index].icon
	data["navigation_l.next_distance.text"] = turns[cur_index].next

	-- reset controls
	data["navigation_l.directional_arrow.alpha_value"] = 255
	data["navigation_l.next_directional_arrow.grd_x"] = 613
	data["navigation_l.next_directional_arrow.grd_y"] = 356
	data["navigation_l.next_directional_arrow.grd_height"] = 26
	data["navigation_l.next_directional_arrow.grd_width"] = 27

	gre.set_data(data)
	--gre.send_event("show_turn")
	
	cur_index = cur_index + 1
	if (cur_index > max) then
		cur_index = 1
	end
	next_index = cur_index + 1
	if (next_index > max) then
		-- send a message
		m["message"] = messages[msg_index]
		--gre.send_event_data("show_message", "1s0 message", m)
		msg_index = msg_index + 1
		if (msg_index > msg_max) then
			msg_index = 1
		end
		next_index = 1
	end
end
