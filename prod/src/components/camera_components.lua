local Component = require("src.components.component")

local common = require("src.components.common_components")

return {
  

camera_renderer = function(args)
  local camera_renderer = Component.new("camera_renderer")
  camera_renderer.canva = love.graphics.newCanvas(800,600)
  camera_renderer.light_canva =  love.graphics.newCanvas(800,600)
  camera_renderer.lights = {}
  camera_renderer.canvas = {}
  camera_renderer.shaders = {}
  camera_renderer.zoom = 1.0
  camera_renderer.size = common.size(args.size)
  camera_renderer.follow = false
  camera_renderer.target = common.target()
  --[[
  for i, shader in ipairs(args.shaders) do
    table.insert(renderer.shaders, common.shader(shader))
  end
  --]]
  return camera_renderer
end




}