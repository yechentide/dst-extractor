---@param itemDataList table result of functions GetWorld???Options???() from customize.lua
---@return table Json json data of a master group
function GenerateMasterGroupJsonObject(itemDataList)
    local groupObjList = {}
    local groupIndexMap = {}

    local function fixWrongDefaultValue(targetItem)
        for _, option in ipairs(targetItem.options) do
            if targetItem.default == option.data then
                return
            end
        end
        targetItem.default = targetItem.options[1].data
    end

    for _, item in ipairs(itemDataList) do
        local groupIndex = groupIndexMap[item.group] or #groupObjList+1
        if groupIndex == #groupObjList+1 then
            groupIndexMap[item.group] = groupIndex
            groupObjList[groupIndex] = {
                name = item.group,
                label = item.grouplabel,
                items = {},
            }
        end

        item.group = nil
        item.grouplabel = nil
        item.label = GetDSTLocalizedString(STRINGS, "STRINGS.UI.CUSTOMIZATIONSCREEN."..string.upper(item.name))
        fixWrongDefaultValue(item)
        local itemObjList = groupObjList[groupIndex].items
        itemObjList[#itemObjList+1] = item
    end

    return groupObjList
end
