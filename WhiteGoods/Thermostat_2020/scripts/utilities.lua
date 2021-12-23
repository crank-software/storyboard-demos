---
--  formula to generate a bounce curve, to be used in conjunction with lerp
--  @param t the time/position to be modified  along the bounce curve
--  @return the modified time/position
function spring_wobbly(t)
  local e = 2.71828
  
  -- 180 stiffness, 12 dampening
  local calc_t = -0.5 * (2.71828 ^ (-6 * t)) * (-2 * (2.71828 ^ (6 * t)) + math.sin(12 * t) + 2 * math.cos(12 * t))
  
  return calc_t
end

---
-- linear interpolation function. interpolates between two values given a modifier
-- @param a the starting value
-- @param b the ending value
-- @param p the positional modifier. Intended to be the return value of spring_wobbly()
-- @return the interpolated value
function lerp(a, b, p)
  return a + p * (b - a)
end

---
-- convert a given temperature from celsius to fahrenheit
-- @param temp the temperature to be converted
-- @return the converted temperature
function c_to_f(temp)
  local f_temp = (temp * (9/5)) + 32
  return f_temp
end

---
-- convert a given temperature from fahrenheit to celsius
-- @param temp the temperature to be converted
-- @return the converted temperature
function f_to_c(temp)
  local c_temp = (temp - 32) * (5/9)
  return c_temp
end