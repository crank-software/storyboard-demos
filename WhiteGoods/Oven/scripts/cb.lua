local g_control = nil
local timeout_timer = nil
local preloads = {
  "images/temperature_bg.png",
  "images/Timer_bg.png",
  "images/red_01.png",
  "images/selector.png",
  "images/br_pizza.png",
  "images/br_focaccia.png",
  "images/des_muffin.png",
  "images/veg_potatoes.png",
  "images/des_pecan.png",
  "images/icn_oven.png",
  "images/MIA_1.png",
  "images/MIA_2.png",
  "images/MIA_4.png",
  "images/MIA_5.png",
}

function cb_init(mapargs)
	local data = {}
	local row = 0
	
	for n=180, 400, 5 do
		row = row + 1
		data["Temperature_layer.temperature_F.var_temp."..row..".1"] = tostring(n)
	end
	data["table_rows"] = row
	gre.set_data(data)	
	gre.send_event_target("resize_table","Temperature_layer.temperature_F")
	
	-- preload images
	for i=0,#preloads,1 do
	 gre.load_resource("image",preloads[i])
	 print(preloads[i])
	end
end



-- this function is called on motion events
function drag(mapargs)
	local ev = mapargs["context_event_data"];
	local pos = {}
	
	-- if no control selected just return
	if g_control == nil then
		return
	end
	
	--set postion to touch co-od (-34 to make it center on image)
	pos["y"] = ev["y"] -  34
	
	-- set the control to the new position
	gre.set_control_attrs(g_control, pos)
end

-- on any release event on the Screen
function release(mapargs)
	g_control = nil
end


function cb_menu_options(mapargs) 
	local dk_data = {}

	if mapargs.context_row == 2 then
    dk_data["temp_next"]="Timer_screen"
		dk_data["go_to_screen"]="Temperature_screen"
		dk_data["selected_mode"]="Bake"
	elseif mapargs.context_row == 3 then
		dk_data["go_to_screen"]="Presets_screen"
    dk_data["selected_mode"]="Presets"
	elseif mapargs.context_row == 4 then
    dk_data["temp_next"]="Summary_screen"
		dk_data["go_to_screen"]="Temperature_screen"
    dk_data["selected_mode"]="Preheat"
	end
	dk_data["selected_mode_image"] = ""
	gre.set_data(dk_data)
end

local _ON = 1
local _OFF = 0

function preheat_on(mapargs) 
	if mapargs.context_row == 4 then
	    local dv = {}
	    
		dv["temperature_next_back.preheat_to_summary.grd_active"]= _ON
		dv["temperature_next_back.preheat_to_summary.grd_opaque"]= _ON
		dv["temperature_next_back.preheat_to_summary.grd_hidden"]= _OFF
		dv["Summary_layer.summary_to_preheat.grd_active"]= _ON
		dv["Summary_layer.summary_to_preheat.grd_opaque"]= _ON
		dv["Summary_layer.summary_to_preheat.grd_hidden"]= _OFF
		
		gre.set_data(dv)
	end
end

function cb_shutdown_timer(mapargs) 
	if ( timeout_timer ~= nil ) then
		gre.timer_clear_timeout(timeout_timer)
	end
	timeout_timer=gre.timer_set_timeout(cb_exit,60000)		      
end

function cb_exit(mapargs) 
end

cb_shutdown_timer() --set up initial timeout timer


function cb_preset_select(mapargs) 
  local dk_data = {}
   
  if mapargs.context_row == 1 then
    dk_data["selected_mode"]="Preset\n Pizza"
    dk_data["selected_mode_image"] = "images/br_pizza.png"
  elseif mapargs.context_row == 2 then
    dk_data["selected_mode"]="Preset\n Foccacia"
    dk_data["selected_mode_image"] = "images/br_focaccia.png"
  elseif mapargs.context_row == 3 then
    dk_data["selected_mode"]="Preset\n Muffins"
    dk_data["selected_mode_image"] = "images/des_muffin.png"
  elseif mapargs.context_row == 4 then
    dk_data["selected_mode"]="Preset\n Potatoes"
    dk_data["selected_mode_image"] = "images/veg_potatoes.png"
  elseif mapargs.context_row == 5 then
    dk_data["selected_mode"]="Preset\n Pecan Pie"
    dk_data["selected_mode_image"] = "images/des_pecan.png"
  end
  gre.set_data(dk_data)
end
