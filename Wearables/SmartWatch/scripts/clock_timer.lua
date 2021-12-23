local date_time = require "date_time"

function cb_update_clock_time(mapargs)
  local minute = date_time.get_current_time().minute
  date_time.update_time()
end

