local Component = require("src.components.component")

return {
  

  
sprite_renderer = function(args)
  local sprite_renderer = Component.new(names.sprite_renderer)
sprite_renderer:disable()
  local color = args.color or { 1,  1 , 1 ,  1}
  --sprite_renderer.color = common.color(color)

  sprite_renderer.color = color
  sprite_renderer.color_filters =  {}
  sprite_renderer.color_modified = common.color({r = 0, g = 0, b =0, a=0})
  sprite_renderer.layer_order = args.layer_order or 10
  
  
  sprite_renderer.rectangle = args.rectangle or false
  sprite_renderer.circle = args.circle or false
  sprite_renderer.radius = 15

  sprite_renderer.size = common.size(args.size or { 50, 50 })
  sprite_renderer.canva = love.graphics.newCanvas(sprite_renderer.size.w,sprite_renderer.size.h)
  sprite_renderer.shaders = {}
  
  return sprite_renderer
end,
  
  
gui_renderer = function(args)
  local gui_renderer = Component.new("gui_renderer")
  gui_renderer.sprite = ""
  return gui_renderer
end

}