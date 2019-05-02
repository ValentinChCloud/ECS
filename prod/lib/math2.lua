






-- DEFINE
MATH_PI = 3.1415926535898
MATH_PI_TIMES_2 = 6.2831853071796
--MATH_PI_ON_2  =

--Averages an arbitrary number of angles (in radians).
function math.averageAngles(...)
  local x,y = 0,0
  for i=1,select('#',...) do local a= select(i,...) x, y = x+math.cos(a), y+math.sin(a) end
  return math.atan2(y, x)
end


-- Returns the distance between two points.
function math.dist(p1, p2) return ((p2[1]-p1[1])^2+(p2[2]-p1[2])^2)^0.5 end


-- Returns the angle between two points.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end


-- Returns the closest multiple of 'size' (defaulting to 10).
function math.multiple(n, size) size = size or 10 return math.round(n/size)*size end


-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end





-- Linear interpolation between two numbers.
function lerp(a,b,t) return (1-t)*a + t*b end
function lerp2(a,b,t) return a+(b-a)*t end

-- Cosine interpolation between two numbers.
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end


-- Normalize two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end


-- Returns 'n' rounded to the nearest 'deci'th (defaulting whole numbers).
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end


-- Randomly returns either -1 or 1.
function math.rsign() return love.math.random(2) == 2 and 1 or -1 end


-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end


-- Gives a precise random decimal number given a minimum and maximum
function math.prandom(min, max) return love.math.random() * (max - min) + min end







-- Get all the vertices of a rectangle
function math.rect_vertices(position, size, rotation)
  local vertices = {}
  local v = {}
  local w = size[1]/2
  local h = size[2]/2
  v1 = vector.rotate({ position[1]-w, position[2] - h},position, rotation)
  v2 = vector.rotate({ position[1]+w, position[2] - h},position, rotation)
  v3 = vector.rotate({position[1]+w, position[2] + h},position, rotation)
  v4 = vector.rotate({position[1]-w,  position[2] + h},position, rotation)
 -- vector.floor(v1)
  --vector.floor(v2)
  --vector.floor(v3)
  --vector.floor(v4)
  table.insert(vertices,v1)
  table.insert(vertices,v2)
  table.insert(vertices,v3)
  table.insert(vertices,v4)
  return vertices
end




