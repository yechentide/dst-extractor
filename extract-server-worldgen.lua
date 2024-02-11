if #arg == 0 then
    print("Usage: lua extract-server-worldgen.lua ${path_to_dst_server_dir} <output_dir_path>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/extention")
require("utils/shell")
require("utils/file")
require("utils/json")
require("utils/dst")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- define variables

local serverRootPath = arg[1]
local scriptZipPath = serverRootPath.."/data/databundles/scripts.zip"
local versionFilePath = serverRootPath.."/version.txt"

local currentDirPath = ExecuteShellCommandReturnOutput("pwd")
local outputDirPath = currentDirPath.."/output"
if #arg >= 2 then
    outputDirPath = arg[2]
end

local tmpDirPath = "/tmp/dst-extract"
local workDirPath = tmpDirPath.."/server-worldgen"

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- prepare

local function checkExecutedLocation()
    if FileExists(currentDirPath.."/extract-server-worldgen.lua", false) then
        return
    end
    print("This script must be executed from working directory")
    os.exit(1)
end

local function checkFileExistence()
    if not FileExists(serverRootPath, true) then
        print("Server root path not found in "..serverRootPath)
        os.exit(1)
    end
    if not FileExists(scriptZipPath, false) then
        print("Script zip not found in "..scriptZipPath)
        os.exit(1)
    end
end

local function makeDirectories()
    local ok = RemakeDir(outputDirPath, false)
    if not ok then
        print("Failed to create output directory in "..outputDirPath)
        os.exit(1)
    end
    print("Created output directory in "..outputDirPath)
    ok = RemakeDir(tmpDirPath, false)
    if not ok then
        print("Failed to create temporary directory in "..tmpDirPath)
        os.exit(1)
    end
    print("Created temporary directory in "..tmpDirPath)
    local _ = MakeDir(workDirPath, false)
end

local function unzipFile()
    print("\nUnzip zip file to "..tmpDirPath)
    local ok = UnzipFile(scriptZipPath, tmpDirPath, true)
    if not ok then
        print("Failed to unzip file from "..scriptZipPath.." to "..tmpDirPath)
        os.exit(1)
    end
    print("Completed!")
end

local function copyFilesFromUnzippedDir()
    local unzippedDirPath = tmpDirPath.."/scripts"
    print("\nCopy files from "..unzippedDirPath.." to "..workDirPath)

    local _ = CopyFile(unzippedDirPath.."/languages", workDirPath, true)

    local _ = MakeDir(workDirPath.."/map", true)
    local _ = CopyFile(unzippedDirPath.."/map/levels",                      workDirPath.."/map", true)
    local _ = CopyFile(unzippedDirPath.."/map/tasksets",                    workDirPath.."/map", true)
    local _ = CopyFile(unzippedDirPath.."/map/customize.lua",               workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/level.lua",                   workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/levels.lua",                  workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/locations.lua",               workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/resource_substitution.lua",   workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/settings.lua",                workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/startlocations.lua",          workDirPath.."/map", false)
    local _ = CopyFile(unzippedDirPath.."/map/tasksets.lua",                workDirPath.."/map", false)

    local _ = CopyFile(unzippedDirPath.."/constants.lua",                   workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/strings.lua",                     workDirPath, false)

    local _ = CopyFile(unzippedDirPath.."/class.lua",                       workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/strict.lua",                      workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/translator.lua",                  workDirPath, false)

    local _ = CopyFile(unzippedDirPath.."/speech_walter.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wanda.lua",                workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_warly.lua",                workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wathgrithr.lua",           workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_waxwell.lua",              workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_webber.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wendy.lua",                workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wickerbottom.lua",         workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_willow.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wilson.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_winona.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wolfgang.lua",             workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_woodie.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wormwood.lua",             workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wortox.lua",               workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wurt.lua",                 workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/speech_wx78.lua",                 workDirPath, false)

    local _ = CopyFile(unzippedDirPath.."/beefalo_clothing.lua",            workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/clothing.lua",                    workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/emote_items.lua",                 workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/item_blacklist.lua",              workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/misc_items.lua",                  workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/prefabskins.lua",                 workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/skin_strings.lua",                workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/techtree.lua",                    workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/tuning.lua",                      workDirPath, false)
    local _ = CopyFile(unzippedDirPath.."/worldsettings_overrides.lua",     workDirPath, false)
end

local function copyMockedFiles()
    local mocksDirPath = currentDirPath.."/mocks/server-worldgen"
    print("\nCopy mocked files from "..currentDirPath.." to "..workDirPath)

    local _ = CopyFile(mocksDirPath.."/map/tasks.lua",                      workDirPath.."/map", false)
    local _ = CopyFile(mocksDirPath.."/util.lua",                           workDirPath, false)
    local _ = CopyFile(mocksDirPath.."/mock.lua",                           workDirPath, false)
end

local function getServerVersion()
    local version = ReadFile(versionFilePath, true)
    if #version == 0 then
        return "0"
    end
    return version
end

checkExecutedLocation()
checkFileExistence()
makeDirectories()
unzipFile()
copyFilesFromUnzippedDir()
copyMockedFiles()
local serverVersion = getServerVersion()

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- main tasks

package.path = package.path..";"..workDirPath.."/?.lua"

require("mock")
require("strings")
require("strict")
require("constants")
require("class")
require("tuning")
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

---@param itemDataList table result of functions GetWorld???Options???() from customize.lua
---@param initIndextLv number indent level
---@return string Json json data of a master group
local function generateMasterGroupJson(itemDataList, initIndextLv)
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

    local function fixWrongDefaultValue(targetItem)
        for _, option in ipairs(targetItem.options) do
            if targetItem.default == option.data then
                return
            end
        end
        targetItem.default = targetItem.options[1].data
    end

    for _, item in ipairs(itemDataList) do
        if item.group ~= currentGroupID then
            startNextGroup(item.group, item.grouplabel, initIndextLv+1)
        end
        item.group = nil
        item.grouplabel = nil
        item.label = GetDSTLocalizedString(STRINGS, "STRINGS.UI.CUSTOMIZATIONSCREEN."..string.upper(item.name))
        fixWrongDefaultValue(item)
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
local function generateClusterJson(location, isMasterWorld, langCode)
    local gen = customize.GetWorldGenOptions(location, isMasterWorld)
    local set = customize.GetWorldSettingsOptions(location, isMasterWorld)

    local masterGroupJsonList = {
        UnitIndent.."\"worldgen_group\": "..generateMasterGroupJson(gen, 1),
        UnitIndent.."\"worldsettings_group\": "..generateMasterGroupJson(set, 1),
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

local function generateJsonFilesForLanguage(langCode)
    local variation = {
        { location = "forest", isMasterWorld = true },
        { location = "forest", isMasterWorld = false },
        { location = "cave", isMasterWorld = true },
        { location = "cave", isMasterWorld = false },
    }

    for _, v in ipairs(variation) do
        local isMasterStr = v.isMasterWorld and ".master" or ""
        local path = outputDirPath.."/"..langCode.."."..v.location..isMasterStr..".json"
        local jsonData = generateClusterJson(v.location, v.isMasterWorld, langCode)
        WriteToFile(path, jsonData)
    end
end

require("translator")

local function changeLanguage(poFileName, langCode)
    local filePath = "./languages/"..poFileName
    LanguageTranslator:LoadPOFile(filePath, langCode)
    TranslateStringTable(STRINGS)
end

local function generateJsonFilesForAllLanguages()
    generateJsonFilesForLanguage("en")
    for _, lang in ipairs(localizations) do
        changeLanguage(lang.file, lang.code)
        package.loaded["map/customize"] = nil
        customize = require("map/customize")

        local langCode = lang.code
        generateJsonFilesForLanguage(langCode)
    end
end
generateJsonFilesForAllLanguages()
