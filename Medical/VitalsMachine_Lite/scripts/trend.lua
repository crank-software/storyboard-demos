local ecgSmall = {}
local plethSmall = {}

local startx = 0
local starty = 120
local max_idx = 376
local cur_w_idx = 1
local wrapped = 1 

local g_scale_rpm = 0.7
local g_scale_bpm = 0.7

function update_small_graphs ( mapargs )
  local v = {}
  local iter
  local radinc
  local theta

  max_idx = table.getn(ecgSmall)

  -- Use a circular buffer to keep points in a sin wave, adjusting position in screen
  -- and then change points into a polygon string  
  if cur_w_idx > max_idx then
    cur_w_idx = 1
    wrapped = 1
  end   
  
  iter = cur_w_idx

  local ecgPointData = {} 
  local oxiPointData = {} 
  while (iter > 0) do
    newstr = string.format("%d:%d", (max_idx - (cur_w_idx-iter) - 1)*3, ecgSmall[iter]*1.5)
    table.insert(ecgPointData, newstr)

    newstr = string.format("%d:%d", (max_idx - (cur_w_idx-iter) - 1)*3, plethSmall[iter]*1.5)
    table.insert(oxiPointData, newstr)

    iter = iter -1
  end
  
  -- Gone around once so now fill in the old point data
  if (wrapped == 1) then
    iter = max_idx    
    
    while (iter > cur_w_idx) do   
      newstr = string.format("%d:%d", (iter - cur_w_idx - 1)*3, ecgSmall[iter]*1.5)
      table.insert(ecgPointData, newstr)
    
      newstr = string.format("%d:%d", (iter - cur_w_idx - 1)*3, plethSmall[iter]*1.5)
      table.insert(oxiPointData, newstr)
    
      iter = iter -1
    end
  else
    -- extend to start of trend window for a flat line 
    if (cur_w_idx < max_idx) then 
      newstr = string.format(" %d:%d",startx,starty)    
      table.insert(ecgPointData, newstr)
      table.insert(oxiPointData, newstr)
    end
  end

  cur_w_idx = cur_w_idx + 1

  local ecgPoints = table.concat(ecgPointData, " ") 
  v["home_layer.2_group.trend.trendData"] = ecgPoints
  v["home_layer.2_group.trend.trendFillData"] = ecgPoints  .. " 1:134 6:140 369:140 374:134 477:134 "

  local oxiPoints = table.concat(oxiPointData, " ") 
  v["home_layer.3_group.trend.trendData"] = oxiPoints
  v["home_layer.3_group.trend.trendFillData"] = oxiPoints .. " 1:134 6:140 369:140 374:134 477:134 "
  
  gre.set_data(v)

end

function plot(mapargs)
  local data = {}
  local ecgData = {79 ,79 ,79 ,78 ,78 ,77 ,77 ,77 ,77 ,77 ,76 ,76 ,76 ,76 ,76 ,75 ,75 ,75 ,75 ,74 ,73 ,71 ,68 ,66 ,63 ,60 ,59 ,59 ,60 ,62 ,65 ,68 ,71 ,73 ,75 ,75 ,76 ,78 ,82 ,78 ,56 ,27 ,13 ,17 ,38 ,70 ,88 ,83 ,78 ,76 ,76 ,75 ,75 ,74 ,72 ,71 ,69 ,66 ,64 ,61 ,58 ,55 ,53 ,52 ,51 ,52 ,53 ,55 ,57 ,60 ,63 ,66 ,69 ,72 ,75 ,76 ,77 ,78 ,78 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,78 ,78 ,76 ,74 ,72 ,69 ,67 ,64 ,63 ,63 ,65 ,67 ,70 ,73 ,76 ,78 ,79 ,80 ,81 ,83 ,87 ,80 ,56 ,29 ,17 ,25 ,50 ,80 ,92 ,86 ,82 ,81 ,80 ,80 ,80 ,79 ,77 ,75 ,73 ,71 ,68 ,65 ,62 ,59 ,58 ,57 ,57 ,57 ,59 ,61 ,63 ,66 ,69 ,72 ,75 ,78 ,80 ,81 ,82 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,82 ,82 ,82 ,82 ,82 ,81 ,80 ,78 ,76 ,74 ,71 ,68 ,67 ,66 ,67 ,69 ,71 ,74 ,77 ,80 ,81 ,81 ,82 ,84 ,88 ,85 ,64 ,35 ,21 ,25 ,45 ,76 ,95 ,90 ,85 ,83 ,82 ,82 ,81 ,80 ,78 ,77 ,75 ,72 ,69 ,66 ,63 ,60 ,58 ,57 ,56 ,56 ,57 ,59 ,61 ,64 ,67 ,70 ,73 ,76 ,78 ,79 ,80 ,81 ,81 ,82 ,82 ,81 ,81 ,81 ,81 ,81 ,81 ,81 ,80 ,80 ,80 ,80 ,80 ,80 ,79 ,79 ,79 ,79 ,78 ,78 ,76 ,74 ,72 ,69 ,66 ,63 ,62 ,62 ,63 ,65 ,67 ,70 ,73 ,75 ,77 ,77 ,78 ,80 ,83 ,80 ,60 ,31 ,16 ,19 ,17 ,28 ,56 ,84 ,93 ,87 ,83 ,82 ,81 ,81 ,80 ,79 ,77 ,75 ,73 ,70 ,68 ,65 ,62 ,59 ,57 ,56 ,55 ,56 ,57 ,59 ,62 ,64 ,67 ,70 ,73 ,76 ,77 ,78 ,78 ,79 ,79}
  local plethData = {88 ,88 ,89 ,90 ,90 ,91 ,92 ,92 ,93 ,93 ,94 ,94 ,95 ,96 ,97 ,98 ,99 ,99 ,100 ,100 ,101 ,101 ,101 ,101 ,101 ,100 ,100 ,99 ,98 ,96 ,94 ,92 ,90 ,86 ,82 ,78 ,72 ,66 ,61 ,55 ,50 ,45 ,40 ,36 ,32 ,31 ,30 ,31 ,33 ,36 ,40 ,44 ,48 ,52 ,57 ,62 ,67 ,71 ,74 ,77 ,80 ,81 ,82 ,82 ,82 ,81 ,80 ,79 ,78 ,77 ,76 ,75 ,75 ,75 ,76 ,76 ,77 ,78 ,80 ,81 ,83 ,84 ,86 ,87 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,96 ,97 ,97 ,98 ,98 ,98 ,98 ,98 ,97 ,97 ,96 ,95 ,94 ,93 ,91 ,89 ,86 ,82 ,78 ,74 ,69 ,63 ,57 ,51 ,46 ,41 ,36 ,33 ,30 ,28 ,28 ,29 ,31 ,34 ,38 ,42 ,46 ,51 ,56 ,60 ,65 ,69 ,73 ,76 ,78 ,79 ,80 ,80 ,80 ,79 ,78 ,77 ,76 ,75 ,74 ,74 ,73 ,73 ,74 ,74 ,75 ,77 ,78 ,80 ,81 ,83 ,84 ,86 ,87 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,95 ,96 ,96 ,96 ,95 ,95 ,95 ,95 ,94 ,94 ,93 ,92 ,91 ,89 ,87 ,84 ,80 ,76 ,72 ,66 ,60 ,54 ,49 ,43 ,38 ,33 ,30 ,27 ,25 ,25 ,26 ,28 ,30 ,34 ,38 ,42 ,47 ,51 ,56 ,61 ,66 ,69 ,72 ,74 ,75 ,76 ,77 ,76 ,76 ,75 ,74 ,73 ,72 ,71 ,70 ,70 ,70 ,71 ,71 ,72 ,73 ,74 ,75 ,77 ,78 ,80 ,81 ,83 ,84 ,85 ,86 ,88 ,89 ,89 ,90 ,91 ,91 ,92 ,92 ,92 ,92 ,92 ,92 ,92 ,91 ,90 ,89 ,87 ,85 ,83 ,80 ,76 ,72 ,67 ,61 ,55 ,49 ,43 ,37 ,32 ,28 ,24 ,21 ,19 ,19 ,20 ,22 ,25 ,29 ,33 ,37 ,42 ,47 ,52 ,57 ,62 ,66 ,69 ,71 ,73 ,74 ,74 ,74 ,73 ,72 ,71 ,70 ,69 ,69 ,68 ,68 ,69 ,70 ,71 ,72 ,73 ,75 ,76 ,78 ,80 ,81 ,82 ,83 ,84 ,85 ,85 ,86 ,86 ,87 ,87 ,87 ,87 ,87}
  local n = 0
  local i = 0
  local nn = 0
  local v
  local rand = 0
  local ecgPointsBig = ""
 
  -- scale data 
  n = table.getn(ecgData)
  for i = 1, n, 1 do
    ecgData[i] = ((ecgData[i]+15) * g_scale_bpm) 
    plethData[i] = (((plethData[i]*.25)+70) * g_scale_rpm)
  end

  for i = 1, n/2, 1 do
    ecgSmall[i] = ecgData[i*2] -- rand
    plethSmall[i] = plethData[i*2]
  end
  
  n = table.getn(ecgSmall)
  
  local point
  local ecgPointData = {}
  local oxiPointData = {}
  for i = 1, n, 1 do
    point = string.format("%.0f",i*3)..":"..string.format("%.0f", ecgSmall[i]*1.5)
    table.insert(ecgPointData, point)

    point = string.format("%.0f",i*3)..":"..string.format("%.0f", plethSmall[i]*1.5)
    table.insert(oxiPointData, point)
  end
  
  local ecgPoints = table.concat(ecgPointData, " ") 
  data["home_layer.2_group.trend.trendData"] = ecgPoints
  data["home_layer.2_group.trend.trendFillData"] = ecgPoints
  
  local oxiPoints = table.concat(oxiPointData, " ") 
  data["home_layer.3_group.trend.trendData"] = oxiPoints
  data["home_layer.3_group.trend.trendFillData"] = oxiPoints
  
  gre.set_data(data)

end
