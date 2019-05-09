
---
-- @author http://lua.space/general/assert-usage-caveat
-- @param a the condition to check
-- @param ... the msg to return if test failed, it accepts function
-- @return a if the condition is true
-- @usage xassert(type(x) == "number", string.concat, "x is a ", type(x)). If it failes raise an error.


function xassert(a, ...)
  if a then return a, ... end
  local f = ...
  if type(f) == "function" then
    local args = {...}
    table.remove(args, 1)
    error(f(unpack(args)), 2)
  else
    error(f or "assertion failed!", 2)
  end
end