local System = require("src.systems.system")



  return {
    
  requires = {"keyboard","common"},
  sub_systems = {},
    
keyboard_controller_system = function()
  
  

  
  
  local keyboard_controller_system = System.new("keyboard_key",{names.keyboard_controller, names.velocity})
  

  function keyboard_controller_system:core_update(World , dt, entity_id)
    
    local velocity = World.components[names.velocity][entity_id]
    -- TODO : Avec a global lexic

    --rigid_body.velocity.vy = 0
--velocity.vx = 0
--velocity.vy = 0
    if love.keyboard.isDown("right") or love.keyboard.isDown("d")  then
     velocity.vx = 50
    end
    
    if love.keyboard.isDown("left") or love.keyboard.isDown("q")  then
       velocity.vx = -50
        
    end
    if love.keyboard.isDown("down")   then
       velocity.vy = 50
        
    end
    if love.keyboard.isDown("up")   then
       velocity.vy = -50
        
    end

  end
  
  function keyboard_controller_system:draw(entity)
    -- Debug
   -- local buttons = entity:get_component(names.keyboard_controller_system)
    --love.graphics.print("keyboard_controller_system.button_state[left] "..tostring(buttons.button_state["left"]), 100,100)
   -- love.graphics.print("keyboard_controller_system.last_state] "..tostring(buttons.last_button_state["left"]), 100,120)
  end
  
  
  
  return keyboard_controller_system
end,


cammera_controller_system = function()
  

  
  local cammera_controller_system = System.new("keyboard",{names.camera_controller, names.body})
  

  function cammera_controller_system:core_update(World, dt, entity_id)
    
    local body = World.components[names.body][entity_id]
    local rg =  World.components["rigid_body"][entity_id]
    local v = 170

    if love.keyboard.isDown("right")   then
--    body.position[1] = body.position[1] +v
      rg.velocity[1] = v
    end
    
    if love.keyboard.isDown("left")   then
        --body.position[1] = body.position[1] -v
      rg.velocity[1] = -v
        
    end
    if love.keyboard.isDown("down")   then
      --  body.position[2] = body.position[2] +v
              rg.velocity[2] = v
    end
    if love.keyboard.isDown("up")   then
         --  body.position[2] = body.position[2] -v
              rg.velocity[2] = -v
    end




  end
  
  
  
  return cammera_controller_system
end,




--[[

basic_jump_system = function()
  local basic_jump_system = System.new({names.jump, names.velocity})
  
  function basic_jump_system:core_update(dt, entity_id)
    local jump = World.components[names.jump][entity_id]
    -- Add : need to checki the state
    if love.keyboard.isDown("space")  then
      for i= 1, #jump.events do
        event_book[jump.events[i].name](entity_id)
      --table.insert(event_controller.queue,{event = "on_enter", arg = entity_id_queue})
      end
    end
    
  end
  
  
  return basic_jump_system
end
--]]
}