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




PRODUCTION = false
--love.window.setMode(800,600, {fullscreen =true, fullscreentype  = "exclusive"})
function string.concat(...)
  return table.concat({...})
end






function love.load()

  require("lib.xassert")
  require("tools.require")
  require("tools.math2")
  require("tools.utils")
  vector = require("tools.vector")
  require("lib.lua-profiler-master.src.profiler")
  utils = require("src.utils")
  shader_book = require("src.shaders.light_shaders")
  --event_book = require("src.events.common_events")
  local sy = require.tree("src.systems")
  local sub_sy = require.tree("src.sub_systems")


  print(_VERSION)









  if PRODUCTION then
    require("lib.debug")
  end


  World = require("src.world")
  World:load()


  World:load_sprites("assets/sprites")


  World:load_module("sprites_renderer")

  local archetype = require("src.archetypes.common_archetypes")
  local test = {}
  table.insert(test, archetype.debug)
  table.insert(test, archetype.debug1)
--  local debug =  World:assemble(archetype.debug)
  --local debug1 =  World:assemble(archetype.debug1)
  --world_camera = World:assemble(archetype.world_camera)
  World:load_scene(test)
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





  world_camera:activate()
--]]

  local sh = require("tools.shoe_box")


end










local my_count  = 1
local f = 1
function love.update(dt)

  World:update(dt)



  if my_count == 0 then
    profilerStop()
    profilerReport("profiler.log")
    love.event.quit()
  end
  my_count = my_count +1


  f = f+dt*0.8


end

function love.draw()
  World:draw()
  if not PRODUCTION then
  love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)
end
--  love.graphics.draw(frames[math.floor(f)].sprite_sheet,frames[math.floor(f)].quad,150,150)

end





function love.keypressed(key)
  World:keypressed(key)

  if key == "escape" then
    love.event.quit()

  end


  if not PRODUCTION then

  end

end
