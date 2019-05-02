local Component = require("src.components.component")

local material = require("src.components.material_components")

return {
  
  
circle_collider = function(args)
    local poly_collider = Component.new(names.circle_collider)
    poly_collider.type = "circle"
    -- For rebond and stuff like that
    if args.material then
      poly_collider.material = material[args.material.name](args.material.args or {})
    else
      poly_collider.material = material["standard_material"]({})
    end

    poly_collider.radius = assert.int(args.radius or 50)
    return poly_collider
  end,

  
  rectangle_collider = function(args)
    local poly_collider = Component.new(names.rectangle_collider)
    poly_collider.type = "poly"
    -- For rebond and stuff like that
    if args.material then
      poly_collider.material = material[args.material.name](args.material.args or {})
    else
      poly_collider.material = material["standard_material"]({})
    end
    local size = assert.type(args.size or {50,50} , "table")
    poly_collider.size = size
    return poly_collider
  end,

  
  
  
  
  
  
}