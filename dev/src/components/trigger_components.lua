local Component = require("src.components.component")
local names = require("src.const").names
local common = require("src.components.common_components")

return {





trigger_box = function(args)
  local trigger_box = Component.new(names.trigger_box)
  trigger_box.size = common.size(args.size)
  trigger_box.trigger_with = {} -- List of tags 
  trigger_box.queue  = {} -- List of entity collided
  trigger_box.last_queue  = {} -- List of entity collide last frame
  -- list of function to call when the event appear
  trigger_box.on_enter_events = {}
  trigger_box.on_stay_events = {}
  trigger_box.on_exit_evebts = {}
  
  for i, tag in ipairs(args.tags) do
    local tag_component = common.tag(tag) 
    table.insert(trigger_box.trigger_with, tag_component)
  end
  
  for i, event_name in ipairs(args.on_enter_events) do
    table.insert(trigger_box.on_enter_events, common.event(event_name))
  end

  
  
  return trigger_box
end,
  
  
  
  
  
  
  
  
}