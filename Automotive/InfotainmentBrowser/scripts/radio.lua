local radio_presets = {}

function radio_preset_read(fname)
	local fp = assert(io.open (fname))
	local index = 1
	local entry = {}
	local data = {}
	
	local line=fp:read()
	local headers=ParseCSVLine(line,",") 
	--for i,v in ipairs(headers) do print(i,v) end

	for line in fp:lines() do
		local cols=ParseCSVLine(line,",")
		for i,v in ipairs(headers) do
   			entry[v] = cols[i]
   			--print(v.. " " ..cols[i])
   		end
   		data[index] = entry
   		index = index + 1
   		entry = {}
	end
	
	return data
end

function radio_preset_load(fname)
	local i = 1
	local data = {}
	local table_base = "radio_list_layer.radio_preset_list"
	local last_char = nil
	
	radio_presets = phone_book_read(gre.SCRIPT_ROOT.."/"..fname)
	while i <= table.maxn(radio_presets) do
		data[table_base..".name."..i..".1"] = radio_presets[i].name
		data[table_base..".station."..i..".1"] = radio_presets[i].station
		i = i + 1
	end	

	gre.set_data(data)

	local dk_data = {}
	dk_data["rows"] = i - 1
	gre.set_table_attrs(table_base, dk_data)  

	cb_select_station()
end

function cb_radio_select(mapargs)
	local name = "radio_layer.radio_name.text"
	local freq = "radio_layer.radio_frequency.text"
end

local radio_selection = 1

function cb_select_station(index)
	local data = {}
	
	data["radio_layer.radio_name.text"] = radio_presets[radio_selection].name
	data["radio_layer.radio_frequency.text"] = radio_presets[radio_selection].station
	gre.set_data(data)
	
	highlight_track('radio_list_layer.radio_preset_list', radio_selection, 1)
end

function cb_radio_table_press(mapargs)
	radio_selection = mapargs.context_row
	cb_select_station()
end

function cb_radio_next(mapargs)
	radio_selection = radio_selection + 1
	if (radio_selection >= table.maxn(radio_presets)) then
		radio_selection = table.maxn(radio_presets)
	end
	cb_select_station()
end

function cb_radio_prev(mapargs)
	radio_selection = radio_selection - 1
	if (radio_selection == 0) then
		radio_selection = 1
	end
	cb_select_station()
end
