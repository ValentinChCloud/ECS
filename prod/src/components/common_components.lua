local Component = require("src.components.component")


return {
  
-- Position



body = function(args)
  local body = Component.new("body")
  local position = args.position or {0,0}

  body.position = args.position and xassert(args.position) or {0,0}
  body.rotation = 0
  body.scale = args.scale and xassert(args.scale) or {1,1}
  body.normal = {1,0}

  function body:rotate(angle)

    self.rotation = self.rotation + xassert(type(angle) == "number")
    if self.rot > MATH_PI_TIMES_2  or self.rot <- MATH_PI_TIMES_2 then 
      self.rot = 0
    end

   self.normal = {math.cos(self.rotation), math.sin(self.rotation)}
  end
  
  body:rotate(args.rotation)
  
  
  return body
end,


 -- No comment
 -- Got modifier
color = function(args)
  local color = Component.new(names.color)
  
  for i, p_color in pairs(args) do
    assert.int(p_color)
    color[i] = p_color
  end
  --local c = p_color or {}
  --color.color = struct.color(unpack(c))

  return color
end,

color_filter = function(color)
  local color_filter = Component.new(names.color_filter)
  local col = color or {}
  color_filter.color = struct.color( unpack( col ) )
  return color_filter
end,

-- require : nothing
event_controller = function(args)
  local event_controller = Component.new(names.event_controller)
  event_controller.events = {}
  
  for i, event in pairs(args.events) do
    assert.type(i,"string","The event must be identified by a string")
    event_controller.events[i] = {}
    for j, events_name in ipairs(event) do
      table.insert(event_controller.events[i], common.event(events_name))
    end
  end
    
  
  
  return event_controller
end,




event = function (args)
  assert.type(args.name, "string",1)
  assert(event_book[args.name], " ERROR : the event provide doesn't exists : "..args.name)
  local event = Component.new(names.event)
  event.name = args.name
  
  return event
end,


tag = function (args)
  local tag = Component.new(names.tag)
  tag.tag = assert.type(args.tag, "string")
  return tag
end,
  
target = function(args)
  local target = Component.new("target")
  if args == nil then
    args = {}
  end
  target.entity_id = args.entity_id and xassert(World.entities[args.entity_id]) or 0
  
  return target
end,
    
   
   


}