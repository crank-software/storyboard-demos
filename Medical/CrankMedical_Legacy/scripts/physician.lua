--[[
Copyright 2012, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]

function cb_select_physician(mapargs)
	local data = {}
	local t_info = {}

	t_info = gre.get_table_attrs("dr_table","active_row")	
	local name = "physician_select_layer.dr_table.name."..t_info["active_row"]..".1"
	t_info = gre.get_data(name)

	data["green_bar_layer.attending_physician.text"] = t_info[name]
	gre.set_data(data)
end



