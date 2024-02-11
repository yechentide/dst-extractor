if #arg == 0 then
    print("Usage: lua extract-mod-config.lua ${path_to_target_mod_dir} <lang_code> <output_dir_path>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/dst")
require("utils/shell")
require("utils/file")
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
if not FileExists(currentDirPath.."/extract-mod-config.lua", false) then
    print("This script must be executed from working directory")
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
local function escapeString(text, alternative)
    if text == nil then
        return alternative
    end
    local result, _ = text:gsub("\"", "\\\"")
    result = result:gsub("\t", "")
    return result
end

print("\nLoad mod info from "..modInfoPath)
dofile(modInfoPath)

local modID = GetModIdFromPath(targetModDirPath)
local modInfo = {
    id = modID,
    name = escapeString(name, "?"),
    author = escapeString(author, "?"),
    version = escapeString(version, "?"),
    description = escapeString(description, "?"),
    configuration_options = configuration_options or {},
}

for _, item in ipairs(modInfo.configuration_options) do
    if item.hover ~= nil then
        item.hover = escapeString(item.hover, "?")
    end
    for _, option in ipairs(item.options) do
        if option.hover ~= nil then
            option.hover = escapeString(option.hover, "?")
        end
    end
end

local outputFilePath = outputDirPath.."/"..locale.."."..modID..".json"
local jsonStr = ItemToJson(modInfo, 0)
WriteToFile(outputFilePath, jsonStr)

print("Completed! Output directory: "..outputDirPath)
