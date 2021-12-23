-- set up package paths
local myenv = gre.env({ "target_os", "target_cpu" })

package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.so;" .. package.cpath

local override_env = os.getenv("GRE_LUA_MODULES")
if (override_env) then
	package.cpath = override_env .."/?.so;" .. package.cpath
end

-- initialize multimedia control
if myenv.target_os == 'qnx' then
	package.path = package.path .. ';' .. gre.SCRIPT_ROOT .. '/qnx_mm_control/?.lua;'
	require 'mm_control'
	mm_control.init('/net/infotainment/pps/services/mm-control', '/net/infotainment/dev/qdb/mme')
else
	package.path = package.path .. gre.SCRIPT_ROOT .. '/qnx_mm_control/?.lua;'
	require 'mm_control'
	mm_control.init('/dev/null', 'scripts/mme_db/mme.db')
end

--
-- globals
--
PLAYER = 'mpaudio'
TRKSESSION = 'sb_trksession'
PLAYING = 0
IPOD_INSERTED = false
MEDIA_SOURCE = 'dbmme'
LAST_TRACK = 1
local open_menu = nil

local media_backtrace = {}
local cur_media_menu = nil

--
-- Callbacks
-- 
function busywait(time)
    --to do: replace busy loop with proper sleep 
    local now = os.time()
    while os.time() - now < time do
        -- nothing
    end    
end 

local mm_control_initialized = 0

function cb_mm_control_init(mapargs)
	if (mm_control_initialized == 0) then
	    mm_control.output_create('output', 'snd:pcmPreferredp', 'audio')
	
	    mm_control.zone_create('zone')
	    busywait(1)
	    mm_control.zone_attach_outputs('zone', 'output')
	    busywait(1)
		
	    mm_control.player_create(PLAYER)
	    busywait(1)
	
	    mm_control.player_attach_zone(PLAYER, 'zone')
	    busywait(1)
	
	    mm_control.create_trksession_for_songs(TRKSESSION, MEDIA_SOURCE)
	    mm_control.player_set_trksession(PLAYER, TRKSESSION)
	    
	    -- default to track 0
	    mm_control.player_set_current(PLAYER, 0)
	    
	    mm_control_initialized = 1
    end
end

-- Main menu callbacks 
function cb_artists_btn_press(mapargs)
    local vars = {}
 	local control = 'media_list_layer.artists_list'
	local res = mm_control.get_artists()

    local row = 1 
	for a, b in pairs(res) do
        if b.artist ~= 'NULL' then
            vars[control .. '.track.' .. row .. '.1'] = b.artist
            vars[control .. '.ids.' .. row .. '.1'] = b.artist_id
--			vars[control..".vshader."..row..".1"] = ""
--			vars[control..".fshader."..row..".1"] = ""
            row = row + 1
        end
	end


    vars[control..'.rows'] = #res 
    gre.set_data(vars)
    gre.send_event_target('list_resize', 'media_list_layer.artists_list')

	open_menu = "artists"
end

function cb_albums_btn_press(mapargs)
    local vars = {}
	local res = mm_control.get_albums()
 	local control = 'media_list_layer.albums_list'

    local row = 1
	for a, b in pairs(res) do
        if b.album ~= 'NULL' then
            vars[control .. '.track.' .. row .. '.1'] = b.album 
            vars[control .. '.ids.' .. row .. '.1'] = b.album_id
            row = row + 1
        end 
	end

    vars[control..'.rows'] = #res 
    gre.set_data(vars)
    gre.send_event_target('list_resize', 'media_list_layer.albums_list')

	open_menu = "albums"
end

function cb_songs_btn_press(mapargs)
    local vars = {}
	local control
	local vname
	local vars = {}
	local res = mm_control.get_songs()	

 	control = 'media_list_layer.songs_list'
	vname = control..'.track.'
	rows = control..'.rows'

	for a, b in pairs(res) do
        if b.title == 'NULL' then
            vars[vname .. a .. '.1'] = 'Unknown Song' 
        else
            vars[vname .. a .. '.1'] = b.title
        end
	end

    vars[rows] = #res 
    gre.set_data(vars)

    gre.send_event_target('list_resize', 'media_list_layer.songs_list')
	cur_media_menu = ""

    mm_control.player_stop(PLAYER)
	mm_control.create_trksession_for_songs(TRKSESSION, MEDIA_SOURCE)
	mm_control.player_set_trksession(PLAYER, TRKSESSION)
    
    open_menu = "songs"
end

-- second level menu
function cb_artiststable_press(mapargs)
	local key = 'media_list_layer.artists_list.ids.' .. mapargs.context_row .. '.1'
	local artist_id = gre.get_data(key)[key]
	local keyname = 'media_list_layer.artists_list.track.' .. mapargs.context_row .. '.1'
	local artist_name = gre.get_data(keyname)[keyname]
	local res = mm_control.get_artist_files(artist_id)
	local vars = {}

 	control = 'media_list_layer.songs_list'
	vname = control..'.track.'
	rows = control..'.rows'

	for a, b in pairs(res) do
        if b.title == 'NULL' then
            vars[vname .. a .. '.1'] = 'Unknown Song' 
        else
            vars[vname .. a .. '.1'] = b.title
        end
	end

    vars[rows] = #res 
    vars["media_list_layer.media_list_title.text"] = artist_name
    gre.set_data(vars)

    gre.send_event_target('list_resize', 'media_list_layer.songs_list')

	table.insert(media_backtrace, "artists")
	cur_media_menu = artist_name

    mm_control.player_stop(PLAYER)
	mm_control.create_trksession_for_artist(TRKSESSION, artist_id, MEDIA_SOURCE)
	mm_control.player_set_trksession(PLAYER, TRKSESSION)

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end
end

function cb_albumstable_press(mapargs)
	local key = 'media_list_layer.albums_list.ids.' .. mapargs.context_row .. '.1'
	local keyname = 'media_list_layer.albums_list.track.' .. mapargs.context_row .. '.1'
	local artist_name = gre.get_data(keyname)[keyname]
	local album_id = gre.get_data(key)[key]
	local res = mm_control.get_album_files(album_id)
	local vars = {}

 	control = 'media_list_layer.songs_list'
	vname = control..'.track.'
	rows = control..'.rows'

	for a, b in pairs(res) do
        if b.title == 'NULL' then
            vars[vname .. a .. '.1'] = 'Unknown Song' 
        else
            vars[vname .. a .. '.1'] = b.title
        end
	end

    vars[rows] = #res 
    vars["media_list_layer.media_list_title.text"] = artist_name
    gre.set_data(vars)

    gre.send_event_target('list_resize', 'media_list_layer.songs_list')
	table.insert(media_backtrace, "albums")
	print("add albums")
	cur_media_menu = artist_name

    mm_control.player_stop(PLAYER)
	mm_control.create_trksession_for_album(TRKSESSION, album_id, MEDIA_SOURCE)
	mm_control.player_set_trksession(PLAYER, TRKSESSION)

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end
end

function cb_songstable_press(mapargs)
	local key = 'media_list_layer.songs_list.track.' .. mapargs.context_row .. '.1'
	local song_name = gre.get_data(key)[key]
	local data = {}
	
	data["media_player_layer.Song.name"] = song_name
	data["media_player_layer.Band.name"] = cur_media_menu
	data["album_art_layer.play_button.grd_hidden"] = 0
	gre.set_data(data)
end

function cb_media_back(mapargs)
	if (media_backtrace == nil) then
		gre.send_event("show_media_main")
	else
		local menu = table.remove(media_backtrace)

		if (menu == nil) then
			gre.send_event("show_media_main")
		elseif (menu == "artists") then
			print("artists")
			gre.send_event("show_media_artists")
		elseif (menu == "albums") then
			print("albums")
			gre.send_event("show_media_albums")
		end
	end
end


function stop_playing()
	mm_control.player_stop(PLAYER)
	PLAYING = 0
end

local shuffle_value = false
local repeat_value = false

function cb_shuffle(mapargs)
	local data = {}
	
	if shuffle_value == true then
		shuffle_value = false
		data["CAR_HALF_MEDIA_BUTTONS.SHUFFLE_BTN.image"] = "images/SHUFFLE_BTN_up.png"
	else
		data["CAR_HALF_MEDIA_BUTTONS.SHUFFLE_BTN.image"] = "images/SHUFFLE_BTN_down.png"
		shuffle_value = true
	end
	gre.set_data(data)
end

function cb_repeat(mapargs)
	local data = {}
	
	if repeat_value == true then
		repeat_value = false
		data["CAR_HALF_MEDIA_BUTTONS.REPEAT_BTN.image"] = "images/REPEAT_BTN_up.png"
	else
		data["CAR_HALF_MEDIA_BUTTONS.REPEAT_BTN.image"] = "images/REPEAT_BTN_down.png"
		repeat_value = true
	end
	gre.set_data(data)
end

--
--
--

function cb_play_btn_press(mapargs)
	mm_control.player_set_speed(PLAYER, 1000)
	mm_control.player_play(PLAYER)
	gre.send_event("start_media_timer")
end

local last_track_hlight_index = {}

function cb_pause_btn_press(mapargs)
	mm_control.player_set_speed(PLAYER, 0)
end

function skip_btn_press(mapargs)

    local status = mm_control.player_get_status(PLAYER)

    next_id = tonumber(status.trkid) + 1

    -- try cycling back to first track
    local res = mm_control.player_set_current(PLAYER, next_id) 

    if res and res.errstr then
        res = mm_control.player_set_current(PLAYER, 0) 
    end

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end

end

function highlight_track(table, trkid)
	local data = {}
	
	if (last_track_hlight_index[table] ~= trkid) then
		data[table..".vshader."..trkid..".1"] = "shaders/glow.vs"
		data[table..".fshader."..trkid..".1"] = "shaders/glow.fs"
		if (last_track_hlight_index[table] ~= nil) then
			data[table..".vshader."..last_track_hlight_index[table]..".1"] = ""
			data[table..".fshader."..last_track_hlight_index[table]..".1"] = ""
		end
		last_track_hlight_index[table] = trkid
		gre.set_data(data)
	end
end

local MEDIA_PATH = "/net/infotainment/pps/services/mm-control/mpaudio/status"

function cb_media_register_event(mapargs)
	MEDIA_PATH = lqnx_pps.monitor_register_event(MEDIA_PATH, "qnxcar.media.update", "status")
end

local current_track = ""

function cb_media_status_timer(mapargs)
    local res = mm_control.currently_playing(PLAYER)
    if not res then
        return
    end

    local data = {}

	if (res.title == current_track) then
		return
	end
	
	current_track = res.title
    data['song_name'] = res.title

    -- current image
    if res.original then
        local path = string.sub(res.original, 8)

        local cur = gre.get_data('album_artwork')
        if cur.cur_album_artwork ~= path then
            data['album_artwork'] = path
        end
    else
    	data['album_artwork'] = "" -- no artwork
    end

    gre.set_data(data) 
    gre.send_event("show_media_screen")
end
