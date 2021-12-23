
local app_icons = {
	"MENU_NAV_layer.browser",
	"MENU_NAV_layer.nav",
	"MENU_NAV_layer.qnxapp",
	"MENU_NAV_layer.phone",
	"MENU_NAV_layer.settings",
	"MENU_NAV_layer.media",
	"MENU_NAV_layer.climate"
}

local app_names = {
	"vm",
	"climate",
	"media",
	"gnav",
	"phone",
	"browser",
	"apps"
	}
	

function cb_init_app_icons(mapargs)
	local data = {}
	local gdata = {}
	
	for i=1, table.maxn(app_icons) do
		gdata = {}
		gdata = gre.get_control_attrs(app_icons[i]) 
		print(app_icons[i].."  ("..gdata["x"].." , "..gdata["y"]..")")
		data[app_icons[i]..".x_orig"] = gdata["x"]
		data[app_icons[i]..".y_orig"] = gdata["y"]
		data[app_icons[i]..".x_grow"] = gdata["x"] - 64
		data[app_icons[i]..".y_grow"] = gdata["y"] - 59
	end
	gre.set_data(data)
end

local g_jogIndex = 1
local jogDelta = 7 -- num of tics of jog wheel to next item
local appMax = 7 -- num apps to rotate through

function cb_jog_wheel(mapargs)
	local data = {}
	local ev = mapargs["context_event_data"]
	
	--print("Jog Wheel : "..ev["value"])
	
	g_jogIndex = g_jogIndex + ev["value"]
	if g_jogIndex > (appMax * jogDelta) then
		g_jogIndex = appMax * jogDelta
	elseif g_jogIndex < 1 then
		g_jogIndex = 1
	end
	
	local focusIndex = math.floor(g_jogIndex / jogDelta)
	data["App_screen.Focus_Index"] = focusIndex
	gre.set_data(data)
	gre.send_event("Set_Focus")
end

function cb_appScreen_setup(mapargs)
	local data = {}
	local focusIndex = math.floor(g_jogIndex / jogDelta)
	data["App_screen.Focus_Index"] = focusIndex
	gre.set_data(data)
	gre.send_event("Set_Focus")
end

function cb_appLaunch_timer(mapargs)

	local index = math.floor(g_jogIndex / jogDelta)	
	if index == 0 then
		index = 1
	end
	print("Launch APP : "..app_names[index])	
	lqnx_pps.set("/pps/services/navigator/status", "mode", app_names[index])	
end

