local System = require("src.systems.system")



return {
  requires = {},
  components = require("src.components.common_components"),
  sub_systems = {},




  target_system = function ()
    local target_system = System.new("target_system", {names.target},3)

    function target_system:core_update(World, dt, entity_id)

      local target = World.components["target"][entity_id]
      local body =  World.components["body"][entity_id]
      local target_body = World.components["body"][target.entity_id]

      if target_body == nil then

      else
        body.position[1],body.position[2]= target_body.position[1],target_body.position[2]
      end

    end

    return target_system
  end,





}