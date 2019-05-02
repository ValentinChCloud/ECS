local Component = require("src.component")

local common = require("src.components.common_components")

return {
  

  
keyboard_controller = function(args)
    local keyboard_controller = Component.new(names.keyboard_controller)
    keyboard_controller.key =""
    return keyboard_controller
    
end,

camera_controller = function(args)
    local camera_controller = Component.new(names.camera_controller)
    camera_controller.key =""
    return camera_controller
    
end,

}