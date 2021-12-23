local clockTimer

function CBDigitalScreenShow(mapargs)
  CBDigitalSyncTime()
  clockTimer = gre.timer_set_interval(CBDigitalSyncTime,15000)
end

function CBDigitalScreenHide(mapargs)
  gre.timer_clear_interval(clockTimer)
end

function CBDigitalSyncTime(mapargs)
  local time = gre.mstime() / 1000
  local data = {}
  --3:45 pm

  data["time_ampm_text"] = os.date("%I:%M %p", math.floor(time))
  data["ampm_text"] = os.date("%p", math.floor(time))
  data["time_text"] = os.date("%I:%M", math.floor(time))
  gre.set_data(data)
end