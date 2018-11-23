local write = io.write
function table.slice(tbl, first, last)
    local sliced = {}
  
    for i = first , last   do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

sam = {1,2,3,4,5,6,7}
a = table.slice(sam,1,3)
b = table.slice(sam,4,7)
print("\na array")
for s = 1, #a do
    write(a[s]," ")
end

print("\nb array")
for k = 1, #a do
     write(b[k]," ")
end

function quickSort(array)
    if #array < 2 then 
        return array
    end
 
    local left = 1
    local right =  #array
    local pivot = math.random( 1, #array )
    
    array[pivot], array[right] = array[right], array[pivot]
   
    for i = 1, #array do
        if array[i] > array[right] then
            array[left], array[i] = array[i], array[left]
            
            left = left + 1
        end
    end

    array[left], array[right] = array[right], array[left]



    aa = slice(array,1,left-1)
    bb = slice(array,left+1,#array)
    
    print("\ntotal array, left value = ", left)
    print("aa length :", #aa, "bb length:", #bb)
    for s = 1, #array do
        write(array[s]," ")
    end

    print("\narray aa")
    for j = 1, #aa do
        write(aa[j], " ")
    end

    print("\narray bb")
    for k = 1, #bb do
        write(bb[k], " ")
    end

    quickSort(aa)
    quickSort(bb)

    


    return array
end