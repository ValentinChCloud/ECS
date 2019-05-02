local Component = require("src.component")

local common = require("src.components.common_components")
local light = require("src.components.light_components")



return {
  
lighter = function (args)
  local lighter = Component.new("lighter")
  lighter.fuel_max = args.fuel_max or 55
  lighter.fuel = args.fuel or lighter.fuel_max
  lighter.is_active = false
  return lighter
end,
  

}