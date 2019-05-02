local System = require("src.systems.system")



return {

  requires = {"common","physic"},
  sub_systems = {},



  rigid_body_system = function ()
    local rigid_body_system = System.new("rigid_body_system", {names.rigid_body, names.body},2)

    function rigid_body_system:core_update(World, dt,entity_id)
      local body = World.components[names.body][entity_id]
      local rigid_body = World.components[names.rigid_body][entity_id]
      local collider = rigid_body.collider  

      if collider == nil then
        return
      end
      if rigid_body.body_type == "static" then
        return
      end



      local entities =  World:get_all_with({names.rigid_body}, true)
      local is_colliding = false

      rigid_body.is_colliding = false
      local ent_collider = {}
      local c = 0
      repeat
        is_colliding = false
        local co = {type = "poly", vertices = math.rect_vertices(body.position,collider.size , body.rot)}
        local sat_object_a = SAT.new_shape(co, body)
        local sat_object_b ={}

        for i = 1, #entities do
          repeat
            if entity_id ~= entities[i]:get_id() then
              ent_collider = entities[i]:get_component(names.rigid_body).collider
              ent_body = entities[i]:get_component(names.body)
              if ent_collider ~= nil then
                local co = {type = "poly", vertices = math.rect_vertices(ent_body.position,ent_collider.size , ent_body.rot)}
                if body.position[1] + collider.size[1]/2 < ent_body.position[1] -ent_collider.size[1]/2 then
                  break
                end

                if body.position[1] - collider.size[1]/2 > ent_body.position[1] +ent_collider.size[1]/2 then
                  break
                end

                if body.position[2] + collider.size[2]/2 < ent_body.position[2] -ent_collider.size[2]/2 then
                  break
                end

                if body.position[2] - collider.size[2]/2 > ent_body.position[2] +ent_collider.size[2]/2 then
                  break
                end


                sat_object_b = SAT.new_shape(co, ent_body)

                -- Test collide

                local collide, mtv_axis, mtv, point = SAT.is_colliding(sat_object_a,sat_object_b, true)
                if collide then
                  if World.components["state"][entity_id] then
                    World.components["state"][entity_id].is_colliding = true
                  end
                  
                  if  jhonny:get_id() == entity_id then
                    bump:play()
                    
                  end
                  
                  
                  
                  
                  
                          c = c +1
                  --is_colliding = true
                  my_mtv_axis = mtv_axis
                  my_point = point
                  body.position = vector.addition(body.position, vector.multiply_vector(mtv_axis, mtv))
                  if ent_collider.body_type ~= "static" then
                    ent_body = vector.addition(body.position, vector.multiply_vector(mtv_axis, -mtv))
                    
                  end
              
                else



                end


              end

            end
          until true
        end
      until not is_colliding

      if c == 0 then
       
        if World.components["state"][entity_id] then
          World.components["state"][entity_id].is_colliding = false
        end

      end
    end

    return rigid_body_system

  end,



  velocity_system = function()
    local velocity_system =System.new( "velocity_system",{names.rigid_body ,names.body},1)

    function velocity_system:core_update(World, dt, entity_id)
      local rigid_body = World.components[names.rigid_body][entity_id]
      local velocity = rigid_body.velocity
      local acceleration = rigid_body.acceleration

      local body = World.components[names.body][entity_id]
      local position = body.position

    



--velocity[2] = math.clamp(velocity[2] + acceleration[2]*dt,-300,300)


--acceleration[2] = 0
      --acceleration[1] =   0
      --acceleration[2] =   0

      if velocity[1] >= 0 then
         position[1] = math.floor( position[1]+ velocity[1]*dt)
      else
         position[1] = math.ceil( position[1]+ velocity[1]*dt)
      end
        
      if velocity[2] >= 0  then
        position[2] = math.floor(position[2]+ velocity[2]*dt)
      else
        position[2] = math.ceil(position[2]+ velocity[2]*dt)
      end
     
      
      velocity[1] =  0
      velocity[2] =  0

      -- print(position[2] )

      --print(rigid_body.angular_acceleration)

      rigid_body.angular_velocity  = rigid_body.angular_velocity +  math.sign(rigid_body.angular_velocity)*-1* math.pi/20
      body:rotation(rigid_body.angular_velocity*dt)

      --rigid_body.angular_velocity = rigid_body.angular_velocity*0.99



    end


    return velocity_system
  end,



  gravity_system = function ()
    local gravity_system = System.new ("gravity_system",{names.rigid_body},2)

    function gravity_system:core_update(World, dt, entity_id)
      local rigid_body = World.components[names.rigid_body][entity_id]
      if not rigid_body.gravity then
        return
      end

      rigid_body.velocity[2] = rigid_body.velocity[2] + 300*dt


    end


    return gravity_system

  end,
}