if #arg == 0 then
    print("Usage: lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir} <output_dir_path>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/string")
require("utils/shell")
require("utils/file")
require("utils/dst")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- define variables

local serverRootPath = arg[1]
local scriptZipPath = serverRootPath.."/data/databundles/scripts.zip"
local versionFilePath = serverRootPath.."/version.txt"

local currentDirPath = ExecuteShellCommandReturnOutput("pwd")
local outputDirPath = arg[2] or currentDirPath.."/output/worldgen"

local tmpDirPath = "/tmp/dst-extract"
local workDirPath = tmpDirPath.."/worldgen-vanilla"

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- prepare

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
    local mocksDirPath = currentDirPath.."/mocks/worldgen-vanilla"
    print("\nCopy mocked files from "..currentDirPath.." to "..workDirPath)

    local _ = CopyFile(mocksDirPath.."/map/tasks.lua",                      workDirPath.."/map", false)
    local _ = CopyFile(mocksDirPath.."/util.lua",                           workDirPath, false)
end

local function getServerVersion()
    local version = ReadFile(versionFilePath, true)
    if #version == 0 then
        return "0"
    end
    return version
end

checkFileExistence()
makeDirectories()
unzipFile()
copyFilesFromUnzippedDir()
copyMockedFiles()
local serverVersion = getServerVersion()

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- main tasks

require("utils/worldgen")
require("mocks/platform")
require("mocks/worldgen-vanilla/mock")
local json = require("utils/json")

package.path = package.path..";"..workDirPath.."/?.lua"

require("strings")
require("strict")
require("constants")
require("class")
require("tuning")
require("translator")
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
local function generateJsonString(location, isMasterWorld, langCode)
    local jsonObj = {}
    if serverVersion ~= nil and serverVersion ~= "" then
        jsonObj.version = serverVersion
    end
    if langCode ~= nil then
        jsonObj.language = langCode
    end
    jsonObj.location = location
    jsonObj.is_master = isMasterWorld

    local gen = customize.GetWorldGenOptions(location, isMasterWorld)
    local set = customize.GetWorldSettingsOptions(location, isMasterWorld)
    jsonObj.worldgen_group = GenerateMasterGroupJsonObject(gen)
    jsonObj.worldsettings_group = GenerateMasterGroupJsonObject(set)

    return json.EncodeCompliant(jsonObj)
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
        local jsonStr = generateJsonString(v.location, v.isMasterWorld, langCode)
        WriteToFile(path, jsonStr)
    end
end

generateJsonFilesForLanguage("en")
for _, lang in ipairs(localizations) do
    local filePath = workDirPath.."/languages/"..lang.file
    LanguageTranslator:LoadPOFile(filePath, lang.code)
    TranslateStringTable(STRINGS)

    package.loaded["map/customize"] = nil
    customize = require("map/customize")

    local langCode = lang.code
    generateJsonFilesForLanguage(langCode)
end

print("Completed! Output directory: "..outputDirPath)
