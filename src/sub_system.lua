return {
  
  -- requires : array of __id component you need for this sub_system
  -- priority : int, 1 to XXX, 1 is the the lower priority level
  -- return : table
  new = function (name)
    assert.type(name, "string")
    local sub_system = {
      requires = requires,
      __name  = name,
      __type = "sub_system",
    }
    
    -- entity : entity
    -- Check if the entity has the components requires by the sub_systems and if these components are actives
    -- return : boolean

    function sub_system:update(dt) 
    end
    
    function sub_system:draw() 
    end
    

    
    return sub_system
  end
}