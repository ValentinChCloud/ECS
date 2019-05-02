

return {
  
  new = function (name)
    assert.type(name, "string")
    local component = {
      __name = name,
      __type = "component",
      enabled = true,
      }


    function component:get_id()
      return self.__name
    end
    
    function component:is_enable()
      return self.enabled
    end
     
    function component:enable()
      self.enabled = true
    end
    
    function component:disable()
      self.enabled = false
    end

    return component
  end
}


