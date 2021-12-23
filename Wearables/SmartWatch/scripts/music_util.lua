---
-- utility to convert raw milliseconds to a M:SS format for displaying in the duration label
-- @param milliseconds the millseconds to convert to M:SS
-- @return nothing
function milliseconds_to_mss(milliseconds)
  local minute
  local second
  local m
  local ss
  
  minute = (milliseconds / 60000)
  minute = minute - (minute % 1)
  second = 60 * ((milliseconds / 60000) % 1)
  
  m = tostring(minute)
  
  -- format seconds to SS
  -- if the character length is 1, it's a single digit and manually needs a 0 prepended
  if (string.len(tostring(second)) == 1) then
    ss = string.format('0%d', tostring(second))
  else
    ss = tostring(second)
  end

  return string.format('%s:%s', m, ss)
end