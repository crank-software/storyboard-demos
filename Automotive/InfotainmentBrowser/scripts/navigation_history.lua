local favorites_list = {}
local history_list = {}
local category_list = {}


function navi_init()
	navi_favorite_add("The Barley Mow", "March Road", 10, 10)
	navi_favorite_add("Black Cat Bistro", "428 Preston St.", 10, 10)
	navi_favorite_add("Crank Software Inc.", "4017 Carling Ave.", 10, 10)
	navi_favorite_add("Scotia Bank Pace", "1000 Palladium Dr", 10, 10)
	navi_favorite_add("Fraser Cafe", "7 Springfield Rd.", 10, 10)
	navi_favorite_add("Rebec and Kroes", "2679 Alta Vista Dr.", 10, 10)
	navi_favorite_add("The Whalesbone Oyster Bar", "430 Bank St.", 10, 10)
	navi_favorite_add("Chelsea Pub", "238 Old Chelsea Road", 10, 10)
	navi_favorites_show()

	navi_history_add("Rebec and Kroes", "2679 Alta Vista Dr.", 10, 10)
	navi_history_add("Cora", "4055 Carling Ave", 10, 10)
	navi_history_add("The Barley Mow", "March Road", 10, 10)
	navi_history_add("Chelsea Pub", "238 Old Chelsea Road", 10, 10)
	navi_history_add("Crank Software", "4017 Carling Ave.", 10, 10)
	navi_favorite_add("Scotia Bank Pace", "1000 Palladium Dr", 10, 10)
	navi_history_show()

	navi_poi_show()
end

function navi_history_add(name, address, date, lat, long)
	local entry = {}
	
	entry["name"] = name
	entry["address"] = address
	entry["lat"] = lat
	entry["long"] = long

	table.insert(history_list, 1, entry)
end

function navi_favorite_add(name, address, lat, long)
	local entry = {}
	
	entry["name"] = name
	entry["address"] = address
	entry["lat"] = lat
	entry["long"] = long

	table.insert(favorites_list, 1, entry)
end

function navi_favorites_show()
	local i = 1
	local data = {}
	local table_base = "navigation_favorites_layer.navigation_favorites_list"
	
	while i <= table.maxn(favorites_list) do
		data[table_base..".name."..i..".1"] = favorites_list[i].name
		data[table_base..".address."..i..".1"] = favorites_list[i].address
		--data[table_base..".icon."..i..".1"] = favorites_list[i].icon		
		i = i + 1
	end	
	data[table_base..".rows"] = i - 1
	gre.set_data(data)
	gre.send_event_target("list_resize", "navigation_favorites_list")
end

function navi_history_show(mapargs)
	local i = 1
	local data = {}
	local table_base = "navigation_history_layer.navigation_history_list"
	
	while i <= table.maxn(history_list) do
		data[table_base..".name."..i..".1"] = history_list[i].name
		data[table_base..".address."..i..".1"] = history_list[i].address
		--data[table_base..".icon."..i..".1"] = history_list[i].icon		
		i = i + 1
	end	
	data[table_base..".rows"] = i - 1
	gre.set_data(data)
	gre.send_event_target("list_resize", "navigation_history_list")
end

local last_index = 0

function cb_favorites_select(mapargs)
	highlight_track("navigation_favorites_layer.navigation_favorites_list", mapargs.context_row, 1)
end

function cb_history_select(mapargs)
	highlight_track("navigation_history_layer.navigation_history_list", mapargs.context_row, 1)
end
