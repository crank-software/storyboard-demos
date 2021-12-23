local min = nil
local max = nil
local range = 0
local redraw_all = 0
local shift_value
local height = 138
local width = 488
local wave_y = {}
local wave_x = {}
local original_data = {}
local poly_wave = ""
local count = 0
local poly_path = "blood_trend_points"
local truncated_width = 0
local waveform_padding = 50 -- give space around the waveform peaks for better drawing

function update_blood_pressure_waveform(wave_points, wave_count, wave_min, wave_max)
  local shaped_point
  local point
  
  if(min == nil or wave_min < min) then
    min = wave_min - waveform_padding
  end
  if(max == nil or wave_max > max) then
    max = wave_max + waveform_padding
  end
  range = math.abs(max - min)
  
  for j=1,wave_count,5 do
    point = wave_points[j]
    point = (wave_points[j] + wave_points[j+1] + wave_points[j+2] + wave_points[j+3] + wave_points[j+4]) / 5
  
    if(point == 0)then
      break
    end
 
    table.insert(original_data,point)   
    shift_value = min * -1
    shaped_point = point + shift_value
    shaped_point = (shaped_point/range) * height
    --flip and shift the point since our positive y-axis is opposite of the the cartesian y     
    shaped_point = (shaped_point * -1) + height
    table.insert(wave_y, shaped_point)
    table.insert(wave_x,count)
    count = count + 1
    
    if(count > width) then
      wave_y = {}
      wave_x = {}
      count = 0
      poly_wave = ""
    end
  end
  poly_wave = gre.poly_string(wave_x,wave_y)
  gre.set_value(poly_path, poly_wave)
end

function draw_entire_blood_pressure_trend()
  local wave_count = #original_data
  local ratio = math.ceil(wave_count/width)
  local point
  local shaped_point
  local x = {}
  local y = {}
  local x_point = 0
  for i=1,wave_count,ratio do
    local sum = 0
    if (wave_count - i) < ratio then
      break
    end
    for j=1,ratio do
      sum = sum + original_data[i+(j-1)]
    end
    point = sum/ratio
    
    shaped_point = point + shift_value
    shaped_point = (shaped_point/range) * height
    --flip and shift the point since our positive y-axis is opposite of the the cartesian y     
    shaped_point = (shaped_point * -1) + height
    table.insert(y,shaped_point)
    table.insert(x,x_point)
    x_point = x_point + 1
  end
  truncated_width = width - x_point
  gre.set_value("blood_trend_points",gre.poly_string(x,y))
  --  blank live update data
  original_data = {}
  count = 0
  wave_x = {}
  wave_y = {}
end


local id = nil
local trend_mask = "graph_layer.graph_blood_pressure.width"
--- @param gre#context mapargs
function cb_blood_pressure_update(mapargs) 
  local ev = mapargs.context_event_data
  local data = {}
  
  data["graph_layer.graph_blood_pressure.grd_x"] = 265
  if(ev.header == 14) then
    data["Blood_Pressure"] = string.format("%d/%d",ev.systolic, ev.diastolic)
    draw_entire_blood_pressure_trend()
    gre.animation_trigger("bloodP_stop_test")
    if(id ~= nil)then
      gre.animation_destroy(id)
      id = nil
    end
    data[trend_mask] = width
    data["graph_layer.graph_blood_pressure.grd_x"] = 265 + (truncated_width/2)
  elseif(ev.header == 15) then
    data["Blood_Pressure"] = ev.pressure
    data["bloodP_layer.direction.alpha"] = 0
    update_blood_pressure_waveform(ev.waveform, ev.waveform_count, ev.wave_min, ev.wave_max)
    if(id ~= nil)then
      gre.animation_destroy(id)
      id = nil
    end
    id = createShowTrendAnimation(trend_mask,count, 250)
    gre.animation_trigger(id)
  else
    data["Blood_Pressure"] = "--/--"
  end
  gre.set_data(data)
end

function createShowTrendAnimation(key, to, duration)
  local step = {}
  local id = gre.animation_create(30,1)
  step["key"] = key
  step["to"] = to
  step["rate"] = "linear"
  step["duration"] = duration
  gre.animation_add_step(id,step)
  return id
end

--- @param gre#context mapargs
function cb_stop_blood_deep_mode(mapargs)
  redraw_all = 1
  gre.set_value("graph_layer.graph_pulse.grd_hidden",1)
  gre.set_value("graph_layer.graph_ecg.grd_hidden",1)
  gre.set_value("graph_layer.graph_blood_pressure.grd_hidden",1)
  gre.animation_trigger("bloodP_stop_test")
end


--- @param gre#context mapargs
function cb_start_blood_deep_mode(mapargs) 
  redraw_all = 1
  gre.set_value("graph_layer.graph_blood_pressure.grd_hidden",0)
end



--- @param gre#context mapargs
function cb_clear_patient_pressure_history(mapargs) 
  min = nil
  max = nil
  wave_y = {}
  wave_x = {}
  count = 0
  poly_wave = ""
  original_data = {}
end
