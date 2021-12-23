CurvedList = {}

local DEG_TO_RAD = (math.pi/180)

function CurvedList:new(radius,cell_height,angle_increment,margin,height,num_items)
  local newList = {}
  setmetatable(newList, self)
  self.__index = self

  newList.radius = radius
  newList.cell_height = cell_height
  newList.angle_increment = angle_increment
  newList.margin = margin
  newList.height = height
  newList.num_items = num_items
  self.last_motion_y = 0
  self.pressed = false
  self.selected_item = nil
  
  return newList
end

local function rotate(center_x, center_y, c, s, point_x, point_y)
  -- translate point back to origin
  point_x = point_x - center_x
  point_y = point_y - center_y

  -- rotate point
  local x_new = point_x * c - point_y * s
  local y_new = point_x * s + point_y * c
  
  -- translate point back
  point_x = x_new + center_x
  point_y = y_new + center_y

  local new_coord = {x = point_x, y = point_y}
  return new_coord
end

function CurvedList:layout(basename)
  local data = {}
  local new_point = {}
  local point_y
  local angle = 0
  local mindex = math.ceil(self.num_items/2)
  local hcount = math.floor(self.num_items/2)
  local half_cell = self.cell_height/2
  local radians
  local midpoint_y
  
  -- start at the midpoint
  new_point.x = self.margin
  new_point.y = self.height/2 
  data[string.format("%s%d.grd_x",basename, mindex)] = new_point.x 
  data[string.format("%s%d.grd_y",basename, mindex)] = new_point.y - half_cell
  midpoint_y = new_point.y
   
  --do the cells, but do 2 at a time, above and below 
  for i = 1, hcount do  
    angle = angle + self.angle_increment   

    radians = angle * DEG_TO_RAD
    xdist = math.floor(math.cos(radians) * self.radius)
    ydist = math.floor(math.sin(radians) * self.radius)
    -- below
    new_point.y = midpoint_y + ydist
    new_point.x = self.radius - xdist + self.margin
    data[string.format("%s%d.grd_x",basename, mindex+i)] = new_point.x 
    data[string.format("%s%d.grd_y",basename, mindex+i)] = new_point.y - half_cell
    -- above
    new_point.y = midpoint_y - ydist
    data[string.format("%s%d.grd_x",basename, mindex-i)] = new_point.x 
    data[string.format("%s%d.grd_y",basename, mindex-i)] = new_point.y - half_cell
  end
  gre.set_data(data)
  
  self.basename = basename
end

function CurvedList:press(event_data, control)
  self.pressed = true
  self.selected_item = control
end

function CurvedList:release(event_data, control)
  self.pressed = false

  if (self.selected_item) then
    return self.selected_item
  end
  return nil
end

function CurvedList:drag(event_data, control)
  if (self.pressed == false) then
    return
  end

  self.selected_item = nil
  
  local motion_x = event_data.x
  local motion_y = event_data.y
  local angle_increment
  local half_cell = self.cell_height/2
  
  --which way are we scrolling?
  if (motion_y > self.last_motion_y) then
    angle_increment = -3
  elseif (motion_y < self.last_motion_y) then
    angle_increment = 3
  else
    return
  end
  self.last_motion_y = motion_y
  
  -- precalculate the sin and cos of the angle
  local radians = angle_increment * DEG_TO_RAD
  local s = math.sin(radians)
  local c = math.cos(radians)
  
  local center_x = self.radius
  local center_y = self.height/2
    
  local data = {}
  
  for i = 1, self.num_items do
    local point_x = gre.get_value(string.format("%s%d.grd_x",self.basename,i)) 
    local point_y = gre.get_value(string.format("%s%d.grd_y",self.basename,i))+ half_cell
    local new_point = rotate(center_x, center_y, c, s, point_x, point_y)
    
    if (i == 1 and new_point.y > self.height/2) then
      return
    end
    if (i == self.num_items and new_point.y < self.height/2) then
      return
    end
    
    data[string.format("%s%d.grd_x",self.basename,i)] = new_point.x
    data[string.format("%s%d.grd_y",self.basename,i)] = new_point.y - half_cell
  end
  gre.set_data(data)
end