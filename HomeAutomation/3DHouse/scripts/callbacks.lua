--require("udp")
SEQINDEX=0

CURRENT_OPEN=nil

currentSeq = function()SEQINDEX=SEQINDEX+1 return SEQINDEX end

local function getDate()
  local time = os.date("%A, %b %d - %H:%M")
  local data={}
  data["header_layer.Date.text"]=time
  gre.set_data(data)
end



function cb_init(mapargs)
  getDate()
  gre.timer_set_interval(getDate,60000)   --This is once a minute so it depends on when you start the app
  math.randomseed(os.time())
end

function getObjectByName(name)
	for i=1,#G_deviceTable do
		local controlData=G_deviceTable[i]:get_controlData()
		local title=controlData.title
		if(title==name)then
			return G_deviceTable[i]
		end
	end
	print("We could not find an object with the name of:"..name.." in the global device list")
	return false
end

function getObjectByDid(searchDid)

	for i=1,#G_deviceTable do
		local did=G_deviceTable[i]:get_did()

		if(did==searchDid)then
			--print("found DID")
			return G_deviceTable[i]
		end
	end
	print("We could not find and object with the did of "..tostring(searchDid).. " in the global device list")
	return false
end

function getObjectByGroup(group_name)
	for i=1,#G_deviceTable do
		local cData=G_deviceTable[i]:get_controlData()
		if(cData.groupName==group_name)then
			return G_deviceTable[i]
		end
	end
	print("We could not find and object with the group_name of "..group_name.. " in the global device list")
	return false
end

function check_quicklaunch_status(mapargs) 
    local active = gre.get_value(mapargs.context_control..".active")
    local control_name
    for w in string.gmatch(mapargs.context_control, "%.([%w_]+)") do
      control_name = w 
    end
    if active == 1 then
        --CLOSE
        gre.send_event(control_name.."_close")
        gre.set_value(mapargs.context_control..".active", 0)
    else
        --OPEN
        gre.send_event(control_name.."_open")
        gre.set_value(mapargs.context_control..".active", 1)
    end   
end
