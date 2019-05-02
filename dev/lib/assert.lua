local old_assert = assert

assert = {}

setmetatable(assert, {__call = function(_,path, msg) return old_assert(path,msg) end})

function assert.type(element, expect, message)
  if type(element) ~= expect then
    local name, value = debug.getlocal(1,1)
    if message then
      
      error("ERROR: argument '"..name.."' value '"..tostring(element).."' type '"..type(element).."' . Expecting : "..expect.." "..message,2 )
    end
  end
  return element
end


function assert.int(number, msg)
  assert.type(number, "number", msg)
  if not number == math.floor(number) then
    local name, value = debug.getlocal(1,1) 
    error("ERROR: argument '"..name.."' value '"..tostring(element).."'. Expecting  an integer",2 )
  end
  return number
end

