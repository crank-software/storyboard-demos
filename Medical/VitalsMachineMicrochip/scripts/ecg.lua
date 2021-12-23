local min = nil
local max = nil
local range = 0
local shift_value
local height = 65
local width = 295
local wave = {}
local poly_wave = ""
local count = 0
local poly_path = "ecg_trend_points"
local ecg_deep = 0
local waveform_padding = 50 -- give space around the waveform peaks for better drawing

function update_ecg_waveform(ecg_points, ecg_count, wave_min, wave_max)
  local shaped_point
  local point
  
  if(min == nil or wave_min < min) then
    min = wave_min - waveform_padding
  end
  if(max == nil or wave_max > max) then
    max = wave_max + waveform_padding
  end
  
  for j=1,ecg_count,5 do
    point = (ecg_points[j] + ecg_points[j+1] + ecg_points[j+2] + ecg_points[j+3] + ecg_points[j+4]) / 5
  
    if(point == 0)then
      break
    end
    
    range = math.abs(max - min)
  
    table.insert(wave, point)
    count = count + 1
    shift_value = min * -1
    shaped_point = point + shift_value
    shaped_point = (shaped_point/range) * height
    --flip and shift the point since our positive y-axis is opposite of the the cartesian y     
    shaped_point = (shaped_point * -1) + height
    poly_wave = string.format("%s %d,%d", poly_wave, count, shaped_point)

    if(count > width) then
      wave = {}
      count = 0
      poly_wave = ""
    end
    
  end

  gre.set_value(poly_path, poly_wave)
end

function redraw_ecg()
  local shaped_point
  local point
  local x = {}
  local y = {}
  local c = 0
  for k,v in ipairs(wave) do
    point = v
    shift_value = min * -1
    shaped_point = point + shift_value
    shaped_point = (shaped_point/range) * height
    --flip and shift the point since our positive y-axis is opposite of the the cartesian y     
    shaped_point = (shaped_point * -1) + height
    table.insert(y,shaped_point)
    table.insert(x,c)
    c = c+1
  end
  gre.set_value(poly_path, gre.poly_string(x,y))
end

local id = nil
local trend_mask = "ecg_layer.ecg_line.width"

--- @param gre#context mapargs
function cb_ecg_update(mapargs)
  local ev = mapargs.context_event_data
  update_ecg_waveform(ev.wave, ev.count, ev.wave_min, ev.wave_max)
  if(id ~= nil)then
    gre.animation_destroy(id)
    id = nil
  end
  id = createShowTrendAnimation(trend_mask, count, 200)
  gre.animation_trigger(id)
end

--- @param gre#context mapargs
function cb_start_ecg_deep_mode(mapargs) 
  width = 492
  height = 141
  ecg_deep = 1
  trend_mask = "graph_layer.graph_ecg.width"
  count = width
  gre.set_value(poly_path,"")
  gre.set_value(trend_mask,0)
end

--- @param gre#context mapargs
function cb_stop_ecg_deep_mode(mapargs) 
  ecg_deep = 0
  height = 65
  width = 295
  trend_mask = "ecg_layer.ecg_line.width"
  count = width
  gre.set_value(poly_path,"")
  gre.set_value(trend_mask,0)
end

--- @param gre#context mapargs
-- reset the min and max values so the ecg trend is scaled appropriate to the waveform source 
function cb_clear_patient_ecg_history(mapargs) 
  min = nil
  max = nil
  wave = {}
  count = 0
  poly_wave = ""
end
