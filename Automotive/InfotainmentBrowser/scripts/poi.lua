
local poi_bank = {["Royal Bank"]="123 Bank St", ["TD Bank"]="123 Bank St", ["Scotia Bank"]="123 Bank St" }
local poi_bar = {["Royal Oak"]="123 Bar St",}
local poi_airport = {["Ottawa International"]="123 Plane St",}
local poi_parks = {["Major's Hill"]="123 Park St",}
local poi_restaurants = {["Fraser Cafe"]="123 Food St",}
local poi_shopping = {["Bayshore Shopping Center"]="123 Money St",}
local poi_hotel = {["Brookstreet"]="123 Sleepy St",}
local poi_fuel = {["Esso"]="123 Gas St",}

local poi_list = {
	["Bank"] = poi_bank,
	["Bar/Pub"] = poi_bar,
	["Airport"] = poi_airport,
	["Public Parks"] = poi_parks,
	["Restaurants"] = poi_restaurants,
	["Shopping"] = poi_shopping,
	["Hotels"] = poi_hotel,
	["Fuel"] = poi_fuel,
}

local cur_category = nil

function navi_poi_show()
	local i = 1
	local data = {}
	local table_base = "category_list.navigation_category_list"

	for name,table in pairs(poi_list) do
		data[table_base..".name."..i..".1"] = name
		i = i + 1
	end
	data[table_base..".rows"] = i - 1
	gre.set_data(data)
	gre.send_event_target("list_resize", "navigation_category_list")
end

function navi_category_select(mapargs)
	local data = {}
	local table_base = "category_list.navigation_category_list"
	local key = table_base..".name."..mapargs.context_row..".1"
	local poi_base = "nvaigation_poi_layer.navigation_poi_list"
	print("select")
	data = gre.get_data(key)
	cur_category = poi_list[data[key]]
	
	-- fill the table
	i = 1
	data = {}
	for name,table in pairs(cur_category) do
	print(name)
		data[poi_base..".name."..i..".1"] = name
		i = i + 1
	end
	data[poi_base..".rows"] = i - 1
	gre.set_data(data)
	gre.send_event_target("list_resize", "navigation_poi_list")
end

function cb_category_select(mapargs)
	local data = {}
	local gdata = {}
	local table_base = "category_list.navigation_category_list"
	local key = table_base..".name."..mapargs.context_row..".1"
	local poi_base = "nvaigation_poi_layer.navigation_poi_list"

	gdata = gre.get_data(key)
	cur_category = poi_list[gdata[key]]
	
	-- fill the table
	i = 1
	for name,a in pairs(cur_category) do
	print(name)
		data[poi_base..".name."..i..".1"] = name
		data[poi_base..".address."..i..".1"] = a
		i = i + 1
	end
	data[poi_base..".rows"] = i - 1
	data["nvaigation_poi_layer.poi_category_title.text"] = gdata[key]
	gre.set_data(data)
	gre.send_event_target("list_resize", "navigation_poi_list")
end

function cb_poi_select(mapargs)
	highlight_contact(mapargs.table, mapargs.context_row, mapargs.image)
end

function cb_poi_clear(mapargs)
	unhighlight_contact(mapargs.table)
end
