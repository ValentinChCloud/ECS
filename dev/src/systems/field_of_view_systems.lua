local System = require("src.systems.system")


local nombre_magic = 36
local angle = 6.28319/nombre_magic




function TableRemoveEfficient(pTable,pRemove)
  local input = pTable
  local remove = pRemove

  local n=#input
  local r=#remove

  for i=1,r do
    input[remove[i]]=nil
  end

  local j=0
  for i=1,n do
    if input[i]~=nil then
      j=j+1
      input[j]=input[i]
    end
  end
  for i=j+1,n do
    input[i]=nil
  end

end







return {

  requires = {"field_of_view"},
  sub_systems = {},


  field_of_view_system = function ()
    local field_of_view_system = System.new("field_of_view_system", {names.field_of_view, names.body},3)

    function field_of_view_system:core_update(World, dt, entity_id)

      local field_of_view = World.components[names.field_of_view][entity_id]
      local body  = World.components[names.body][entity_id]


      local circle_collider = {type = "circle", radius = field_of_view.radius}
      local shape_a= SAT.new_shape(circle_collider,body)

      local ents = World:get_all_with({names.rigid_body}, true)
      local ents_body = {}
      local ents_rigid_body = {}



      local tot_vert = {}
      for i=1, #ents do
        repeat
          if ents[i]:get_id() == entity_id  then
            break
          end
          ents_body = ents[i]:get_component("body")
          ents_rigid_body = ents[i]:get_component("rigid_body")


          if ents_rigid_body.cast_shadows == false then
            break
          end
          local vertices =  math.rect_vertices(ents_body.position, ents_rigid_body.collider.size, ents_body.rot)
          local collider_b = {type ="poly", vertices = vertices}


          if ents_body.position[1] + ents_rigid_body.collider.size[1]/2 < body.position[1] -field_of_view.radius then
            break
          end
          if ents_body.position[1] - ents_rigid_body.collider.size[1]/2 > body.position[1] +field_of_view.radius then
            break
          end


          if ents_body.position[2] + ents_rigid_body.collider.size[2]/2 < body.position[2] -field_of_view.radius then
            break
          end
          if ents_body.position[2] - ents_rigid_body.collider.size[2]/2 > body.position[2] +field_of_view.radius then
            break
          end



          local shape_b =SAT.new_shape(collider_b, ents_body)

          local collide = SAT.is_colliding(shape_a, shape_b)

          if collide then

            table.insert(tot_vert, vertices)
          else
          end
          -- table.insert(tot_vert, vertices)
        until true
      end


      for i=1, nombre_magic do
        --print(math.rad(360))
        local pre = {math.cos(angle*i), math.sin(angle*i)}
        local p = vector.multiply_vector(pre, field_of_view.radius)
        p = vector.addition(body.position, p)
        p = {p[1], p[2]}
        table.insert(tot_vert,{p})
      end
      points = self:poly_view(body.position, tot_vert, field_of_view.radius)
      local p = {}

      for i=1,#points do
        table.insert(p, points[i][1])
        table.insert(p, points[i][2])

      end

      field_of_view.points = p


    end

    --- Gat a field of view as a polygon
    -- @param position center of yout field of view
    -- @param list_vertices the more important !! It must be a list of vertices like {{{10,10},{20,20}}}, it's ugly but I need
    -- to keep trace of each collider, I don't want to create segments between my collider
    -- @radius number range of the field_of_view
    function field_of_view_system:poly_view(position, list_vertices, radius)
      local rays = {}
      local segments = {}
      local list_rays, list_segments = {}
      local points = {}

      -- From the vertices get a ray from the position to the vertex
      -- At the same time get all the segments 
      for i =1, #list_vertices do
        list_rays, list_segments = self:get_rays_segments(position,list_vertices[i], radius+5)
        for j =1 , #list_rays do
          table.insert(rays, list_rays[j])
        end
        for j =1 , #list_segments do
          table.insert(segments, list_segments[j])
        end
      end


      local collide,x,y = false,0,0
      local collide_points = {}
      local closest_point = {}


      -- For each rays, check if they collide with an segment.
      for i= 1, #rays do


        collide_points = {}
        closest_point = {}


        for j=1, #segments do

          collide,x,y= segment_collide(rays[i],segments[j])
          if collide then
            table.insert(collide_points,{x,y})
          end
        end

        -- if they didn't collide, get the end point of the rays.
        if #collide_points == 0 then
          closest_point = rays[i][2]

        else
          -- A ray can coolide with multiple segment, so take the point nearest to the position
          closest_point = math.nearest_point(position,collide_points)
        end


        -- Create a vector from center to the point and an arbitrary vector
        temp_seg = vector.substract_vector(rays[i][2],rays[i][1])
        -- Calcul the angle between this angle and 
        atan_theta = math.round(math.atan2(temp_seg[2],temp_seg[1])- math.atan2(-1,0),2)


        closest_point.angle = atan_theta

        -- These part is to avoind to have to much similar point to our polygone. It makes crash the machine.
        local similar = false
        if #points >= 1 then
          for l=1, #points do
            --print(math.round(closest_point.angle,1), math.round(points[l].angle,1))
            if closest_point.angle == points[l].angle then

              similar = true
              break
            end

          end
          if not similar then
            table.insert(points,closest_point)
          end
        else

          table.insert(points,closest_point)
        end

      end
      -- Then sort the point with the angle, just to have a nice order in the point
      table.sort(points, function(a,b)
  
          if a.angle < b.angle then
            return true
          else
            return false
          end
        end
      )


      local to_remove = {}
      
      for i=1, #points do
       points[i] = vector.floor(points[i])
        
      end

      for i=1, #points do
        
        local plus_un = i+1 <= #points and i+1 or 1
        local plus_deux = i+2 <= #points and i+2 or i+2-#points

        if math.dist(points[i],points[plus_un]) <= 2  then
          table.insert(to_remove,plus_un)
      end


--[[
      if points[i][2] == points[plus_un][2] and points[plus_un][2] == points[plus_deux][2] then
      table.insert(to_remove,plus_un)
     end
--]]
      end

      TableRemoveEfficient(points,to_remove)

      


      return points
    end




    function field_of_view_system:get_rays_segments(position, vertices, radius)
      local segments = {}
      local rays = {}
      local new_segment = {}
      local new_ray = {}


      -- If the there is only one vertex, none segment can be found so just return the ray between the position and the vertex
      if #vertices == 1 then
        new_ray = {{position[1], position[2]},vertices[1]}
        table.insert(rays, new_ray)
        return rays, segments
      end


      for i=1, #vertices do
        -- Test if the vertex is in range. If true I draw 3 rays. One to the vertex and two with a different angle. It needed to see
        -- to corner

        if math.dist(position, vertices[i]) < radius then
          new_ray = {{position[1], position[2]},vertices[i]}
          table.insert(rays, new_ray)


          local my_vector = vector.substract_vector(vertices[i], position)
          local m = vector.normalize(my_vector)
          local strait = vector.multiply_vector(m, radius)
          strait = vector.addition(position,strait)
          local r = vector.rotate(strait,position, 0.01)
    
          new_ray = {{position[1], position[2]},r}
          table.insert(rays, new_ray)

          local l = vector.rotate(strait,position, -0.01)
 
          new_ray = {{position[1], position[2]},l}

          table.insert(rays, new_ray)


        end
        local copy_vert = deepcopy(vertices[i])
        local copy_vert2 = deepcopy(vertices[ i+1 <= #vertices and i+1 or 1])

        local new_segment = {copy_vert, copy_vert2}




        table.insert(segments, new_segment)

      end

      return rays, segments

    end



    return field_of_view_system
  end


}