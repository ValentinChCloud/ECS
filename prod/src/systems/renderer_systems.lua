local System = require("src.systems.system")



return {


requires = {"common"},
components = require("src.components.renderer_components"),
sub_systems = {},



sprite_renderer_system = function()
  local sprite_renderer = System.new("sprite_renderer_system",{names.sprite_renderer, names.body},4)
  


--[[
  function sprite_renderer:core_update(dt, entity_id)
    local sprite_renderer = World.components[names.sprite_renderer][entity_id]
    local color = sprite_renderer.color
    local color_filters = sprite_renderer.color_filters
    local color_modified = sprite_renderer.color_modified
    
    color_modified.r = color.r
    color_modified.g = color.g
    color_modified.b = color.b
    color_modified.a = color.a

    for i, filter in pairs(color_filters) do
      color_modified.r = color_modified.r + filter.r
      color_modified.g = color_modified.g + filter.g
      color_modified.b = color_modified.b + filter.b
      color_modified.a = color_modified.a + filter.a
    end

    
  end
  --]]

    
  function sprite_renderer:core_draw(entity_id)
    
  
    local sprite_renderer = World.components[names.sprite_renderer][entity_id]
    --local color_modified = sprite_renderer.color_modified
    local color_modified = sprite_renderer.color
    local body = World.components[names.body][entity_id]
    local size = sprite_renderer.size
    
    
    
    love.graphics.push("all")

      
      
      
      love.graphics.setCanvas(sprite_renderer.canva )
      love.graphics.clear( )
     -- love.graphics.setColor(color_modified.r,color_modified.g,color_modified.b,color_modified.a)
      love.graphics.setColor(color_modified)
        if sprite_renderer.rectangle then  
          love.graphics.rectangle("fill",0,0, size.size[1], size.size[2])
        elseif sprite_renderer.circle then
          love.graphics.circle("fill",15,15,sprite_renderer.radius )
          
        end
      love.graphics.setCanvas()
      --]]
      --[[
    for i, shader_id in pairs(sprite_renderer.shaders) do
      local shader_entity = World.entities[i]
      local canvas2 = love.graphics.newCanvas(size.w, size.h)
      love.graphics.setCanvas(canvas2)
        shader_book[shader_entity:get_component("shader").name](shader_entity)
        love.graphics.draw(canvas,0,0)
        love.graphics.setShader()
      love.graphics.setCanvas()
      canvas = canvas2
  end
      --]]
      
      
      
      
      

  -- love.graphics.draw(sprite_renderer.canva, math.floor(body.x-size.w/2),math.floor(body.y-size.h/2))
    love.graphics.pop()

    
  end

  return sprite_renderer
end,



  
  


}