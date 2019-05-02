local Component = require("src.components.component")
local names = require("src.const").names
local common = require("src.components.common_components")

return {
  
  
  
event_controller = function(args)
  local event_controller = Component.new(names.event_controller)
  event_controller.events = {}
  event_controller.queue = {}
  for i, event in pairs(args.events) do
    assert.type(i,"string","The event must be identified by a string")
    event_controller.events[i] = {}
    for j, events_name in ipairs(event) do
      table.insert(event_controller.events[i], common.event(events_name))
    end
  end
  return event_controller
end, 
  
  
  
  
  
  
}