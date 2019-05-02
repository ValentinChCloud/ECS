
local Sub_system = require("src.sub_system")


return {






  point_light_system = function () 
    local point_light_system = Sub_system.new("point_light")

    function point_light_system:update(dt, entity_id)
      local light = World.components["light"][entity_id]
      local body =  World.components["body"][entity_id]
      t=  vector.substract_vector( body.position,    world_camera:get_component("body").position)
      light.shader:send("light.position", t)
      light.shader:send("light.diffuse", light.diffuse)
      light.shader:send("light.pow", light.pow)
      light.shader:send("light.range", light.range)



    end



    function point_light_system:draw(light, canva)
      love.graphics.setShader(light.shader)
      love.graphics.draw(canva)
      love.graphics.setShader()
    end



    return point_light_system


  end,



  shadow_light_system = function()
    local shadow_light_system = Sub_system.new("shadow_light")

    function shadow_light_system:update(World,dt, entity_id, light)
    
      local field_of_view = World.components["field_of_view"][entity_id]
      local body =  World.components["body"][entity_id]
      light.field_of_view = field_of_view.points

      t=  vector.substract_vector( body.position,    world_camera:get_component("body").position)
      light.shader:send("light.position", t)
      light.shader:send("light.diffuse", light.diffuse)
      light.shader:send("light.pow", light.pow)
      light.shader:send("light.range", light.range)
      
      local rand = math.random()
      if rand < light.sparkling then
        light.pow = math.clamp(math.random(),light.pow_max*0.95, light.pow_max)
      else
        light.pow = math.clamp(light.pow + light.pow*1.05,0,light.pow_max)
      end



    end


    function shadow_light_system.stencil_function()
      if #stencil_light.field_of_view == 0 then
        return
      end
      love.graphics.push("all")
      love.graphics.translate(-t.position[1], - t.position[2])

      local triangles = love.math.triangulate(stencil_light.field_of_view)
      for i=1, # triangles do
        love.graphics.polygon("fill",triangles[i])
      end

      love.graphics.pop()
    end

    function shadow_light_system:draw(light,canva, camera)

      stencil_light = light
      t = camera


      love.graphics.push("all")
      love.graphics.stencil(shadow_light_system.stencil_function , "replace", 1)
      love.graphics.setStencilTest("greater", 0)
      love.graphics.setShader(light.shader)

      love.graphics.draw(canva)

      love.graphics.setShader()
      love.graphics.setStencilTest()
      love.graphics.pop()
    end



    return shadow_light_system
  end,

  world_light_system = function () 
    local world_light_system = Sub_system.new("world_light")


    function world_light_system:update(World, dt, entity_id)
      local light = World.components["light"][entity_id]
      light.shader:send("light.diffuse", light.diffuse)
      light.shader:send("light.pow", light.pow)

    end


    function world_light_system:draw(light, canva)

      love.graphics.setShader(light.shader)


      love.graphics.draw(canva)
      love.graphics.setShader()


    end



    return world_light_system


  end


}
