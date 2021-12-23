-- set up package paths
local myenv = gre.env({ "target_os", "target_cpu" })

package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.so;" .. package.cpath

local override_env = os.getenv("GRE_LUA_MODULES")
if (override_env) then
	package.cpath = override_env .."/?.so;" .. package.cpath
end

-- initialize multimedia control
if myenv.target_os == 'qnx' then
	package.path = gre.SCRIPT_ROOT .. '/qnx_mm_control/?.lua;' .. package.path
	require 'mm_control'
	mm_control.init('/pps/services/mm-control', '/dev/qdb/mme')
else
	package.path = gre.SCRIPT_ROOT .. '/qnx_mm_control/?.lua;' .. package.path
	require 'mm_control'
	mm_control.init('/dev/null', gre.SCRIPT_ROOT .. '/mme_db/mme.db')
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
	if myenv.target_os ~= 'qnx' then
		mm_control_initialized = 1
	end

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
	    
    -- default state is artist
    cb_artists_btn_press()
end

-- Main menu callbacks 
function cb_artists_btn_press(mapargs)
    local vars = {}
 	local control = 'artists_list_layer.artists_list'
	local res = mm_control.get_artists()

    local row = 1 
	for a, b in pairs(res) do
        if b.artist ~= 'NULL' then
            vars[control .. '.name.' .. row .. '.1'] = b.artist
            vars[control .. '.ids.' .. row .. '.1'] = b.artist_id
--			vars[control..".vshader."..row..".1"] = ""
--			vars[control..".fshader."..row..".1"] = ""
            row = row + 1
        end
	end

    gre.set_data(vars)
    
	local dk_data = {}
	dk_data[control..".grd_yoffset"] = 0	
	dk_data["rows"] = #res 
	gre.set_table_attrs('artists_list_layer.artists_list', dk_data)      
    
end

function cb_albums_btn_press(mapargs)
    local vars = {}
	local res = mm_control.get_albums()
 	local control = 'albums_list_layer.albums_list'

    local row = 1
	for a, b in pairs(res) do
        if b.album ~= 'NULL' then
            vars[control .. '.name.' .. row .. '.1'] = b.album 
            vars[control .. '.ids.' .. row .. '.1'] = b.album_id
            row = row + 1
        end 
	end

    gre.set_data(vars)

	local dk_data = {}
	dk_data[control..".grd_yoffset"] = 0	
	dk_data["rows"] = #res 
	gre.set_table_attrs('albums_list_layer.albums_list', dk_data)  
  
	open_menu = "albums"
end

function cb_songs_btn_press(mapargs)
    local vars = {}
	local control
	local vname
	local vars = {}
	local res = mm_control.get_songs()	

 	control = 'songs_list_layer.songs_list'
	vname = control..'.name.'
	rows = control..'.rows'

	for a, b in pairs(res) do
        if b.title == 'NULL' then
            vars[vname .. a .. '.1'] = 'Unknown Song' 
        else
            vars[vname .. a .. '.1'] = b.title
        end
	end

	vars[control..".grd_yoffset"] = 0	
    gre.set_data(vars)
    
	local dk_data = {}
	dk_data["rows"] = #res 
	gre.set_table_attrs('songs_list_layer.songs_list', dk_data) 

	unhighlight_track('songs_list_layer.songs_list')

    mm_control.player_stop(PLAYER)
	mm_control.create_trksession_for_songs(TRKSESSION, MEDIA_SOURCE)
	mm_control.player_set_trksession(PLAYER, TRKSESSION)

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end
end

-- second level menu
function cb_artiststable_press(mapargs)
	local key = 'artists_list_layer.artists_list.ids.' .. mapargs.context_row .. '.1'
	local artist_id = gre.get_data(key)[key]
	local keyname = 'artists_list_layer.artists_list.name.' .. mapargs.context_row .. '.1'
	local artist_name = gre.get_data(keyname)[keyname]
	local res = mm_control.get_artist_files(artist_id)
	local vars = {}

 	control = 'songs_list_layer.songs_list'
	vname = control..'.name.'
	rows = control..'.rows'

	for a, b in pairs(res) do
        if b.title == 'NULL' then
            vars[vname .. a .. '.1'] = 'Unknown Song' 
        else
            vars[vname .. a .. '.1'] = b.title
        end
	end

    vars["media_list_layer.breadcrumb_title.text"] = artist_name
	vars[control..".grd_yoffset"] = 0
    gre.set_data(vars)
    
	local dk_data = {}
	dk_data["rows"] = #res 
	gre.set_table_attrs('songs_list_layer.songs_list', dk_data)         

    gre.send_event_target('show_songs', 'media_menu_layer.songs')

	unhighlight_track('songs_list_layer.songs_list')
	
    mm_control.player_stop(PLAYER)
	mm_control.create_trksession_for_artist(TRKSESSION, artist_id, MEDIA_SOURCE)
	mm_control.player_set_trksession(PLAYER, TRKSESSION)

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end
end

function cb_albumstable_press(mapargs)
	local key = 'albums_list_layer.albums_list.ids.' .. mapargs.context_row .. '.1'
	local keyname = 'albums_list_layer.albums_list.name.' .. mapargs.context_row .. '.1'
	local artist_name = gre.get_data(keyname)[keyname]
	local album_id = gre.get_data(key)[key]
	local res = mm_control.get_album_files(album_id)
	local vars = {}

 	control = 'songs_list_layer.songs_list'
	vname = control..'.name.'
	rows = control..'.rows'

	for a, b in pairs(res) do
        if b.title == 'NULL' then
            vars[vname .. a .. '.1'] = 'Unknown Song' 
        else
            vars[vname .. a .. '.1'] = b.title
        end
	end

    vars["media_list_layer.breadcrumb_title.text"] = artist_name
	vars[control..".grd_yoffset"] = 0
    gre.set_data(vars)

	local dk_data = {}
	dk_data["rows"] = #res 
	gre.set_table_attrs('songs_list_layer.songs_list', dk_data)    

    gre.send_event_target('show_songs', 'media_menu_layer.songs')
	
	unhighlight_track('songs_list_layer.songs_list')
	
    mm_control.player_stop(PLAYER)
	mm_control.create_trksession_for_album(TRKSESSION, album_id, MEDIA_SOURCE)
	mm_control.player_set_trksession(PLAYER, TRKSESSION)

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end
end

function cb_songstable_press(mapargs)
	local key = 'songs_list_layer.songs_list.name.' .. mapargs.context_row .. '.1'
	local song_name = gre.get_data(key)[key]
	local data = {}
	
	data["album_layer.song_name.text"] = song_name
	data["media_player_layer.Band.name"] = cur_media_menu
	data["album_art_layer.play_button.grd_hidden"] = 0
	gre.set_data(data)
	highlight_track("songs_list_layer.songs_list", mapargs.context_row, 1)
	
	-- trk id's are 0 based
	mm_control.player_set_current(PLAYER, mapargs.context_row-1) 
    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end
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

function cb_radio_switch(mapargs)
	if (PLAYING == 1) then
		local data = {}
		data["album_layer.play_pause_control.image"] = "images/play_btn.png"
		mm_control.player_set_speed(PLAYER, 0)
		PLAYING = 0
		gre.set_data(data)
	end
end

function cb_play_btn_press(mapargs)
	local data = {}
	
	if (PLAYING == 1) then
		data["album_layer.play_pause_control.image"] = "images/play_btn.png"
		mm_control.player_set_speed(PLAYER, 0)
		PLAYING = 0
	else
		mm_control.player_set_speed(PLAYER, 1000)
		mm_control.player_play(PLAYER)
		gre.send_event("start_media_timer")
		PLAYING = 1
		data["album_layer.play_pause_control.image"] = "images/pause_btn.png"
	end
	gre.set_data(data)
end

local last_track_hlight_index = {}

function cb_pause_btn_press(mapargs)
	mm_control.player_set_speed(PLAYER, 0)
end

function cb_skip_btn_press(mapargs)
    local status = mm_control.player_get_status(PLAYER)

	if (mapargs.skip == "-1") then
    	next_id = tonumber(status.trkid) - 1
    	if (next_id < 0) then
    		next_id = 0
    	end
	else
    	next_id = tonumber(status.trkid) + 1
	end
	
    -- try cycling back to first track
    local res = mm_control.player_set_current(PLAYER, next_id) 

    if res and res.errstr then
        res = mm_control.player_set_current(PLAYER, status.trkid) 
    end

    if PLAYING == 1 then 
        mm_control.player_play(PLAYER)
    end

end

local last_track_hlight_index = {}
local last_track_hlight_col = {}

function highlight_track(table, trkid, col)
	local data = {}
	
	if (last_track_hlight_index[table] ~= trkid) then
		data[table..".vshader."..trkid.."."..col] = "shaders/glowc_list.vs"
		data[table..".fshader."..trkid.."."..col] = "shaders/glowc_list.fs"
		if (last_track_hlight_index[table] ~= nil) then
			data[table..".vshader."..last_track_hlight_index[table].."."..col] = ""
			data[table..".fshader."..last_track_hlight_index[table].."."..col] = ""
		end
		last_track_hlight_index[table] = trkid
		last_track_hlight_col[table] = col
		gre.set_data(data)
	end
end

function unhighlight_track(table)
	local data = {}
	
	if (last_track_hlight_index[table] ~= nil) then
		data[table..".vshader."..last_track_hlight_index[table].."."..last_track_hlight_col[table]] = ""
		data[table..".fshader."..last_track_hlight_index[table].."."..last_track_hlight_col[table]] = ""
	end
	gre.set_data(data)
	last_track_hlight_index[table] = nil
	last_track_hlight_col[table] = nil
end

local AUDIO_CTRL = "/pps/services/audio/control"

function set_volume(level)
	local name = 'speaker'
	local ID = 1000

	if (level > 0) then
    	level = 100 * (math.log(level)) / (math.log(100));
    end
    lqnx_pps.set(AUDIO_CTRL,
            {{name='msg', value='set_output_level'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name .. '", "level":' .. level .. '}'}
            })    
end

function cb_media_status_timer(mapargs)
    local res = mm_control.currently_playing(PLAYER)
    if not res then
        return
    end
	
    local data = {}

    data["album_layer.artist_album.text"] = res.artist
    --data['cur_album_name'] = res.album
    data["album_layer.song_name.text"] = res.title

    if res.position then
        local sec = res.position / 1000.0
        local min = math.floor(sec / 60.0)
        local sec = sec - min * 60.0

		data["album_layer.progress_bar_control.offset"] = res.position/res.duration * 270
        data["album_layer.progress_bar_control.text"] = string.format('%d:%02d', min, sec)
    end

    -- current image
    if res.original then
        local path = string.sub(res.original, 8)

        local cur = gre.get_data('cur_album_artwork')
        if cur.cur_album_artwork ~= path then
           data['cur_album_artwork'] = path
        end
    else
    	data['cur_album_artwork'] = "" -- no artwork
    end

    -- highlight selected track
    if res.trkid then
	  	highlight_track("songs_list_layer.songs_list", res.trkid+1, 1)
--		highlight_track("CAR_HALF_BUTTON.songs_half_table", res.trkid+1)
--		highlight_track("CAR_HALF_BUTTON.songs_sub_menu", res.trkid+1)
    end

    gre.set_data(data) 
end
