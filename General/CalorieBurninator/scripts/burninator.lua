
--Global table of Activities
local g_activity = {
	{
   		name = "Football", 
   		icon = "images/football.png",
   		rate = 0.061
	},
	{
   		name = "Golf", 
   		icon = "images/golf.png",
   		rate = 0.029
	},	
	{
   		name = "Dog Walking", 
   		icon = "images/walkdog.png",
   		rate = 0.033
	},	
	{
   		name = "Stroll", 
   		icon = "images/stroller.png",
   		rate = 0.023
	},	
	{
   		name = "Bicycling", 
   		icon = "images/biking.png",
   		rate = 0.049
	},	
	{
   		name = "Hiking", 
   		icon = "images/hiking.png",
   		rate = 0.046
	},	 
	{
   		name = "Rollerblading", 
   		icon = "images/roller_skate.png",
   		rate = 0.053
	},	
	{
   		name = "Tennis", 
   		icon = "images/tennis.png",
   		rate = 0.061
	},	
	{
   		name = "Dancing", 
   		icon = "images/dancing.png",
   		rate = 0.038
	},	
	{
   		name = "Skating", 
   		icon = "images/skating.png",
   		rate = 0.046
	},		
	{
   		name = "Downhill Ski", 
   		icon = "images/ski_downhill.png",
   		rate = 0.049
	},	
	{
   		name = "X-Country Ski", 
   		icon = "images/xcountryski.png",
   		rate = 0.061
	},	
	{
   		name = "Sledding", 
   		icon = "images/sledding.png",
   		rate = 0.053
	},
	{
   		name = "Aerobics", 
   		icon = "images/aerobics.png",
   		rate = 0.045
	},
	{
   		name = "Baseball", 
   		icon = "images/baseball.png",
   		rate = 0.039
	},		
	{
   		name = "Canoeing", 
   		icon = "images/canoe.png",
   		rate = 0.045
	},	
	{
   		name = "Rowing", 
   		icon = "images/row.png",
   		rate = 0.08
	},	
	{
   		name = "Yoga", 
   		icon = "images/yoga.png",
   		rate = 0.03
	},
	{
   		name = "Jogging", 
   		icon = "images/running.png",
   		rate = 0.075
	},	
	{
   		name = "Soccer", 
   		icon = "images/soccer.png",
   		rate = 0.052
	},			
	{
   		name = "Water Skiing", 
   		icon = "images/waterski.png",
   		rate = 0.048
	},		
}

-- Populate activities in table
function load_activities()
	local data = {}
	
	for i=1, table.maxn(g_activity) do
		data["tumbler_layer.activity.text."..i..".1"] = g_activity[i].name
		data["tumbler_layer.activity.image."..i..".1"] = g_activity[i].icon
	end
	
	data["tumbler_layer.activity.rows"] = table.maxn(g_activity)
	data["tumbler_layer.activity.grd_height"] = 40 * table.maxn(g_activity)
	
	gre.set_data(data)
	gre.send_event_target("resize_table","tumbler_layer.activity")
end  


-- Populate hours in table
function load_hours()
	local data = {}
	local hours = 24
	
	for i=1, hours do
		data["tumbler_layer.hours.text."..i..".1"] = (i-1).." hr"
	end
	
	data["tumbler_layer.hours.rows"] = hours + 1
	data["tumbler_layer.hours.grd_height"] = 40 * hours 
	
	gre.set_data(data)
	gre.send_event_target("resize_table","tumbler_layer.hours")
end  

--Populate minutes in table
function load_minutes()
	local data = {}
	local minutes = 60
	
	for i=1, (minutes/5) do
		data["tumbler_layer.minutes.text."..i..".1"] = ((i-1)*5).." min"
	end
	
	data["tumbler_layer.minutes.rows"] = minutes / 5
	data["tumbler_layer.minutes.grd_height"] = 40 * (minutes / 5)
	
	gre.set_data(data)
	gre.send_event_target("resize_table","tumbler_layer.minutes")
end  
   
-- Load the intial values in the tumblers   
function cb_load_tumblers(mapargs)
	load_activities()
	load_hours()
	load_minutes()
end  

--Return the activity selected
function get_activity_index()
	local gdata = {}
	local index
	
	gdata = gre.get_data("tumbler_layer.activity.grd_y")
	if gdata["tumbler_layer.activity.grd_y"] < 0 then
		index = math.abs(gdata["tumbler_layer.activity.grd_y"] / 40)+ 3
	else
		index = 3 - math.abs(gdata["tumbler_layer.activity.grd_y"] / 40)
	end

	return index
end

-- Return the value for the number of hours
function get_hour_value()
	local gdata = {}
	local index
	
	gdata = gre.get_data("tumbler_layer.hours.grd_y")
	
	if gdata["tumbler_layer.hours.grd_y"] < 0 then
		index = math.abs(gdata["tumbler_layer.hours.grd_y"] / 40)+ 3
	else
		index = 3 - math.abs(gdata["tumbler_layer.hours.grd_y"] / 40)
	end
	
	return (index -1)
end

-- Return the value for the number of minutes
function get_minute_value()
	local gdata = {}
	local index
	
	gdata = gre.get_data("tumbler_layer.minutes.grd_y")

	if gdata["tumbler_layer.minutes.grd_y"] < 0 then
		index = math.abs(gdata["tumbler_layer.minutes.grd_y"] / 40)+ 3
	else
		index = 3 - math.abs(gdata["tumbler_layer.minutes.grd_y"] / 40)
	end
	
	return ((index -1) * 5)
end


function cb_calc_burn(mapargs)
	local data = {}
	
	local index = get_activity_index()
	local hours = get_hour_value()
	local minutes = get_minute_value()
	
	local time = (hours * 60) + minutes 
	
	data["dialog_layer.icon.image"] = g_activity[index].icon
	data["dialog_layer.desciption.text"] = "A "..weight.." lbs person doing "..time.." minutes of "..g_activity[index].name.." will burn"
	local cal = math.floor(g_activity[index].rate * weight * time) 
	data["dialog_layer.calories.text"] = cal.." Calories"
	
	gre.set_data(data)
	gre.send_event("show_results")
end


