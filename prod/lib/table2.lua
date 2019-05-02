function table.remove_efficient(pTable,pRemove)
  local input = pTable
  local remove = pRemove

  local n=#input
  local r=#remove

  for i=1,r do
    input[remove[i]]=nil
  end

  local j=0
  for i=1,n do
    if input[i]~=nil then
      j=j+1
      input[j]=input[i]
    end
  end
  for i=j+1,n do
    input[i]=nil
  end

end
