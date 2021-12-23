function getNextPlayback()
  local f = assert(io.open(string.format("%s/playback.txt", gre.SCRIPT_ROOT)))
  local playback = f:read()
  f:close()
  return playback
end

function setNextPlayback(file)
    local f = assert(io.open(string.format("%s/playback.txt", gre.SCRIPT_ROOT), "w"))
    f:write(file)
    f:close()
end