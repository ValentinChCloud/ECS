
local sprite ={}



function sprite.new(img, meta)
  local s = {}
  s.img = img
  local w,h = s.img:getDimensions()
  s.size = {w,h}
  
  
  s.offset = {0,0}
  return s
end


return sprite