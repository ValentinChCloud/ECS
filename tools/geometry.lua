local geometry = {}






--- Return the point on a circle, function an angle
-- @param center vec2{}
-- @param radius int
-- @param angle float, radian
-- @return position vec2{}
function geometry.point_angle_circle(center, radius ,angle)
  local position = { center[1] + radius*math.cos(angle),  center[2] + radius*math.sin(angle)}
  return position
end

--- Get the nearest point between a point and a list of points
-- @param point the one you want to test
-- @param points the list of points 
-- @return the_point table, position of the point
-- @return min number, the distance between the two point
function geometry.nearest_point(point, points)
  local min =  math.dist(point, points[1])
  local the_point = points[1]

  for i= 1 , #points do
    local dist = math.dist(point, points[i])
    if dist < min then
      min = dist
      the_point = points[i]
    end
  end

  return the_point,min

end







-- Detect if two ligne overlap

function geometry.line_overlap(a_min, a_max, b_min, b_max)

  local min1 = math.min(a_max,b_max)
  local max1 = math.max(a_min,b_min)

  local diff = min1-max1
  diff = math.floor(diff)
  return math.max(0,diff)



end



function geometry.point_in_poly(point, vertices)


  local j = #vertices-1
  local x,y= point[1],point[2]
  local oddNodes = false;

  for i=1,#vertices,2 do
    if ((vertices[i+1] < y and vertices[j+1] >= y  or vertices[j+1] < y and vertices[i+1] >=y) 
      and (vertices[i] <= x or vertices[j] <= x )) then
      if vertices[i] + ( y - vertices[i+1]) / ( vertices[j+1] - vertices[i+1]) *( vertices[j] - vertices[i]) < x then
        oddNodes = not oddNodes
      end


    end
    j = i
  end


  return oddNodes 


end

-- Rotate a point 
-- @point : vector2(x,y)
-- @origin : vector2(x,y)
-- @angle : radian
-- @return : vec2(x,y)
function geometry.rotate_point( point,origin, angle)
  local temp_point ={ x = point.x - origin.x, y = point.y -origin.y }

  local new_point = rotate_vector(temp_point, -angle)

  new_point.x = new_point.x + origin.x
  new_point.y = new_point.y + origin.y


  return new_point
end



function geometry.is_rectangles_collide(rec1, rec2)

  if rec1.position[1] +rec1.size[1]/2 < rec2.position[1]-rec2.size[1]/2 then
    return false
  end

  if rec1.position[1] -rec1.size[1]/2 > rec2.position[1]+rec2.size[1]/2 then
    return false
  end

  if rec1.position[2] +rec1.size[2]/2 < rec2.position[2]-rec2.size[2]/2 then
    return false
  end

  if rec1.position[2] -rec1.size[2]/2 > rec2.position[2]+rec2.size[2]/2 then
    return false
  end


  return true

end





return geometry
