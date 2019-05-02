local System = require("src.systems.system")






return {


  requires = {"common" ,"renderer", "camera", "light"},
  sub_systems = {"light"},

camera_target_system = function ()
  local camera_target_system = System.new("camera_target_system", {names.camera_renderer,names.body}, 3)
  
  function camera_target_system:core_update(World, dt, entity_id)
    local camera_target = World.components[names.camera_renderer][entity_id].target
    
    if camera_target.entity_id == 0 then
      return
    end
    
    local target_body = World.components[names.body][camera_target.entity_id]
    local camera_body = World.components[names.body][entity_id]
    local camera_size = World.components[names.size][entity_id].size
    
    if target_body == nil then
      
    else
    camera_body.position = {target_body.position[1]-camera_size[1]/2,  target_body.position[2]- camera_size[2]/2}
    end
  end
  
  
  return camera_target_system
end,

--]]
  camera_renderer_system = function()
    local camera_renderer_system = System.new("camera_renderer_system",{names.camera_renderer, names.body},10)


    function camera_renderer_system:sort_entities(ents)


      table.sort(ents, function(a,b)
          if a.layer > b.layer then
            return true
          elseif a.layer < b.layer then
            return false
          else
            return a.y < b.y
          end

        end
      )


    end





    function camera_renderer_system:load()

    end






    function camera_renderer_system:core_update(World, dt, entity_id)
      local camera_renderer = World.components[names.camera_renderer][entity_id]
      local camera_body = World.components[names.body][entity_id]
      local entities = World:get_all_with({"sprite_renderer"}, false)
      --local entities_sorted = self:sort_entities(entities)
       local entities_sorted = entities
      camera_renderer.canvas = {}

      for index, entity_to_draw in ipairs(entities_sorted) do
        repeat
          local sprite_renderer = entity_to_draw:get_component("sprite_renderer")
          local body =  entity_to_draw:get_component("body")
          local w = sprite_renderer.size.size[1]/2
          local h =  sprite_renderer.size.size[2]/2
          
          

          if body.position[1]+w < camera_body.position[1]- camera_renderer.size.size[1] *0.2 then
            entity_to_draw:desactivate()
           -- sprite_renderer:disable()
            break
          end

          if body.position[1]-w > camera_body.position[1]+ camera_renderer.size.size[1]*1.2 then
           entity_to_draw:desactivate()
           -- sprite_renderer:disable()
            break
          end




          if body.position[2]+h < camera_body.position[2] - camera_renderer.size.size[2]* 0.2  then
            entity_to_draw:desactivate()
           -- sprite_renderer:disable()
            break
          end



          if body.position[2]-h > camera_body.position[2]+ camera_renderer.size.size[2]*1.2 then
            entity_to_draw:desactivate()
            -- sprite_renderer:disable()
            break
          end
    
        entity_to_draw:activate()
           -- sprite_renderer:enable()


          local my_table = { canva = sprite_renderer.canva,
            id = entity_to_draw:get_id(),
            x = math.floor(body.position[1] - camera_body.position[1]) ,

            y = math.floor(body.position[2]- camera_body.position[2]),

            layer  = sprite_renderer.layer_order,
            offset_x = math.floor(sprite_renderer.size.size[1]/2),
            offset_y = math.floor(sprite_renderer.size.size[2]/2),
            rot = body.rot
          }


          table.insert(camera_renderer.canvas, my_table)

        until true
      end

self:sort_entities(camera_renderer.canvas)
      for i, shader in ipairs(camera_renderer.shaders) do
        World.sub_systems[shader.name]:update(dt, shader, renderer)
      end


 local entities = World:get_all_with({"sound_emitter"}, false)
 
 for i=1, #entities do
   if entities[i]:get_component("sound_emitter").enabled == false then
     entities[i]:get_component("sound_emitter").source:stop()
    end
   
  end


    end


    function camera_renderer_system:core_draw(entity_id)
      
      local camera_renderer = World.components[names.camera_renderer][entity_id]
      local body = World.components[names.body][entity_id]
            love.graphics.setBlendMode("alpha","alphamultiply")
      love.graphics.setCanvas(camera_renderer.canva)
      love.graphics.clear()
      --love.graphics.push("all")
     -- love.graphics.translate(body.position[1], body.position[2])
      for i, canva in ipairs(camera_renderer.canvas) do
        love.graphics.draw(canva.canva, canva.x, canva.y, -canva.rot,camera_renderer.zoom,camera_renderer.zoom,canva.offset_x,canva.offset_y)
      end
      love.graphics.setCanvas()
--      love.graphics.pop()

      local ents = World:get_all_with({"light"}, true)
      love.graphics.setCanvas{camera_renderer.light_canva,stencil = true}
      love.graphics.clear()

      local light = {}
      for i= 1, #ents do
        light = ents[i]:get_component("light")
        World:call_sub_system(light.type):draw(light, camera_renderer.canva, body)
      end
     
     
     local ents = World:get_all_with({"timer"}, true)
     
     for i=1, #ents do

       love.graphics.push("all")
        timer = ents[i]:get_component("timer")
        love.graphics.setFont(bit_font)
        
        love.graphics.printf(math.floor(timer.timer),200,10,200,"center",0,2,2)
          love.graphics.pop()
      end
     local lighter = lighter:get_component("lighter")
     
     love.graphics.push("all")
     love.graphics.draw(key,350,535,0,0.15,0.15)
     love.graphics.draw(space,550,570,0,0.10,0.10)
     love.graphics.draw(TEST,600,535,0,0.25,0.25)
     love.graphics.setColor(0+1-1*(lighter.fuel/lighter.fuel_max ),1*(lighter.fuel/lighter.fuel_max) ,0,1)
     love.graphics.rectangle("fill",665,600,15,-50 *(lighter.fuel/lighter.fuel_max) )
          love.graphics.setColor(1,1,1,1)
          
          love.graphics.setColor( 252/255,209/255,4/255,1)
    
          love.graphics.rectangle("fill",10,10,40,40)
              love.graphics.setFont(bitM_font)
          love.graphics.print("X "..#treasures,60,20)
                love.graphics.setColor(1,1,1,1)
                love.graphics.pop()
     -- for i, shader in ipairs(camera_renderer.shaders) do
       -- World.sub_systems[shader.name]:draw(shader, renderer)
      --end
 
        love.graphics.setCanvas()
        love.graphics.setBlendMode("alpha","alphamultiply")
      love.graphics.draw(camera_renderer.light_canva,0,0)


    end



    function camera_renderer_system:destroy(entity)

    end


    return camera_renderer_system
  end

}
