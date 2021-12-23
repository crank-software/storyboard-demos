local hourAmounts = 48

local function initTables()
  
  local hour = 0
  local min = 0
  
  local tableData = {}
  tableData["rows"] = hourAmounts * 3
  gre.set_table_attrs("timeSelect.timeTable", tableData)  
    
  local data = {} 
   
  --put the proper numbers into the cells
  for i=1, hourAmounts do
    if i % 2 == 0 then  
      min = 30
    else
      hour = hour + 1
      min = 0
    end
        
    local textHour, textMin, period

    textHour = hour
    textMin = min
    
    if(textHour > 12)then
      textHour = textHour - 12 
      period = 'PM'
    else
      period = 'AM'
    end
    
    if(hour == 12)then
      period = 'PM'
    elseif(hour == 24)then
      period = 'AM'
    end
    
    if(string.len(textHour) < 2)then
      textHour = '0'..textHour
    end
    
    if(string.len(textMin) < 2)then
      textMin = '0'..textMin
    end
    
    data["timeSelect.timeTable.text."..i..".1"] = textHour..':'..textMin..' '..period
    data["timeSelect.timeTable.text."..i+hourAmounts..".1"] = textHour..':'..textMin..' '..period
    data["timeSelect.timeTable.text."..i+(hourAmounts*2)..".1"] = textHour..':'..textMin..' '..period

  end
  gre.set_data(data)
end


function CBInit()

  initTables()
  initDisplay()
  initFlipbookAnimations()
  initIconAnimations()
  
end