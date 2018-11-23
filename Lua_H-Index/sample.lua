local file = io.open("\\Users\\quino0627\\Documents\\pl-h-Index\\Lua_H-Index\\users.json","r")
if ~file then
    local data = file:read("*all")
    file:close()
    print("parsing")
    print (data)
end
print("asdf?")