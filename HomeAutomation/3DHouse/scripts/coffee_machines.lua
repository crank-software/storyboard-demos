--VARIABLES TO CHANGE/WHAT THEY DO
--FORMAT (VARIABLE::COMMENT ON WHAT THEY CHANGE)

--"mapargs.context_group.program_number" :: The number of the program between 1-5. See programs table to see the types of programs - number is the index of this table
--"mapargs.context_group.program_text" :: The text that shows up and refers to said program
--"mapargs.context_group.icon_circle.image", "mapargs.context_group.small_icon.image" :: either on or off icon (colour change between the two) - "images/coffee_maker_off_icon.png", "images/coffee_maker_icon.png"
--"mapargs.context_group.status.text" :: the text of the status (on/off) - BUSY/IDLE
--"mapargs.context_group.status.bg_image" :: the bg of the status (on/off) - "images/status_bg_off.png", "images/status_bg.png"
--"mapargs.context_group.toggle" :: the toggle state of the coffee machine (0/1) - 0 is idle, 1 is busy

--WHAT TO CHANGE FOR STANDARD USE CASES

--TURN COFFEE ON OFF :: REFER TO cb_coffee_toggle FUNCTION ON LINE 61
--SET THE COFFEE PROGRAM :: "mapargs.context_group.program.text", "mapargs.context_group.program_number" 

--{"notif":"property_update","property":{"value":"busy","id":{"name":"coffee_status","did":"0001C014F4A7-mBedCoffeeMachine-00049F024661"}}}


local programs={"Arpeggio", "Decaffeinato Intenso", "Livanto", "Roma", "Vivalto Lungo", "Uninitialized"}
local program_num
local data_table = {}
local data = {}
local toggle

function updateCoffeeUI(self)
  local data={}

  local target=self.controlData.groupName
  
  if(self.controlData.controlType == "coffee_machine")then

    if(self.properties.coffee_status == "idle")then
      data[target..".icon_circle.image"] = "images/coffee_maker_off_icon.png"
      data[target..".status.text"] = "IDLE"
      data[target..".status.bg_image"] = "images/status_bg_off.png"
      data[target..".small_icon.image"] = "images/coffee_maker_off_icon.png"
      data[target..".toggle"] = 0
    elseif(self.properties.coffee_status == "busy")then
      data[target..".icon_circle.image"] = "images/coffee_maker_on_icon.png"
      data[target..".status.text"] = "BUSY"
      data[target..".status.bg_image"] = "images/status_bg.png"
      data[target..".small_icon.image"] = "images/coffee_maker_on_icon.png"
      data[target..".toggle"] = 1
    else
      print("Warning ("..self.controlData.controlType..") : unkown state -> "..self.properties.coffee_status)
      return
    end

    if self.properties.coffee_program == "arpeggio" then
      program_num = 1
      data[target..".program_number"] = program_num
      data[target..".program.text"] = programs[program_num]
    elseif self.properties.coffee_program == "decaffeinato_intenso" then
      program_num = 2
      data[target..".program_number"] = program_num
      data[target..".program.text"] = programs[program_num] 
    elseif self.properties.coffee_program == "livanto" then
      program_num = 3
      data[target..".program_number"] = program_num
      data[target..".program.text"] = programs[program_num]  
    elseif self.properties.coffee_program == "roma" then
      program_num = 4
      data[target..".program_number"] = program_num
      data[target..".program.text"] = programs[program_num]  
    elseif self.properties.coffee_program == "vivalto_lungo" then
      program_num = 5
      data[target..".program_number"] = program_num
      data[target..".program.text"] = programs[program_num] 
    elseif self.properties.coffee_program == "uninitialized" then
      program_num = 6
      data[target..".program_number"] = program_num
      data[target..".program.text"] = programs[program_num] 
    else
      print("Warning ("..self.controlData.controlType..") : unkown program -> "..self.properties.coffee_program)
      return
    end
  
  elseif(self.controlData.controlType == "coffee_is2t")then
       
      if(self.properties.coffee_status == "stop")then
      data[target..".icon_circle.image"] = "images/coffee_maker_off_icon.png"
      data[target..".status.text"] = "IDLE"
      data[target..".status.bg_image"] = "images/status_bg_off.png"
      data[target..".small_icon.image"] = "images/coffee_maker_off_icon.png"
      data[target..".toggle"] = 0
    elseif(self.properties.coffee_status == "start")then
      data[target..".icon_circle.image"] = "images/coffee_maker_on_icon.png"
      data[target..".status.text"] = "BUSY"
      data[target..".status.bg_image"] = "images/status_bg.png"
      data[target..".small_icon.image"] = "images/coffee_maker_on_icon.png"
      data[target..".toggle"] = 1
    else
      print("Warning ("..self.controlData.controlType..") : unkown state -> "..self.properties.coffee_status)
      return
    end
  
    if self.properties.coffee_program == "single" then
      data[target..".program_number"] = program_num
      data[target..".program.text"] = "Single"
    elseif self.properties.coffee_program == "couple" then
      data[target..".program_number"] = program_num
      data[target..".program.text"] = "Couple"
    elseif self.properties.coffee_program == "lungo" then
      data[target..".program_number"] = program_num
      data[target..".program.text"] = "Lungo"
    else
      print("Warning ("..self.controlData.controlType..") : unkown program -> "..self.properties.coffee_program)
      return
    end
    
  else
     print("Warning ("..self.controlData.controlType..") : currently not handled in update script")
     return
  end 
  data[self.controlData.overallDisplay] = string.lower(data[target..".status.text"])
  gre.set_data(data)
end

function cb_coffee_program_next(mapargs)
  data_table = gre.get_data(mapargs.context_group..".program_number")
  program_num = data_table[mapargs.context_group..".program_number"]
  program_num = program_num + 1
  
  if(program_num > 5)then
    program_num = 1
  end
  
  program_num = tonumber(program_num)
  
  local data = {} 
  data[mapargs.context_group..".program.text"] = programs[program_num]
  data[mapargs.context_group..".program_number"] = program_num
  gre.set_data(data)  
end

function cb_coffee_program_prev(mapargs)
  local data_table = gre.get_data(mapargs.context_group..".program_number")
  program_num = data_table[mapargs.context_group..".program_number"]
  program_num = program_num - 1
  
  if(program_num < 1)then
    program_num = 5
  end
  
  program_num = tonumber(program_num)
  
  local data = {} 
  data[mapargs.context_group..".program.text"] = programs[program_num]
  data[mapargs.context_group..".program_number"] = program_num
  gre.set_data(data)
end

function cb_coffee_toggle(mapargs)

  local data_table = gre.get_data(mapargs.context_group..".toggle")
  toggle = data_table[mapargs.context_group..".toggle"]
  
  if(toggle == 1)then
    data[mapargs.context_group..".icon_circle.image"] = "images/coffee_maker_off_icon.png"
    data[mapargs.context_group..".status.text"] = "IDLE"
    data[mapargs.context_group..".status.bg_image"] = "images/status_bg_off.png"
    data[mapargs.context_group..".small_icon.image"] = "images/coffee_maker_off_icon.png"
    data[mapargs.context_group..".toggle"] = 0
  else
    data[mapargs.context_group..".icon_circle.image"] = "images/coffee_maker_on_icon.png"
    data[mapargs.context_group..".status.text"] = "BUSY"
    data[mapargs.context_group..".status.bg_image"] = "images/status_bg.png"
    data[mapargs.context_group..".small_icon.image"] = "images/coffee_maker_on_icon.png"
    data[mapargs.context_group..".toggle"] = 1
  end
  
  gre.set_data(data)
  
end


function animate_coffee_close(mapargs)

  print("called_coffee_close")
  
  local anim_data = {}  
  local group_coffee_close = gre.animation_create(60,1)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 1
  anim_data["offset"] = 695
  anim_data["key"] = mapargs.context_group..".icon_circle.grd_hidden"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 130
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 518
  anim_data["key"] = mapargs.context_group..".transition_circle.alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 176
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 519
  anim_data["key"] = mapargs.context_group..".icon_circle.bg_alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
    
  anim_data["duration"] = 350
  anim_data["rate"] = "linear"
  anim_data["from"] = 90*.66
  anim_data["to"] = 0
  anim_data["offset"] = 647
  anim_data["key"] = mapargs.context_group..".transition_circle.rad"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 168
  anim_data["key"] = mapargs.context_group..".coffee_bg.alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 272*.66
  anim_data["to"] = 0
  anim_data["offset"] = 168
  anim_data["key"] = mapargs.context_group..".coffee_bg.grd_width"
  gre.animation_add_step(group_coffee_close, anim_data)
    
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 42
  anim_data["key"] = mapargs.context_group..".next_arrow.alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 28
  anim_data["key"] = mapargs.context_group..".prev_arrow.alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = mapargs.context_group..".program.alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 168
  anim_data["key"] = mapargs.context_group..".status.alpha"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 79*.66
  anim_data["to"] = 0
  anim_data["offset"] = 168
  anim_data["key"] = mapargs.context_group..".status.grd_width"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 5*.66
  anim_data["to"] = 75*.66
  anim_data["offset"] = 168
  anim_data["key"] = mapargs.context_group..".status.grd_x"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 1
  anim_data["offset"] = 495
  anim_data["key"] = mapargs.context_group..".status.grd_hidden"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 1
  anim_data["offset"] = 157
  anim_data["key"] = mapargs.context_group..".program.grd_hidden"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 1
  anim_data["offset"] = 212
  anim_data["key"] = mapargs.context_group..".prev_arrow.grd_hidden"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 1
  anim_data["offset"] = 226
  anim_data["key"] = mapargs.context_group..".next_arrow.grd_hidden"
  gre.animation_add_step(group_coffee_close, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 1
  anim_data["offset"] = 520
  anim_data["key"] = mapargs.context_group..".coffee_bg.grd_hidden"
  gre.animation_add_step(group_coffee_close, anim_data)
  if(CURRENT_OPEN==mapargs.context_group)then
    CURRENT_OPEN=nil
  end
  gre.animation_trigger(group_coffee_close)

end

function animate_coffee_open(mapargs)
  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN..".auto_close")
  end
  CURRENT_OPEN=mapargs.context_group  
  
  local anim_data = {}  
  local group_status_open = gre.animation_create(60,1)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 304
  anim_data["key"] = mapargs.context_group..".icon_circle.grd_hidden"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 130
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 350
  anim_data["key"] = mapargs.context_group..".transition_circle.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 176
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 304
  anim_data["key"] = mapargs.context_group..".icon_circle.bg_alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 2
  anim_data["to"] = 2
  anim_data["offset"] = 0
  anim_data["key"] = mapargs.context_group..".transition_circle.line_width"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 176
  anim_data["rate"] = "linear"
  anim_data["from"] = 2
  anim_data["to"] = 50
  anim_data["offset"] = 176
  anim_data["key"] = mapargs.context_group..".transition_circle.line_width"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 350
  anim_data["rate"] = "linear"
  anim_data["from"] = 46*.66
  anim_data["to"] = 90*.66
  anim_data["offset"] = 0
  anim_data["key"] = mapargs.context_group..".transition_circle.rad"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 478
  anim_data["key"] = mapargs.context_group..".coffee_bg.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 272*.66
  anim_data["offset"] = 478
  anim_data["key"] = mapargs.context_group..".coffee_bg.grd_width"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = mapargs.context_group..".next_arrow.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = mapargs.context_group..".prev_arrow.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = mapargs.context_group..".program.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 773
  anim_data["key"] = mapargs.context_group..".next_arrow.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 787
  anim_data["key"] = mapargs.context_group..".prev_arrow.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 815
  anim_data["key"] = mapargs.context_group..".program.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 478
  anim_data["key"] = mapargs.context_group..".status.alpha"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 184
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 79
  anim_data["offset"] = 646
  anim_data["key"] = mapargs.context_group..".status.grd_width"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 352
  anim_data["rate"] = "linear"
  anim_data["from"] = 75
  anim_data["to"] = 5
  anim_data["offset"] = 478
  anim_data["key"] = mapargs.context_group..".status.grd_x"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 504
  anim_data["key"] = mapargs.context_group..".status.grd_hidden"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 842
  anim_data["key"] = mapargs.context_group..".program.grd_hidden"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 787
  anim_data["key"] = mapargs.context_group..".prev_arrow.grd_hidden"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 773
  anim_data["key"] = mapargs.context_group..".next_arrow.grd_hidden"
  gre.animation_add_step(group_status_open, anim_data)
  
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 478
  anim_data["key"] = mapargs.context_group..".coffee_bg.grd_hidden"
  gre.animation_add_step(group_status_open, anim_data)
  
  gre.animation_trigger(group_status_open)

end