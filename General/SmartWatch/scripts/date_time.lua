local date_time = {}

-- TODO: loop through these dynamically
local weekdays = { "mon", "tues", "wed", "thur", "fri", "sat", "sun" }
local months = { "jan", "feb", "mar", "april", "may", "june", "july", "aug", "sept", "oct", "nov", "dec" }

local current_time = {
  hour = 12,
  minute = 0,
  second = 0,
}

local current_date = {
  day = 1,
  month = months[7],
  weekday = weekdays[3]
}

local function get_current_time()
  return current_time
end

local function get_current_date()
  return current_date
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
end

date_time = {
  get_current_time = get_current_time,
  get_current_date = get_current_date,
  update_time = update_time,
}

return date_time
