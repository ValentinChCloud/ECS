local System = require("src.systems.system")




local sprite_renderer_system = {}
function sprite_renderer_system.new()
  local s = System.new("sprite_renderer_system", {"sprite_renderer","body"},4)
  local s_meta = {__index = sprite_renderer_system}
  setmetatable(s,s_meta)
  s.core_draw = nil
  return s
end



function sprite_renderer_system:core_draw(World, entity_id)

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
          love.graphics.rectangle("fill",0,0, size[1], size[2])
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



return {


requires = {"common"},
components = require("src.components.sprite_renderer_components"),
sub_systems = {},
systems ={
sprite_renderer_system = sprite_renderer_system.new,

}






}
