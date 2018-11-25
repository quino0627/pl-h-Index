local write = io.write --io.write을 write으로 할당하여 간편하게 사용하기 위함입니다.
math.randomseed((os.time())) --randomseed에 랜덤 값을 주어 random함수 호출 시 매번 다른 값이 나오게 합니다.
--기본 정보와 프로그램의 명세를 콘솔에 출력하는 부분입니다.
print("고려대학교 정보대학 컴퓨터학과\n2017320124 송동욱\n")
print("Input: userList.lua (JSON 을 Table으로)")
print("Output: 인풋을 Console에 출력함 ")
print("Output File : h-Index를 계산하여, h-Index가 높은 순서대로 유저를 정렬하여 출력, 또한 각 유저의 논문 피인용수를 오름차순으로 출력")

print("resultFile.txt contains a ascending list of people based on the h-index\nAlso  ascending list of Citation number per paper")
--userList.lua는 json 형식으로 저장된 변수를 파싱하여 테이블 형태로 리턴하는 객체를 작성해놓은 파일입니다.
--그 리턴된 값을 require을 이용하여 obj 변수에 담습니다.
obj = require("userList")

--obj에 접근하여 json값을 파싱한 값을 콘솔에 출력합니다.
for i = 1,#obj.users do --#은 다른 언어에서 length와 같은 기능을합니다

    print("User Name : ",obj.users[i].name)
    print("User Age : ",obj.users[i].age, "\nUser Citatation List")
    write("[ ")
    --저장하기 때문에 
    for j = 1,#obj.users[i].citationList do
        write(obj.users[i].citationList[j])
        write(" ")
        -- print w/o newline --> io.write
    end
    print("]\n")

end
--테이블이 슬라이스 기능을 지원하지 않기 때문에 슬라이스 function을 만들어 주었습니다.
function slice(tbl, first, last)
    local sliced = {}
  
    for i = first , last   do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end


--재귀함수입니다
--lua는 go 와 달리 parameter로 전달할때 단지 값을 복사하는 것이기 때문에 배열의 인덱스를 전달해 주어야 합니다.
function quickSort(array, le, ri)
    if ri-le < 1 then 
        return array
    end
 
    local left, right = le, ri --다음과 같이 선언, 할당할 수 있습니다.
    local pivot = math.random( le, ri ) --le와 ri 사이의 정수 값을 랜덤으로 반환합니다.
    
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

-- h-index를 기준으로 유저를 소팅하기 위해 새로운 변수에 obj를 할당하여 초기화합니다.
copied = obj 

--user할당합니다.
--퀵 소트 함수와 유사하기 때문에 추가적인 설명은 생략합니다.
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

--output 파일을 만드는 과정입니다.
file = io.open("LuaResultFile.txt","w+") --w+는 새로운 파일을 생성한다는 뜻입니다 +가 없으면 기존 파일에 덧붙입니다..
for i = 1,#copied.users do --file:write을 이용하여 파일에 output을 쓰는 과정입니다.
   file:write(i, "등 : ",copied.users[i].name,"이고, H-index는", copied.users[i].hindex)
    file:write("\n그의 논문 인용 정렬은 [ ")
   
    for j = 1,#copied.users[i].citationList do
        file:write(obj.users[i].citationList[j])
        file:write(" ")
        -- print w/o newline --> io.write
    end
    file:write("]\n\n")
    
end
