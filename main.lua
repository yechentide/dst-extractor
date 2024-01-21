-- Use `sumneko.lua` VSCode extension to see type hints

if #arg < 2 then
    print("Usage: main.lua <output_dir> <server_version>")
    os.exit(1)
end

require("my_utils")
require("mock")
require("strings")

require("strict")
require("constants")
require("class")
require("tuning")

local outputDir = arg[1]
local serverVersion = arg[2]

local customize = require("map/customize")

local localizations = {
    { file = "chinese_s.po",        code = "zh-CN" },
    { file = "chinese_t.po",        code = "zh-TW" },
    { file = "french.po",           code = "fr" },
    { file = "german.po",           code = "de" },
    { file = "italian.po",          code = "it" },
    { file = "japanese.po",         code = "ja" },
    { file = "korean.po",           code = "ko" },
    { file = "polish.po",           code = "pl" },
    { file = "portuguese_br.po",    code = "pt" },
    { file = "russian.po",          code = "ru" },
    { file = "spanish.po",          code = "es" },
    { file = "spanish_mex.po",      code = "es-MX" },
}

---@param key string key like "STRINGS.UI.CUSTOMIZATIONSCREEN.SEASON_START"
function GetLocalizedString(key)
    local localized = STRINGS
    local elems = Split(key, ".")
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

---@param itemDataList table result of functions GetWorld???Options???() from customize.lua
---@param initIndextLv number indent level
---@return string Json json data of a master group
function GenerateMasterGroupJson(itemDataList, initIndextLv)
    local itemJsonList = {}             ---@type string[]
    local groupJsonList = {}            ---@type string[]
    local currentGroupID = nil          ---@type string?
    local currentGroupLabel = nil       ---@type string?

    local function startNextGroup(nextGroupID, nextGroupLabel, indentLv)
        local indent = string.rep(UnitIndent, indentLv)
        local nextLvIndex = indent..UnitIndent

        if #itemJsonList > 0 then
            local groupJson = indent.."{\n"
            groupJson = groupJson..nextLvIndex.."\"name\": \""..currentGroupID.."\",\n"
            groupJson = groupJson..nextLvIndex.."\"label\": \""..currentGroupLabel.."\",\n"
            groupJson = groupJson..nextLvIndex.."\"items\": [\n"
            groupJson = groupJson..table.concat(itemJsonList, ",\n").."\n"
            groupJson = groupJson..nextLvIndex.."]\n"
            groupJson = groupJson..indent.."}"
            groupJsonList[#groupJsonList+1] = groupJson
        end

        currentGroupID = nextGroupID
        currentGroupLabel = nextGroupLabel
        itemJsonList = {}
    end

    for _, item in ipairs(itemDataList) do
        if item.group ~= currentGroupID then
            startNextGroup(item.group, item.grouplabel, initIndextLv+1)
        end
        item.group = nil
        item.grouplabel = nil
        item.label = GetLocalizedString("STRINGS.UI.CUSTOMIZATIONSCREEN."..string.upper(item.name))
        itemJsonList[#itemJsonList+1] = ItemToJson(item, 4, true)
    end
    local indent = string.rep(UnitIndent, initIndextLv)
    return "[\n"..table.concat(groupJsonList, ",\n").."\n"..indent.."]"
end

---@alias LocationType
---| "forest"
---| "cave"
---| "lavaarena"
---| "quagmire"

--- Generate worldgen & world settings data in json
---@param location LocationType
---@param isMasterWorld boolean
---@param langCode string?
---@return string Json json data of target location
function GenerateClusterJson(location, isMasterWorld, langCode)
    local gen = customize.GetWorldGenOptions(location, isMasterWorld)
    local set = customize.GetWorldSettingsOptions(location, isMasterWorld)

    local masterGroupJsonList = {
        UnitIndent.."\"worldgen_group\": "..GenerateMasterGroupJson(gen, 1),
        UnitIndent.."\"worldsettings_group\": "..GenerateMasterGroupJson(set, 1),
    }

    local json = "{\n"
    if serverVersion ~= nil and serverVersion ~= "" then
        json = json..UnitIndent.."\"version\": \""..serverVersion.."\",\n"
    end
    if langCode ~= nil then
        json = json..UnitIndent.."\"language\": \""..langCode.."\",\n"
    end
    json = json..UnitIndent.."\"location\": \""..location.."\",\n"
    json = json..UnitIndent.."\"is_master\": "..tostring(isMasterWorld)..",\n"
    json = json..table.concat(masterGroupJsonList, ",\n").."\n"
    json = json.."}\n"
    return json
end

function GenerateJsonFilesForLanguage(langCode)
    local variation = {
        { location = "forest", isMasterWorld = true },
        { location = "forest", isMasterWorld = false },
        { location = "cave", isMasterWorld = true },
        { location = "cave", isMasterWorld = false },
    }

    for _, v in ipairs(variation) do
        local isMasterStr = v.isMasterWorld and ".master" or ""
        local path = outputDir.."/"..langCode.."."..v.location..isMasterStr..".json"
        local jsonData = GenerateClusterJson(v.location, v.isMasterWorld, langCode)
        WriteToFile(path, jsonData)
    end
end

require("translator")

function ChangeLanguage(poFileName, langCode)
    local filePath = "./languages/"..poFileName
    LanguageTranslator:LoadPOFile(filePath, langCode)
    TranslateStringTable(STRINGS)
end

function GenerateJsonFilesForAllLanguages()
    GenerateJsonFilesForLanguage("en")
    for _, lang in ipairs(localizations) do
        ChangeLanguage(lang.file, lang.code)
        package.loaded["map/customize"] = nil
        customize = require("map/customize")

        local langCode = lang.code
        GenerateJsonFilesForLanguage(langCode)
    end
end
GenerateJsonFilesForAllLanguages()
