function MakeDoubleDigit(number)
  if(number < 10) then
    number = string.format("0%d", number)
  end
  return number
end