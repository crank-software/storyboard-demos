require "app_list"
local index=nil
local timeout_timer = nil
local idle_status=0
local app_screen_flag=0
function cb_load_list(mapargs) 
	local data = {}
	
	data["thumbnail_layer.thumb_photo.image"] = ""
	data["thumbnail_layer.app_title.text"] = ""
	data["thumbnail_layer.app_description.text"] = ""
	data["thumbnail_layer.play_btn.grd_hidden"] = 1	
	
	for i=1, table.maxn(app_list) do
		data["table_layer.app_table.text."..i..".1"] = app_list[i].name
	end
	gre.set_data(data)
	
	data = {}
	data["rows"] = table.maxn(app_list) 
	gre.set_table_attrs("table_layer.app_table", data)
end

local app_select = 1

function cb_select_app(mapargs)
	local data = {}
	
	index = mapargs.context_row
	
	data["thumbnail_layer.thumb_photo.image"] = app_list[index].image
	data["thumbnail_layer.app_title.text"] = app_list[index].name
	data["thumbnail_layer.app_description.text"] = app_list[index].description
	data["thumbnail_layer.play_btn.grd_hidden"] = 0

	app_select = index
	
	for i=1, table.maxn(app_list) do
		if i == app_select then
			data["table_layer.app_table.image."..i..".1"] = "images/cell_press.png"
		else
			data["table_layer.app_table.image."..i..".1"] = "images/cell_reg.png"
		end	
	end
	gre.set_data(data)	
	
	
end

function cb_timeout(mapargs)
	idle_status=0
	if ( timeout_timer ~= nil ) then
		gre.timer_clear_timeout(timeout_timer)
	end
	timeout_timer=gre.timer_set_timeout(cb_cycle,24000)
end

function cb_cycle(mapargs)
	local data={}

	if(app_screen_flag==0)then
		gre.send_event("go_to_app_screen")
		data.context_row=1
		cb_select_app(data)
	end

	if (idle_status==1) then
		data.context_row=index+1
		if(data.context_row==4)then
			data.context_row=1
		end
		cb_select_app(data)

	end
	timeout_timer=gre.timer_set_timeout(cb_cycle,6000)		
	idle_status=1

end

function cb_launch_app(mapargs) 
	local data={}
	
	data["model"] = app_list[app_select].gapp
	gre.send_event_data("gre.load_app", "1s0 model", data)
	gre.quit()
end

function cb_app_screen()

app_screen_flag=1

end

cb_timeout()