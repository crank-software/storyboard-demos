
CREATE TABLE mediastore_metadata (
      syncflags   INTEGER DEFAULT 0 NOT NULL,
      last_sync   INTEGER DEFAULT 0 NOT NULL,
      mssname     TEXT DEFAULT NULL,
      name        TEXT DEFAULT NULL,
      mountpath   TEXT NOT NULL
);

CREATE TABLE folders (
      folderid          INTEGER PRIMARY KEY ,
      parentid          INTEGER DEFAULT 0 NOT NULL,
      synced            INTEGER DEFAULT 0 NOT NULL,
      filecount         INTEGER DEFAULT 0 NOT NULL,
      playlistcount     INTEGER DEFAULT 0 NOT NULL,
      foldercount       INTEGER DEFAULT 0 NOT NULL,
      last_sync         INTEGER DEFAULT 0 NOT NULL,
      folderflags       INTEGER DEFAULT 0 NOT NULL,
      foldername        TEXT NOT NULL,
      basepath          TEXT NOT NULL,
      hash              BLOB,
      collisions        BLOB,
	  bookmark			TEXT,
      collision_names   BLOB
);

CREATE TABLE files (
      fid              INTEGER PRIMARY KEY ,
      folderid         INTEGER DEFAULT 0 NOT NULL REFERENCES folders,
      ftype            INTEGER DEFAULT 0 NOT NULL,
      accurate         INTEGER DEFAULT 0 NOT NULL,
      last_sync        INTEGER DEFAULT 0 NOT NULL,
      size             INTEGER DEFAULT 0 NOT NULL,
      date_added       INTEGER DEFAULT 0 NOT NULL,
      date_modified    INTEGER DEFAULT 0 NOT NULL,
      filename         TEXT DEFAULT '' NOT NULL
--      size             INTEGER DEFAULT 0 NOT NULL
);

CREATE TABLE audio_metadata (
      fid              INTEGER NOT NULL REFERENCES files,
      artist_id        INTEGER DEFAULT 1 NOT NULL REFERENCES artists,
      album_id         INTEGER DEFAULT 1 NOT NULL REFERENCES albums,
      genre_id         INTEGER DEFAULT 1 NOT NULL REFERENCES genres,
      year             INTEGER DEFAULT 0 NOT NULL,
      disc             INTEGER DEFAULT 0 NOT NULL,
      track            INTEGER DEFAULT 0 NOT NULL,
      rating           INTEGER DEFAULT 0 NOT NULL,
      bitrate          INTEGER DEFAULT 0 NOT NULL,
      samplerate       INTEGER DEFAULT 0 NOT NULL,
      protected        INTEGER DEFAULT 0 NOT NULL,
      duration         INTEGER DEFAULT 0 NOT NULL,
      description      TEXT DEFAULT '' NOT NULL,
	  url			   TEXT DEFAULT '' NOT NULL,
      title            TEXT DEFAULT NULL
);

CREATE TABLE video_metadata (
      fid              INTEGER NOT NULL REFERENCES files,
      artist_id        INTEGER DEFAULT 1 NOT NULL REFERENCES artists,
      album_id         INTEGER DEFAULT 1 NOT NULL REFERENCES albums,
      genre_id         INTEGER DEFAULT 1 NOT NULL REFERENCES genres,
      year             INTEGER DEFAULT 0 NOT NULL,
      width            INTEGER DEFAULT 0 NOT NULL,
      height           INTEGER DEFAULT 0 NOT NULL,
      rating           INTEGER DEFAULT 0 NOT NULL,
      audio_bitrate    INTEGER DEFAULT 0 NOT NULL,
      audio_samplerate INTEGER DEFAULT 0 NOT NULL,
      protected        INTEGER DEFAULT 0 NOT NULL,
      duration         INTEGER DEFAULT 0 NOT NULL,
      description      TEXT DEFAULT '' NOT NULL,
	  url			   TEXT DEFAULT '' NOT NULL,
      title            TEXT DEFAULT NULL
);

CREATE TABLE photo_metadata (
      fid              INTEGER NOT NULL REFERENCES files,
      latitude         TEXT DEFAULT '' NOT NULL,
      longitude        TEXT DEFAULT '' NOT NULL,
      width            INTEGER DEFAULT 0 NOT NULL,
      height           INTEGER DEFAULT 0 NOT NULL,
      orientation      TEXT DEFAULT '' NOT NULL,
      shutter          TEXT DEFAULT '' NOT NULL,
      aperture         TEXT DEFAULT '' NOT NULL,
      focal_length     INTEGER DEFAULT 0 NOT NULL,
      iso              INTEGER DEFAULT 0 NOT NULL,
      description      TEXT DEFAULT '' NOT NULL,
      date_original    TEXT DEFAULT '' NOT NULL,
	  url			   TEXT DEFAULT '' NOT NULL,
      keywords         TEXT DEFAULT '' NOT NULL
);

CREATE TABLE genres (
      genre_id         INTEGER PRIMARY KEY ,
      genre            TEXT
);

CREATE TABLE artists (
      artist_id        INTEGER PRIMARY KEY ,
      artist           TEXT
);

CREATE TABLE albums (
      album_id         INTEGER PRIMARY KEY ,
      album            TEXT
);

CREATE TABLE artworks (
      album_id      INTEGER NOT NULL REFERENCES albums(album_id),
      type          INTEGER DEFAULT 1 NOT NULL, 
      artwork_url   TEXT DEFAULT NULL, 
      PRIMARY KEY   (album_id, type)
);

CREATE TABLE playlists (
      plid             INTEGER PRIMARY KEY ,
      ownership        INTEGER DEFAULT 0 NOT NULL,
      folderid         INTEGER DEFAULT 0 NOT NULL REFERENCES folders,
      mode             INTEGER DEFAULT 0 NOT NULL,
      date_modified    INTEGER DEFAULT 0 NOT NULL,
      accurate         INTEGER DEFAULT 0 NOT NULL,
      last_sync        INTEGER DEFAULT 0 NOT NULL,
      size             INTEGER DEFAULT 0 NOT NULL,
      signature        TEXT DEFAULT '0' NOT NULL,
      filename         TEXT DEFAULT '' NOT NULL,
      name             TEXT NOT NULL,
      seed_data        TEXT,
      lang_code        TEXT DEFAULT 'en_CA' NOT NULL
);

CREATE TABLE playlist_entries (
      oid                   INTEGER PRIMARY KEY ,
      plid                  INTEGER NOT NULL REFERENCES playlists,
      fid                   INTEGER NOT NULL REFERENCES files,
      unresolved_entry_text TEXT DEFAULT NULL
);

CREATE TABLE player_mpaudio(
    trkid INTEGER PRIMARY KEY ,
    fid INTEGER NOT NULL
);

insert into mediastore_metadata values (3,1338566450830000000,'devb', null,'/accounts/1000/shared');

insert into folders values (1,0,3,0,0,11,1338566452124000000,0,'','/',0, null, null, null);

insert into folders values (2,1,3,0,0,0,1338566452124000000,0,'bookmarks','/bookmarks/',null, null, null, null);

insert into folders values (3,1,3,0,0,0,1338566452124000000,0,'books','/books/',null, null, null, null);

insert into folders values (4,1,3,0,0,0,1338566452124000000,0,'camera','/camera/',null, null, null, null);

insert into folders values (5,1,3,0,0,1,1338566452124000000,0,'documents','/documents/',null, null, null, null);

insert into folders values (6,1,3,0,0,0,1338566452124000000,0,'downloads','/downloads/',null, null, null, null);

insert into folders values (7,1,3,0,0,0,1338566452124000000,0,'misc','/misc/',null, null, null, null);

insert into folders values (8,1,3,0,0,4,1338566452124000000,0,'music','/music/',null, null, null, null);

insert into folders values (14,8,3,5,0,0,1338566452124000000,0,'set006','/music/set006/',null,null,null,null);

insert into folders values (15,8,3,5,0,0,1338566452124000000,0,'set007','/music/set007/',null,null,null,null);

insert into folders values (16,8,3,5,0,0,1338566452124000000,0,'set008','/music/set008/',null,null,null,null);

insert into folders values (17,8,3,6,0,0,1338566452124000000,0,'set009','/music/set009/',null,null,null,null);

insert into folders values (18,9,3,0,0,0,1338566452124000000,0,'contacts','/photos/contacts/',null,null,null,null);

insert into files values (1,14,1,1,1338566450910000000,6034117,1338566450910000000,1349407807,'01 - 0000025.mp3');

insert into files values (2,14,1,1,1338566450910000000,5287830,1338566450910000000,1349407807,'02 - 00019.mp3');

insert into files values (3,14,1,1,1338566450910000000,13261530,1338566450910000000,1349407807,'03 - 00023.mp3');

insert into files values (4,14,1,1,1338566450910000000,4799374,1338566450910000000,1349407807,'04 - 00020.mp3');

insert into files values (5,14,1,1,1338566450910000000,5325038,1338566450910000000,1349407807,'05 - 0000026.mp3');

insert into files values (6,15,1,1,1338566450910000000,5715375,1338566450910000000,1349407812,'01 - Luna bulimica.mp3');

insert into files values (7,15,1,1,1338566450910000000,2284386,1338566450910000000,1349407812,'02 - Alegoria.mp3');

insert into files values (8,15,1,1,1338566450910000000,3270823,1338566450910000000,1349407812,'03 - El amor y el craneo.mp3');

insert into files values (9,15,1,1,1338566450910000000,3561337,1338566450910000000,1349407812,'04 - Las dos buenas hermanas.mp3');

insert into files values (10,15,1,1,1338566450910000000,7510988,1338566450910000000,1349407812,'05 - La metamorfosis del vampiro.mp3');

insert into files values (11,16,1,1,1338566450910000000,3730438,1338566450910000000,1349407803,'01 - See-Through.mp3');

insert into files values (12,16,1,1,1338566450910000000,2902994,1338566450910000000,1349407805,'02 - Burning, Itching, Irritation.mp3');

insert into files values (13,16,1,1,1338566450910000000,4597327,1338566450910000000,1349407803,'03 - Anyhow, Anyway.mp3');

insert into files values (14,16,1,1,1338566450910000000,4423155,1338566450910000000,1349407805,'04 - Tumble Mat.mp3');

insert into files values (15,16,1,1,1338566450910000000,3414972,1338566450910000000,1349407802,'05 - Spooge.mp3');

insert into files values (16,17,1,1,1338566450910000000,1667828,1338566450910000000,1349407809,'01 - Bluesy All Alone.mp3');

insert into files values (17,17,1,1,1338566450910000000,5263680,1338566450910000000,1349407809,'02 - Night On The Streets.mp3');

insert into files values (18,17,1,1,1338566450910000000,5359415,1338566450910000000,1349407811,'03 - Endless Love.mp3');

insert into files values (19,17,1,1,1338566450910000000,6437493,1338566450910000000,1349407811,'04 - The Beginning Of Time.mp3');

insert into files values (20,17,1,1,1338566450910000000,3837944,1338566450910000000,1349407809,'05 - Long Haired Hero.mp3');

insert into files values (21,17,1,1,1338566450910000000,4381221,1338566450910000000,1349407811,'06 - The Interview.mp3');

insert into files values (22,11,2,1,1338566450940000000,30582280,1338566450940000000,1349407813,'starshipvideoonly.mp4');

insert into audio_metadata values(1,2,2,1,2008,0,1,0,188000,44100,0,254066,'http://www.jamendo.com/','','0000025');

insert into audio_metadata values(2,2,2,1,2008,0,2,0,163000,44100,0,257697,'http://www.jamendo.com/','','00019');

insert into audio_metadata values(3,2,2,1,2008,0,3,0,214000,44100,0,492747,'http://www.jamendo.com/','','00023');

insert into audio_metadata values(4,2,2,1,2008,0,4,0,161000,44100,0,235102,'http://www.jamendo.com/','','00020');

insert into audio_metadata values(5,2,2,1,2008,0,5,0,217000,44100,0,194194,'http://www.jamendo.com/','','0000026');

insert into audio_metadata values(6,3,3,2,2007,0,1,0,189000,44100,0,240117,'http://www.jamendo.com/','','Luna bulímica');

insert into audio_metadata values(7,3,3,2,2007,0,2,0,129000,44100,0,139206,'http://www.jamendo.com/','','Alegoría');

insert into audio_metadata values(8,3,3,2,2007,0,3,0,154000,44100,0,167314,'http://www.jamendo.com/','','El amor y el cráneo');

insert into audio_metadata values(9,3,3,2,2007,0,4,0,132000,44100,0,213786,'http://www.jamendo.com/','','Las dos buenas hermanas');

insert into audio_metadata values(10,3,3,2,2007,0,5,0,140000,44100,0,426344,'http://www.jamendo.com/','','La metamorfosis del vampiro');

insert into audio_metadata values(11,4,4,3,1995,0,1,0,210000,44100,0,140042,'http://www.jamendo.com/','','See-Through');

insert into audio_metadata values(12,4,4,3,1995,0,2,0,208000,44100,0,110184,'http://www.jamendo.com/','','Burning, Itching, Irritation');

insert into audio_metadata values(13,4,4,3,1995,0,3,0,211000,44100,0,172042,'http://www.jamendo.com/','','Anyhow, Anyway');

insert into audio_metadata values(14,4,4,3,1995,0,4,0,209000,44100,0,167915,'http://www.jamendo.com/','','Tumble Mat');

insert into audio_metadata values(15,4,4,3,1995,0,5,0,206000,44100,0,131056,'http://www.jamendo.com/','','Spooge');

insert into audio_metadata values(16,5,5,3,2007,0,1,0,215000,44100,0,60368,'http://www.jamendo.com/','','Bluesy All Alone');

insert into audio_metadata values(17,5,5,4,2007,0,2,0,195000,44100,0,213342,'http://www.jamendo.com/','','Night On The Streets');

insert into audio_metadata values(18,5,5,5,2007,0,3,0,164000,44100,0,258351,'http://www.jamendo.com/','','Endless Love');

insert into audio_metadata values(19,5,5,4,2007,0,4,0,199000,44100,0,256626,'http://www.jamendo.com/','','The Beginning Of Time');

insert into audio_metadata values(20,5,5,3,2007,0,5,0,209000,44100,0,145606,'http://www.jamendo.com/','','Long Haired Hero');

insert into audio_metadata values(21,5,5,4,2007,0,6,0,186000,44100,0,186096,'http://www.jamendo.com/','','The Interview');

insert into artists values(1,null);
insert into artists values(2,'ALONE IN THE CHAOS');
insert into artists values(3,'Caminos del Sonido');
insert into artists values(4,'Sinkhole');
insert into artists values(5,'Jampy');

insert into albums values(1,null);
insert into albums values(2,'Ballads In White Forest   (2008)');
insert into albums values(3,'Las flores del Mal');
insert into albums values(4,'Space Freak');
insert into albums values(5,'The Unemployed');

insert into artworks values(2,2,'file:///apps/mediasources/imagecache//mme/2/thumb');

insert into artworks values(2,1,'file:///apps/mediasources/imagecache//mme/2/original');

insert into artworks values(3,2,'file:///apps/mediasources/imagecache//mme/3/thumb');

insert into artworks values(3,1,'file:///apps/mediasources/imagecache//mme/3/original');

insert into artworks values(4,2,'file:///apps/mediasources/imagecache//mme/4/thumb');

insert into artworks values(4,1,'file:///apps/mediasources/imagecache//mme/4/original');

insert into artworks values(5,2,'file:///apps/mediasources/imagecache//mme/5/thumb');

insert into artworks values(5,1,'file:///apps/mediasources/imagecache//mme/5/original');
