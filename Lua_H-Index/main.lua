local write = io.write
math.randomseed((os.time()))
print("고려대학교 정보대학 컴퓨터학과\n2017320124 송동욱\n")

print("resultFile.txt contains a ascending list of people based on the h-index\n")

local obj = require("userList")
-- for i = 1,#obj.users do
--     print(i)
--     print(obj.users[i].name)
--     print(obj.users[i].age)
        
-- end

for i = 1,#obj.users do
    print("User Name : ",obj.users[i].name)
    print("\nUser Age : ",obj.users[i].age,"\n")
    write("[ ")
    for j = 1,#obj.users[i].citationList do
        write(obj.users[i].citationList[j])
        write(" ")
        -- print w/o newline --> io.write
    end
    print("]")
end

function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first , last , step  do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

b = {1,2,3,4,5}
local left, right = 0, #b-1
print("-----")
print(#table.slice(b,2,5,1))
print(table.slice(b,2,5,1)[2])
print(table.slice(b,2,5,1)[3])
print("-----")




function quickSort(array)
    if #array < 2 then 
        return array
    end
 
    local left = 1
    local right =  #array
    local pivot = math.random( 1,#array )
    array[pivot], array[right] = array[right], array[pivot]
   
    for i = 1, #array do
        if array[i] < array[right] then
            array[left], array[i] = array[i], array[left]
            
            left = left + 1
        end
    end

    array[left], array[right] = array[right],array[left]
    quickSort(table.slice(array,1,left-1,1))
    quickSort(table.slice(array,left+1,#array,1))
    return array
end

print("asdf")
for j = 1,#obj.users[3].citationList do
    write(obj.users[3].citationList[j])
    write(" ")
    -- print w/o newline --> io.write
end
print(obj.users[3].citationList)
print(#obj.users[3].citationList)
print(quickSort(obj.users[3].citationList))
for j = 1,#obj.users[3].citationList do
    write(obj.users[3].citationList[j])
    write(" ")
    -- print w/o newline --> io.write
end

