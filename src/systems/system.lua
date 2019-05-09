return {

  -- requires : array of __id component you need for this system
  -- priority : int, 1 to XXX, 1 is the the lower priority level
  -- return : table
  new = function (name, requires, priority)
    assert(type(requires) == 'table')
    local system = {
      requires = xassert(requires),
      __name = xassert(name),
      __type = "system",
      __priority = priority or 10,
      list = {}
    }

    -- entity : entity
    -- Check if the entity has the components requires by the systems and if these components are actives
    -- return : boolean
    function system:match(entity)

      assert(type(entity) == "table", " system:match, no table gave "..type(entity))
      for i=1, #self.requires do
        local comp = World.components[self.requires[i]][entity_id]
        if comp == nil then
          return false
        end
        if not comp:is_enable() then
          return false
        end
      end
      return true
    end

    function system:selection(World, requires, dt)
      xassert(requires, string.concat,"Requires is nil in systems ",self.__name)  

      local invalid = false
      local comp = {}
      for entity_id, components in pairs(World.components[requires[1]]) do

        invalid = false
        repeat
          for j=1, #self.requires do
            comp = World.components[requires[j]][entity_id]
            if comp == nil or comp:is_enable() == false then
              invalid = true
              break
            end
          end
        until true
        if invalid == true then

        else
          self:core_update(World, dt,entity_id)
          table.insert(self.list, entity_id)
        end


      end

    end
    function system:update(World, dt) 
        self.list = {}
        self:selection(World, self.requires, dt)
    end

    function system:draw(World) 
      
      if self.core_draw then -- Keep this line, to avoid to call many times core_draw, if not needed
        for i = 1, #self.list do
          self:core_draw(World, self.list[i])
        end
      end
    end

    function system:keypressed(key) 
      if self.core_keypressed == nil then
        return
      end
      for i = 1, #self.list do

        self:core_keypressed(key, self.list[i])
      end
    end

    function system:core_update(World, dt,entity) end
    function system:core_draw(World,entity) end
    function system:destroy( ) end

    return system
  end
}