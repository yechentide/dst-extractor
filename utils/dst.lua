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
