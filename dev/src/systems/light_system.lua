local System = require("src.systems.system")






return {
  


requires = {"light"},
sub_systems = {"light"},


light_system = function()
  local light_system = System.new("light_system",{names.light},6)
  
  function light_system:core_update(World, dt, entity_id)
    local light = World.components[names.light][entity_id]
    
    local sub_system = World:call_sub_system(light.type)
    
    if sub_system == nil then
      return
    else
      sub_system:update(World, dt, entity_id, light)
      
    end
    
    
    if light.wawe then
      light.wawe_timer = light.wawe_timer+dt * light.wawe_speed 
      if light.wawe_timer >= 6.28 then
        light.wawe_timer = 0
      end

      light.pow = math.clamp( math.cos(light.wawe_timer),0, light.pow_max)
      
    end
  end
  
  -- The draw system for the lights must be done when everythings is render
  -- If the light systems is before the camera than you render everytimes the last frame and not the actual one
  
  
  
  return light_system
  
end


}