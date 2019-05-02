local Component = require("src.components.component")
local common = require("src.components.common_components")
local colliders = require("src.components.colliders_components")


return {

  poly_collider = function(args)
    local poly_collider = Component.new(names.poly_collider)
    poly_collider.type = "rectangle"
    -- For rebond and stuff like that
    if args.material then
      poly_collider.material = material[args.material.name](args.material.args or {})
    else
      poly_collider.material = material["standard_material"]({})
    end

    poly_collider.size = common.size(args.size)  
    return poly_collider
  end,


  rigid_body = function (args)
    local rigid_body = Component.new(names.rigid_body)
    
    -- Base mouvement variables
    rigid_body.velocity = {0,0}
    rigid_body.acceleration = {0,0}
    rigid_body.angular_velocity = 0
    rigid_body.angular_acceleration = 0
    if args.cast_shadows  == nil then
       rigid_body.cast_shadows = true
    else
    rigid_body.cast_shadows = args.cast_shadows 
    end

    -- If gravity, set on false, the gravity acceleration not apply to entity
    rigid_body.body_type = assert.type(args.body_type or "static" , "string")
    rigid_body.gravity = assert.type(args.gravity or false , "boolean")
    if args.collider ~= nil then
      
      rigid_body.collider = colliders[args.collider.type](args.collider.args)
    else
      rigid_body.collider = nil
    end
    -- If kinematic is true, the object will not be move by the physic engine
    --rigid_body.drag = assert.int(args.drag)
    --rigid_body.mass = assert.int(args.drag)
    --rigid_body.speed = assert.int(args.speed)
    --rigid_body.mass = assert.int(args.mass, "boolean")

    return rigid_body
  end,




}