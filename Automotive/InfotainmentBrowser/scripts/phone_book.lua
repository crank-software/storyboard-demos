
local phone_book = {}
local recent_callers = {}
local call_time = 0

function phone_book_read(fname)
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

function phone_book_load(fname)
	local i = 1
	local data = {}
	local table_base = "contacts_layer.contacts_table"
	local last_char = nil
	
	phone_book = phone_book_read(gre.SCRIPT_ROOT.."/"..fname)
	while i <= table.maxn(phone_book) do
		--print(i.." "..phone_book[i].name)
		data[table_base..".name."..i..".1"] = phone_book[i].name
		data[table_base..".number."..i..".1"] = phone_book[i].number
		c = string.sub(phone_book[i].name, 1, 1)
		if (last_char == nil or last_char ~= c) then
			data[table_base..".fill_alpha."..i..".1"] = 255
			data[table_base..".alpha_image."..i..".2"] = "images/contact_alpha/"..string.upper(c).."-1.png"
		else
			data[table_base..".fill_alpha."..i..".1"] = 0
			data[table_base..".alpha_image."..i..".2"] = ""
		end
		last_char = c
		i = i + 1
	end	
	gre.set_data(data)
	
	local dk_data = {}
	dk_data["rows"] = i - 1
	gre.set_table_attrs(table_base, dk_data)   	
	
end

function recent_calls_load(fname)
	local i = 1
	local data = {}
	local table_base = "recent_layer.recent_table"
	local last_char = nil
	
	recent_callers = phone_book_read(gre.SCRIPT_ROOT.."/"..fname)
	while i <= table.maxn(recent_callers) do
		--print(i.." "..recent_callers[i].name)
		data[table_base..".name."..i..".2"] = recent_callers[i].name
		data[table_base..".number."..i..".2"] = recent_callers[i].number
		data[table_base..".time."..i..".2"] = recent_callers[i].time
		data[table_base..".icon."..i..".1"] = recent_callers[i].icon
		i = i + 1
	end	
	gre.set_data(data)
	
	local dk_data = {}
	dk_data["rows"] = i - 1
	gre.set_table_attrs(table_base, dk_data)  
end

local last_contact_hlight_index = {}

function highlight_contact(table, trkid, image)
	local data = {}
	
	if (last_contact_hlight_index[table] ~= trkid) then
		data[table..".highlight."..trkid..".1"] = image
		if (last_contact_hlight_index[table] ~= nil) then
			data[table..".highlight."..last_contact_hlight_index[table]..".1"] = ""
		end
		last_contact_hlight_index[table] = trkid
		gre.set_data(data)
	end
end

function unhighlight_contact(table)
	local data = {}
	
	if (last_contact_hlight_index[table] ~= nil) then
		data[table..".highlight."..last_contact_hlight_index[table]..".1"] = ""
	end
	gre.set_data(data)
	last_contact_hlight_index[table] = nil
end

function cb_phone_select(mapargs)
	local data = {}
	local words = {}

	highlight_track(mapargs.table, mapargs.context_row, 2)
	--highlight_contact(mapargs.table, mapargs.context_row, mapargs.image)
	data["cur_contact_photo"] = recent_callers[mapargs.context_row].lgicon
	for word in recent_callers[mapargs.context_row].name:gmatch("%w+") do table.insert(words, word) end
	data["cur_contact_firstname"] = words[1]
	data["cur_contact_lastname"] = words[2]
	gre.set_data(data)
end

function cb_contact_select(mapargs)
	local data = {}
	local words = {}

	highlight_track(mapargs.table, mapargs.context_row, 1)
	--highlight_contact(mapargs.table, mapargs.context_row, mapargs.image)
	data["cur_contact_photo"] = phone_book[mapargs.context_row].icon
	data["contact_details_layer.contact_email.email"] = phone_book[mapargs.context_row].email

	for word in phone_book[mapargs.context_row].name:gmatch("%w+") do table.insert(words, word) end
	data["cur_contact_firstname"] = words[1]
	data["cur_contact_lastname"] = words[2]
	data["phone_contacts_s.contact_details_layer.grd_hidden"] = 0	
	gre.set_data(data)
end

function cb_contact_clear(mapargs)
	local data = {}
	local words = {}

	unhighlight_contact(mapargs.table)
	data["phone_contacts_s.contact_details_layer.grd_hidden"] = 1
	gre.set_data(data)
end

function SecondsToClock(nSeconds)
	if nSeconds == 0 then
		--return nil;
		return "00:00:00";
	else
		nHours = string.format("%02.f", math.floor(nSeconds/3600));
		nMins = string.format("%02.f", math.floor(nSeconds/60 - (nHours*60)));
		nSecs = string.format("%02.f", math.floor(nSeconds - nHours*3600 - nMins *60));
		return nHours..":"..nMins..":"..nSecs
	end
end

function cb_phone_timer(mapargs)
	local data = {}
	
	call_time = call_time + 1
	data["cur_call_time"] = SecondsToClock(call_time)	
	gre.set_data(data)
end

function cb_reset_phone_timer(mapargs)
	call_time = 0
end


