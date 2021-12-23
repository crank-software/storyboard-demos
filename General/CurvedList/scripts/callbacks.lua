require('CurvedList')

local myList

function cb_init(mapargs)
  -- (radius,cell_height,angle_increment,margin,height,num_items)
  myList = CurvedList:new(300,100,20,20,390,5)
  myList:layout("Layer.item_")
end

--- @param gre#context mapargs
function cb_drag(mapargs) 
  myList:drag(mapargs.context_event_data, mapargs.context_control)
end

function cb_press(mapargs)
  myList:press(mapargs.context_event_data, mapargs.context_control) 
end

function cb_release(mapargs)
  if (myList:release(mapargs.context_event_data, mapargs.context_control)) then
    print("Selected "..mapargs.context_control)
  end
end
