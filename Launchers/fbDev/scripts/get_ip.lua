local myenv = gre.env({ "target_os", "target_cpu" })

function get_ip_qnx()
  local ip_addr = nil
  local f = assert( io.popen("cat /pps/services/networking/interfaces/en0"))
  
  for line in f:lines() do
    if string.find(line, "ip_addresses", 1) == 1 then 
      ip_addr=line:match("%d+.%d+.%d+.%d+")
      --print(ip_addr)
    end
  end -- for loop
     
  f:close()
  return(ip_addr)
end

function get_ip_win32()
  local ip_addr = nil
  local f = assert( io.popen("ipconfig"))
  
  for line in f:lines() do
    if line:match("%sIPv4 Address") ~= nil then
      ip_addr=line:match("%d+.%d+.%d+.%d+")
    end
  end 

  f:close()
  return(ip_addr)
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

function get_ip_macos()
  local ip_addr = nil
  local f = assert( io.popen("ipconfig getifaddr en0"))
  
  for line in f:lines() do
   ip_addr=line:match("%d+.%d+.%d+.%d+")
   if ip_addr ~= nil then
    break
   end 
  end -- for loop
   
  f:close()
  return(ip_addr)
end



function get_ip()
  local ip_addr = nil
  if myenv["target_os"] == "qnx" then
    ip_addr = get_ip_qnx()
  elseif myenv["target_os"] == "linux" then
    ip_addr = get_ip_linux()
  elseif myenv["target_os"] == "macos" then
    ip_addr = get_ip_macos()    
  elseif myenv["target_os"] == "win32" then
    ip_addr = get_ip_win32()      
  else
    print("Can't get IP, unsupported OS")
  end
  
  return(ip_addr)
end