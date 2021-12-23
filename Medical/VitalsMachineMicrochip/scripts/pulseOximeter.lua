local min = nil
local max = nil
local range = 0
local shift_value
local height = 80
local width = 160
local wave = {}
local poly_wave = ""
local count = 0
local poly_path = "pulse_trend_points"
local pulse_deep = 0
local pulse_wave_length_shift = 1
local waveform_padding = 50 -- give space around the waveform peaks for better drawing

function update_waveform(wave_points, wave_count, wave_min, wave_max)
  local shaped_point
  local point
  
  if(min == nil or wave_min < min) then
    min = wave_min - waveform_padding
  end
  if(max == nil or wave_max > max) then
    max = wave_max + waveform_padding
  end
  range = math.abs(max - min)
  
  for j=1,wave_count do
    point = wave_points[j]
  
    if(point == 0)then
      break
    end
  
    table.insert(wave, point)
    count = count + pulse_wave_length_shift
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
      min = wave_min - waveform_padding
      max =  wave_max + waveform_padding
    end
  end
  gre.set_value(poly_path, poly_wave)
end

function redraw_pulse()
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
    c = c+pulse_wave_length_shift
  end
  gre.set_value(poly_path, gre.poly_string(x,y))
end

local id = nil
local trend_mask = "pulseOx_layer.SpO2_line.width"
--- @param gre#context mapargs
function cb_pulse_oximeter_update(mapargs)
  local ev = mapargs.context_event_data
  local data = {}
  data["Blood_Oxygen_Level"] = string.format("%d%%", ev.blood_oxygen_level)
  data["BPM"] = ev.bpm
  update_waveform(ev.pulsation_waveform, ev.waveform_count, ev.wave_min, ev.wave_max)
  if(id ~= nil)then
    gre.animation_destroy(id)
    id = nil
  end
  id = createShowTrendAnimation(trend_mask, count, 250)
  gre.animation_trigger(id)
  gre.set_data(data)
end

--- @param gre#context mapargs
function cb_start_pulse_deep_mode(mapargs) 
  width = 492
  height = 141
  pulse_deep = 1
  trend_mask = "graph_layer.graph_pulse.width"
  pulse_wave_length_shift = 2
  redraw_pulse()
end

--- @param gre#context mapargs
function cb_stop_pulse_deep_mode(mapargs) 
  height = 80
  width = 160
  pulse_deep = 0
  trend_mask = "pulseOx_layer.SpO2_line.width"
  pulse_wave_length_shift = 1
  redraw_pulse()
end


--- @param gre#context mapargs
function cb_clear_patient_pulse_history(mapargs) 
  min = nil
  max = nil
  wave = {}
  count = 0
  poly_wave = ""
end
