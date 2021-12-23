local  SMULTI = (272 / 480)
--local  SMULTI = 1

function controls_press(mapargs) 
	local data = {}

	local click = gre.animation_create(60, 1)

	data["key"] = mapargs.context_control..".bg_alpha"
	data["rate"] = "linear"
	data["duration"] = 250
	data["offset"] = 18
	data["from"] = 0
	data["to"] = 200
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".bg_height"
	data["to"] = 36
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".bg_width"
	data["to"] = 36
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".bg_alpha"
	data["offset"] = 268
	data["from"] = 200
	data["to"] = 0
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".height"
	data["rate"] = "easein"
	data["offset"] = 0
	data["from"] = 36
	data["to"] = 32
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".width"
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".height"
	data["rate"] = "easeout"
	data["duration"] = 400
	data["offset"] = 300
	data["from"] = 32
	data["to"] = 36
	gre.animation_add_step(click, data)
	
	data["key"] = mapargs.context_control..".width"
	gre.animation_add_step(click, data)
	
	gre.animation_trigger(click)
end

function slider_control_press(mapargs)
	local data = {}
	
	local press = gre.animation_create(60, 1)
	
	data["key"] = mapargs.context_control..".fill_alpha"
	data["rate"] = "easein"
	data["duration"] = 250
	data["offset"] = 0
	data["from"] = 0
	data["to"] = 160
	gre.animation_add_step(press, data)
		
	data["rate"] = "easein"
	data["duration"] = 500
	data["offset"] = 250
	data["from"] = 160
	data["to"] = 120
	gre.animation_add_step(press, data)
	
	data["key"] = mapargs.context_control..".stroke_alpha"
	data["rate"] = "easeout"
	data["duration"] = 600
	data["offset"] = 0
	data["from"] = 0
	data["to"] = 255
	gre.animation_add_step(press, data)
	
	data["key"] = mapargs.context_control..".stroke_height"
	data["rate"] = "linear"
	data["duration"] = 250
	data["offset"] = 0
	data["from"] = math.floor(45 * SMULTI)
	data["to"] = math.floor(35 * SMULTI)
	gre.animation_add_step(press, data)
	
	data["key"] = mapargs.context_control..".stroke_width"
	gre.animation_add_step(press, data)
	
	data["key"] = mapargs.context_control..".stroke_height"
	data["rate"] = "easeout"
	data["duration"] = 400
	data["offset"] = 250
	data["from"] = math.floor(35 * SMULTI)
	data["to"] = math.floor(45 * SMULTI)
	gre.animation_add_step(press, data)
	
	data["key"] = mapargs.context_control..".stroke_width"
	gre.animation_add_step(press, data)
	
	gre.animation_trigger(press)	
end

function slider_control_release(mapargs)
	local data = {}
	
	local release = gre.animation_create(60, 1)
	
	data["key"] = mapargs.context_control..".fill_alpha"
	data["rate"] = "easeout"
	data["duration"] = 350
	data["offset"] = 300
	data["from"] = 160
	data["to"] = 0
	gre.animation_add_step(release, data)
	
	data["key"] = mapargs.context_control..".stroke_alpha"
	data["from"] = 255
	gre.animation_add_step(release, data)
	
	gre.animation_trigger(release)	
end

