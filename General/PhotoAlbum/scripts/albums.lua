local pressed=0
local init_press=nil
local timeout_timer = nil

local arc_album = {
	"arc_33.jpg", 
	"arc_boardwalk.jpg", 
	"arc_courtyard.jpg", 
	"arc_concept.jpg", 
	"arc_new_build.jpg", 
	"arc_palace.jpg", 
	"arc_pillars.jpg", 
	"arc_prague.jpg", 
	"arc_roof_top.jpg", 
	"arc_skyline.jpg", 
	"arc_tower.jpg", 
	"arc_washington.jpg"
	}
	
local bw_album = {
	"bw_alley.jpg",
	"bw_apple_store.jpg",
	"bw_beach.jpg",
	"bw_boats.jpg",
	"bw_dalmation.jpg",
	"bw_doodles.jpg",
	"bw_gas_stn.jpg",
	"bw_horses.jpg",
	"bw_horses2.jpg",
	"bw_kid_wall.jpg",
	"bw_love_love.jpg",
	"bw_umbrella.jpg"
	}
	
local nature_album = {
	"na_Li_river.jpg",
	"na_beach_sunset.jpg",
	"na_blue_forest.jpg",
	"na_field_sunset.jpg",
	"na_frozen_reeds.jpg",
	"na_grass_river.jpg",
	"na_man_mountain.jpg",
	"na_misty_mountain.jpg",
	"na_ripples.jpg",
	"na_snow_peak.jpg",
	"na_sun_dog.jpg",
	"na_trees.jpg"
	}

local portraits_album = {
	"po_child.jpg",
	"po_cold.jpg",
	"po_family.jpg",
	"po_gandalf.jpg",
	"po_hipster.jpg",
	"po_isolated.jpg",
	"po_makeup.jpg",
	"po_old_lady.jpg",
	"po_scarf.jpg",
	"po_sleeping.jpg",
	"po_swayze_man.jpg",
	"po_toddler.jpg"
	}
	
local vintage_album = {
	"vin_aeroplane.jpg",
	"vin_beach.jpg",
	"vin_camera.jpg",
	"vin_easter_card.jpg",
	"vin_esso_truck.jpg",
	"vin_fan.jpg",
	"vin_ferris_wheel.jpg",
	"vin_monocle.jpg",
	"vin_radio.jpg",
	"vin_reception.jpg",
	"vin_roller_skates.jpg",
	"vin_st_petersburg.jpg"
	}
	
local wildlife_album = {
	"w_cheetah.jpg",
	"w_dall_sheep.jpg",
	"w_elephant.jpg",
	"w_fox.jpg",
	"w_kangaroo.jpg",
	"w_lynx.jpg",
	"w_owl.jpg",
	"w_red_panda.jpg",
	"w_salamander.jpg",
	"w_turtles.jpg",
	"w_waterbuck.jpg",
	"w_wolf.jpg"
	}
	
local g_current_album = arc_album
local g_album_name = "architecture"
g_current_col = 1
	
function load_album(name, album)
	local data = {}
	
	g_current_album = album
	g_album_name = name 
	
	local tnum = table.maxn(album) * 3
	local x = 1

	for i=1, tnum do
		data["album.photos.image.1."..i] = "images/thumbs/"..name.."/"..album[x]
		x = x + 1
		if x > table.maxn(album) then
			x = 1
		end
	end
	gre.set_data(data)
end


function cb_album_select(mapargs)

	local col = mapargs.context_col % 6
	if col == 0 then
		col = 6
	end
	
	if col == 1 then
		load_album("architecture", arc_album)
	elseif col == 2 then
		load_album("bw", bw_album)
	elseif col == 3 then
		load_album("portraits", portraits_album)
	elseif col == 4 then
		load_album("wildlife", wildlife_album)
	elseif col == 5 then
		load_album("vintage", vintage_album)
	elseif col == 6 then
		load_album("nature", nature_album)
	end		

end

function cb_set_images(mapargs) 
	local data={}
	local col=g_current_col%12
	if col == 0 then
		col = 12
	end	
	local next=col+1
	if(next>12)then
	next=1
	end
	local prev=col-1
	if(prev<1)then
		prev=12
	end
	data["photo.photo_large.image"] = "images/photos/"..g_album_name.."/"..g_current_album[col]
	data["photo.photo_next.image"] = "images/photos/"..g_album_name.."/"..g_current_album[next]
	data["photo.photo_prev.image"] = "images/photos/"..g_album_name.."/"..g_current_album[prev]
	--data["Photo_screen.photo.grd_x"]=-480
	data["photo.photo_prev.alpha"] = 0
	data["photo.photo_next.alpha"]= 0
	data["photo.photo_large.alpha"]=255
	data["photo.photo_large.grd_x"] = 0

	gre.set_data(data)
end

function cb_photo_select(mapargs)
	local data = {}

	local col = mapargs.context_col % 12
	if col == 0 then
		col = 12
	end
	g_current_col = col
	cb_set_images(col)

	gre.send_event("photo_screen")
end


function cb_app_init(mapargs)
	load_album("architecture", arc_album)
end

function cb_press(mapargs)
	local ev_data = mapargs["context_event_data"]
	local x= ev_data["x"]
	pressed=1
	init_press=x
end

function cb_next_press(mapargs)
	local data = {}
	data["photo.photo_prev.alpha"]=0
	g_current_col=g_current_col+1
	gre.set_data(data)
	gre.send_event("fade_it")
end

function cb_prev_press(mapargs)
	local data = {}
	data["photo.photo_next.alpha"]=0
	g_current_col=g_current_col-1
	gre.set_data(data)
	gre.send_event("fade_it")
end

function cb_release(mapargs)
	local ev_data = mapargs["context_event_data"]
	local x= ev_data["x"]
	if(pressed==1)then
		local data = {}
		if((x-init_press)>30)then
			data["photo.final_number"]=0
			g_current_col=g_current_col-1
		elseif((x-init_press)<-30)then
			data["photo.final_number"]=-960
			g_current_col=g_current_col+1
		else
			data["photo.final_number"]=-480
		end
		gre.set_data(data)
		gre.send_event("slide_photo")

	end
	pressed=0

end



function cb_flick(mapargs) 
	local ev_data = mapargs["context_event_data"]
	local x= ev_data["x"]
	if(pressed==1)then
		local data={}
		data["Photo_screen.photo.grd_x"]=(x-init_press)-480
	gre.set_data(data)
	end
end

function cb_shutdown_timer(mapargs) 
	if ( timeout_timer ~= nil ) then
		gre.timer_clear_timeout(timeout_timer)
	end
	timeout_timer=gre.timer_set_timeout(cb_exit,60000)		      
end

function cb_exit(mapargs)
	--local data={}
	--data["model"]=gre.SCRIPT_ROOT.."/../../launcher/launcher_480.gapp"
	--gre.send_event_data("gre.load_app", "1s0 model", data)
	gre.quit()
end

cb_shutdown_timer()
