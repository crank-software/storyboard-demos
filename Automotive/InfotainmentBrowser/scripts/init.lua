

function cb_init(mapargs)
	phone_book_load("phone_book.csv")
	recent_calls_load("recent_callers.csv")
	radio_preset_load("radio.csv")
	
	load_bookmarks()
	
	sensor_register()
	sensor_init()
	navi_init()
end
