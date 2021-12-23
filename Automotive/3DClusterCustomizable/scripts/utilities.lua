local csv = require("csv")
--takes seconds and converts it to the proper format 00:00:00 etc.
function formatSeconds(incTime)
  local h = math.floor(incTime / 3600)
  local m = math.floor((incTime - (h * 3600)) / 60)
  local s = math.floor(incTime - ((h * 3600) + (m * 60)))
  return string.format('%02d:%02d', m, s)
end


function loadMode(fname,col_num)
  local data = {}
  local column
  
  if(col_num == nil)then
    column = 2
  else
    column = col_num
  end
  
  local f = csv.open(gre.SCRIPT_ROOT.."/../translations/"..fname..".csv")
  for fields in f:lines() do
    for i, v in ipairs(fields) do 
      if(i == 1)then
        k = v
      elseif(i == column)then  
        data[k]=v
      end
    end
  end
  
  return data
end

function CBChangeMode(incMode) 
  local lang_data = {}
  lang_data = loadMode(incMode)
  gre.set_data(lang_data)
end

function autoSwapMode()
  
  local autoSwap = configTable.autoSwap
  local size = gre.get_value('appSize')
    
  if(autoSwap == 'off')then
    return
  end

  local autoSwapMode = gre.get_value('mode')  
  if(autoSwapMode == 'eco')then
    CBChangeMode('sport'..size)
  elseif(autoSwapMode == 'sport')then
    CBChangeMode('comfort'..size)
  elseif(autoSwapMode == 'comfort')then
    CBChangeMode('eco'..size)
  end

end

function TwoDDial(mapargs)
  local data = {}
  data["speedometerSingle.3D.num8.grd_hidden"] = 1
  data["speedometerSingle.3D.num7.grd_hidden"] = 1
  data["speedometerSingle.3D.num6.grd_hidden"] = 1
  data["speedometerSingle.3D.num5.grd_hidden"] = 1
  data["speedometerSingle.3D.num4.grd_hidden"] = 1
  data["speedometerSingle.3D.num3.grd_hidden"] = 1
  data["speedometerSingle.3D.num2.grd_hidden"] = 1
  data["speedometerSingle.3D.num1.grd_hidden"] = 1
  data["speedometerSingle.3D.3DDial.grd_hidden"] = 1
  data["speedometerSingle.3D.2DDial.grd_hidden"] = 0
  gre.set_data(data)
end