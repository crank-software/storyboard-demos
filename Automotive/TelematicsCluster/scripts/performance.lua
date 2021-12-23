local idval = {}                    
local shown_controls = false

function update_performance_values()
  local data = {}
  
  local f = io.popen("cat /pps/services/perf/control") -- runs command
  local l = f:read("*a") -- read output of command
  

  local active_start = string.find (l, "perf_active")
  local active_end = string.find(l, "\n", active_start)
  local active_string = string.sub(l, active_start, active_end)
  local active_sep = string.find(active_string, ":")
  local active_val = string.sub(active_string, active_sep + 2, -2)  
  
  if(shown_controls == false and active_val == "1") then
    data["branding.cpu1_out.grd_hidden"] = 0
    data["branding.cpu1.grd_hidden"] = 0
    data["branding.gpu_out.grd_hidden"] = 0
    data["branding.gpu.grd_hidden"] = 0
    shown_controls = true
  elseif(shown_controls == true and active_val == "0") then
    data["branding.cpu1_out.grd_hidden"] = 1
    data["branding.cpu1.grd_hidden"] = 1
    data["branding.gpu_out.grd_hidden"] = 1
    data["branding.gpu.grd_hidden"] = 1
    shown_controls = false
  end
  
  
  local mpu1_start = string.find (l, "mpu1_percentage")
  local mpu1_end = string.find(l, "\n", mpu1_start)
  local mpu1_string = string.sub(l, mpu1_start, mpu1_end)
  local mpu1_sep = string.find(mpu1_string, ":")
  local mpu1_val = string.sub(mpu1_string, mpu1_sep + 2, -2)  
  data["cpu1_usage"] = mpu1_val .. "%"
  
  local mem_start = string.find (l, "emif_bw")
  local mem_end = string.find(l, "\n", mem_start)
  local mem_string = string.sub(l, mem_start, mem_end)
  local mem_sep = string.find(mem_string, ":")
  local mem_val = string.sub(mem_string, mem_sep + 2, -2)  
  mem = tonumber(mem_val)
  mem = mem / 1000
  data["gpu_usage"] = tostring(mem) .. " GB/s"

  gre.set_data(data)
  f:close()
end
            
function performance_init(mapargs)
  idval = gre.timer_set_interval(update_performance_values, 1000)
end