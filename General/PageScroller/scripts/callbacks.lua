require('PageScroller')

local myScroller

function select_cb(selected)
  print("Currently selected Page is: "..selected)
end

--- @param gre#context mapargs
function cb_init(mapargs) 
  -- create a new scroller PageScroller:new((layer, screen width, x-padding, animation duration in msec, select callback)
   myScroller = PageScroller:new("scroll_layer", 390, 20, 150, select_cb)

   -- add controls to the scroller
   myScroller:add_control("settings")
   myScroller:add_control("climate")
   myScroller:add_control("security")
   myScroller:add_control("calendar")
   --myScroller:dump()
end

function cb_scroll_press(mapargs)
  myScroller:press(mapargs.context_event_data.x)
end

function cb_scroll_release(mapargs)
  myScroller:release(mapargs.context_event_data.x)
end

function cb_scroll_drag(mapargs)
  myScroller:drag(mapargs.context_event_data.x)
end

