function updateLockUI(self)
 local data={}
 local target=self.controlData.groupName

 local LOCK_TOGGLE=self.properties.locked
 local targetStatus=self.controlData.doorStatusLink
 local doorStatusToUpdate=getObjectByDid(targetStatus)
 doorStatusToUpdate:update()

  if (LOCK_TOGGLE==true) then
      --print("locking lock")
      data[target..".toggle"] = 0
      data[target..".lock_small.image"] = "images/small_locked.png"

      if(CURRENT_OPEN ~= target)then
        data[target..".lock_status.text"]="Locked"
        data[target..".lock_top.grd_y"]=172
      end
    else
    --locked to unlocked
      --print("unlocking lock")
      data[target..".toggle"] = 1
      data[target..".lock_small.image"] = "images/small_unlocked.png"

      if(CURRENT_OPEN ~= target)then
        data[target..".lock_status.text"]="Unlocked"
        data[target..".lock_top.grd_y"]=159
      end
    end
 gre.set_data(data)
end

function updateDoorUI(self)
  local data={}
  local doorStatus=""
  local lockStatus = ""
  local displayName=""

  local target=self.controlData.groupName

  local lockTargetDid=self.controlData.doorLockLink
  local lockTarget=getObjectByDid(lockTargetDid)

  if(self.controlData.controlType == "door")then
    local cdata=lockTarget:get_controlData()
    local pdata=lockTarget:get_properties()
    displayName=cdata.overallDisplay

    if(self.properties.open)then
      doorStatus="Open"
      data[target..".door_status.text"] = "Door Open"
      data[target..".color"] = 0xF44336
    else
      doorStatus="Closed"
      data[target..".door_status.text"] = "Door Closed"
      data[target..".color"] = 0x4CAF50

    end


    if(pdata.locked)then
      lockStatus="Locked"
    else
      lockStatus="Unlocked"
    end

    local toplevel=""
    if(lockStatus=="Unlocked" and doorStatus=="Closed")then
      toplevel="unlocked"
    elseif(doorStatus=="Open")then
      toplevel="open"
    elseif(lockStatus=="Locked" and  doorStatus=="Closed")then
      toplevel="locked"
    end
    data[displayName]=toplevel

    gre.set_data(data)

  else
    print("Could not find Door associated with "..self.did)
  end

end


function updateLockData(property,value,group)
  print("\nupdating "..group.." "..tostring(value).." "..property)
  local device=getObjectByGroup(group)
  if(device)then
    local props=device:get_properties()
    props[property]=value
    --device:update()
    --sendSetProperty(property,value,device:get_did())
    --Set the top level label
  else
    print("Could not find the device, No update sent")
  end

end
--Toggles the lock via the apargs name, or via the optional object parameter
--function toggle_door_lock(mapargs)
--  lock = getObjectByGroup(mapargs.context_group)
--  if not(lock)then
--    print("Lock not found in devices")
--    return
--  end
--
--  local properties=lock:get_properties()
--
--  local locked=properties.locked
--  if (locked) then
--    print("I AM NOW UNLOCKED")
--    properties.locked=false
--    unlockAnimation(mapargs)
--  else
--    print("I AM NOW LOCKED")
--    properties.locked=true
--    lockAnimation(mapargs)
--  end
--
--
--  local datagram= {req = "set_property",details = {did = lock:get_did(),name = "locked"},value = properties.locked}
--
--  --sendThread(datagram)
--  updateLock(object)
--end
--
--function updateLock(lockObject)
--  local data = {}
--  local topTitle = "house_overall_controls_layer.livingroom_data_2_status.text"
--  if (LOCK_TOGGLE == 1) then
--    gre.animation_trigger("foyer_lock_press_lock")
--    data[topTitle] = "locked"
--  else
--    gre.animation_trigger("foyer_lock_press_unlock")
--    data[topTitle] = "unlocked"
--  end
--  gre.set_data(data)
--end
--
local ACTIVE_LOCK
local ACTIVE_LOCK_ANIM

function lock_open(mapargs)
  ACTIVE_LOCK = mapargs.context_group

  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN..".auto_close")
  end
  CURRENT_OPEN=mapargs.context_group
end

function lock_toggle_lock(mapargs)

  ACTIVE_LOCK_ANIM = mapargs.context_control

  local data = {}
  local data_table = {}

  local toggle, door_toggle

  data_table = gre.get_data(ACTIVE_LOCK..".toggle", ACTIVE_LOCK..".door_toggle")

  toggle = data_table[ACTIVE_LOCK..".toggle"]
  door_toggle = data_table[ACTIVE_LOCK..".door_toggle"]

  --toggle between lock states, complete with animations

  if(toggle == 1)then
  --unlocked to locked
    print("locking lock")
    data[ACTIVE_LOCK..".toggle"] = 0
    data[ACTIVE_LOCK..".lock_small.image"] = "images/small_locked.png"
    gre.send_event_target("lock_locked",ACTIVE_LOCK_ANIM)
    updateLockData("locked",true,ACTIVE_LOCK)
  else
  --locked to unlocked
    print("unlocking lock")
    data[ACTIVE_LOCK..".toggle"] = 1
    data[ACTIVE_LOCK..".lock_small.image"] = "images/small_unlocked.png"
    gre.send_event_target("lock_unlocked",ACTIVE_LOCK_ANIM)
    updateLockData("locked",false,ACTIVE_LOCK)
  end

  gre.timer_set_timeout(auto_close_lock, 800)
  local thisLock=getObjectByGroup(mapargs.context_group)

  gre.set_data(data)
  thisLock:update()
end

function lock_toggle_lock_small(mapargs)

  ACTIVE_LOCK_ANIM = mapargs.context_control

  local data = {}
  local data_table = {}

  local toggle, door_toggle

  data_table = gre.get_data(ACTIVE_LOCK..".toggle", ACTIVE_LOCK..".door_toggle")

  toggle = data_table[ACTIVE_LOCK..".toggle"]
  door_toggle = data_table[ACTIVE_LOCK..".door_toggle"]

  --toggle between lock states, complete with animations

  if(toggle == 1)then
  --unlocked to locked
    print("locking lock")
    data[ACTIVE_LOCK..".toggle"] = 0
    data[ACTIVE_LOCK..".lock_small.image"] = "images/Resized_800/small_locked.png"
    gre.send_event_target("lock_locked",ACTIVE_LOCK_ANIM)
    updateLockData("locked",true,ACTIVE_LOCK)
  else
  --locked to unlocked
    print("unlocking lock")
    data[ACTIVE_LOCK..".toggle"] = 1
    data[ACTIVE_LOCK..".lock_small.image"] = "images/Resized_800/small_unlocked.png"
    gre.send_event_target("lock_unlocked",ACTIVE_LOCK_ANIM)
    updateLockData("locked",false,ACTIVE_LOCK)
  end

  gre.timer_set_timeout(auto_close_lock, 800)
  local thisLock=getObjectByGroup(mapargs.context_group)

  gre.set_data(data)
  thisLock:update()
end

function lock_toggle_door()

  local data = {}
  local data_table = {}

  local toggle

  data_table = gre.get_data(ACTIVE_LOCK..".door_toggle")

  toggle = data_table[ACTIVE_LOCK..".door_toggle"]

  --toggle between door states

  if(toggle == 1)then
  --open to closed
    print("closing door")
    data[ACTIVE_LOCK..".door_toggle"] = 0
    data[ACTIVE_LOCK..".door_status.text"] = "door closed"
    data[ACTIVE_LOCK..".color"] = 0xF44336
  else
  --clsoed to open
    print("opening door")
    data[ACTIVE_LOCK..".door_toggle"] = 1
    data[ACTIVE_LOCK..".door_status.text"] = "door open"
    data[ACTIVE_LOCK..".color"] = 0x4CAF50
  end

  gre.set_data(data)

end

function auto_close_lock()
  gre.send_event_target("lock_close",ACTIVE_LOCK_ANIM)
end
