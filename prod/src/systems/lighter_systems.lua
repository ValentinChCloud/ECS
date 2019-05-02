local System = require("src.systems.system")






return {
  


requires = {"lighter", "light"},
sub_systems = {"light"},


ligther_system = function()
  local ligther_system = System.new("lighter_system",{names.lighter},4)
  
  function ligther_system:core_update(World, dt, entity_id)
    local lighter = World.components["lighter"][entity_id]
    local light = World.components["light"][entity_id]
    if lighter.is_active then
      light:enable()
      lighter.fuel = math.clamp(lighter.fuel - dt*3,0,lighter.fuel_max)
      if lighter.fuel == 0 then
        light:disable()
        lighter.is_active = false
      end
      
    else
       lighter.fuel = math.clamp(lighter.fuel + dt*2,0,lighter.fuel_max)
      light:disable()
    end
    
    
    
  end
  
  function ligther_system:core_keypressed(key, entity_id)

    if key == "space" then

      
      World.components["lighter"][entity_id].is_active = not World.components["lighter"][entity_id].is_active
     -- print( World.components["lighter"][entity_id].is_active)
    
    end
    
    
  end


  
  
  
  return ligther_system
  
end


}