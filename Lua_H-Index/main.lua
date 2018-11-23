local write = io.write
math.randomseed((os.time()))
print("고려대학교 정보대학 컴퓨터학과\n2017320124 송동욱\n")
print("Input: userList.lua (JSON 을 Table으로)")
print("Output: 인풋을 Console에 출력함 ")
print("Output File : h-Index를 계산하여, h-Index가 높은 순서대로 유저를 정렬하여 출력, 또한 각 유저의 논문 피인용수를 오름차순으로 출력")

print("resultFile.txt contains a ascending list of people based on the h-index\nAlso  ascending list of Citation number per paper")

obj = require("userList")
-- for i = 1,#obj.users do
--     print(i)
--     print(obj.users[i].name)
--     print(obj.users[i].age)
        
-- end

for i = 1,#obj.users do
    print("User Name : ",obj.users[i].name)
    print("User Age : ",obj.users[i].age, "\nUser Citatation List")
    write("[ ")
    for j = 1,#obj.users[i].citationList do
        write(obj.users[i].citationList[j])
        write(" ")
        -- print w/o newline --> io.write
    end
    print("]\n")
end

function slice(tbl, first, last)
    local sliced = {}
  
    for i = first , last   do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end



function quickSort(array, le, ri)
    if ri-le < 1 then 
        return array
    end
 
    local left = le
    local right =  ri
    local pivot = math.random( le, ri )
    
    array[pivot], array[right] = array[right], array[pivot]
   
    for i = le, ri do
        if array[i] > array[right] then
            array[left], array[i] = array[i], array[left]
            
            left = left + 1
        end
    end

    array[left], array[right] = array[right], array[left]



    quickSort(array, 1, left-1)
    quickSort(array, left +1, ri)

    --Go 와 다르게 Lua의 slice는 단지 새로운 복사본을 생성하는 것일 뿐
    --Go의 Slice는 reference를 참조하기 때문에 동작하는 것
    -- 그래서 추가적인 매개 변수를 통하여 범위를 전달, array에 직접 접근하여야 ㅁ

    return array
end

--get h-index, output data
function getHIndex(array)
    sortedTable = quickSort(array.citationList, 1, #array.citationList)
    len = #sortedTable
    for j=0, #sortedTable-1 do
        if sortedTable[j+1] < j+1 then
            return j
        end
    end
end

for i=1,#obj.users do
    obj.users[i].hindex = getHIndex(obj.users[i])
end

-- for n in pairs(obj.users) do
--      table.insert(sample, )
-- end

copied = obj

function quickSortUser(le, ri)
    if ri-le < 1 then 
        return nil
    end
 
    local left = le
    local right =  ri
    local pivot = math.random( le, ri )
    
    copied.users[pivot], copied.users[right] = copied.users[right], copied.users[pivot]
   
    for i = le, ri do
        if copied.users[i].hindex > copied.users[right].hindex then
            copied.users[left], copied.users[i] = copied.users[i],copied.users[left]
            
            left = left + 1
        end
    end

    copied.users[left], copied.users[right] = copied.users[right], copied.users[left]



    quickSortUser(1, left-1)
    quickSortUser(left +1, ri)

    return copied
end

quickSortUser(1,#copied.users)


file = io.open("LuaResultFile.txt","w+")
for i = 1,#copied.users do
   file:write(i, "등 : ",copied.users[i].name,"이고, H-index는", copied.users[i].hindex)
    file:write("\n그의 논문 인용 정렬은 [ ")
   
    for j = 1,#copied.users[i].citationList do
        file:write(obj.users[i].citationList[j])
        file:write(" ")
        -- print w/o newline --> io.write
    end
    file:write("]\n\n")
    
end
