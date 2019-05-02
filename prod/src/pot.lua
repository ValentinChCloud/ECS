


function poly_view(position, list_vertices, radius)

  local points = {}

  local rays = {}
  local segments = {}

  local list_rays= {}
  local list_segments = {}
  for i =1, #list_vertices do

    list_rays, list_segments = get_rays_segments(point,list_vertices[i], radius)

    for j =1 , #list_rays do
      table.insert(rays, list_rays[j])
    end
    for j =1 , #list_segments do
      table.insert(segments, list_segments[j])
    end

    -- même chose pour segments
  end

end



function get_rays_segments(point, vertices, radius)
  local segments = {}
  local rays = {}
  local new_segment = {}
  local new_ray = {}
  local angle_theta = 0

  -- If only one vertex, no segment are possible, return the ray between the position and the vertex
  if #vertices == 1 then
    new_ray = {{point[1], point[2]},vertices[1]}
    table.insert(rays, new_ray)
    return rays, segments
  end

  for i=1, #vertices do

    if distance(point, vertices[i]) < radius then
      new_ray = {{point[1], point[2]},vertices[i]}
      table.insert(rays, new_ray)

      local my_vector = vector.substract_vector(vertices[i], point)
      local m = vector.normalize(my_vector)
      local strait = vector.multiply_vector(m, radius)
      strait = vector.addition(point,strait)
      local r = vector.rotate(strait,point, 0.010)
      --new_ray = {{point[1], point[2]},vertices[i]}
      new_ray = {{point[1], point[2]},r}
      table.insert(rays, new_ray)

      local l = vector.rotate(strait,point, -0.010)
      new_ray = {{point[1], point[2]},l}
      table.insert(rays, new_ray)


    end

    local copy_vert = deepcopy(vertices[i])
    local copy_vert2 = deepcopy(vertices[ i+1 <= #vertices and i+1 or 1])
    local new_segment = {copy_vert, copy_vert2}




    table.insert(segments, new_segment)

  end

  return rays, segments

end


