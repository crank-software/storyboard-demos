--
-- Copyright (c) 2012 Crank Software Inc.
--

-- set up our dependencies 
local io = require 'io'
local json = require 'json'
local pps = require 'lqnx_pps'
local qdb = require 'qdb'
local string = require 'string'
local pairs = pairs
local print = print

module(...)

local ID = 1000

--
-- initialize module global variables
--
function init(service_path, db_path) 

    MM_SERVICE_PATH = service_path
    MM_CONTROL_PATH = MM_SERVICE_PATH .. '/control'

    MM_CONTROL_SUBS = pps.subscribe(MM_CONTROL_PATH .. '?delta')
   
    -- get any status prior to our subscription 
    if MM_CONTROL_SUBS then
        local res = pps.get(MM_CONTROL_SUBS)
        for a, b in pairs(res) do
            print(a, b)
        end
    end 

    MME_DB_PATH = db_path 
end

function set_database(db_path)
    MME_DB_PATH = db_path 
end

function devices()
    local res = pps.get('/pps/services/mm-detect/status')

    local ret = {}

    if res then
        for name, json_data in pairs(res) do
            decoded = json.decode(json_data) 
            ret[name] = decoded
        end
    end
        
    return ret 

end

--
-- Track Session Interface
-- 
function trksession_create(name, source)
    print("Create session "..source)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='trksession_create'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name.. '", "media_source":"' .. source .. '"}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    return res
end

function trksession_import(name, url)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='trksession_import'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name.. '", "url":"' .. url .. '"}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 

    if res then 
        if res.err then
            print('trksession_import: error: ' .. res.err .. ': ' .. res.errstr)
        else
            local size = res.trksession_size 
            if size then
                print('trksession size: ' .. size)
                return tonumber(size)
            end
        end    
    end 
end

function trksession_randomize_range(name, first, last)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='trksession_import'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name.. '", "first":' .. first .. ', "end":' .. last .. '}'}
            })

    return pps.get(MM_CONTROL_SUBS) 

end

function trksession_get_range(name, first, last, mode)

    -- set up some defaults
    if not mode then
        mode = 'sequential'
    elseif mode ~= 'sequential' and mode ~= 'random' then 
        print('error: trksession_get_range: unrecognized type: ' .. mode)
        return
    end

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='trksession_get_range'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name.. '", "start":' .. first .. ', "end":' .. last .. ', "type":"' .. mode .. '"}'}
            })

    return pps.get(MM_CONTROL_SUBS)
end

function trksession_delete(name)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='trksession_delete'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name.. '"}'}
            })

    return pps.get(MM_CONTROL_SUBS) 

end

--
-- Output Interface
-- 
function output_create(name, device, type)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='output_create'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name .. '", "url":"' .. device .. '","type":"' .. type .. '"}'}
            }) 

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        if res.err == '16' then
            --output already existed...
        else
            print('output_create: error: ' .. res.err .. ': ' .. res.errstr)
        end
    end 
end

--
-- Zone interface
--
function zone_create(name)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='zone_create'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name .. '"}'}
            }) 

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        if res.err == '16' then
            -- already existed 
        else
            print('zone_create: error: ' .. res.err .. ': ' .. res.errstr)
        end
    end
end

function zone_attach_outputs(name, output)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='zone_attach_outputs'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. name .. '", "outputs":["' .. output .. '"]}'}
            }) 

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('zone_attach_outputs: error: ' .. res.err .. ': ' .. res.errstr)
    end 

end

--
-- Player Interface
-- 
function player_create(player)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_create'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"name":"' .. player .. '"}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        if res.err == '17' then
            print('player_create: player already existed...')
        else
            print('zone_attach_outputs: error: ' .. res.err .. ': ' .. res.errstr)
        end
    end 
end

function player_attach_zone(player, zone)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_attach_zone'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "zone":"' .. zone .. '"}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_attach_zone: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_set_trksession(player, trksession, idx)

    -- default index
    if not idx then
        idx = 0
    end

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_set_trksession'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "trksession":"' .. trksession.. '", "idx":' .. idx ..'}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_set_trksession: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_set_speed(player, speed)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_set_speed'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "speed":' .. speed .. '}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_set_speed: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_set_position(player, position)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_set_speed'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "position":' .. position .. '}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_set_position: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_set_read_mode(player, mode)

    if mode ~= 'random' and mode ~= 'sequential' then
        print('error: player_set_read_mode unrecognized mode: ' .. mode)
        return
    end 

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_set_read_mode'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "mode":' .. mode .. '}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_set_read_mode: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_set_repeat_mode(player, mode)

    if mode ~= 'all' and mode ~= 'one' and mode ~= 'none' then
        print('error: player_set_read_mode unrecognized mode: ' .. mode)
        return
    end

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_set_repeat_mode'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "mode":' .. mode .. '}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_set_repeat_mode: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_set_current(player, index)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_set_current'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '", "index":' .. index .. '}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_set_current: error: ' .. res.err .. ': ' .. res.errstr)
    end

    return res 
end

function player_play(player)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_play'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '"}'}
            })

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_play: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_stop(player)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_stop'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '"}'}
            }) 

    local res = pps.get(MM_CONTROL_SUBS) 
    if res and res.err then
        print('player_stop: error: ' .. res.err .. ': ' .. res.errstr)
    end 
end

function player_previous_track(player)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_previous_track'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '"}'}
            })

    return pps.get(MM_CONTROL_SUBS)
end

function player_next_track(player)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_next_track'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '"}'}
            })

    return pps.get(MM_CONTROL_SUBS)
end

function player_current_track(player)

    pps.set(MM_CONTROL_SUBS,
            {{name='msg', value='player_current_track'},
             {name='id', value=ID},
             {name='dat', type='json', value='{"player":"' .. player .. '"}'}
            })

    return pps.get(MM_CONTROL_SUBS)
end

function player_get_status(player)

    local path = MM_SERVICE_PATH .. '/' .. player .. '/status'

    return pps.get(path)
end

--
-- Database interface
--

--
-- Currently playing
--
local db = nil

function currently_playing(player)
    local status = player_get_status(player)
--for a, b in pairs(status) do
--print(a.." "..b)
--end
    if status == nil or status.dbpath == nil or status.state ~= "PLAYING" then
        return
    end

    local fid = status.fid

    if (db == nil) then
    	db = qdb.open("/net/infotainment"..status.dbpath)
    end
    local dbres = qdb.exec(db, 'select title, year, artist, duration, audio_metadata.album_id, album from audio_metadata, artists, albums where audio_metadata.fid = ' .. fid .. ' and audio_metadata.artist_id = artists.artist_id and audio_metadata.album_id = albums.album_id')
    
    --qdb.close(db)

    local res = {}

    -- relevant status
    res['state'] = status.state
    res['position'] = status.position or 0.0
	res['trkid'] = status.trkid
	
    -- results from db
    for a, b in pairs(dbres) do
        for c, d in pairs(b) do
            res[c] = d
        end
    end

    -- artwork
    if res.album_id then
        local thumb
        local original 
        thumb, original = get_album_artwork(res.album_id, "/net/infotainment"..status.dbpath) 
        res.thumb = thumb
        res.original = original
    else
        res.thumb = '' 
        res.original = '' 
    end

    return res
 
end

--
-- Albums
--
function get_albums()

    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select album_id, album from albums')

    qdb.close(db)

    return res
end

function get_album_artist(album_id)

    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select distinct artist from artists, audio_metadata where artists.artist_id = audio_metadata.artist_id and audio_metadata.album_id = ' .. album_id)

    qdb.close(db)

    if res then
        return res[1].artist
    end 
end

function get_album_artwork(album_id, db_path)

    local path = db_path or MME_DB_PATH

    local db = qdb.open(path)
    local res = qdb.exec(db, 'select type, artwork_url from artworks where album_id = ' .. album_id)

    qdb.close(db)

    local thumb
    local original 
    for a, b in pairs(res) do
        if b.type == 1 then
            original = b.artwork_url 
        else
            thumb = b.artwork_url 
        end
    end

    return thumb, original 
end

function get_album_files(album_id)

    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select fid, duration, title from audio_metadata where album_id = ' .. album_id)

    qdb.close(db)

    return res
end 

function create_trksession_for_album(name, album_id, source)

    -- delete if it exists
    trksession_delete(name)

    -- create new and import all songs from album
    trksession_create(name, source)

    local res = trksession_import(name, "SELECT coalesce(nullif(trim(audio_metadata.url), ''), mediastore_metadata.mountpath || folders.basepath || files.filename) AS url, files.fid AS userdata from mediastore_metadata, folders, files, audio_metadata WHERE files.folderid == folders.folderid and files.fid = audio_metadata.fid and audio_metadata.album_id = " .. album_id .. " ORDER BY files.fid")

    return res 
end

--
-- Artists
--
function get_artists()

    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select artist_id, artist from artists')

    qdb.close(db)

    return res
end

function get_artist_files(artist_id)

    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select fid, duration, title, year from audio_metadata where artist_id = ' .. artist_id)

    qdb.close(db)

    return res
end 

function create_trksession_for_artist(name, artist_id, source)

    -- delete if it exists
    trksession_delete(name)

    -- create new and import all songs for artist

    trksession_create(name, source)

    local res = trksession_import(name, "SELECT coalesce(nullif(trim(audio_metadata.url), ''), mediastore_metadata.mountpath || folders.basepath || files.filename) AS url, files.fid AS userdata from mediastore_metadata, folders, files, audio_metadata WHERE files.folderid == folders.folderid and files.fid = audio_metadata.fid and audio_metadata.artist_id = " .. artist_id .. " ORDER BY files.fid")

    return res 
end

--
-- Playlists
--
function get_playlists()
    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select * from playlists')

    qdb.close(db)

    return res 
end

function get_playlist_files(plid)

    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select fid, duration, title from audio_metadata, playlist_entries where audio_metadata.fid = playlist_entries.fid and playlist_entries.plid = ' .. plid)

    qdb.close(db)

    return res 
end

function create_trksession_for_playlist(name, plid, source)

    -- delete if it exists
    trksession_delete(name)

    -- create new and import all songs from playlist
    
    trksession_create(name, source)

    local res = trksession_import(name, "SELECT coalesce(nullif(trim(audio_metadata.url), ''), mediastore_metadata.mountpath || folders.basepath || files.filename) AS url, files.fid AS userdata from mediastore_metadata, folders, files, playlist_entries WHERE files.folderid == folders.folderid and files.fid = playlist_entries.fid and playlist_entries.plid = " .. plid .. " ORDER BY files.fid")

    return res 
end

--
-- All songs
--
function get_songs()
--	local cmd = "SELECT coalesce(nullif(trim(am.url), ''), m.mountpath || f.basepath || fi.filename) AS url, fi.fid as userdata FROM mediastore_metadata m, folders f LEFT JOIN files fi ON f.folderid = fi.folderid INNER JOIN audio_metadata am ON am.fid = fi.fid ORDER BY upper(title)"
    local db = qdb.open(MME_DB_PATH)
    local res = qdb.exec(db, 'select fid, title, year, track, duration, album, artist from audio_metadata, artists, albums where audio_metadata.artist_id = artists.artist_id and audio_metadata.album_id = albums.album_id')

    qdb.close(db)

    return res 
end

function create_trksession_for_songs(name, source)
	local cmd = "SELECT coalesce(nullif(trim(audio_metadata.url), ''), mediastore_metadata.mountpath || folders.basepath || files.filename) AS url, files.fid AS userdata from mediastore_metadata, folders, files, audio_metadata WHERE files.folderid == folders.folderid and files.fid = audio_metadata.fid ORDER BY files.fid"

    -- delete if it exists
    trksession_delete(name)

    -- create new and import all songs from album
    
    trksession_create(name, source)

    local res = trksession_import(name, cmd)
    return res 
end 
