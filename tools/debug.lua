-- debugstuff.lua


local _print = print
function print(...)
    -- do logging as well 
    -- then call the actual print function; ... passes all arguments on.
    local s = ...
    love.filesystem.createDirectory("log")
    --love.filesystem.append("log/log.txt","\n"..s)
    _print(...)
end