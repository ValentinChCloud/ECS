local Component = require("src.components.component")


return {
  
standard_material = function(args)
  local standard_material = Component.new(names.standard_material)
  -- For rebond and stuff like that
  standard_material.friction = assert.int(args.friction or 0)
  standard_material.bouciness = assert.int(args.bouciness or 0)
  return standard_material
end,

bouncy_material = function(args)
  local bouncy_material = Component.new(names.bouncy_material)
  -- For rebond and stuff like that
  bouncy_material.friction = assert.int(args.friction or 0)
  bouncy_material.bouciness = assert.int(args.bouciness or 0.5)
  return bouncy_material
end

}