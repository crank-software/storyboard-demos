function updateStatusUI(self)
  local data={}

local GREEN=0x4CAF50
local YELLOW=0xFFC107
local RED=0xF44336
local GREY=0xC1C1C1
local target=self.controlData.groupName

--{"notif":"property_update","property":{"value":false,"id":{"name":"open","did":"00049F02FC31002E-LivingRoomWindow"}}}
  --WINDOW
  if (self.controlData.controlType == "window") then
    if (self.properties.open) then
      data[target..".image"] = "images/status_winopen.png"
      data[target..".color"] = RED
      data[target..".status_text.status"] = "OPEN"

    else
      data[target..".image"] = "images/status_winclosed.png"
      data[target..".color"] = GREEN
      data[target..".status_text.status"] = "CLOSED"
    end
  --STOVE
  elseif(self.controlData.controlType == "stove_top")then
    if(self.properties.stove_status=="boiling")then
      data[target..".image"] = "images/status_boiling.png"
      data[target..".color"] = RED
      data[target..".status_text.status"] = "BOILING"
    elseif(self.properties.stove_status=="stop")then
      data[target..".image"] = "images/status_notboiling.png"
      data[target..".color"] = GREEN
      data[target..".status_text.status"] = "IDLE"
    elseif(self.properties.stove_status=="simmer")then
      data[target..".image"] = "images/status_notboiling.png"
      data[target..".color"] = YELLOW
      data[target..".status_text.status"] = "SIMMERING"
    else
      print("Warning ("..self.controlData.controlType..") : unkown state -> "..self.properties.stove_status)
      return
    end
  --PUMP
  elseif(self.controlData.controlType == "pump")then
    if(self.properties.pump_status=="on")then
      --data[target..".image"] = ""
      data[target..".color"] = GREEN
      data[target..".status_text.status"] = "ON"
    elseif(self.properties.pump_status=="off")then
      --data[target..".image"] = ""
      data[target..".color"] = GREY
      data[target..".status_text.status"] = "OFF"
    elseif(self.properties.pump_status=="blocked")then
      --data[target..".image"] = ""
      data[target..".color"] = RED
      data[target..".status_text.status"] = "BLOCKED"
    else
      print("Warning ("..self.controlData.controlType..") : unkown state -> "..self.properties.pump_status)
      return
    end

  else
    print("Warning ("..self.controlData.controlType..") : currently not handled in update script")
  end

  data[self.controlData.overallDisplay]=string.lower(data[target..".status_text.status"])

--  for k,v in pairs(data) do
--    print(k,v)
--  end

  gre.set_data(data)

end

function status_open(mapargs)
  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN..".auto_close")
  end
  CURRENT_OPEN=mapargs.context_group
end

--test toggle button, just to make sure it works
--uses mapargs for testing, will have to use something else to get the active group you are changing
local toggle = 1
function update_status_dots(mapargs)
  local data = {}
  local data_table = {}


  data_table = gre.get_data(mapargs.context_group..".type")
  local type = data_table[mapargs.context_group..".type"]

--  data[mapargs.context_group..".status_title.text"] = "Title of Status"


  if(toggle == 1)then --Status on, open, etc (green)
    if(type == 1)then
      --window open
      data[mapargs.context_group..".image"] = "images/status_winopen.png"
    elseif(type == 0)then
      --water boiling
      data[mapargs.context_group..".image"] = "images/status_boiling.png"
    end
    data[mapargs.context_group..".status_text.status"] = "OPEN"
    data[mapargs.context_group..".color"] = 0x4CAF50
    --toggle for testing purposes
    toggle = 0
  else --status off,close, etc (red)
    if(type == 1)then
      --window close
      data[mapargs.context_group..".image"] = "images/status_winclosed.png"
    elseif(type == 0)then
      --water not boiling
      data[mapargs.context_group..".image"] = "images/status_notboiling.png"
    end
    data[mapargs.context_group..".status_text.status"] = "CLOSED"
    data[mapargs.context_group..".color"] = 0xF44336
    --toggle for testing purposes
    toggle = 1
  end

  gre.set_data(data)

end
