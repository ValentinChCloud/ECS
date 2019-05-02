local Component = require("src.component")
local names = require("src.const").names
local common = require("src.components.common_components")
local renderer = require("src.components.renderer_components")



return {


add_shader = function(args)
  assert.int(args.target)
  local add_shader = Component.new(names.add_shader)
  add_shader.target = common.target(args.target)
  add_shader.shader = common.target(args.shader_name)
  
  return add_shader
end

}