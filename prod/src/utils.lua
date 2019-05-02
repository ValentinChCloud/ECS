
function table.new(orig)
  local orig_type = type(orig)
  local copy 
  if orig_type == 'table'then
    copy = {}
    for orig_key, orig_value in next, orig, nill do
      copy[table.new(orig_key)] = table.new(orig_value)
    end
  else
    copy = orig
  end
  return copy
end




function deepcopy( orig )
  local copy = {}

  if type(orig) == "table" then

    for i, value in pairs(orig) do
      copy[i] = deepcopy(value)
    end
  else -- number, string, boolean etc.
    copy = orig
    
  end
   return copy
  
end


function deepcopy_no_function( orig )
  local copy = {}

  if type(orig) == "table" then
    for i, value in pairs(orig) do
      copy[i] = deepcopy_no_function(value)
    end
  elseif type(orig) == "function" then
    
    return nil
  else-- number, string, boolean etc.
    copy = orig
    
  end
   return copy
  
end


-- a = { x1, y1, x2, y2}



function draw_polygone(vertices)
  local vertices_to_love = {}
  for i=1, #vertices do
    table.insert(vertices_to_love, vertices[i][1])
    table.insert(vertices_to_love, vertices[i][2])
  end
  love.graphics.polygon("fill",vertices_to_love)
end


function segment_collide(a, b)
  local point1 = a[1]
  local point2 = a[2]
  local point3 = b[1]
  local point4 = b[2]


  if point1[1] == point3[1] and  point1[2] == point3[2] then
    return true, point1[1], point1[2]
  end
  if point1[1] == point4[1] and  point1[2] == point4[2] then
    return true, point1[1], point1[2]
  end 

  if point2[1] == point3[1] and  point2[2] == point3[2] then
    return true, point2[1], point2[2]
  end
  if point2[1] == point4[1] and  point2[2] == point4[2] then
    return true, point2[1], point2[2]
  end 


  -- Simple overlap detection
  if (math.max(point1[1],point2[1]) < math.min(point3[1], point4[1])) then
    return false -- No mutual abscisses
  end


  local parra_y = {false,false }
  if point1[1] == point2[1] then
    -- ligbe1 parra to y axis
    parra_y[1] = true
  end

  if point3[1] == point4[1] then
    -- ligne2 parra to y axis

    parra_y[2] = true

  end

  if parra_y[1] == parra_y[2] and  parra_y[2] ~= false then
    return false -- parra to y axis
  end





  local A1 = (point2[2] -point1[2]) / (point2[1] -point1[1]) 
  local A2 = (point4[2] -point3[2]) / (point4[1] -point3[1])

  if A1 == A2 then
    return false -- parallel segments
  end

  local b1 = point1[2] - A1*point1[1] 
  local b2 = point3[2] - A2*point3[1]


  -- So if the segments collide a poiint exists to resolve the two equations

  -- yA =  A1 * Xa + b1
  -- yA =  A2* Xa + b2
  --   A2* Xa - b2 = A1 * Xa - b1
  -- Xa =  (b2 - b1) / (A1 - A2)
  -- y axis : x = A2 * xa -b2
  -- xa = x+b2 / A2
  local Xa = 0
  local Xb = 0
  if parra_y[1] then
    Xa =  point1[1] 
    if A2 == 0 then

      Xb = b2
    else
      Xb = Xa*A2 +b2
    end

    if ( Xb < math.max( math.min(point1[2],point2[2]) ,math.min(point3[2],point4[2])) or
      Xb > math.min( math.max(point1[2],point2[2]) ,math.max(point3[2],point4[2]))) then

      return false
    end
  elseif parra_y[2]then
    Xa = point3[1] 
    if A1 == 0 then

      Xb = b1
    else

      Xb = A1 *Xa +b1
    end
    if ( Xb < math.max( math.min(point1[2],point2[2]) ,math.min(point3[2],point4[2])) or
      Xb > math.min( math.max(point1[2],point2[2]) ,math.max(point3[2],point4[2]))) then

      return false
    end
  else

    Xa = (b2 -b1) / (A1 -A2)
    Xb = A1 * Xa + b1
  end


  if ( Xa < math.max( math.min(point1[1],point2[1]) ,math.min(point3[1],point4[1])) or
    Xa > math.min( math.max(point1[1],point2[1]) ,math.max(point3[1],point4[1]))) then

    return false
  else
    return true, Xa, Xb
  end



end



-- require 
-- Detect if two rectangle collide
-- a : a.body, a.hitbox 
-- b : a.body, b.hitbox 
-- return : true, false
function simple_collide( a, b)
  local body_a = a.body
  local body_b = b.body
  local hitb_a = a.hitbox
  local hitb_b = b.hitbox  
  --Centered

  if (body_a.x + hitb_a.w/2) >= (body_b.x-hitb_b.w/2)  and  (body_a.x - hitb_a.w/2) <= (body_b.x  + hitb_b.w/2) then
    if body_a.y + hitb_a.h/2 >= (body_b.y-hitb_b.h/2)  and (body_a.y - hitb_a.h/2)<= (body_b.y + hitb_b.h/2) then
      return true
    end
  end

  
  
    return false
end



-- Test collide between two shape that can rotate
-- T = PB–PA
-- L = an arbitrary axis (i.e. a unit vector)
-- Proj ( T )| > ½|Proj ( RectangleA )| + ½|Proj ( RectangleB )|
-- equivalent
--[[ |Proj ( T )|> |Proj ( WA*Ax )|+ |Proj ( HA*Ay )|+ |Proj ( WB*Bx )|+ |Proj( HB*By )|--]]
-- equivalent
-- | T • L | > | ( WA*Ax )• L | + | ( HA*Ay )• L | + | ( WB*Bx )• L | + |( HB*By )• L |

-- A a shape with all segments and normals
---
function complexe_collide(a, b)
  local body_a = a.body
  local body_b = b.body
  local hitb_a = a.hitbox
  local hitb_b = b.hitbox



  
  -- left corner
  local vertices_a = math.rect_vertices({x =body_a.x, y = body_a.y}, hitb_a, body_a.rot)
  local vertices_b = math.rect_vertices({x =body_b.x, y = body_b.y}, hitb_b, body_b.rot)
  local v = {}
  
  
  local axes = {}
  for i= 1, #vertices_a do
    
    local v1 = vertices_a[i]
    local v2 = vertices_a[i+1 == #vertices_a+1 and 1 or i+1 ]
    
    -- Create the vector axis
    local axis = rotate_vector(math.normalize_vec(vector.substract_vector(v2,v1)), math.pi/2)
    table.insert(axes,axis)
  end
  
   for i= 1, #vertices_b do
    
    local v1 = vertices_b[i]
    local v2 = vertices_b[i+1 == #vertices_b+1 and 1 or i+1 ]
    
    -- Create the vector axis
    local axis = rotate_vector(math.normalize_vec(vector.substract_vector(v2,v1)),math.pi/2)
    table.insert(axes,axis)
  end 
  
  

  local T =  vector.substract_vector(body_a,body_b)
  T.x = math.abs(T.x)
  T.y = math.abs(T.y)
  local T_dot = 0
  local smallest_overlap = -999
  local mtv_axis = {}
  local Wa_dot =0
  local Ha_dot =0
  local Wb_dot =0
  local Hb_dot =0
  local t_dot = 0
  local t_dots = {}
  local overlaps = {}
  local overlap = 9999
  local differences = {}
  local min_difference = 1000
  local min_overlap = 1000
  local numero_axe = 0
  local min = 1000
  for i=1, 8 do
    
--  print("axis",i)
    local min_a = math.dot(vertices_a[1],axes[i])
    local max_a = min_a

    for j=2, 4 do
      local projection = math.dot(vertices_a[j],axes[i])
      if projection < min_a then
        
        min_a = projection
      elseif projection > max_a then
        max_a = projection
      end
    end

  
    
    
    local min_b = math.dot(vertices_b[1],axes[i])
    local max_b = min_b
    for j=2, 4 do
      local projection = math.dot(vertices_b[j],axes[i])
      if projection < min_b then
        min_b = projection
      elseif projection > max_b then
        max_b = projection
      end
    end
    
    T_dot = math.dot(T, axes[i])
    local difference = T_dot -(max_a+ max_b)


    -- Get the overlap always positive
    local overlap = math.line_overlap(min_a, max_a, min_b, max_b)
     ---   print(min_a, max_a, min_b, max_b,axis[i].x,axis[i].y,difference)
    if overlap ==0 then
      return false
    end
   -- print("axis",i)
   -- print("ca passe avec", overlap,min_overlap)
    if overlap < min_overlap then
      min_overlap = overlap
      mtv_axis = axes[i]
      numero_axe = i
    end
    --print("i",i)
    --print(overlap)
   --- print(T_dot)
   --print(axis[i].x,axis[i].y)
    --table.insert(t_dots, T_dot)
    --table.insert(overlaps,overlap)
    --table.insert(differences, math.abs(T_dot-overlap))
  end


  local first_face = {}
  local seconde_face = {}
  local a = false
  local b= false
  local op = false
  if math.dot(vector.substract_vector(body_a,body_b),mtv_axis) <= 0  then
   mtv_axis = math.multiply_vector(mtv_axis,-1)
    op = true
end


  for i = 1 , 4 do
    local v1 = vertices_a[i]
    local v2 = vertices_a[i+1 == #vertices_a+1 and 1 or i+1 ]
    
    -- Create the vector axis
    local axis = rotate_vector(math.normalize_vec(vector.substract_vector(v2,v1)), math.pi/2)

     -- axis = math.multiply_vector(axis,-1)

    if mtv_axis.x == axis.x and mtv_axis.y == axis.y then
      a = true
      first_face = {v1,v2}
      break
    end
  end
  if not a then
  for i = 1 , 4 do
    local v1 = vertices_b[i]
    local v2 = vertices_b[i+1 == #vertices_b+1 and 1 or i+1 ]
    
    -- Create the vector axis
    local axis = rotate_vector(math.normalize_vec(vector.substract_vector(v2,v1)), -math.pi/2)
    if mtv_axis.x == axis.x and mtv_axis.y == axis.y then
      first_face = {v1,v2}
      b = true
      break
    end
  end
end

  if a then
    for i = 1 , 4 do
    local v1 = vertices_b[i]
    local v2 = vertices_b[i+1 == #vertices_b+1 and 1 or i+1 ]
    local face = vector.substract_vector(v2,v1)
    local dot = math.dot(face,vector.substract_vector(first_face[2],first_face[1]))
    
    
    if dot < min then
        --face_b = face
        seconde_face = {v2, v1}
        min = dot
    end
    end
  else
    for i = 1 , 4 do
    local v1 = vertices_a[i]
    local v2 = vertices_a[i+1 == #vertices_a+1 and 1 or i+1 ]
    local face = vector.substract_vector(v2,v1)
    local dot = math.dot(face,vector.substract_vector(first_face[2],first_face[1]))
    
    
    if dot < min then
        --face_b = face
        seconde_face = {v2, v1}
        min = dot
    end
    
    
    
    end
  end
  
  
  local bool, point = segment_collide(first_face, seconde_face )
  
  
  --[[
   local face_a = {}
   local face_b = {}
   
  if numero_axe <= 4 then
    face_a = {vertices_a[numero_axe], vertices_a[ numero_axe+1 == 5 and 1 or numero_axe+1]}
  -- face_a = vector.substract_vector(vertices_a[numero_axe], vertices_a[ numero_axe+1 == 5 and 1 or numero_axe+1])
  
    local min = 1000
    for i=1, #vertices_b do
      local v1 = vertices_b[i]
      local v2 = vertices_b[i+1 == #vertices_b+1 and 1 or i+1 ]
      local face = vector.substract_vector(v2,v1)
      local dot = math.dot(face,vector.substract_vector(face_a[1],face_a[2]))
      if dot < min then
        --face_b = face
        face_b = {v2, v1}
        min = dot
      end
      
    end
  else
    face_a = {vertices_b[numero_axe-4], vertices_b[numero_axe+1 == 9 and 5 or numero_axe-4+1]}
    --face_a = vector.substract_vector(vertices_b[numero_axe-4], vertices_b[numero_axe-4+1 == 8 and 5 or numero_axe-4+1])
    
    local min = 1000
    for i=1, #vertices_a do
      local v1 = vertices_a[i]
      local v2 = vertices_a[i+1 == #vertices_a+1 and 1 or i+1 ]
      local face = vector.substract_vector(v2,v1)
      local dot = math.dot(face,vector.substract_vector(face_a[1],face_a[2]))
      if dot < min then
        --face_b = face
        face_b = {v2, v1}
        min = dot
      end
      
    end

  end
--]]
  --local bool, x, y = segment_collide(face_a, face_b )
  

  -- Loking for the face b

  if bool == false then
    --print("edge_edge")
    if b then
      local x1 = (seconde_face[1].x+seconde_face[2].x)/2
      local y2 = (seconde_face[1].y+seconde_face[2].y)/2

      point = { x= x1, y = y2}
    end
    if a then
      local x1 = (first_face[1].x+first_face[2].x)/2
      local y2 = (first_face[1].y+first_face[2].y)/2
      point = { x= x1, y = y2}
    end
  end
  --print("avant")
  --print(math.dot(vector.substract_vector(body_a,body_b),mtv_axis),mtv_axis.x, mtv_axis.y, min_difference)

--print(math.dot(vector.substract_vector(body_a,body_b),mtv_axis),mtv_axis.x, mtv_axis.y, min_difference)

  return true, min_overlap, mtv_axis, point,first_face, seconde_face

end


function complexe_collide2( a,b)
  local body_a = a.body
  local body_b = b.body
  local hitb_a = a.hitbox
  local hitb_b = b.hitbox
  
    
  local point_lu_a = rotate_point({ x = (body_a.x - hitb_a.w/2), y = (body_a.y - hitb_a.h/2)}, {x = body_a.x , y  = body_a.y},body_a.rot)
  
  
  local point_ld_a = rotate_point({ x = (body_a.x - hitb_a.w/2), y = (body_a.y + hitb_a.h/2)}, {x = body_a.x , y  =body_a.y},body_a.rot)
  local point_ru_a = rotate_point({ x = (body_a.x + hitb_a.w/2), y = (body_a.y - hitb_a.h/2)}, {x = body_a.x , y  =body_a.y},body_a.rot)
  local point_rd_a = rotate_point({ x = (body_a.x + hitb_a.w/2), y = (body_a.y + hitb_a.h/2)}, {x = body_a.x , y  =body_a.y},body_a.rot)
  
    local point_lu_b = rotate_point({ x = (body_b.x - hitb_b.w/2), y = (body_b.y - hitb_b.h/2)}, {x = body_b.x , y  = body_b.y},body_b.rot)
  local point_ld_b = rotate_point({ x = (body_b.x - hitb_b.w/2), y = (body_b.y + hitb_b.h/2)}, {x = body_b.x , y  = body_b.y},body_b.rot)
  local point_ru_b = rotate_point({ x = (body_b.x + hitb_b.w/2), y = (body_b.y - hitb_b.h/2)}, {x = body_b.x , y  = body_b.y},body_b.rot)
  local point_rd_b = rotate_point({ x = (body_b.x + hitb_b.w/2), y = (body_b.y + hitb_b.h/2)}, {x = body_b.x , y  = body_b.y},body_b.rot)
  
  
  local ligne_top_a = {point_lu_a,point_ru_a}
  local ligne_left_a = {point_lu_a,point_ld_a}
  local ligne_down_a = {point_ld_a,point_rd_a}
  local ligne_right_a = {point_ru_a,point_rd_a}
  
  
  local ligne_top_b = {point_lu_b,point_ru_b}
  local ligne_left_b = {point_lu_b,point_ld_b}
  local ligne_down_b = {point_ld_b,point_rd_b}
  local ligne_right_b = {point_ru_b,point_rd_b}
  
  local lignes_a = {ligne_top_a, ligne_left_a, ligne_down_a, ligne_right_a}
  local lignes_b = {ligne_top_b, ligne_left_b, ligne_down_b, ligne_right_b}
  local collide = false
  for i=1, 4 do
    for j=1, 4 do
      collide = segment_collide(lignes_a[i], lignes_b[j])
     if collide then return collide end
    end
  end
  return collide
      
  
  
end
