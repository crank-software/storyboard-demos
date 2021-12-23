local gtablePressed = 0
local gFGTable
local gBGTable
local gBGTableHeight
local gBGTableCellCount


function CBFillTable(mapargs) 
  --fill the table with your data. Make sure to have the data duplicated
  --default setup shown below containing numbers 1-10
  
  --use this for all of your templated tables. This will be called on init
  --table 1
  local data = {}
  for i=1, 31 do
    data["dateLayer.date.backgroundTable.text."..i..".1"] = i
    data["dateLayer.date.foregroundTable.text."..i..".1"] = i
    local j = i+31
    data["dateLayer.date.backgroundTable.text."..j..".1"] = i
    data["dateLayer.date.foregroundTable.text."..j..".1"] = i
    local k = i+62
    data["dateLayer.date.backgroundTable.text."..k..".1"] = i
    data["dateLayer.date.foregroundTable.text."..k..".1"] = i
    
  end
  
  --table 2
  --Months Setup
  local months = {}
  months[1] ="January"
  months[2] ="February"
  months[3] ="March"
  months[4] ="April"
  months[5] ="May"
  months[6] ="June"
  months[7] ="July"
  months[8] ="August"
  months[9] ="September"
  months[10] ="October"
  months[11] ="November"
  months[12] ="December"
  
  for i=1, 12 do
    data["dateLayer.month.backgroundTable.text."..i..".1"] = months[i]
    data["dateLayer.month.foregroundTable.text."..i..".1"] = months[i]
    local j = i+12
    data["dateLayer.month.backgroundTable.text."..j..".1"] = months[i]
    data["dateLayer.month.foregroundTable.text."..j..".1"] = months[i]
    local k = i+24
    data["dateLayer.month.backgroundTable.text."..k..".1"] = months[i]
    data["dateLayer.month.foregroundTable.text."..k..".1"] = months[i]
  end  
  --table 3
  for i=1, 17 do
    local k = i
    if(i<10)then
      k = "0"..i
    end
    data["dateLayer.year.backgroundTable.text."..i..".1"] = "20"..k
    data["dateLayer.year.foregroundTable.text."..i..".1"] = "20"..k
    local j = i+16
    data["dateLayer.year.backgroundTable.text."..j..".1"] = "20"..k
    data["dateLayer.year.foregroundTable.text."..j..".1"] = "20"..k
    local l = i+32
    data["dateLayer.year.backgroundTable.text."..l..".1"] = "20"..k
    data["dateLayer.year.foregroundTable.text."..l..".1"] = "20"..k
  end
  
  --table 4
  for i=1, 12 do
    local k = i
    data["dateLayer.hour.backgroundTable.text."..i..".1"] = i
    data["dateLayer.hour.foregroundTable.text."..i..".1"] = i
    local j = i+12
    data["dateLayer.hour.backgroundTable.text."..j..".1"] = i
    data["dateLayer.hour.foregroundTable.text."..j..".1"] = i
    local k = i+24
    data["dateLayer.hour.backgroundTable.text."..k..".1"] = i
    data["dateLayer.hour.foregroundTable.text."..k..".1"] = i
  end
  
  --table 5
  for i=1, 60 do
    local s = i
    if s < 10 then s = "0"..s end
    data["dateLayer.minute.backgroundTable.text."..i..".1"] = s
    data["dateLayer.minute.foregroundTable.text."..i..".1"] = s
    local j = i+60
    data["dateLayer.minute.backgroundTable.text."..j..".1"] = s
    data["dateLayer.minute.foregroundTable.text."..j..".1"] = s
    local k = i+120
    data["dateLayer.minute.backgroundTable.text."..k..".1"] = s
    data["dateLayer.minute.foregroundTable.text."..k..".1"] = s
  end
  
  gre.set_data(data)
  
  --offsets the tables to halfway down depending on how large the table is
  --for the background table you want it offset down an entire table so you can see the bottom of the first table and top of the
  --second table, then subtract 35 to offset it properly in the center
  
  --BACKGROUND TABLE OFFSET EXAMPLE--
  --ex if you have 20 cells (2 tables of 10 numbers@ height of 50px each) with a table height of 480 you will offset it as follows 
  -- -500 [- (1/2 total cells (20/2 = 10) * Height of cells (50))] - The table will now be offset so the top cell is the start of the second table
  -- 240  [TABLE HEIGHT / 2] - The table will now be pushed down halfway so the top of the cell will be directly in the middle
  -- -25  [-CELL HEIGHT/2]
  -- -500 + 240 - 25 = -285
  
  --foreground table will be offset by the amount of the second table to keep in line
  --for the foreground table it is much easier, offset it by the first part of the background table
  -- -500 [- (1/2 total cells (20/2 = 10) * Height of cells (50))] - The table will now be offset so the top cell is the start of the second table
  
  
  --Table 1
  local bgTableOffset = -2885
  local fgTableOffset = -1550
  
  local dataTable = {}
  dataTable["yoffset"] = bgTableOffset
  dataTable["rows"] = 93
  gre.set_table_attrs("dateLayer.date.backgroundTable",dataTable)
  dataTable["yoffset"] = fgTableOffset
  gre.set_table_attrs("dateLayer.date.foregroundTable",dataTable)
  
  --Table 2
  bgTableOffset = -985
  fgTableOffset = -600
  
  local dataTable = {}
  dataTable["yoffset"] = bgTableOffset
  dataTable["rows"] = 36
  gre.set_table_attrs("dateLayer.month.backgroundTable",dataTable)
  dataTable["yoffset"] = fgTableOffset
  gre.set_table_attrs("dateLayer.month.foregroundTable",dataTable)
  
  --Table 3
  bgTableOffset = -1385
  fgTableOffset = -800
  
  local dataTable = {}
  dataTable["yoffset"] = bgTableOffset
  dataTable["rows"] = 48
  gre.set_table_attrs("dateLayer.year.backgroundTable",dataTable)
  dataTable["yoffset"] = fgTableOffset
  gre.set_table_attrs("dateLayer.year.foregroundTable",dataTable)

  --Table 4
  bgTableOffset = -985
  fgTableOffset = -600
  
  local dataTable = {}
  dataTable["yoffset"] = bgTableOffset
  dataTable["rows"] = 36
  gre.set_table_attrs("dateLayer.hour.backgroundTable",dataTable)
  dataTable["yoffset"] = fgTableOffset
  gre.set_table_attrs("dateLayer.hour.foregroundTable",dataTable)
  
  --Table 5
  bgTableOffset = -5785
  fgTableOffset = -3000
  
  local dataTable = {}
  dataTable["yoffset"] = bgTableOffset
  dataTable["rows"] = 180
  gre.set_table_attrs("dateLayer.minute.backgroundTable",dataTable)
  dataTable["yoffset"] = fgTableOffset
  gre.set_table_attrs("dateLayer.minute.foregroundTable",dataTable)    
end


--function CBPressTable(mapargs)
--  --setup the two tables when the area is pressed. Make sure that the two tables are the names of your tables.
--  --Default names are as below
--  gBGTable = mapargs.context_group..".backgroundTable"
--  gFGTable = mapargs.context_group..".foregroundTable"
--  
--  local dk_data = {}
--  dk_data = gre.get_table_attrs(gBGTable, "height", "cellcount")
--  --print(dk_data["height"], dk_data["rows"]) 
--  gBGTableHeight = dk_data["height"]
--  gBGTableCellCount = dk_data["rows"]
--end

--check and setup table locations--\



--TABLES, EACH HAVE UNIQUE FUNCTION AND ANIMATIONS DUE TO MULTIPLES BEING ABLE TO GO AT MULTIPLE TIMES

--Table1 ---------------------------
--check if the person moved up or down(1 is up 0 is down)
local datePress, dateRelease
local dateAnim = false

function CBDatePress(mapargs)
  local evData = mapargs.context_event_data
  datePress = evData["y"]
  dateAnim = false
end

function CBDateRelease(mapargs)
  local evData = mapargs.context_event_data
  dateRelease = evData["y"]
end

function CBSetupDateTable(mapargs)
  local dk_data  = {}
  dk_data = gre.get_table_attrs("dateLayer.date.backgroundTable", "yoffset", "rows")
  local yoffset = dk_data["yoffset"]
  local height = (dk_data["rows"] * 50)/2
  
  resetDateTableLocation(yoffset, height)
  dk_data = gre.get_table_attrs("dateLayer.date.backgroundTable", "yoffset", "rows")
  local newYoffset = dk_data["yoffset"]
  setDateForegroundLocation(newYoffset)
end

function setDateForegroundLocation(offset)
  local foregroundLocation = (480/2) - 25
  local dataTable = {}
  dataTable["yoffset"] = offset-foregroundLocation
  gre.set_table_attrs("dateLayer.date.foregroundTable",dataTable)
end

function resetDateTableLocation(offset, height)
  if(dateAnim ==true)then
    return
  end
  
  local newoffset
  if(offset > -1550)then
    newoffset = -3100
  elseif(offset < -3100)then
    newoffset = -1550
  end
  
  local dataTable = {}
  dataTable["yoffset"] = newoffset
  gre.set_table_attrs("dateLayer.date.backgroundTable",dataTable)
  gre.set_table_attrs("dateLayer.date.foregroundTable",dataTable)
end

function CBDateTableSnap()
  local dk_data = {}
  local newoffset
  local newfgoffset
  
  dk_data = gre.get_table_attrs("dateLayer.date.backgroundTable", "yoffset") 
  local bgOffset = dk_data["yoffset"]
  dk_data = gre.get_table_attrs("dateLayer.date.foregroundTable", "yoffset") 
  local fgOffset = dk_data["yoffset"]  
  
  if(datePress>dateRelease)then
    local ceiling100 = math.floor(bgOffset * 0.01) * 100
    
    if(math.abs(ceiling100 - bgOffset) > 50)then
      newoffset = ceiling100 + 50
    else
      newoffset = ceiling100
    end
  else
    local newbgOffset = bgOffset - 25
    local floor100 = math.ceil((newbgOffset) * 0.01) * 100
    if(math.abs(newbgOffset - floor100) > 50)then
      newoffset = floor100 - 50
    else
      newoffset = floor100
    end
  end
  
  newoffset = newoffset + 15
  local offsetdifference = newoffset - bgOffset
  local newfgoffset = fgOffset + offsetdifference
  dateAnim = true  
  animateDateSnap(bgOffset, newoffset, fgOffset, newfgoffset)
end

function animateDateSnap(bgFrom, bgTo, fgFrom, fgTo)

  local anim_data = {}
  
  local snapDateTableAnim = gre.animation_create(60, 1)
  
  anim_data["key"] = "dateLayer.date.backgroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = bgFrom
  anim_data["to"] = bgTo
  gre.animation_add_step(snapDateTableAnim, anim_data)
  
  anim_data["key"] = "dateLayer.date.foregroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = fgFrom
  anim_data["to"] = fgTo
  gre.animation_add_step(snapDateTableAnim, anim_data)
  
  gre.animation_trigger(snapDateTableAnim)

end

-- end of table 1 ----------------------------------------

--Table2 ---------------------------
local monthPress, monthRelease
local monthAnim = false

function CBMonthPress(mapargs)
  local evData = mapargs.context_event_data
  monthPress = evData["y"]
  monthAnim = false
end
function CBMonthRelease(mapargs)
  local evData = mapargs.context_event_data
  monthRelease = evData["y"]
end

function CBSetupMonthTable(mapargs)
  local dk_data  = {}
  dk_data = gre.get_table_attrs("dateLayer.month.backgroundTable", "yoffset", "rows")
  local yoffset = dk_data["yoffset"]
  local height = (dk_data["rows"] * 50)/2
  
  resetMonthTableLocation(yoffset, height)
  dk_data = gre.get_table_attrs("dateLayer.month.backgroundTable", "yoffset", "rows")
  local newYOffset = dk_data["yoffset"]
  setMonthForegroundLocation(newYOffset)
end

function setMonthForegroundLocation(offset)
  local foregroundLocation = (480/2) - 25
  local dataTable = {}
  dataTable["yoffset"] = offset-foregroundLocation
  gre.set_table_attrs("dateLayer.month.foregroundTable",dataTable)
end

function resetMonthTableLocation(offset, height)
  if (monthAnim == true) then
    return
  end
  
  local newoffset
  if(offset > -600)then
    newoffset = -1200 
  elseif(offset < -1200)then
    newoffset = -600
  else
    return
  end
  
  local dataTable = {}
  dataTable["yoffset"] = newoffset
  gre.set_table_attrs("dateLayer.month.backgroundTable",dataTable)
  gre.set_table_attrs("dateLayer.month.foregroundTable",dataTable)
end

function CBMonthTableSnap()
  local dk_data = {}
  local newoffset
  local newfgoffset
  
  dk_data = gre.get_table_attrs("dateLayer.month.backgroundTable", "yoffset") 
  local bgOffset = dk_data["yoffset"]
  dk_data = gre.get_table_attrs("dateLayer.month.foregroundTable", "yoffset") 
  local fgOffset = dk_data["yoffset"]  
  
  
  --upwads
  if(monthPress>monthRelease)then
    local ceiling100 = math.floor(bgOffset * 0.01) * 100
    
    if(math.abs(ceiling100 - bgOffset) > 50)then
      newoffset = ceiling100 + 50
    else
      newoffset = ceiling100
    end
  --downwards
  else
    local newbgOffset = bgOffset - 25
    local floor100 = math.ceil((newbgOffset) * 0.01) * 100
    if(math.abs(newbgOffset - floor100) > 50)then
      newoffset = floor100 - 50
    else
      newoffset = floor100
    end
    --print(bgOffset, newoffset, floor100)
  end
  
  
  
  newoffset = newoffset + 15
  local offsetdifference = newoffset - bgOffset
  local newfgoffset = fgOffset + offsetdifference 
  monthAnim = true 
  animateMonthSnap(bgOffset, newoffset, fgOffset, newfgoffset)
end

function animateMonthSnap(bgFrom, bgTo, fgFrom, fgTo)

  local anim_data = {}
  
  local snapMonthTableAnim = gre.animation_create(60, 1)
  
  anim_data["key"] = "dateLayer.month.backgroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = bgFrom
  anim_data["to"] = bgTo
  gre.animation_add_step(snapMonthTableAnim, anim_data)
  
  anim_data["key"] = "dateLayer.month.foregroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = fgFrom
  anim_data["to"] = fgTo
  gre.animation_add_step(snapMonthTableAnim, anim_data)
  
  gre.animation_trigger(snapMonthTableAnim)

end
-- end of table 2 ----------------------------------------

--Table3 ---------------------------
local yearPress, yearRelease
local yearAnim = false
function CBYearPress(mapargs)
  yearAnim = false
  local evData = mapargs.context_event_data
  yearPress = evData["y"]
end
function CBYearRelease(mapargs)
  local evData = mapargs.context_event_data
  yearRelease = evData["y"]
end
function CBSetupYearTable(mapargs)
  local dk_data  = {}
  dk_data = gre.get_table_attrs("dateLayer.year.backgroundTable", "yoffset", "rows")
  local yoffset = dk_data["yoffset"]
  local height = (dk_data["rows"] * 50)/2
  

  
  resetYearTableLocation(yoffset, height)
  --in case the table location resets, check for the location of the table again before we set up the foreground location
  dk_data = gre.get_table_attrs("dateLayer.year.backgroundTable", "yoffset", "rows")
  local newYOffset = dk_data["yoffset"]
  setYearForegroundLocation(newYOffset)
end

function setYearForegroundLocation(offset)
  local foregroundLocation = (480/2) - 25
  local dataTable = {}
  dataTable["yoffset"] = offset-foregroundLocation
  gre.set_table_attrs("dateLayer.year.foregroundTable",dataTable)
end

function resetYearTableLocation(offset, height)
  if(yearAnim == true)then
    return
  end
  
  local newoffset
  
  if(offset > -800)then
    newoffset = -1600
  elseif(offset < -1600)then
    newoffset = -800
  end
  
  local dataTable = {}
  dataTable["yoffset"] = newoffset
  gre.set_table_attrs("dateLayer.year.backgroundTable",dataTable)
  gre.set_table_attrs("dateLayer.year.foregroundTable",dataTable)
end

function CBYearTableSnap()
  local dk_data = {}
  local newoffset
  local newfgoffset
  
  dk_data = gre.get_table_attrs("dateLayer.year.backgroundTable", "yoffset") 
  local bgOffset = dk_data["yoffset"]
  dk_data = gre.get_table_attrs("dateLayer.year.foregroundTable", "yoffset") 
  local fgOffset = dk_data["yoffset"]  
  
  if(yearPress>yearRelease)then
    local ceiling100 = math.floor(bgOffset * 0.01) * 100
    
    if(math.abs(ceiling100 - bgOffset) > 50)then
      newoffset = ceiling100 + 50
    else
      newoffset = ceiling100
    end
  else
    local newbgOffset = bgOffset - 25
    local floor100 = math.ceil((newbgOffset) * 0.01) * 100
    if(math.abs(newbgOffset - floor100) > 50)then
      newoffset = floor100 - 50
    else
      newoffset = floor100
    end
  end
  
  newoffset = newoffset + 15
  local offsetdifference = newoffset - bgOffset
  local newfgoffset = fgOffset + offsetdifference  
  yearAnim = true
  animateYearSnap(bgOffset, newoffset, fgOffset, newfgoffset)
end

function animateYearSnap(bgFrom, bgTo, fgFrom, fgTo)

  local anim_data = {}
  
  local snapYearTableAnim = gre.animation_create(60, 1)
  
  anim_data["key"] = "dateLayer.year.backgroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = bgFrom
  anim_data["to"] = bgTo
  gre.animation_add_step(snapYearTableAnim, anim_data)
  
  anim_data["key"] = "dateLayer.year.foregroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = fgFrom
  anim_data["to"] = fgTo
  gre.animation_add_step(snapYearTableAnim, anim_data)
  
  gre.animation_trigger(snapYearTableAnim)

end

-- end of table 3 ----------------------------------------

--Table4 ---------------------------
local hourPress, hourRelease
local hourAnim = false

function CBHourPress(mapargs)
  local evData = mapargs.context_event_data
  hourPress = evData["y"]
  hourAnim = false
end
function CBHourRelease(mapargs)
  local evData = mapargs.context_event_data
  hourRelease = evData["y"]
end
function CBSetupHourTable(mapargs)
  local dk_data  = {}
  dk_data = gre.get_table_attrs("dateLayer.hour.backgroundTable", "yoffset", "rows")
  local yoffset = dk_data["yoffset"]
  local height = (dk_data["rows"] * 50)/2
  
  
  resetHourTableLocation(yoffset, height)
  dk_data = gre.get_table_attrs("dateLayer.hour.backgroundTable", "yoffset", "rows")
  local newYOffset = dk_data["yoffset"]
  setHourForegroundLocation(newYOffset)
end

function setHourForegroundLocation(offset)
  local foregroundLocation = (480/2) - 25
  local dataTable = {}
  dataTable["yoffset"] = offset-foregroundLocation
  gre.set_table_attrs("dateLayer.hour.foregroundTable",dataTable)
end

function resetHourTableLocation(offset, height)
  if(hourAnim == true)then
    return
  end
  
  local newoffset
  
  if(offset > -600)then
    newoffset = -1200
  elseif(offset < -1200)then
    newoffset = -600
  end
  
  local dataTable = {}
  dataTable["yoffset"] = newoffset
  gre.set_table_attrs("dateLayer.hour.backgroundTable",dataTable)
  gre.set_table_attrs("dateLayer.hour.foregroundTable",dataTable)
end

function CBHourTableSnap()
  local dk_data = {}
  local newoffset
  local newfgoffset
  
  dk_data = gre.get_table_attrs("dateLayer.hour.backgroundTable", "yoffset") 
  local bgOffset = dk_data["yoffset"]
  dk_data = gre.get_table_attrs("dateLayer.hour.foregroundTable", "yoffset") 
  local fgOffset = dk_data["yoffset"]  
  
  if(hourPress>hourRelease)then
    local ceiling100 = math.floor(bgOffset * 0.01) * 100
    
    if(math.abs(ceiling100 - bgOffset) > 50)then
      newoffset = ceiling100 + 50
    else
      newoffset = ceiling100
    end
  else
    local newbgOffset = bgOffset - 25
    local floor100 = math.ceil((newbgOffset) * 0.01) * 100
    if(math.abs(newbgOffset - floor100) > 50)then
      newoffset = floor100 - 50
    else
      newoffset = floor100
    end
  end
  
  newoffset = newoffset + 15
  local offsetdifference = newoffset - bgOffset
  local newfgoffset = fgOffset + offsetdifference
  hourAnim = true  
  animateHourSnap(bgOffset, newoffset, fgOffset, newfgoffset)
end

function animateHourSnap(bgFrom, bgTo, fgFrom, fgTo)

  local anim_data = {}
  
  local snapHourTableAnim = gre.animation_create(60, 1)
  
  anim_data["key"] = "dateLayer.hour.backgroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = bgFrom
  anim_data["to"] = bgTo
  gre.animation_add_step(snapHourTableAnim, anim_data)
  
  anim_data["key"] = "dateLayer.hour.foregroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = fgFrom
  anim_data["to"] = fgTo
  gre.animation_add_step(snapHourTableAnim, anim_data)
  
  gre.animation_trigger(snapHourTableAnim)

end

-- end of table 4 ----------------------------------------

--Table5 ---------------------------
local minutePress, minuteRelease
local minuteAnim = false
function CBMinutePress(mapargs)
  local evData = mapargs.context_event_data
  minutePress = evData["y"]
  minuteAnim = false
end
function CBMinuteRelease(mapargs)
  local evData = mapargs.context_event_data
  minuteRelease = evData["y"]
end
function CBSetupMinuteTable(mapargs)
  local dk_data  = {}
  dk_data = gre.get_table_attrs("dateLayer.minute.backgroundTable", "yoffset", "rows")
  local yoffset = dk_data["yoffset"]
  local height = (dk_data["rows"] * 50)/2
  
  
  resetMinuteTableLocation(yoffset, height)
  dk_data = gre.get_table_attrs("dateLayer.minute.backgroundTable", "yoffset", "rows")
  local newYOffset = dk_data["yoffset"]
  setMinuteForegroundLocation(newYOffset)
end

function setMinuteForegroundLocation(offset)
  local foregroundLocation = (480/2) - 25
  local dataTable = {}
  dataTable["yoffset"] = offset-foregroundLocation
  gre.set_table_attrs("dateLayer.minute.foregroundTable",dataTable)
end

function resetMinuteTableLocation(offset, height)
  if(minuteAnim == true)then
    return
  end
  local newoffset
  
  if(offset > -3000)then
    newoffset = -6000
  elseif(offset < -6000)then
    newoffset = -3000
  end
  
  local dataTable = {}
  dataTable["yoffset"] = newoffset
  gre.set_table_attrs("dateLayer.minute.backgroundTable",dataTable)
  gre.set_table_attrs("dateLayer.minute.foregroundTable",dataTable)
end

function CBMinuteTableSnap()
  local dk_data = {}
  local newoffset
  local newfgoffset
  
  dk_data = gre.get_table_attrs("dateLayer.minute.backgroundTable", "yoffset") 
  local bgOffset = dk_data["yoffset"]
  dk_data = gre.get_table_attrs("dateLayer.minute.foregroundTable", "yoffset") 
  local fgOffset = dk_data["yoffset"]  
    
  if(minutePress>minuteRelease)then
    local ceiling100 = math.floor(bgOffset * 0.01) * 100
    
    if(math.abs(ceiling100 - bgOffset) > 50)then
      newoffset = ceiling100 + 50
    else
      newoffset = ceiling100
    end
  else
    local newbgOffset = bgOffset - 25
    local floor100 = math.ceil((newbgOffset) * 0.01) * 100
    if(math.abs(newbgOffset - floor100) > 50)then
      newoffset = floor100 - 50
    else
      newoffset = floor100
    end
  end
  
  newoffset = newoffset + 15
  local offsetdifference = newoffset - bgOffset
  local newfgoffset = fgOffset + offsetdifference  
  minuteAnim = true
  animateMinuteSnap(bgOffset, newoffset, fgOffset, newfgoffset)
end

function animateMinuteSnap(bgFrom, bgTo, fgFrom, fgTo)

  local anim_data = {}
  
  local snapMinuteTableAnim = gre.animation_create(60, 1)
  
  anim_data["key"] = "dateLayer.minute.backgroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = bgFrom
  anim_data["to"] = bgTo
  gre.animation_add_step(snapMinuteTableAnim, anim_data)
  
  anim_data["key"] = "dateLayer.minute.foregroundTable.grd_yoffset"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 200
  anim_data["offset"] = 0
  anim_data["from"] = fgFrom
  anim_data["to"] = fgTo
  gre.animation_add_step(snapMinuteTableAnim, anim_data)
  
  gre.animation_trigger(snapMinuteTableAnim)

end

-- end of table 5 ----------------------------------------
