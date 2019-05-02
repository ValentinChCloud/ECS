-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')
-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")


if arg[#arg] == "-debug" then require("mobdebug").start() end

-- RANDOM
--[[
if arg[#arg] == "-debug" then require("mobdebug").start() end
--local seed  = 1555479.6703509
seed = os.time()
love.math.setRandomSeed( seed)
math.randomseed(seed)

--]]





PRODUCTION = true



--love.window.setMode(800,600, {fullscreen =true, fullscreentype  = "exclusive"})
function string.concat(...)
  return table.concat({...})
end






function love.load()


SAT = require("lib.SAT")

require("lib.xassert")
require("lib.require")
require("lib.math2")
vector = require("lib.vector")
require("lib.lua-profiler-master.src.profiler")
utils = require("src.utils")
shader_book = require("src.shaders.light_shaders")
--event_book = require("src.events.common_events")
local sy = require.tree("src.systems")
local sub_sy = require.tree("src.sub_systems")


print(_VERSION)













  !if DEVELOPER_MODE  then
	require("lib.debug")
  !end


  World = require("src.world")
  World:load()
  World:load_module("common")
  World:load_module("renderer")
  --World:load_module("camera")
--[[

  World:load_system_module("camera_systems")
  World:load_system_module("physic_systems")
  World:load_system_module("keyboard_systems")
  World:load_system_module("field_of_view_systems")
  World:load_system_module("light_system")
  World:load_system_module("ia_cavern_systems")
  World:load_system_module("lighter_systems")
  World:load_system_module("common_systems")

  --profilerStart()
  local archetype = require("src.archetypes.common_archetypes")



  world_camera = World:assemble(archetype.world_camera)
  world_camera:activate()
--]]
end










local my_count  = 1
function love.update(dt)


 -- World:update(dt)



  if not PRODUCTION then
    number_of_active_entities =0
    for index, entity in pairs(World.entities) do
      if entity.active == true then
      number_of_active_entities = number_of_active_entities + 1
    end
  end




  if my_count == 0 then
    profilerStop()
    profilerReport("profiler.log")
    love.event.quit()
  end
  my_count = my_count +1

  end



end

function love.draw()
  --World:draw()

  !if DEVELOPER_MODE then
    love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
  !end
end





function love.keypressed(key)
  World:keypressed(key)

  if key == "escape" then
    love.event.quit()

  end


  if not PRODUCTION then

  end

end
