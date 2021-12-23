--
-- This file is responsible for transforming the cell position to 
-- a corresponding position along the arc of a reference curve
--

-- Cache the calculated values as we get them, there are only so many y pixels
local gPositionCache

-- Mapping function for mapping an h position to an x position.
-- 
-- This particular formula maps the left hand size of an ellipse
-- that is specified within the UI design by a control containing
-- a elliptical outline (the control isn't rendered, but the outline
-- is a nice visual reference to have.
-- 
-- General parameter for an ellipse of width 2a and height 2b:
--   (x^2 / a^2) + (y^2 / b^2) = 1
--   x^2 = a^2 * (1 - (y^2 / b^2))
local function resolve_x_position_from_y(guideControlName, tcy)
 
  -- Lazy extraction of the reference curve from the design
  if(gPositionCache == nil) then
    local cInfo = gre.get_control_attrs(guideControlName, "x", "y", "width", "height")
    gPositionCache = {}
    gPositionCache.ellipse_width =  cInfo.width
    gPositionCache.ellipse_height = cInfo.height
    gPositionCache.ellipse_a_squared = (gPositionCache.ellipse_width / 2) * (gPositionCache.ellipse_width / 2)
    gPositionCache.ellipse_b_squared = (gPositionCache.ellipse_height  / 2) * (gPositionCache.ellipse_height / 2)
    gPositionCache.ellipse_cx = cInfo.x + (cInfo.width / 2)
    gPositionCache.ellipse_cy = cInfo.y + (cInfo.height / 2)
  end
  
  -- Check if we had a cached value already computed
  if(gPositionCache[tcy]) then
    return gPositionCache[tcy]
  end
  
  -- Compute and cache a value for this position
  local dy = gPositionCache.ellipse_cy - tcy
  
  -- This isn't entirely right, but is cheaper than the edge situation
  if(math.abs(dy) > (gPositionCache.ellipse_height/2)) then
    if(dy < 0) then
      dy = -gPositionCache.ellipse_cy
    else
      dy = gPositionCache.ellipse_cy
    end
  end
  
  local nx = math.sqrt(gPositionCache.ellipse_a_squared * (1 - ((dy * dy) / gPositionCache.ellipse_b_squared)))
  nx = gPositionCache.ellipse_cx - nx
 
  gPositionCache[tcy] = nx
  
  return nx
end

-- When the table's yoffset value changes an event will be triggered and that's 
-- when we want to synchronize the overlay table that is managing the gestures
-- with our visual custom controls.
--
-- We iterate through the overlay table as a reference for the y position of the 
-- individual cells in the gesture based scroller and then we use that y position 
-- as input to determine the x position/offset that we want to follow on a smooth 
-- curve.
-- 
-- We then apply that new x and y position to the controls that are visible 
--- @param gre#context mapargs
function cb_sync_position(mapargs)
  local tableName = mapargs.context_control
  local guideName = tableName .. "_guide"
  local tInfo = gre.get_table_attrs(tableName, "row", "rows", "visible_rows")
  local circle_center = gre.get_value(string.format('%s.grd_height', guideName))/2 
  --print(tableName)
  -- Really we only need to do this for visible rows ...  
  for r=1,tInfo.rows do
    local row = r
    local cellInfo = gre.get_table_cell_attrs(tableName, row, 1, "y", "height")
    local newX = resolve_x_position_from_y(guideName, cellInfo.y + (cellInfo.height / 2))
    --print(row .. ": " .. cellInfo.y)
    -- Arbitrarily scale the width of the cell based on the position
    local newWidth = (1 - (newX / 387)) * 500
    --local size_perc = math.abs(math.min(cellInfo.y / circle_center, 1))
    --print(row .. "%: " .. size_perc)
    --gre.set_value(string.format("main_menu_layer.screen_menu.width.%d.1", row), gre.get_value(string.format("main_menu_layer.screen_menu.width.%d.1", row))*size_perc)
    gre.set_table_cell_attrs(tableName, row, 1, { x = newX, width = newWidth })
  end
end
