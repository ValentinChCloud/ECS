local Component = require("src.components.component")
local common = require("src.components.common_components")





local camera_renderer = {}

-- TODO : Pespective camera
function camera_renderer.new(args)
  xassert(type(args) == "table")
  local c = Component.new("camera_renderer")
  local c_meta = {__index = camera_renderer}
  setmetatable(c, c_meta)
  c.size = {args.size[1],args.size[2]}
  c.canva = love.graphics.newCanvas(c.size[1],c.size[2])

  c.to_draw = {}
  

  return c
end

local camera_ia = {}
function camera_ia.new(args)
  xassert(type(args) == "table")
  local c = Component.new("camera_ia")
  local c_meta = {__index = camera_ia}
  setmetatable(c, c_meta)
  c.size = {args.size[1],args.size[2]}
  c.canva = love.graphics.newCanvas(c.size[1],c.size[2])
  c.entities_to_draw = {}
  return c
end




return {

  camera_renderer = camera_renderer.new,
  camera_ia = camera_ia.new,
--[[
camera_renderer = function(args)
  local camera_renderer = Component.new("camera_renderer")
  camera_renderer.canva = love.graphics.newCanvas(800,600)
  camera_renderer.light_canva =  love.graphics.newCanvas(800,600)
  camera_renderer.lights = {}
  camera_renderer.canvas = {}
  camera_renderer.shaders = {}
  camera_renderer.zoom = 1.0
  camera_renderer.size = common.size(args.size)
  camera_renderer.follow = false
  camera_renderer.target = common.target()

  for i, shader in ipairs(args.shaders) do
    table.insert(renderer.shaders, common.shader(shader))
  end

  return camera_renderer
end
--]]



}