








local World = {
  entities = {},
  singletons = {}, -- Ok these entities are special enttiers. They must be accessible b y every system at ant time. Like camera
  components = {},
  pool_components = {},
  modules = {},
  loaded_components_modules = {},

  loaded_systems_modules = {},
  loaded_subsystems_modules = {},
  systems = {},
  sub_systems = {},
  free_id = {},
}

local entity_module = {
  
activate = function(entity_id)
  local entity = self.entities[entity_id]
    entity.active = true
    
    for index, component in pairs(self.components) do
      if component[entity_id] then
        component:enable()
      end
    end
  end,
  
  
deactivate = function(entity_id)
  local entity = self.entities[entity_id]
      entity.active = false
    
    for index, component in pairs(self.components) do
      if component[entity_id] then
        component:disable()
      end
    end
  end,
  
  
}





function World:add_component(entity_id, component)
  xassert(type(entity_id) == "number", string.concat, "Add components, entity_id is not a number : ",entity_id, component.__name)

  assert(component, "No component given to add_component")
  assert(self.components[component.__name], "component.__id: ".. component.__name.. " does not exists")

  local entity = World.entities[entity_id]

  if entity:get_component(component.__name) ~= nil then
    entity:del_component(component:get_id())    
  end

  self.components[component.__name][entity:get_id()] = component
  entity:set_component(component)
end



function World:m_del_component(entity, comp_id_array)
  for i, id in ipairs(comp_id_array) do
    self:del_component(entity, id)
  end
end


function World:get_component(id_entity , id_component)
  assert(World.components[id_component][id_entity], " Get_component didn't found anything")
  return World.components[id_component][id_entity]
end



--- Call a sub_system
-- @param name sub_system's name
-- @return sub_system or nil

function World:call_sub_system(name)
  local sub_system = World.sub_systems[name]

  if sub_system == nil then
    -- print("The sub_system",name,"not implemented")
    return nil
  end

  return sub_system

end




function World:register_system(system_function)
  assert.type(system_function,"function")

  local new_system = system_function()
    for i = 1, #new_system.requires do
      assert.type(new_system.requires[i], "string")
      if self.pool_components[new_system.requires[i]] == nil then
        error("ERROR: system '"..new_system.__name.." , the require '"..new_system.requires[i].. "' doesn't exists in the database of World")
      end
    end


    new_system.__id = #self.systems +1
    for i, system in ipairs(self.systems) do
      if new_system.__priority > system.__priority then
      elseif new_system.__priority < system.__priority then
        table.insert(self.systems,i, new_system)
        return new_system
      end
    end

    table.insert(self.systems, new_system)
    return new_system
  end










  function World:register_sub_system(sub_system)
    local new_subsystem = sub_system()
    World.sub_systems[new_subsystem.__name] = new_subsystem
    return new_subsystem
  end

  function World:add_entity( entity )
    assert(entity ,"__ids is empty")

    if #self.free_id == 0 then
      self.entities[#self.entities +1] =  entity
      entity.__ids.id = #self.entities
    else
      entity.__ids.id = self.free_id[#self.free_id]
      table.remove(self.free_id, #self.free_id)
      self.entities[entity:get_id()] = entity
    end

    return entity
  end

--- Get all the entities with the requires
-- @param requires table of components names needed

-- @return : table, list of entities matched with the requires
  function World:get_all_with(requires, only_enabled)

    assert.type(requires,"table", "Need a table of tables of requires")
    assert.type(only_enabled,"boolean", "Need a table of tables of requires")

    local matched = {}
    local invalid = false
    local comp =  {}
    for i,component in pairs(World.components[requires[1]]) do
      repeat
        if World.entities[i].active == false  and only_enabled == true then
          invalid = true
          break
        end
        invalid = false
        for j=1, #requires do
          comp = World.components[requires[j]][i]
          if comp == nil then
            invalid = true
            break
          end
          if only_enabled then
            if comp:is_enable() == false then

              invalid = true
              break
            end
          end
        end
      until true
      if invalid == true then
      else
        table.insert(matched, World.entities[i])
      end
    end



    return matched
  end

--- Similar to get_all_with, but you can pass multiple different requires combinaison

  function World:get_all_with_multiple(requires, only_enabled)
    local matched = {}
    local only_enabled = only_enabled or false
    local temp_matched
    for i=1, #requires do
      temp_matched = self:get_all_with(requires[i], only_enabled)
      for j =1, #temp_matched do
        table.insert(matched, temp_matched[i])
      end
    end
    return matched
  end




  function World:get_entity( ent_id)
    return World.entities[ent_id]
  end

-- Create all the tables to store components
  function World:load()
    Entity = require "src.entity"
    World.entity_module = entity_module
    require("lib.string")
    names = {}
  end


  function World:load_module( filename)
    xassert(filename, string.concat, "Need a path, in World:load_system ",filename)
    if self.modules[filename] == true then
      print("The module ",filename," is already loaded")
      return true
    end
    local module = require("src.systems."..filename.."_systems")
    print("Loading :",filename,"systems")
    print("------------------")
    for i=1,#module.requires do 
      if self.modules[module.requires[i]] ~= true then
        print("The module ", module.requires[i], " is necessary for systems", filename)

        self:load_module(module.requires[i])
      end
    end
    local components = module.components
    for name,p_function in pairs(components) do
      self:register_component(name, p_function)
    end

    print("Module ",filename," ***loaded***")
    print("------------------")
    self.modules[filename] = true
  end

  function World:register_component(name , p_function)
    xassert(name)
    xassert(type(p_function) == "function")

    print("Register the component",name)
    names[name] = name
    self.pool_components[name] = p_function
    self.components[name] = {}
    print("Done",name)


  end

  function World:load_component_module(file_name)
    assert.type(file_name,"string")
    local module = require("src.components."..file_name)
    print("Loading the module",file_name)
    print("------------------")
    for name, component in pairs(module) do
      print("loading component ",name)
      print("------------------")
      self:register_component(name, component)
    end
    self.loaded_components_modules[file_name] = true
  end

  function World:load_subsystems_module(file_name)
    assert.type(file_name,"string")
    local module = require("src.sub_systems."..file_name.."_sub_systems")
    print("Loading the module",file_name)
    print("------------------")
    for name, sub_systems in pairs(module) do
      print("loading sub_systems ",name)
      print("------------------")
      self:register_sub_system( sub_systems)
    end
    self.loaded_components_modules[file_name] = true
  end




  function World:load_system_module(file_name)
    assert.type(file_name,"string")
    local module = require("src.systems."..file_name)

    print("Loading :",file_name)
    print("------------------")
    for i=1,#module.requires do 
      if World.loaded_components_modules[module.requires[i]] ~= true then
        print("the module ", module.requires[i], " is necessary for systems", file_name)

        self:load_component_module(string.concat(module.requires[i],"_components"))
      end
    end

    for i=1, #module.sub_systems do
      if World.loaded_subsystems_modules[module.sub_systems[i]] ~= true then
        print("the module ", module.sub_systems[i], " is necessary for systems", file_name)

        self:load_subsystems_module(module.sub_systems[i])
      end


    end


    for name, system in pairs(module) do
      if type(system) == "table" then
        -- The requires field
      else
        self:register_system( system)
        self.loaded_systems_modules[file_name] = true
      end




    end

  end



  function World:assemble(ent_type)
    local ent = self:create_entity()
    assert.type(ent_type, "table")

    for component_name, attributes in pairs(ent_type) do

      xassert(type(attributes) == "table")
      xassert(self.pool_components[component_name], string.concat,"Components name : ",component_name," doesn't exist")
      self:add_component(ent:get_id(), self.pool_components[component_name](attributes))
    end
    return ent
  end


--Example use
--[[
World:create_entity()
  :madd (common.body(100, 100))
  :madd(common.rectangle_component())
--]]


-- Create entity
-- Add it to the world
-- @return new_entity
  function World:create_entity()
    local entity = Entity.new()

    self:add_entity(entity)
    return entity
  end




-- The main loop
  function World:update(dt)
    self:remove_entities()
    for i, system in ipairs(self.systems) do 
      --  print(system.__name)
      system:update(self, math.clamp(dt,0,1 ))
    end
    --local ents = World:get_all_with({"sprite_renderer"})
    --self:sort_entities(ents)
  end

  function World:clean()
    self.entities = {}
    for index,components in pairs(self.components) do
      self.components[index] = {}
    end

  end


  function World:draw()
    for i, system in ipairs(self.systems) do
      system:draw()
    end
  end

  function World:keypressed(key)

    for i, system in ipairs(self.systems) do

      system:keypressed(key)
    end
  end






-- Get all the entity that have to be destroyed and free thier __id to be reused
  function World:remove_entities()
    local to_delete = {} -- List of the __id to delete
    local entities = self.entities

    for i,ent in pairs(entities) do
      if ent.remove == true then
        for i, system in ipairs(self.systems) do      
          if system:match(ent) then
            system:destroy(ent)
          end
          for i, comp in pairs(ent.components) do
            World.components[comp:get_id()][ent:get_id()] = nil
          end
        end
        table.insert(to_delete,i)
      end
    end

    if #to_delete == 0 then return true end
    local n=#entities
    local r=#to_delete

    for i=1,r do
      entities[to_delete[i]]= nil
      table.insert(self.free_id, to_delete[i])
    end

  end


  return World