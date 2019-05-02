local System = require("src.systems.system")



return {

  requires = {"ia_cavern", "sounds"},
  sub_systems = {},



  ia_cavern_system = function ()
local ia_cavern_system  = System.new("ia_cavern_system ", {names.ia_cavern, names.field_of_view, names.state, names.body},1)


    function ia_cavern_system:core_update(World, dt, entity_id)
      local field_of_view = World.components["field_of_view"][entity_id]
      local my_body = World.components["body"][entity_id]
      local state = World.components["state"][entity_id]
      local rg =  World.components["rigid_body"][entity_id]
      local ia =  World.components["ia_cavern"][entity_id]
      local light =  World.components["light"][entity_id]
      local sound =  World.components["sound_emitter"][entity_id]
      local speed = 100
      if math.point_in_poly(jhonny:get_component("body").position, field_of_view.points) then
        local v = vector.substract_vector( jhonny:get_component("body").position, my_body.position)

        if vector.magnitude(v) <= 26 then
         --jhonny:destroy()
         --jhonny:desactivate()
         jhonny:del_component("camera_controller")
         restart = true
          return
        end
        v = vector.normalize(v)
        ia.direction = v

        state.state = HUNTING
        state.hunting_timer = 0
      end

      if  state.state == HUNTING then
--sound.source:play()
--sound.source:setPitch(1.3)
speed= 200
        state.hunting_timer = state.hunting_timer  +dt
        if state.hunting_timer >=2 then
           state.state = IDLE
             state.idle_timer  = 0
           ia.direction = {0,0}
        end
      end
      
      if  state.state == IDLE then
--sound.source:stop()
        state.idle_timer =   state.idle_timer + dt
        light.wawe = true
        light.wawe_speed = 0.2
        if state.idle_timer >= 5 then
           ia.direction = vector.rotate({1,0},{0,0}, math.rad(math.clamp(45 * math.random(0,8),0,360)))
           state.walking_timer  = 0
           state.state = WALKING
        end
      end
      
            
      if  state.state == WALKING then
        --feets:play()
 
        state.walking_timer =   state.walking_timer + dt
        
        if  state.walking_timer >= 7 then
           ia.direction = {0,0}
             state.idle_timer  = 0
           state.state = IDLE
        end
      end
      
      
      -- Just moving 

      if state.is_colliding  and state.state ~= HUNTING then

        ia.direction = vector.rotate(ia.direction,{0,0}, math.rad(math.clamp(45 * math.random(0,8),0,360)))
      end
        rg.velocity = vector.multiply_vector(ia.direction,speed)
      --  my_body.position[1] =my_body.position[1] +ia.direction[1]
      --  my_body.position[2] =my_body.position[2] +ia.direction[2]
      
      
    end


  return ia_cavern_system
end

}