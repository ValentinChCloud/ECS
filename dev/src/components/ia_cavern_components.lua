local Component = require("src.component")

local common = require("src.components.common_components")


return {
  
ia_cavern = function(args)
   local ia_cavern = Component.new("ia_cavern")
   ia_cavern.direction = {1,0}
  return ia_cavern
end, 
  
  }