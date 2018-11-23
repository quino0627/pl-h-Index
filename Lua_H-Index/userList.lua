-- JSON = assert(loadfile "JSON.lua")()
local json = require("dkjson")

local str = [[
    {
        "users": [
          { "name": "Alice", "age": 26, "citationList": [3, 0, 6, 1, 5] },
          {
            "name": "Aria",
            "age": 34,
            "citationList": [2, 5, 3, 4, 6, 2, 3, 15, 26, 71, 12, 12, 133, 14]
          },
          {
            "name": "Bess",
            "age": 19,
            "citationList": [3, 10, 9, 3, 14, 9, 9, 10, 18, 2]
          },
          {
            "name": "Carmen",
            "age": 47,
            "citationList": [14, 1, 5, 5, 13, 3, 15, 5, 6, 9]
          },
          {
            "name": "Daisy",
            "age": 25,
            "citationList": [6, 4, 7, 10, 3, 8, 18, 2, 19, 5, 17, 17, 13, 7, 1]
          },
          {
            "name": "Elin",
            "age": 22,
            "citationList": [14, 19, 10, 15, 15, 13, 1, 5, 17, 4, 14, 10, 4, 6, 7]
          },
          {
            "name": "Emma",
            "age": 37,
            "citationList": [5, 4, 4, 17, 16, 2, 8, 4, 19, 17, 17, 13, 19, 5, 5, 14]
          },
          {
            "name": "Eva",
            "age": 50,
            "citationList": [16, 9, 2, 15, 11, 17, 10, 13, 17, 19, 7, 17, 9, 13, 14]
          },
          {
            "name": "Gloria",
            "age": 24,
            "citationList": [16, 4, 3, 15, 10, 2, 17, 11, 12, 9, 1, 1]
          },
          {
            "name": "Liam",
            "age": 29,
            "citationList": [9, 2, 19, 11, 1, 20, 17, 13, 20, 10, 6, 2]
          },
          {
            "name": "Noah",
            "age": 34,
            "citationList": [6, 10, 3, 17, 15, 16, 12, 12, 9, 7, 5, 1]
          },
          {
            "name": "Mason",
            "age": 52,
            "citationList": [1, 18, 18, 12, 18, 20, 4, 11, 14, 15]
          },
          { "name": "Daisy", "age": 49, "citationList": [4, 8, 11, 8, 17, 2] },
          {
            "name": "Lucas",
            "age": 56,
            "citationList": [12, 5, 8, 3, 10, 2, 14, 2, 20, 7, 15, 7]
          },
          {
            "name": "Oliver",
            "age": 20,
            "citationList": [9, 12, 4, 1, 4, 10, 11, 17]
          }
        ]
      }
      
]]

local obj, pos, err = json.decode ( str, 1, nil)
if err then
    print("Error:", err)
else
    print("Successfully Opened userList.lua")
    print("Json to Table, obj is table type\n")
end

return obj