-- debugstuff.lua


local _print = print
function print(...)
    -- do logging as well
    -- then call the actual print function; ... passes all arguments on.
    _print(...)
end