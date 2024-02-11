---find if a string contains another string
---@param str string string
---@param subStr string sub string
---@param startIdx number? start index
---@return boolean true if contains
function string.contains(str, subStr, startIdx)
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
    local sep, fields = separator or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    local _ = str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end
