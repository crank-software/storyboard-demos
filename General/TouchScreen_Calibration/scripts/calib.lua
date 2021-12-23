--[[
Copyright 2012, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com

More information related to the demo can be found at http://www.cranksoftware.com/forums/viewtopic.php?f=5&t=152

Calibrate a tslib based touchscreen
This assumes the appliation has a target to move around called "calib.target"
It will write the file "/etc/pointercal", change the name is required
You must run sbengine with the following option:  -otslib,calibrate
]]--

-- location goes clockwise from top left corner and then center
local location = 0
local target_size = {}
local screen_size = {}
-- calibration values
local cal_x = {}
local cal_y = {}
local cal_a = {}
-- target positions
local pos_x = {}
local pos_y = {}

function round(what)
	local precision = 8
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

function perform_calibration()
	local j;
	local n = 0;
	local x = 0
	local y = 0
	local x2 = 0
	local y2 = 0
	local xy = 0
	local z = 0
	local zx = 0
	local zy = 0;
	local det, a, b, c, e, f, i;
	local scaling = 65536.0;

--Get sums for matrix
	for j=1,5,1 do
		n = n + 1.0;
		x = x + cal_x[j];
		y = y + cal_y[j];
		x2 = x2 + (cal_x[j]*cal_x[j]);
		y2 = y2 + (cal_y[j]*cal_y[j]);
		xy = xy + (cal_x[j]*cal_y[j]);
	end

--Get determinant of matrix -- check if determinant is too small
	det = (n*(x2*y2 - xy*xy) + x*(xy*y - x*y2) + y*(x*xy - y*x2))
	if (det < 0.1) then
		if (det > -0.1) then
			print("ts_calibrate: determinant is too small -- %f\n",det);
			return 0;
		end
	end

--Get elements of inverse matrix
	a = round((x2*y2 - xy*xy)/det)
	b = round((xy*y - x*y2)/det)
	c = round((x*xy - y*x2)/det)
	e = round((n*y2 - y*y)/det)
	f = round((x*y - n*xy)/det)
	i = round((n*x2 - x*x)/det)

--Get sums for x calibration
	z = 0
	zx = 0
	zy = 0
	for j=1,5,1 do
		z = z + pos_x[j];
		zx = zx + (pos_x[j]*cal_x[j]);
		zy = zy + (pos_x[j]*cal_y[j]);
	end

--Now multiply out to get the calibration for framebuffer x coord
	cal_a[1] = round((a*z) + (b*zx) + (c*zy))*(scaling)
	cal_a[2] = round((b*z) + (e*zx) + (f*zy))*(scaling)
	cal_a[3] = round((c*z) + (f*zx) + (i*zy))*(scaling)

--Get sums for y calibration
	z = 0
	zx = 0
	zy = 0
	for j=1,5,1 do
		z = z + pos_y[j];
		zx = zx + (pos_y[j]*cal_x[j]);
		zy = zy + (pos_y[j]*cal_y[j]);
	end

--Now multiply out to get the calibration for framebuffer y coord
	cal_a[4] = round((a*z) + (b*zx) + (c*zy))*(scaling);
	cal_a[5] = round((b*z) + (e*zx) + (f*zy))*(scaling);
	cal_a[6] = round((c*z) + (f*zx) + (i*zy))*(scaling);

--If we got here, we're OK, so assign scaling to a[6] and return
	cal_a[7] = scaling;
end

function write_calib()
	local target_os = gre.env("target_os")
	if(target_os == "linux") then
		print("Calibration complete, writing /etc/pointercal")
		local directory = "/etc/"
		local file_name = "pointercal"
		
		--[[
		- If the file has not been opened, check to see if the directory/file exist
		- If the directory does not exist, then create a new one.
		- If the permission settings are insufficient for access to this file, let to user know.
		]]--
		local f,err = io.open(directory..file_name, "w")
		if not f then 
			print(err)
			if (err == (directory..file_name..": No such file or directory")) then -- Directory does not exist
				print("Make sure the directory /etc/ exists")
			elseif (err == (directory..file_name..": Permission denied")) then --Insufficient permissions
				print("Make sure you have permissions to access /etc/, \nor else run as root.")
			end			
		else -- Write the file	
			f:write(string.format("%d %d %d %d %d %d %d", cal_a[2],cal_a[3],cal_a[1],cal_a[5],cal_a[6],cal_a[4],cal_a[7]))
			f:close()
		end
	else
		print("Non-Linux system, no configuration file created")
	end
	
	gre.send_event("gre.quit")
end

function get_sample(mapargs)
	local data = {}
	
	if (location > 0) then
		-- take a sample
		cal_x[location] = mapargs.context_event_data.x
		cal_y[location] = mapargs.context_event_data.y
		print("Sample: "..location.." x="..cal_x[location].." y="..cal_y[location])	
	end
	
	location = location + 1

	if (location == 6) then
		perform_calibration()
		write_calib()
	else
		-- move the control
		data["x"] = pos_x[location]-target_size["width"]/2
		data["y"] = pos_y[location]-target_size["height"]/2
		gre.set_control_attrs("calib.target", data)
	end
end

function setup_calibration()
	local data = {}
	
	screen_size["width"] = gre.env("screen_width")
	screen_size["height"] = gre.env("screen_height")
	print("Screen: "..screen_size["width"].. "x"..screen_size["height"])
	
	target_size = gre.get_control_attrs("calib.target", "width", "height")
	print("Target: "..target_size["width"].."x"..target_size["height"])

	-- calcluate the target positions based on screen size
	-- they move clockwise around the screen from top-left 
	-- and then the last is center
	pos_x[1] = 50
	pos_x[2] = screen_size["width"] - 50
	pos_x[3] = pos_x[2]
	pos_x[4] = pos_x[1]
	pos_x[5] = screen_size["width"]/2
	
	pos_y[1] = 50
	pos_y[2] = pos_y[1]
	pos_y[3] = screen_size["height"] - 50
	pos_y[4] = pos_y[3]
	pos_y[5] = screen_size["height"]/2
	
	location = 1
	data["x"] = pos_x[location]-target_size["width"]/2
	data["y"] = pos_y[location]-target_size["height"]/2
	gre.set_control_attrs("calib.target", data)
end

