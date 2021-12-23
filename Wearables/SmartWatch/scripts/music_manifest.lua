--- music_manifest.lua
-- store the music data table

-- the total list of songs and their data
local music_list = {
  {
    title = '(Da Le) Yaleo',
    artist = 'Santana',
    duration = 352000,
    art = 'images/album_01.png',
    liked = false
  },
  {
    title = 'Come Together',
    artist = 'The Beatles',
    duration = 260000,
    art = 'images/album_02.png',
    liked = false
  },
  {
    title = 'Sultans Of Swing',
    artist = 'Dire Straits',
    duration = 348000,
    art = 'images/album_03.png',
    liked = false
  },
  {
    title = 'So What',
    artist = 'Miles Davis',
    duration = 562000,
    art = 'images/album_04.png',
    liked = false
  },
  {
    title = 'La Llorona',
    artist = 'Natalia Lafourcade',
    duration = 415000,
    art = 'images/album_05.png',
    liked = false
  },
  {
    title = 'Minsu is confused',
    artist = 'Minsu',
    duration = 225000,
    art = 'images/album_06.png',
    liked = false
  },
  {
    title = 'Sandiya',
    artist = 'Karim Ziad',
    duration = 277000,
    art = 'images/album_07.png',
    liked = false
  },
  {
    title = 'Mobali',
    artist = 'Siboy',
    duration = 208000,
    art = 'images/album_08.png',
    liked = false
  },
  {
    title = 'Still Broke',
    artist = 'Sam Henshaw',
    duration = 204000,
    art = 'images/album_09.png',
    liked = false
  },
}
---
-- fetch the music_list table
-- @return music_list the music list table
function get_music_list()
  return music_list
end

---
-- fetch the size of music_list table
-- @return size the size of the music list table
function get_music_list_size()
  return #music_list
end

function toggle_liked_status(index)
  if (music_list[index].liked == true) then
    music_list[index].liked = false
  else
    music_list[index].liked = true
  end 
end
  
function get_liked_status(index)
  return music_list[index].liked
end