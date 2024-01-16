-- Use `sumneko.lua` VSCode extension to see type hints

if #arg < 2 then
    print("Usage: main.lua <lang_dir> <output_dir>")
    os.exit(1)
end

require("mock")
require("strings")

require("strict")
require("constants")
require("class")
require("tuning")

local langDir = arg[1]
local outputDir = arg[2]

local customize = require("map/customize")
local unitIndent = "    "
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

--- Convert simple lua object to json
---@param data any
---@param indentLv number
---@param inArray boolean?
function ToJson(data, indentLv, inArray)
    if type(data) == "function" or type(data) == "thread" or type(data) =="userdata" then
        print("Unsupported data: "..type(data))
        os.exit(1)
    end
    local indent = string.rep(unitIndent, indentLv)
    
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
        return indent.."\""..data.."\""
    end
    
    local contents = {}
    if data[1] ~= nil then
        for _, value in ipairs(data) do
            contents[#contents+1] = ToJson(value, indentLv+1, true)
        end
        return "[\n"..table.concat(contents, ",\n").."\n"..indent.."]"
    end

    for key, value in pairs(data) do
        local keyJson = ToJson(key, indentLv+1)
        local valueJson = ""
        if type(value) == "table" then
            valueJson = ToJson(value, indentLv+1)
        else
            valueJson = ToJson(value, 0)
        end
        contents[#contents+1] = keyJson..": "..valueJson
    end
    if inArray then
        return indent.."{\n"..table.concat(contents, ",\n").."\n"..indent.."}"
    end
    return "{\n"..table.concat(contents, ",\n").."\n"..indent.."}"
end

--- 
---@param masterGroupData table result of functions GetWorld???Options???() from customize.lua
---@param initIndextLv number indent level
---@return string Json json data of a master group
function GenerateMasterGroupJson(masterGroupData, initIndextLv)
    local itemJsonList = {}             ---@type string[]
    local groupJsonList = {}            ---@type string[]
    local currentGroupID = nil          ---@type string?
    local currentGroupLabel = nil       ---@type string?

    local function startNextGroup(nextGroupID, nextGroupLabel, indentLv)
        local indent = string.rep(unitIndent, indentLv)
        local nextLvIndex = indent..unitIndent
    
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

    for _, item in ipairs(masterGroupData) do
        if item.group ~= currentGroupID then
            startNextGroup(item.group, item.grouplabel, initIndextLv+1)
        end
        itemJsonList[#itemJsonList+1] = ToJson(item, 4, true)
    end
    local indent = string.rep(unitIndent, initIndextLv)
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
---@param version string?
---@return string Json json data of target location
function GenerateClusterJson(location, isMasterWorld, langCode, version)
    local gen = customize.GetWorldGenOptions(location, isMasterWorld)
    local set = customize.GetWorldSettingsOptions(location, isMasterWorld)

    local masterGroupJsonList = {
        unitIndent.."\"worldgen_group\": "..GenerateMasterGroupJson(gen, 1),
        unitIndent.."\"worldsettings_group\": "..GenerateMasterGroupJson(set, 1),
    }

    local json = "{\n"
    if langCode ~= nil then
        json = json..unitIndent.."\"lang\": \""..langCode.."\",\n"
    end
    if version ~= nil then
        json = json..unitIndent.."\"version\": \""..version.."\",\n"
    end
    json = json..unitIndent.."\"location\": \""..location.."\",\n"
    json = json..unitIndent.."\"is_master_world\": "..tostring(isMasterWorld)..",\n"
    json = json..table.concat(masterGroupJsonList, ",\n").."\n"
    json = json.."}\n"
    return json
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

function ChangeLanguage(langDir, poFileName, langCode)
    local filePath = langDir.."/"..poFileName
    LanguageTranslator:LoadPOFile(filePath, langCode)
    TranslateStringTable(STRINGS)
end

function GenerateJsonFilesForAllLanguages()
    GenerateJsonFilesForLanguage("en")
    for _, lang in ipairs(localizations) do
        ChangeLanguage(langDir, lang.file, lang.code)
        package.loaded["map/customize"] = nil
        customize = require("map/customize")

        local langCode = lang.code
        GenerateJsonFilesForLanguage(langCode)
    end
end
GenerateJsonFilesForAllLanguages()
