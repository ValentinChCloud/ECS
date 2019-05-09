local Component = require("src.components.component")







local body = {}
function body.new(args)
  xassert(type(args) == "table", string.concat,"body.new, need a table")
  local b =  Component.new("body")
  local b_meta = {__index = body}
  setmetatable(b, b_meta)


  
  b.position = args.position or {0,0,0}
  b.rotation = args.rotation or 0
  b.scale = args.scale or {1,1}
  b.normal = {1,0}
  b.off_x = 0.5
  b.off_y = 0.5

  b:rotate(b.rotation)



  return b
end


function body:rotate(angle)
  xassert(type(angle) == "number")
  self.rotation = self.rotation + angle
  if self.rotation > MATH_PI_TIMES_2  or self.rotation <- MATH_PI_TIMES_2 then
    self.rot = 0
  end

 self.normal = {math.cos(self.rotation), math.sin(self.rotation)}
end

function body:get_position()
  return self.position[1],self.position[2]

end




local color = {}
function color.new(args)
  local color = Component.new("color")
  local c_meta  = {__index = body}
  setmetatable(color, c_meta)
  
  
  color.color = args.color and xassert(args.color) or {1,1,1,1}
  
end



return {


body = body.new,
color = color.new,




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
