---get localized string from global string table
---@param globalStringTable table STRINGS from scripts/strings.lua
---@param key string the key looks like "STRINGS.UI.CUSTOMIZATIONSCREEN.SEASON_START"
function GetDSTLocalizedString(globalStringTable, key)
    local localized = globalStringTable
    local elems = key:split(".")
    for _, elem in ipairs(elems) do
        if elem ~= "STRINGS" then
            localized = localized[elem]
        end
    end
    if type(localized) == "string" then
        return localized
    end
    return ""
end

---get mod id from path
---@param path string path to mod directory
---@return string string mod id
function GetModIdFromPath(path)
    local lastComp = ""
    local i = path:match(".+()/")
    if i then
        lastComp = path:sub(i + 1)
    else
        lastComp = path
    end
    local modID = lastComp:gsub("workshop%-", "")
    return modID
end
