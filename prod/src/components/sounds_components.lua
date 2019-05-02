local Component = require("src.components.component")


return {
  
-- Position



sound_emitter = function(args)
  sound_emitter = Component.new("sound_emitter")
  sound_emitter.source = ""
  sound_emitter.volume = 1
  sound_emitter.pitch = 1
  return sound_emitter
end,



sound_receiver = function(args)
  sound_receiver = Component.new("sound_receiver")

  return sound_receiver
end,
  
  
}