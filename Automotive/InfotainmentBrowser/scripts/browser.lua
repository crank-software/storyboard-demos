local view_created = 0

function load_bookmarks()
	local data = {}
	
	data["browser_bookmark_l.bookmark_table.url.1.1"] = "file:///fs/usb0/sites/crank/www.cranksoftware.com/index.html"
	data["browser_bookmark_l.bookmark_table.image.1.1"] = "/fs/usb0/sites/crank.jpg"

	data["browser_bookmark_l.bookmark_table.url.1.2"] = "file:///fs/usb0/sites/android/index.html"
	data["browser_bookmark_l.bookmark_table.image.1.2"] = "/fs/usb0/sites/android.jpg"

	data["browser_bookmark_l.bookmark_table.url.2.1"] = "file:///fs/usb0/sites/apple/index.html"
	data["browser_bookmark_l.bookmark_table.image.2.1"] = "/fs/usb0/sites/apple.jpg"

	data["browser_bookmark_l.bookmark_table.url.2.2"] = "file:///apps/WeatherNetwork.testDev_therNetworke376bba_/native/index.html"
	data["browser_bookmark_l.bookmark_table.image.2.2"] = "/apps/WeatherNetwork.testDev_therNetworke376bba_/native/icon.png"
	
	data["browser_url"] = "http://www.cranksoftware.com"
	
	gre.set_data(data)
end

function cb_browser_create_view(mapargs)
	if (view_created == 0) then
		gre.send_event("browser_create_view")
		gre.send_event("browser_load_url")
		view_created = 1
	end
end

function cb_browser_load(mapargs)
	local data = {}
	
	data = gre.get_data("browser_url")
	protocol = string.sub(data["browser_url"], 1, 7)
	if (protocol ~= "http://" and protocol ~= "file://") then
		data["browser_url"] = "http://"..data["browser_url"]
		gre.set_data(data)
	end
	gre.send_event("browser_load_url")
end

function cb_browser_back(mapargs)
end

function cb_browser_reload(mapargs)
end

function cb_browser_load_bookmark(mapargs)
	local data = {}
	local ndata = {}
	
	data = gre.get_data("browser_bookmark_l.bookmark_table.url."..mapargs.context_row.."."..mapargs.context_col)
	print("Bookmark :"..data["browser_bookmark_l.bookmark_table.url."..mapargs.context_row.."."..mapargs.context_col])

	ndata["browser_url"] = data["browser_bookmark_l.bookmark_table.url."..mapargs.context_row.."."..mapargs.context_col]
	gre.set_data(ndata)
	
	gre.send_event("browser_load_url")
end
