if #arg == 0 then
    print("Usage: lua extract-mod-config.lua ${path_to_target_mod_dir} <lang_code> <output_dir_path>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/shell")
require("utils/file")
require("utils/string")
require("utils/json")
require("mocks/mod-config/mock")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- prepare

local targetModDirPath = arg[1]
local modInfoPath = targetModDirPath.."/modinfo.lua"

local currentDirPath = ExecuteShellCommandReturnOutput("pwd")
local outputDirPath = arg[3] or currentDirPath.."/output/modconfig"
locale = arg[2] or "en"

if not FileExists(modInfoPath, false) then
    print("Mod info not found in "..modInfoPath)
    os.exit(1)
end

if not FileExists(outputDirPath, true) then
    local ok = MakeDir(outputDirPath, false)
    if not ok then
        print("Failed to create output directory in "..outputDirPath)
        os.exit(1)
    end
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --

---escape double quotes and tabs
---@param text string
---@param alternative string
---@return string
local function escapeOrUseAlternative(text, alternative)
    assert(type(alternative) == "string")
    if text == nil or type(text) ~= "string" then
        return alternative
    end
    return text:escape("\t", "\"")
end

---get mod id from path
---@param path string path to mod directory
---@return string string mod id
local function getModIdFromPath(path)
    local lastComponent = path:getLastComponentFromPath()
    local modID = lastComponent:removePrefix("workshop-")
    return modID
end

print("\nLoad mod info from "..modInfoPath)
dofile(modInfoPath)

local modID = getModIdFromPath(targetModDirPath)
local modInfo = {
    id = modID,
    name = escapeOrUseAlternative(name, "?"),
    author = escapeOrUseAlternative(author, "?"),
    version = escapeOrUseAlternative(version, "?"),
    description = escapeOrUseAlternative(description, "?"),
    configuration_options = configuration_options or {},
}

for _, item in ipairs(modInfo.configuration_options) do
    if item.hover ~= nil then
        item.hover = escapeOrUseAlternative(item.hover, "?")
    end
    for _, option in ipairs(item.options) do
        if option.hover ~= nil then
            option.hover = escapeOrUseAlternative(option.hover, "?")
        end
    end
end

local outputFilePath = outputDirPath.."/"..locale.."."..modID..".json"
local jsonStr = ItemToJson(modInfo, 0)
WriteToFile(outputFilePath, jsonStr)

print("Completed! Output directory: "..outputDirPath)
