--[[
  Copyright 2019, Crank Software Inc.
  All Rights Reserved.
  For more information email info@cranksoftware.com
  ** FOR DEMO PURPOSES ONLY **
]]--

--[[
  This module will move controls on a layer in the x direction.  It allows scrolling/paging of the controls
  assuming the controls each cover a screen area. It will snap the controls to the screen size and animate
  back to the proper position once a release happens. If the new control has move 50% of the way the animation
  will happen to move to a new position. Once the animation is complete it will triger a callback to notify
  the application that a new item has been selected
]]--

PageScroller = {}

-- Create a new page scroller instance with the initial values
function PageScroller:new(layer, size, pad, duration, cb, drag_cb)
  local newScroller = {}
  setmetatable(newScroller, self)
  self.__index = self

  -- the layer used as a container for controls
  newScroller.layer = layer
  -- padding (from the left) for the controls in the x direction
  newScroller.pad = pad
  -- the total screen/layer width
  newScroller.width = size
  -- a callback to invoke when the scroll is complete
  newScroller.cb = cb
  newScroller.drag_notify_cb = drag_cb
  -- internal list of controls being scrolled
  newScroller.controls = {}
  -- animation for the release
  newScroller.anim = nil
  -- are we activly dragging
  newScroller.pressed = false
  -- current position
  newScroller.pos = 1
  -- complete animation duration
  newScroller.duration = duration
  
  return newScroller
end

-- add a control to the Scroller instance
function PageScroller:add_control(control)
  table.insert(self.controls, control)
end

-- Dump the list of controls for debugging
function PageScroller:dump()
  print("== Controls ==")
  for k,v in ipairs(self.controls) do
     print(k,v)
  end
end

-- the layer containing the controls has been pressed and a scroll started
function PageScroller:press(x)
  -- do not allow a new scroll when the complete animation is running
  if (self.anim == nil) then
    self.pressed = true
    self.press_pos = x
  end
end

-- Animation complete callback for scrolling
function PageScroller:animate_complete(id)
  self.anim = nil
  -- trigger the user callback
  if (self.cb) then
    self.cb(self.controls[self.pos])
  end
end

-- A release has occurred on the layer
-- Reposition all of the controls and trigger the complete animation
function PageScroller:release(x)
  if (self.pressed == true) then
    local data = {}
    local adata = {}
    local npos = 0
    local skey
    local hkey
    
    -- move everything into position
    delta = x - self.press_pos
    if (delta < 0) then
      npos = self.pos + 1
      if (npos > #self.controls) then
        npos = 1
      end
    else
      npos = self.pos - 1
      if (npos <= 0) then
        npos = #self.controls
      end
    end
    
    -- create the animation with the complete callback
    local animation_cb = function(id)
      self:animate_complete(id)
    end

    self.anim = gre.animation_create(30, 1, animation_cb)
    adata["rate"] = "linear"
    adata["duration"] = self.duration
    adata["offset"] = 0

    -- determine which controls are shown/hidden
    if (math.abs(delta) > self.width/2) then
      show = npos
      hide = self.pos
      update = 1
    else
      show = self.pos
      hide = npos
      update = 0
    end
    
    skey = self.layer.."."..self.controls[show]..".grd_x"
    hkey = self.layer.."."..self.controls[hide]..".grd_x"
    
    -- show animation step
    adata["to"] = self.pad
    adata["key"] = skey
    gre.animation_add_step(self.anim, adata)
    
    cur = gre.get_value(hkey)
    if (cur < 0) then
      target = -self.width + self.pad
    else
      target = self.width + self.pad
    end

    -- hide animation step
    adata["to"] = target
    adata["key"] = hkey
    gre.animation_add_step(self.anim, adata)

    -- move all other controls off-screen
    for i=1,#self.controls do
      if (i ~= self.pos and i ~= npos) then
        data[self.layer.."."..self.controls[i]..".grd_x"] = self.width + self.pad
      end
    end
    
    if (update == 1) then
      self.pos = npos
    end
    
    -- set data and trigger complete animation
    gre.set_data(data)
    gre.animation_trigger(self.anim)
  end
  self.pressed = false
  self.drag_notify = 0
end

-- A motion event has triggered on the layer, move the controls
function PageScroller:drag(x)

  if (self.pressed == true) then
    local data = {}
    local cur_x = x
    local delta
    local pkey = self.layer.."."..self.controls[self.pos]..".grd_x"

    -- position the current cell
    delta = cur_x - self.press_pos
    if (math.abs(delta) < 3) then
      return
    end
    if (self.drag_notify == 0) then
      if (self.drag_notify_cb) then
        self.drag_notify_cb(self.controls[self.pos])
      end
      self.drag_notify = 1
    end
    data[pkey] = delta + self.pad
    if (delta < 0) then
      local n = self.pos + 1
      if (n > #self.controls) then
        n = 1
      end
      data[self.layer.."."..self.controls[n]..".grd_x"] = data[pkey] + self.width
    else
      local n = self.pos - 1
      if (n <= 0) then
        n = #self.controls
      end
      data[self.layer.."."..self.controls[n]..".grd_x"] = data[pkey] - self.width
    end
    gre.set_data(data)
  end
end



