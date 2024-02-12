---find if a string contains another string
---@param str string string
---@param subStr string sub string
---@param startIdx number? start index
---@return boolean true if contains
function string.contains(str, subStr, startIdx)
    assert(type(str) == "string")
    assert(type(subStr) == "string")
    assert(startIdx == nil or type(startIdx) == "number")

    local startIndex = 1
    if startIdx and type(startIdx) == "number" then
        startIndex = startIdx
    end
    return str:find(subStr, startIndex, true) ~= nil
end

---split a string
---@param str string string
---@param separator string separator
---@return string[] list of splitted elements
function string.split(str, separator)
    assert(type(str) == "string")
    assert(type(separator) == "string")

    local sep, fields = separator or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    local _ = str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

---get last component from path
---@param path string path
---@return string
function string.getLastComponentFromPath(path)
    assert(type(path) == "string")

    local i = path:match(".+()/")
    if i then
        return path:sub(i + 1)
    end
    return path
end

---remove prefix string
---@param str string
---@param prefix string
---@return string
function string.removePrefix(str, prefix)
    assert(type(str) == "string")
    assert(type(prefix) == "string")

    local p = prefix:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    local s = str:gsub("^" .. p, "")
    return s
end

---escape string
---@param str string
---@param ... string target escape chars
---@return string
function string.escape(str, ...)
    assert(type(str) == "string")

    local toChar = function (escapeChar)
        local c = ""
        if escapeChar == "\a" then c = "a"
        elseif escapeChar == "\b" then c = "b"
        elseif escapeChar == "\\" then c = "\\"
        elseif escapeChar == "\f" then c = "f"
        elseif escapeChar == "\n" then c = "n"
        elseif escapeChar == "\r" then c = "r"
        elseif escapeChar == "\t" then c = "t"
        elseif escapeChar == "\v" then c = "v"
        elseif escapeChar == "\"" then c = "\""
        elseif escapeChar == "\'" then c = "\'"
        end
        return c
    end

    local result = str
    for _, target in ipairs{...} do
        local c = toChar(target)
        result = result:gsub(target, "\\"..c)
    end
    return result
end
