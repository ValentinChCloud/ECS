local Component = require("src.component")

local common = require("src.components.common_components")



return {
  
light = function (args)
  local light = Component.new("light")
  light.type = args.type and xassert(type(args.type) == "string") and args.type or "point"
  light.diffuse = args.diffuse and xassert(type(args.diffuse) == "table") and args.diffuse or {1,1,1}
  light.range = type(args.range) == "number" and args.range  or 200
  light.pow =  args.pow and xassert(type(args.pow) == "number")  and args.pow or 1
  light.pow_max = args.pow_max and xassert(type(args.pow_max) == "number")  and args.pow_max or 1
  light.shader = shader_book[light.type]() 
  light.wawe = false
  light.wawe_speed = 0
  light.wawe_timer = 0
  light.sparkling = args.sparkling and xassert(type(args.sparkling) == "number") and args.sparkling or 0
  light.field_of_view = {}
  return light
end,
  

}