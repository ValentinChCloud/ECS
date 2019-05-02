local Component = require("src.component")

local common = require("src.components.common_components")


return {
  
field_of_view = function(args)
   local field_of_view = Component.new("field_of_view")
  field_of_view.radius = args.radius and xassert(type(args.radius) == "number") and args.radius  or 80
  field_of_view.points = {}
  return field_of_view
end, 
  
  }