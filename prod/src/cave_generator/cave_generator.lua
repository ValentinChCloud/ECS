


local cave_generator = {}
  

function cave_generator.ini_map(number_line, number_col, chance_to_born)
  local new_map = {}
  new_map.size = {number_line, number_col}
  new_map.tiles = {}
  local tiles = new_map.tiles
  local proba = 0
  for i=1, number_line do
    tiles[i] = {}
    for j=1, number_col do
      proba = math.random()

      if proba < chance_to_born then
        tiles[i][j] = 1
      else
        tiles[i][j] = 0
      end
    end
  end


  return new_map
end

function cave_generator:creuse_le_milieu(map)
  local x2,y2= math.ceil(map.size[1]/2), math.ceil(map.size[2]/2)
  local moit = math.floor(map.size[1]/4)
  local moit2 = math.floor(map.size[1]/4)
  local new_map = map -- lol

  for i=1, map.size[1] do
    new_map.tiles[i][moit] =0

    new_map.tiles[i][x2] =0
    new_map.tiles[i][map.size[2]-moit] =0
  end
  
    for i=1, map.size[2] do
     new_map.tiles[moit][i] =0
    new_map.tiles[x2][i] =0
    new_map.tiles[map.size[2]-moit][i] =0
  end
  
  for i =-1, 1 do
    for j=-1,1 do
       new_map.tiles[x2-i][y2-j] =0
      
    end
  end
--[[
 local x3,y3 = math.floor(x2/2),math.floor(y2/2)
 
 
   for i=1, map.size[1] do
    new_map.tiles[i][x3] =0
    new_map.tiles[i][x2 +x3] =0
  end
  
    for i=1, map.size[2] do
    new_map.tiles[y3][i] =0
    new_map.tiles[y2+y3][i] =0
  end
--]]
 --[[
  local x4,y4 = math.floor(x2/4),math.floor(y2/4)
 
 
   for i=1, map.size[1] do
    new_map.tiles[i][x4] =0
    new_map.tiles[i][x2 +x4] =0
  end
  
    for i=1, map.size[2] do
    new_map.tiles[y4][i] =0
    new_map.tiles[y2+y4][i] =0
  end
--]]
  
  return new_map
end

function cave_generator.count_alive_neighbours(map, x,y)
  local count = 0
  local neighbour_x = 0
  local neighbour_y = 0
  local size_map = map.size
  for i = -1 , 1  do
    for j= -1, 1 do
      repeat
        neighbour_x = x + i
        neighbour_y = y + j


        if i == 0 and j == 0 then
          break
        end

        if neighbour_x < 1 or neighbour_y < 1  or neighbour_x > size_map[1] or neighbour_y > size_map[2] then

          count = count + 1
          break
        end
        if map.tiles[neighbour_x][neighbour_y] == 1 then
          count = count +1
        end
      until true
    end
  end

  return count

end




function cave_generator.simulation_step(old_map, death_limit, birth_limit)
  local new_map = {}
  new_map.size = old_map.size
  new_map.tiles = {}
  local count = 0
  for i = 1, old_map.size[1] do
    
    new_map.tiles[i] = {}
    for j = 1 , old_map.size[2] do
      if i == 9 and j == 9 then
       
      end
      count = cave_generator.count_alive_neighbours(old_map, i, j)

      if old_map.tiles[i][j] == 1 then
        if count <  death_limit then
          new_map.tiles[i][j] = 0 

        else
          new_map.tiles[i][j] = 1 

        end
      else
        if count > birth_limit then

          new_map.tiles[i][j] = 1
        else
          new_map.tiles[i][j] = 0 

        end




      end


    end
  end

  return new_map
end


return cave_generator
-- EXAMPLE
--[[

function love.load()
  map = ini_map(100,100,0.8)



end


function love.update()



end


step = 0

function love.draw()
  for i=1, #map.tiles do
    for j=1, #map.tiles[i] do
      if map.tiles[i][j] == 1 then
        love.graphics.setColor(25/255,25/255,200/225,1)
      end
      
      love.graphics.rectangle("fill",i+(i *5), j +(j*5),5,5)

      love.graphics.setColor(1,1,1,1)
    end
  end

  love.graphics.print("Step :"..tostring(step), 700,10)
love.graphics.print("taille : 100 x 100", 700,40)
end


function love.keypressed(key)
  if key == "i" then
    for i= 1, 1 do
      step = step +i
      map = cave_simulation_step( map,6,6)
    end
    
  end
  
  
end
--]]
