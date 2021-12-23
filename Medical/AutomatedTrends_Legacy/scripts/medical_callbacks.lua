local menu_state=0
local info=0
local button_down=5
require("medical_graph")

function cb_menu_check(mapargs)
	if(menu_state ==1) then
		gre.send_event("close_tabs")
		menu_state=0
		local res = gre.timer_set_timeout( cb_toggle_info , 220)	  --wait for the animation to finish then send over to toggle info
	else
		cb_toggle_info()
	end

end

function cb_menu_touch(mapargs)
	local data={}
	data= gre.get_data("tabs_state")
	if (data["tabs_state"]==0) then
		gre.send_event("play_tabs")
	else
		gre.send_event("hide_tabs")
	end
end



function cb_toggle_info(mapargs) 
	if (info==0)then
		gre.send_event("show_info")
		info=1
	else
		gre.send_event("hide_info")
		info=0
	end
end

function cb_bt_click(mapargs) 

	local data={}
	for i=1,7 do
		data["body_temp_hourly_layer.select_temp_"..i..".alpha"]=0
	end

	data[mapargs.context_control..".alpha"]=51
	gre.set_data(data)


end



function cb_bg_click(mapargs) 

	local data=gre.get_data(mapargs.context_control..".y_value")
	for i=1,6 do
		data["blood_glucose_table_layer.select_glucose_"..i..".alpha"]=0
	end

	local num= string.sub(mapargs.context_control,#mapargs.context_control) --get the last character in mapargs.context_control
	data["blood_glucose_table_layer.glucose_select_control.x_to"]=130+66*num
	data["blood_glucose_table_layer.glucose_select_control.y_to"]=data[mapargs.context_control..".y_value"]
	data[mapargs.context_control..".alpha"]=51

	gre.set_data(data)

	gre.send_event("glucose_anim")
end



function cb_toggle_click(mapargs) 
	local exploded=explode(".",mapargs.context_control)--get the last name of the button
	local touched=string.gsub(exploded[#exploded],"control","sc")--replace "control" with "sc"
	local data=gre.get_data("tabs_state")
	data["screen_to"]=touched
	gre.set_data(data)

	if(data["tabs_state"]==0)then
		gre.send_event("switch_screen")
	else
		gre.send_event("hide_first")
		print("Gotta Hide em all!")
	end
	button_down=tonumber(mapargs.down)
	cb_toggle(mapargs)
end

function cb_toggle(mapargs)
	local buttons={"vitals2_layer.blood_pressure_control","vitals2_layer.RPM_control","vitals2_layer.blood_oxygen_control","vitals2_layer.body_temp_control",""}
	local data={}
	for i=1,4 do
		data[buttons[i]..".image"]="images/temp_up.png"
	end
	if (mapargs.context_control~="top_bar_layer.home_btn") then
		local pressed=buttons[button_down]
		data[pressed..".image"]="images/temp_down.png"
	else
		button_down=5

	end
	gre.set_data(data)
end


function cb_bp_press(mapargs) 
	local ev_data = mapargs["context_event_data"]
	local x= ev_data["x"]
	local data={}

	--print(mapargs.context_screen)
	if (mapargs.context_screen=="blood_pressure_sc")then
		local sys={125,140,126,130,135,124,120,119,120,118,126}
		local dia={77,90,80,79,78,64,76,76,64,77,80}
		local pressed=math.ceil((x-233)/31)
		if (pressed==0 or pressed>11)then
			data["blood_pressure_table_layer.bp_alpha"]=0
			data["blood_pressure_table_layer.bp_sel"]=210
		else
			data["blood_pressure_table_layer.bp_sel"]=(pressed-1)*31+233
			data["blood_pressure_table_layer.bp_alpha"]=51

		end
		data["blood_pressure_right_layer.systolic_reading.text"]=sys[pressed]
		data["blood_pressure_right_layer.diastolic_reading.text"]=dia[pressed]

		gre.set_data(data)
		gre.send_event("bp_anim")
	


		elseif(mapargs.context_screen=="body_temp_sc") then
			local pressed=math.ceil((x-184)/58)	
			if (pressed >7) or (pressed<1) then
				data["body_temp_table_layer.bt_sel"]=184
				data["body_temp_table_layer.bt_alpha"]=0
			else
				data["body_temp_table_layer.bt_sel"]=58*(pressed-1)+184
				data["body_temp_table_layer.bt_alpha"]=51
			end
			gre.set_data(data)
			gre.send_event("bt_anim")


		elseif(mapargs.context_screen=="RPM_sc") then
			local readings={21,17,20,17,20,16}
			local pressed=math.ceil((x-233)/56)	
			if (pressed >6) or (pressed<1) then
				data["RPM_table_layer.rpm_sel"]=0
				data["RPM_right_side_layer.RPM_value.text"]=16
				data["RPM_table_layer.rpm_alpha"]=0
			else
				data["RPM_table_layer.rpm_sel"]=56*(pressed-1)+233
				data["RPM_table_layer.rpm_alpha"]=51
				data["RPM_right_side_layer.RPM_value.text"]=readings[pressed]
			end
			gre.set_data(data)
			gre.send_event("rpm_anim")

		elseif(mapargs.context_screen=="blood_oxygen_sc") then
			local oxy={99,96,97,98,98,96,94,95,96,95,98}
			local times={"11h00","11h30","12h00","12h30","13h00","13h30","14h00","14h30","15h00","15h30","16h00"}
			local sel={229,259,289,320,351,383,413,443,474,505,535}
			local pressed=math.ceil((x-225)/30)
		
			if (pressed<1) or (pressed>11)then
				data["blood_oxy_layer.bo_alpha"]=0
				data["blood_oxy_layer.bo_sel"]=210

			else
				local percent=oxy[pressed]/100
				data["blood_oxy_layer.bo_sel"]=sel[pressed]
				data["blood_oxy_layer.bo_alpha"]=51
				data["blood_oxy_right_layer.time1.text"]=times[pressed]
				data["blood_oxy_right_layer.blood_ox_value1.text"]=oxy[pressed]
				data["blood_oxy_right_layer.chart_fill.points"]=get_arc_points(0,360*percent,145,145)
			end
			gre.set_data(data)
			gre.send_event("bo_anim")
		
	end

end


function explode(d,p) -- helper function to add split functionality for strings.
    local t, ll
    t={}
    ll=0
    if(#p == 1) then return {p} end
        while true do
        	l=string.find(p,d,ll,true) -- find the next d in the string
	        if l~=nil then -- if "not not" found then..
	            table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
	            ll=l+1 -- save just after where we found it for searching next time.
	        else
	            table.insert(t, string.sub(p,ll)) --Save whats left in our array.
	        break --Break at end, as it should be, according to the lua manual.
	    end
    end
    return t
end


function cb_exit(mapargs)
	local data={}
	data["model"]=gre.SCRIPT_ROOT.."/../../../launcher.gapp"
	gre.send_event_data("gre.load_app", "1s0 model", data)
	gre.quit()
end

function cb_menu_press(mapargs) 
-- Your code goes here ...
end

local medical_index = 0

function medical_run_demo(mapargs)
	local data = {}

	medical_index = medical_index + 1
	data["down"] = medical_index
	if (medical_index == 1) then
		data["context_control"] = "blood_pressure_control"
	elseif (medical_index == 2) then
		data["context_control"] = "RPM_control"
	elseif (medical_index == 3) then
		data["context_control"] = "blood_oxygen_control"
	elseif (medical_index == 4) then
		data["context_control"] = "body_temp_control"
	else
		gre.send_event("medical_complete")
		medical_index = 0
	end

	if (medical_index < 5) then
		cb_toggle_click(data)
	end
end

