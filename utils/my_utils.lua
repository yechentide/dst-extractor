UnitIndent = "    "

--- Convert simple lua object to json
---@param data any
---@param indentLv number
---@param inArray boolean?
---@return string json string in json format
function ItemToJson(data, indentLv, inArray)
    if type(data) == "function" or type(data) == "thread" or type(data) =="userdata" then
        print("Unsupported data: "..type(data))
        os.exit(1)
    end
    local indent = string.rep(UnitIndent, indentLv)

    if type(data) == nil then
        return indent.."null"
    end
    if type(data) == "number" then
        return indent..data
    end
    if type(data) == "boolean" then
        return indent..tostring(data)
    end
    if type(data) == "string" then
        return indent.."\""..string.gsub(data, "\n", "\\n").."\""
    end

    local contents = {}
    if data[1] ~= nil then
        for _, value in ipairs(data) do
            contents[#contents+1] = ItemToJson(value, indentLv+1, true)
        end
        return "[\n"..table.concat(contents, ",\n").."\n"..indent.."]"
    end

    for key, value in pairs(data) do
        local keyJson = ItemToJson(key, indentLv+1)
        local valueJson = ""
        if type(value) == "table" then
            valueJson = ItemToJson(value, indentLv+1)
        else
            valueJson = ItemToJson(value, 0)
        end
        contents[#contents+1] = keyJson..": "..valueJson
    end
    if inArray then
        return indent.."{\n"..table.concat(contents, ",\n").."\n"..indent.."}"
    end
    return "{\n"..table.concat(contents, ",\n").."\n"..indent.."}"
end

function Split(text, separator)
    local sep, fields = separator or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    local tmp = string.gsub(text, pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function WriteToFile(path, jsonData)
    local output = io.open(path, "w+")
    if output == nil then
        print("Failed to open "..path)
        os.exit(1)
        return
    end
    output:write(jsonData)
    output:close()
end
