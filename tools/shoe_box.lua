



local shoe_box = {}

function shoe_box:load_sprite_sheet(path)
  local m = require(path)  
  local sprite_sheet = love.graphics.newImage(path..".png")
  frames = m.sheetData.frames
  sprites = {}
  for i=1, #frames do
    local sprite = {}
    sprite.name = frames[i].names
    sprite.quad = love.graphics.newQuad(frames[i].x,frames[i].y, frames[i].width, frames[i].height,m.sheetData.sheetContentWidth, m.sheetData.sheetContentHeight)
    sprite.sprite_sheet =sprite_sheet
    sprite.pivot = {0.5,0.5}
    sprite.hitboxes = {}
    sprite.hurtboxes = {}
  table.insert(sprites, sprite)
  end

  return m, sprites
end






return shoe_box