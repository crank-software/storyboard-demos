NOTIFICATION_SLOT_ARRAY = {}
NOTIFICATION_TEMP_ARRAY = {}
NOTIFICATION_CONTROL_NUM = 0
NOTIFICATION_DELETE_CONTROL = nil

ARRAY_SIZE = 100

NOTIFICATION_CONTROL_DELETING_ACTIVE = 0

function notification_inits(mapargs)
  for i=1,ARRAY_SIZE do
    NOTIFICATION_SLOT_ARRAY[i] = ""
  end
  for i=1,ARRAY_SIZE do
    NOTIFICATION_TEMP_ARRAY[i] = ""
  end
  
  --print("slots initiated")

end

function notification_incoming(title,details)
  
  --increase the number of the control - these numbers will always be unique, so none of the notification controls are the same
  NOTIFICATION_CONTROL_NUM = NOTIFICATION_CONTROL_NUM + 1
  
  --setting up position of the new control 
  local dk_data = {}
  dk_data["y"] = 60
  dk_data["x"] = 1280
  dk_data["hidden"] = 0
  local newName="notification_block_"..NOTIFICATION_CONTROL_NUM
  local data={}
  
  --cloning the control and setting the new name control to the show animation
  gre.clone_control("notification_block", newName, "notification_layer", dk_data)
  local new_control_target = "notification_layer."..newName
  data[new_control_target..".title"]=title
  data[new_control_target..".data"]=details
  gre.set_data(data)
  
  notification_animation_show(new_control_target)
 
  local cb = function()
    gre.send_event_target("notification_hide",new_control_target)
  end 
  gre.timer_set_timeout(cb, 5000)
  
  --Check to see if the last slot is filled, reset the array to have nothing in it
  if(NOTIFICATION_SLOT_ARRAY[ARRAY_SIZE] ~= "")then
    notification_animation_hide(NOTIFICATION_SLOT_ARRAY[ARRAY_SIZE])
    NOTIFICATION_SLOT_ARRAY[ARRAY_SIZE] = ""
  end

  --Put this control into the temporary array
  NOTIFICATION_TEMP_ARRAY[1] = new_control_target
  
  --push the notifications down and then rearragne the slots to show the new arrangement
  local j = 1
  while NOTIFICATION_SLOT_ARRAY[j] ~= "" do
    notification_animation_push(j)
    --Put the control into the temporary array into the position the control moved to
    NOTIFICATION_TEMP_ARRAY[j + 1] = NOTIFICATION_SLOT_ARRAY[j]
    j = j + 1
  end
    
  --Start the rearranging at the second slot, the first was already set at line 32
  for i=1,ARRAY_SIZE do
    if(NOTIFICATION_TEMP_ARRAY[i] ~= "")then
      NOTIFICATION_SLOT_ARRAY[i] = NOTIFICATION_TEMP_ARRAY[i]
    end
  end
  
  --print("--NEW ARRAY BELOW--")  
  for i=1,ARRAY_SIZE do
    --print(NOTIFICATION_SLOT_ARRAY[i])
  end
  
end

function notification_hide(mapargs)

 --if the notification has deleted, then we can call this again
 -- if(NOTIFICATION_CONTROL_DELETING_ACTIVE == 0)then
  
    local hidden_index_loc = 0
      
    --fill temporary array
    for i=1,ARRAY_SIZE do
      NOTIFICATION_TEMP_ARRAY[i] = NOTIFICATION_SLOT_ARRAY[i]
    end
    
    for i=1,ARRAY_SIZE do
      if(NOTIFICATION_SLOT_ARRAY[i] == mapargs.context_control)then
        hidden_index_loc = i
      end
      --go through list, when the mapargs.context_control = the other one we found the one
    end
      
    for i=1,ARRAY_SIZE do 
      if(i < hidden_index_loc)then
        NOTIFICATION_SLOT_ARRAY[i] = NOTIFICATION_TEMP_ARRAY[i]
      elseif(i == hidden_index_loc)then

        notification_animation_hide(NOTIFICATION_SLOT_ARRAY[i])

      else
        notification_animation_push_up(i)
        NOTIFICATION_SLOT_ARRAY[i-1] = NOTIFICATION_TEMP_ARRAY[i]
      end
    end
    
    if(NOTIFICATION_SLOT_ARRAY[ARRAY_SIZE] ~= "")then
      NOTIFICATION_SLOT_ARRAY[ARRAY_SIZE] = ""
    end
end




function notification_animation_show(control)

  local anim_data = {}
  local notification_show = gre.animation_create(60,1)  
  
  --reset animations to make sure the 0s are set at the beginning
 
  anim_data["duration"] = 0
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 0
  anim_data["offset"] = 0
  
  anim_data["key"] = control..".bot_stroke_alpha"
  gre.animation_add_step(notification_show, anim_data)  
  anim_data["key"] = control..".close_alpha"
  gre.animation_add_step(notification_show, anim_data)  
  anim_data["key"] = control..".data_alpha"
  gre.animation_add_step(notification_show, anim_data)  
  anim_data["key"] = control..".data_width"
  gre.animation_add_step(notification_show, anim_data)   
  anim_data["key"] = control..".title_alpha"
  gre.animation_add_step(notification_show, anim_data)  
  anim_data["key"] = control..".title_width"
  gre.animation_add_step(notification_show, anim_data)  
  anim_data["key"] = control..".top_stroke_alpha"
  gre.animation_add_step(notification_show, anim_data)  
  
  --end of resets  
  
  
  anim_data["duration"] = 700
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 0
  anim_data["key"] = control..".bg_alpha"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 500
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 388
  anim_data["key"] = control..".bot_stroke_alpha"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 250
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 514
  anim_data["key"] = control..".close_alpha"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 400
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 462
  anim_data["key"] = control..".data_alpha"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 400
  anim_data["rate"] = "easeout"
  anim_data["from"] = 0
  anim_data["to"] = 300
  anim_data["offset"] = 462
  anim_data["key"] = control..".data_width"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 700
  anim_data["rate"] = "easeinout"
  anim_data["from"] = 0
  anim_data["to"] = 324
  anim_data["offset"] = 0
  anim_data["key"] = control..".grd_width"
  gre.animation_add_step(notification_show, anim_data)

  anim_data["duration"] = 700
  anim_data["rate"] = "easeinout"
  anim_data["from"] = 1280
  anim_data["to"] = 957
  anim_data["offset"] = 0
  anim_data["key"] = control..".grd_x"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 400
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 398
  anim_data["key"] = control..".title_alpha"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 400
  anim_data["rate"] = "easeout"
  anim_data["from"] = 0
  anim_data["to"] = 300
  anim_data["offset"] = 398
  anim_data["key"] = control..".title_width"
  gre.animation_add_step(notification_show, anim_data)
  
  anim_data["duration"] = 500
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 308
  anim_data["key"] = control..".top_stroke_alpha"
  gre.animation_add_step(notification_show, anim_data)

  gre.animation_trigger(notification_show)
  
end

function notification_animation_hide(control)
  local anim_data = {}
  
  local cb = function()
    gre.delete_control(control) 
  end
  local notification_hide = gre.animation_create(60,1,cb)  
  
  --reset animations to make sure the 0s are set at the beginning
 
  anim_data["duration"] = 500
  anim_data["rate"] = "easeinout"
  anim_data["from"] = 487
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = control..".grd_width"
  gre.animation_add_step(notification_hide, anim_data)  
  
  anim_data["duration"] = 500
  anim_data["rate"] = "easeinout"
  anim_data["from"] = 1280 -324
  anim_data["to"] = 1280
  anim_data["offset"] = 0
  anim_data["key"] = control..".grd_x"
  gre.animation_add_step(notification_hide, anim_data)  

  gre.animation_trigger(notification_hide)

end

function notification_animation_push(slot)
  
 local anim_data = {}
 local notification_push = gre.animation_create(60,1)  
 
 --print("pushed down"..slot)
 
 anim_data["duration"] = 500
 anim_data["rate"] = "easeinout"
 anim_data["from"] = 70*slot
 anim_data["to"] = 70*slot + 70
 anim_data["offset"] = 0
 anim_data["key"] = NOTIFICATION_SLOT_ARRAY[slot]..".grd_y"
 gre.animation_add_step(notification_push, anim_data)  
 
 
 gre.animation_trigger(notification_push)

end

function notification_animation_push_up(slot)
  
 local anim_data = {}
 local notification_push = gre.animation_create(60,1)  
 
 --print("pushed down"..slot)
 
 anim_data["duration"] = 500
 anim_data["rate"] = "easeinout"
 anim_data["from"] = 70*slot
 anim_data["to"] = 70*slot - 70
 anim_data["offset"] = 0
 anim_data["key"] = NOTIFICATION_SLOT_ARRAY[slot]..".grd_y"
 gre.animation_add_step(notification_push, anim_data)  
 
 
 gre.animation_trigger(notification_push)

end

function notification_animation_press(control)
  local anim_data = {}
  local notification_press = gre.animation_create(60,1)  
  
  --reset animations to make sure the 0s are set at the beginning
 
  anim_data["duration"] = 150
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = control..".bot_stroke_alpha"
  gre.animation_add_step(notification_press, anim_data)  

  anim_data["duration"] = 350
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 150
  anim_data["key"] = control..".bot_stroke_alpha"
  gre.animation_add_step(notification_press, anim_data)
  
  anim_data["duration"] = 150
  anim_data["rate"] = "linear"
  anim_data["from"] = 255
  anim_data["to"] = 0
  anim_data["offset"] = 0
  anim_data["key"] = control..".top_stroke_alpha"
  gre.animation_add_step(notification_press, anim_data)  

  anim_data["duration"] = 350
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 255
  anim_data["offset"] = 150
  anim_data["key"] = control..".top_stroke_alpha"
  gre.animation_add_step(notification_press, anim_data)  
    
  anim_data["duration"] = 150
  anim_data["rate"] = "linear"
  anim_data["from"] = 0
  anim_data["to"] = 10
  anim_data["offset"] = 0
  anim_data["key"] = control..".GL_yrot"
  gre.animation_add_step(notification_press, anim_data)  
  
  anim_data["duration"] = 350
  anim_data["rate"] = "linear"
  anim_data["from"] = 10
  anim_data["to"] = 0
  anim_data["offset"] = 150
  anim_data["key"] = control..".GL_yrot"
  gre.animation_add_step(notification_press, anim_data)  


  gre.animation_trigger(notification_press)
  
end