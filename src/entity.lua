--- Entity, basicaly it's only a table with and id. For common use I keep a link to the components
--- in, but I think I should remove it . Remove in version 0.0.2 (bordeaux)


return {

  new = function ()
    local entity = {        
      __ids = {0, love.timer.getTime()},
      __type = "entity",
      components = {}, -- hashtable
      remove = false,
      loaded = false,
      active = true
    }
    
    function entity:destroy()
      self.remove = true
    end

    function entity:get_id()
      return self.__ids.id
    end

    return entity

  end
}