local ACTIVE_ELEVATION = 1
local  SMULTI = (272 / 480)

function select_elevation(mapargs)
	local index = mapargs.context_row
	local data = {}
	
	local elsel = gre.animation_create(20, 1)
	
	data["key"] = "Customize.elevation_table.sel_alpha."..index..".1"
	data["rate"] = "easein"
	data["duration"] = 200
	data["offset"] = 400
	data["from"] = 0
	data["to"] = 100
	gre.animation_add_step(elsel, data)
	
	data["key"] = "Customize.elevation_table.sel_alpha."..index..".1"
	data["rate"] = "easein"
	data["duration"] = 350
	data["offset"] = 250
	data["from"] = 100
	data["to"] = 0
	gre.animation_add_step(elsel, data)
	
	data["key"] = "Customize.elevation_table.sel_left."..index..".1"
	data["rate"] = "easeinout"
	data["duration"] = 600
	data["offset"] = 0
	data["from"] = math.floor(-75 * SMULTI) + 1
	data["to"] = math.floor(-175 * SMULTI) + 1
	gre.animation_add_step(elsel, data)
	
	data["key"] = "Customize.elevation_table.sel_right."..index..".1"
	data["from"] = math.floor(75 * SMULTI) 
	data["to"] = math.floor(175 * SMULTI)  
	gre.animation_add_step(elsel, data)
	
	data["key"] = "Customize.elevation_table.sel_width."..index..".1"
	data["from"] = math.floor(135 * SMULTI)
	data["to"] = math.floor(400 * SMULTI)
	gre.animation_add_step(elsel, data)	

	
	gre.animation_trigger(elsel)

	data["Customize.select_elevation_button.img"] = "images/elevation_0"..index..".png"
	ACTIVE_ELEVATION = index
	
	gre.set_data(data)
	
end

function set_elevation_profile(mapargs)

	local data = {}
	data["RunningScreen.elevation_profile.running_elevation"] = "images/elevation_0"..ACTIVE_ELEVATION..".png"
	data["RunningScreen.elevation_profile.running_elevation_white"] = "images/elevation_0"..ACTIVE_ELEVATION.."_white.png"
	gre.set_data(data)
end

function switch_elevation(mapargs) 
	customize_elevation()
end
function switch_customize(mapargs) 
	customize_run()
end

--Customize screen toggle selections
local CUSTOMIZE_SCREEN = 1

function customize_trail(mapargs)
	local data = {}
	data["Customize.select_location_button.alpha"] = 100
	data["Customize.select_elevation_button.sel_alpha"] = 0
	data["Customize.run_settings_button.alpha"] = 0
	gre.set_data(data)
	
	if not (CUSTOMIZE_SCREEN == 1)then
		hide_toggle()
		CUSTOMIZE_SCREEN = 1
		customize_toggle()
	end
end

function customize_elevation(mapargs)
	local data = {}
	data["Customize.select_location_button.alpha"] = 0
	data["Customize.select_elevation_button.sel_alpha"] = 100
	data["Customize.run_settings_button.alpha"] = 0
	gre.set_data(data)
	
	if not (CUSTOMIZE_SCREEN == 2)then
		hide_toggle()
		CUSTOMIZE_SCREEN = 2
		customize_toggle()
	end
end

function customize_run(mapargs)
	local data = {}
	data["Customize.select_location_button.alpha"] = 0
	data["Customize.select_elevation_button.sel_alpha"] = 0
	data["Customize.run_settings_button.alpha"] = 100
	gre.set_data(data)
	
	if not (CUSTOMIZE_SCREEN == 3)then
		hide_toggle()
		CUSTOMIZE_SCREEN = 3
		customize_toggle()
	end
end



--SHOW THE TOGGELED CUSTOMIZE SCREEN AND ANIMATIONS
function customize_toggle(mapargs)
	local data = {}
	
--	local bg = gre.animation_create(60, 1)
	
--	data["key"] = "Customize.settings_bg.grd_width"
--	data["rate"] = "easeinout"
--	data["duration"] = 400
--	data["offset"] = 400
--	data["from"] = 0
--	data["to"] = 460
--	gre.animation_add_step(bg, data)
	
--	gre.animation_trigger(bg)
	
	if (CUSTOMIZE_SCREEN == 1)then
		data["hidden"] = 0
		gre.set_control_attrs("Customize.availble_path", data)
		gre.set_control_attrs("Customize.unavaible_path", data)
		gre.set_control_attrs("Customize.unavaible_path_2", data)
		gre.set_control_attrs("Customize.trail_selector", data)
		
		data["hidden"] = 1
		gre.set_control_attrs("Customize.elevation_selector", data)
		gre.set_control_attrs("Customize.elevation_table", data) 
		
		data["hidden"] = 1
		gre.set_control_attrs("Customize.slider_age", data)
		gre.set_control_attrs("Customize.slider_weight", data)
		gre.set_control_attrs("Customize.slider_intensity", data) 
		gre.set_control_attrs("Customize.slider_time", data)		
		
		local fadein = gre.animation_create(60, 1)
		local animdata = {}
		
		--Main Path Animation In
		animdata["key"] = "Customize.availble_path.main_alpha"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 400
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.availble_path.fill_alpha"
		animdata["to"] = 191
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.availble_path.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 395
		animdata["from"] = math.floor(-3 * SMULTI)
		animdata["to"] = math.floor(7 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		
		--Unavailbe Path Animation In
		animdata["key"] = "Customize.unavaible_path.main_alpha"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 455
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.unavaible_path.fill_alpha"
		animdata["to"] = 191
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.unavaible_path.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 450
		animdata["from"] = math.floor(112 * SMULTI)
		animdata["to"] = math.floor(122 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		
		--Unavailbe Path2 Animation In
		animdata["key"] = "Customize.unavaible_path_2.main_alpha"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 510
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.unavaible_path_2.fill_alpha"
		animdata["to"] = 191
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.unavaible_path_2.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 500
		animdata["from"] = math.floor(228 * SMULTI)
		animdata["to"] = math.floor(238 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		
		gre.animation_trigger(fadein)
		
	end
	
	if (CUSTOMIZE_SCREEN == 2)then
		data["hidden"] = 0
		gre.set_control_attrs("Customize.elevation_selector", data)
		gre.set_control_attrs("Customize.elevation_table", data) 
		
		
		data["hidden"] = 1
		gre.set_control_attrs("Customize.availble_path", data)
		gre.set_control_attrs("Customize.unavaible_path", data)
		gre.set_control_attrs("Customize.unavaible_path_2", data)
		gre.set_control_attrs("Customize.trail_selector", data)
		
		data["hidden"] = 1
		gre.set_control_attrs("Customize.slider_age", data)
		gre.set_control_attrs("Customize.slider_weight", data)
		gre.set_control_attrs("Customize.slider_intensity", data) 
		gre.set_control_attrs("Customize.slider_time", data) 
		
		
		
		local fadein = gre.animation_create(60, 1)
		local animdata = {}
		
		for i=1, 6 do
			animdata["key"] = "Customize.elevation_table.main_alpha."..i..".1"
			animdata["rate"] = "easein"
			animdata["duration"] = 150
			animdata["offset"] = 400 + (35*i)
			animdata["from"] = 0
			animdata["to"] = 255
			gre.animation_add_step(fadein, animdata)	
		end
		
		gre.animation_trigger(fadein)
			
	end
	
	if (CUSTOMIZE_SCREEN == 3)then
		data["hidden"] = 0
		gre.set_control_attrs("Customize.slider_age", data)
		gre.set_control_attrs("Customize.slider_weight", data)
		gre.set_control_attrs("Customize.slider_intensity", data) 
		gre.set_control_attrs("Customize.slider_time", data) 
		
		data["hidden"] = 1
		gre.set_control_attrs("Customize.elevation_selector", data)
		gre.set_control_attrs("Customize.elevation_table", data) 
		
		
		data["hidden"] = 1
		gre.set_control_attrs("Customize.availble_path", data)
		gre.set_control_attrs("Customize.unavaible_path", data)
		gre.set_control_attrs("Customize.unavaible_path_2", data)
		gre.set_control_attrs("Customize.trail_selector", data)		
		
		local fadein = gre.animation_create(60, 1)
		local animdata = {}
		
		--slider time Animation In
		animdata["key"] = "Customize.slider_time.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 400
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.slider_time.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 395
		animdata["from"] = math.floor(24 * SMULTI)
		animdata["to"] = math.floor(33 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		--slider Intensity Animation In
		animdata["key"] = "Customize.slider_intensity.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 425
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.slider_intensity.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 420
		animdata["from"] = math.floor(104 * SMULTI)
		animdata["to"] = math.floor(113 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		--slider Weight Animation In
		animdata["key"] = "Customize.slider_weight.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 450
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.slider_weight.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 455
		animdata["from"] = math.floor(184 * SMULTI)
		animdata["to"] = math.floor(193 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		--slider Age Animation In
		animdata["key"] = "Customize.slider_age.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 475
		animdata["from"] = 0
		animdata["to"] = 255
		gre.animation_add_step(fadein, animdata)
		
		animdata["key"] = "Customize.slider_age.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 480
		animdata["from"] = math.floor(264 * SMULTI)
		animdata["to"] = math.floor(273 * SMULTI)
		gre.animation_add_step(fadein, animdata)
		
		gre.animation_trigger(fadein) 
	end
end
--HIDE THE TOGGELED CUSTOMIZE SCREEN AND ANIMATIONS
function hide_toggle(mapargs)
	local data = {}
	
--	local bg = gre.animation_create(60, 1)
	
--	data["key"] = "Customize.settings_bg.grd_width"
--	data["rate"] = "easeinout"
--	data["duration"] = 400
--	data["offset"] = 0
--	data["from"] = 460
--	data["to"] = 0
		
--	gre.animation_add_step(bg, data)
--	gre.animation_trigger(bg)
	
	if (CUSTOMIZE_SCREEN == 1)then
	
		local fadeout = gre.animation_create(60, 1)
		local animdata = {}
		
		--Main Path Animation Out
		animdata["key"] = "Customize.availble_path.main_alpha"
		animdata["rate"] = "easeout"
		animdata["duration"] = 250
		animdata["offset"] = 100
		animdata["from"] = 225
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.availble_path.fill_alpha"
		animdata["from"] = 191
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.availble_path.grd_y"
		animdata["rate"] = "easeout"
		animdata["duration"] = 225
		animdata["offset"] = 105
		animdata["from"] = math.floor(7 * SMULTI)
		animdata["to"] = math.floor(-3 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		--Unavailbe Path Animation Out
		animdata["key"] = "Customize.unavaible_path.main_alpha"
		animdata["rate"] = "easeout"
		animdata["duration"] = 250
		animdata["offset"] = 50
		animdata["from"] = 255
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.unavaible_path.fill_alpha"
		animdata["from"] = 191
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.unavaible_path.grd_y"
		animdata["rate"] = "easeout"
		animdata["duration"] = 225
		animdata["offset"] = 55
		animdata["from"] = math.floor(122 * SMULTI)
		animdata["to"] = math.floor(112 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		--Unavailbe Path 2 Animation Out
		animdata["key"] = "Customize.unavaible_path_2.main_alpha"
		animdata["rate"] = "easeout"
		animdata["duration"] = 250
		animdata["offset"] = 0
		animdata["from"] = 255
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.unavaible_path_2.fill_alpha"
		animdata["from"] = 191
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.unavaible_path_2.grd_y"
		animdata["rate"] = "easeout"
		animdata["duration"] = 225
		animdata["offset"] = 5
		animdata["from"] = math.floor(238 * SMULTI)
		animdata["to"] = math.floor(228 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		--HIDING THE CONTROLS AND SCHTUFF
		
		animdata["key"] = "Customize.availble_path.grd_hidden"
		animdata["rate"] = "linear"
		animdata["duration"] = 1
		animdata["offset"] = 251
		animdata["from"] = 0
		animdata["to"] = 1
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.unavaible_path.grd_hidden"
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.unavaible_path_2.grd_hidden"
		gre.animation_add_step(fadeout, animdata)
		
		gre.animation_trigger(fadeout)
	end
	
	if (CUSTOMIZE_SCREEN == 2)then
		data["hidden"] = 1
		gre.set_control_attrs("Customize.elevation_selector", data)
		--gre.set_control_attrs("Customize.elevation_table", data) 
		
		local fadeout = gre.animation_create(60, 1)
		local animdata = {}
		
		for i=1, 3 do
			animdata["key"] = "Customize.elevation_table.main_alpha."..(4-i)..".1"
			animdata["rate"] = "easein"
			animdata["duration"] = 150
			animdata["offset"] = 0 + (35*i)
			animdata["from"] = 255
			animdata["to"] = 0
			gre.animation_add_step(fadeout, animdata)	
		end
		
		animdata["key"] = "Customize.elevation_table.grd_hidden"
		animdata["rate"] = "linear"
		animdata["duration"] = 1
		animdata["offset"] = 200
		animdata["from"] = 0
		animdata["to"] = 1
		gre.animation_add_step(fadeout, animdata)	
		
		gre.animation_trigger(fadeout)
		
	end
	
	if (CUSTOMIZE_SCREEN == 3)then
		data["hidden"] = 1

		
		local fadeout = gre.animation_create(60, 1)
		local animdata = {}
		
		--slider time Animation In
		animdata["key"] = "Customize.slider_time.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 75
		animdata["from"] = 255
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_time.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 70
		animdata["from"] = math.floor(33 * SMULTI)
		animdata["to"] = math.floor(24 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		--slider Intensity Animation In
		animdata["key"] = "Customize.slider_intensity.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 50
		animdata["from"] = 255
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_intensity.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 45
		animdata["from"] = math.floor(113 * SMULTI)
		animdata["to"] = math.floor(104 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		--slider Weight Animation In
		animdata["key"] = "Customize.slider_weight.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 25
		animdata["from"] = 255
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_weight.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 20
		animdata["from"] = math.floor(193 * SMULTI)
		animdata["to"] = math.floor(184 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		--slider Age Animation In
		animdata["key"] = "Customize.slider_age.alpha_main"
		animdata["rate"] = "easein"
		animdata["duration"] = 250
		animdata["offset"] = 5
		animdata["from"] = 255
		animdata["to"] = 0
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_age.grd_y"
		animdata["rate"] = "easein"
		animdata["duration"] = 225
		animdata["offset"] = 0
		animdata["from"] = math.floor(273 * SMULTI)
		animdata["to"] = math.floor(264 * SMULTI)
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_age.grd_hidden"
		animdata["rate"] = "linear"
		animdata["duration"] = 1
		animdata["offset"] = 100
		animdata["from"] = 0
		animdata["to"] = 1
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_weight.grd_hidden"
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_intensity.grd_hidden"
		gre.animation_add_step(fadeout, animdata)
		
		animdata["key"] = "Customize.slider_time.grd_hidden"
		gre.animation_add_step(fadeout, animdata)

		gre.animation_trigger(fadeout) 
	end
end

--INCREASING AND DECREASING SPEED AND INCLINE

local SPEED = 5.1
local INCLINE = 6.5

function cb_reset_run_screen(mapargs)
  local data = {}
  
  SPEED = 5.1
  INCLINE = 6.5
  
  data["RunningScreen.speed_data.speed"] = SPEED
  data["RunningScreen.incline_data.incline"] = INCLINE
  gre.set_data(data)
 end
  

function increase_speed(mapargs)
	local data = {}
	if (SPEED < 14.9)then
		SPEED = SPEED + 0.1
		if(string.len(SPEED) < 3)then
			data["RunningScreen.speed_data.speed"] = SPEED..".0"
		else
			data["RunningScreen.speed_data.speed"] = SPEED
		end
	end
	gre.set_data(data)
end


function decrease_speed(mapargs)
	local data = {}
	if (SPEED > .1)then
		SPEED = SPEED - 0.1
		if(string.len(SPEED) < 3)then
			data["RunningScreen.speed_data.speed"] = SPEED..".0"
		else
			data["RunningScreen.speed_data.speed"] = SPEED
		end
	end
	gre.set_data(data)
end


function increase_incline(mapargs)
	local data = {}
	if (INCLINE < 15)then
		INCLINE = INCLINE + 0.5
		if(string.len(INCLINE) < 3)then
			data["RunningScreen.incline_data.incline"] = INCLINE..".0"
		else
			data["RunningScreen.incline_data.incline"] = INCLINE
		end
	end
	gre.set_data(data)
end


function decrease_incline(mapargs)
	local data = {}
	if (INCLINE > .5)then
		INCLINE = INCLINE - 0.5
		if(string.len(INCLINE) < 3)then
			data["RunningScreen.incline_data.incline"] = INCLINE..".0"
		else
			data["RunningScreen.incline_data.incline"] = INCLINE
		end
	end
	gre.set_data(data)
end

--SHOWING AND HIDING DETAILS

local DETAILS = 0
function details_toggle(mapargs)
	local data = {}
	
	if (DETAILS == 1)then
		DETAILS = 0
		gre.animation_trigger("show_details_reversed")
	elseif (DETAILS == 0)then
		DETAILS = 1
		gre.animation_trigger("show_details")
		data["hidden"] = 1
		gre.set_control_attrs("RunningScreen.info_toast", data)
	end
		
end

--HIDING AND SHOWING THE CUSOMIZATION TO WALK THE PERSON THROUGH IT

local ELEVATION_OPEN = 0
local CUSTOMIZE_OPEN = 0

function unlock_elevation(mapargs)
	if (ELEVATION_OPEN == 0)then
		gre.animation_trigger("unlock_elevation")	
		ELEVATION_OPEN = 1
	end
end

function unlock_customize(mapargs)
	if (CUSTOMIZE_OPEN == 0)then
		gre.animation_trigger("unlock_customize")
		local data = {}
		data["hidden"] = 1
		gre.set_control_attrs("Customize.start_run_greyed", data)	
		CUSTOMIZE_OPEN = 1
	end
end

function reset_customization(mapargs)
	local data = {}
	data["hidden"] = 0
	gre.set_control_attrs("Customize.start_run_greyed", data)	
	gre.set_control_attrs("Customize.elevation_greyed", data)
	gre.set_control_attrs("Customize.customize_greyed", data)
	
	ELEVATION_OPEN = 0
	CUSTOMIZE_OPEN = 0
	
	customize_trail()
end

function cb_start_home_video(mapargs)  
        --print("Start home screen video")
        os.execute(gre.SCRIPT_ROOT.."/run-home-video.sh &")
end                                            
          
function cb_start_trail_video(mapargs)                                 
        --print("Start home screen video")
        os.execute(gre.SCRIPT_ROOT.."/run-trail-video.sh &")
end

function cb_stop_video(mapargs)
    os.execute("killall gst-launch-1.0")
    os.execute("dd if=/dev/zero of=/dev/fb0")
end
