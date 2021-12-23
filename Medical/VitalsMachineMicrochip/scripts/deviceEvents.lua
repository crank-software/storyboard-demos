--medical_backend no_target event 4s1:device 3 1s1:command c 
local ECG_ID = 1
local PULSE_ID = 2
local THERMO_ID = 3
local BPC_ID = 4
local backend_channel = "medical_backend"
local backend_event = "device_event"
local backend_fmt = "4s1 device 1s1 command"

--- @param gre#context mapargs
function cb_toggle_temp(mapargs) 
  local data = {}
  
  if(TEMP_UNITS == "C")then
    data["command"] = "f"
  elseif(TEMP_UNITS =="F")then
    data["command"] = "c"
  end  
 
  data["device"] = THERMO_ID
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end

--- @param gre#context mapargs
function cb_reset_pulse_ox(mapargs) 
  local data = {}
  data["device"] = PULSE_ID
  data["command"] = "r"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end

--- @param gre#context mapargs
function cb_reset_thermometer(mapargs) 
  local data = {}
  data["device"] = THERMO_ID
  data["command"] = "r"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end


--- @param gre#context mapargs
function cb_start_bpc(mapargs) 
  local data = {}
  data["device"] = BPC_ID
  data["command"] = "1"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end


--- @param gre#context mapargs
function cb_stop_bpc(mapargs) 
  local data = {}
  data["device"] = BPC_ID
  data["command"] = "0"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end


--- @param gre#context mapargs
function cb_reset_bpc(mapargs) 
  local data = {}
  data["device"] = BPC_ID
  data["command"] = "r"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end


--- @param gre#context mapargs
function cb_user_ecg(mapargs) 
  local data = {}
  data["device"] = ECG_ID
  data["command"] = "n"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end


--- @param gre#context mapargs
function cb_demo_ecg(mapargs) 
  local data = {}
  data["device"] = ECG_ID
  data["command"] = "d"
  gre.send_event_data(backend_event,backend_fmt,data,backend_channel)
end

local TIME_FORMAT = 24
--- @param gre#context mapargs
function cb_toggle_time(mapargs) 
  if(TIME_FORMAT == 24)then
    TIME_FORMAT = 12
  elseif(TIME_FORMAT == 12)then
    TIME_FORMAT = 24
  end
  gre.animation_trigger("time_toggle_"..TIME_FORMAT)
end

local init = 0
--- @param gre#context mapargs
function cb_ui_ready(mapargs) 
  if(init == 0)then
    local success, error = gre.send_event("ui_ready",backend_channel)
    if (success == true)then
      init = 1
    else
      gre.timer_set_timeout(cb_ui_ready,500)
    end
  end
  
  gre.set_value("settings_layer.device.ipData.ip",get_ip_linux())
end

function get_ip_linux()
  local ip_addr = nil
  local f = assert( io.popen("ifconfig"))
  
  for line in f:lines() do
    if line:match("%sinet addr:") ~= nil then
      ip_addr=line:match("%d+.%d+.%d+.%d+")
      if ip_addr ~= "127.0.0.1" then
        break
      else
        ip_addr = nil
      end
    end
  end 
  f:close()
  return(ip_addr)
end
