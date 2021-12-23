local date_time =      {year = 1998, month = 9, day = 16, yday = 259, wday = 4, hour = 23, min = 48, sec = 10, isdst = false}

-- TODO: loop through these dynamically
local weekdays = { "mon", "tues", "wed", "thur", "fri", "sat", "sun" }
local months = { "jan", "feb", "mar", "april", "may", "june", "july", "aug", "sept", "oct", "nov", "dec" }

local current_time = {
  hour = 10,
  minute = 7,
  second = 50,
}

local current_date = {
  day = 1,
  month = months[7],
  weekday = weekdays[3]
}

local function init()

  -- get current time
--  local hour = tonumber(os.date("%I"))
--  local minute = tonumber(os.date("%M"))
--  local meridian = os.date("%p")
  local hour = date_time.hour
  local minute = date_time.minute
  local meridian = "am"

  if hour ~= nil and minute ~= nil then
    local data = {}
    print(string.format("%d:%02d",hour,minute))
    data["time"] = string.format("%d:%02d",hour,minute)
    data["meridian"] = meridian
    gre.set_data(data)

    current_time.hour = hour
    current_time.minute = minute
  end

end

local function set_current_time(hour, min)


end

local function get_current_time()
  return current_time
end

local function get_current_date()
  return current_date
end

local function get_clock_string()
  return string.format("%d:%02d", current_time.hour, current_time.minute)
end

local function update_time()
  if current_time.second < 59 then
    current_time.second = current_time.second + 1
  else
    current_time.second = 0
    if current_time.minute < 59 then 
      current_time.minute = current_time.minute + 1
    else
      current_time.minute = 0
      if current_time.hour < 12 then 
        current_time.hour = current_time.hour + 1
      elseif current_time.hour == 12 then
        current_time.hour = 1
      end
    end
  end
  
  --local meridian = os.date("%p")
  local meridian = "am"
  
  local data = {}
  data["time"] = string.format("%d:%02d", current_time.hour, current_time.minute)
  data["seconds"] = string.format("%02d", current_time.second)
  
  if (meridian ~= nil) then
    data["meridian"] = meridian
  end
  gre.set_data(data)
end

date_time = {
  init = init,
  get_current_time = get_current_time,
  get_current_date = get_current_date,
  get_clock_string = get_clock_string,
  update_time = update_time,
}

return date_time
