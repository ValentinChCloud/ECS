
local utils = {}

function utils.get_file_extension(file_name)

  local ex = file_name:match("^.+(%..+)$")
  ex = ex:gsub("%.", "")
  return ex
end


function utils.table_length(table)
  local count  = 0
  for i,e in pairs(table) do
    count = count +1
  
  end
  return count 
end



return utils