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
local ok = MakeDir(outputDirPath, false)
if not ok then
    print("Failed to create output directory in "..outputDirPath)
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --

---escape double quotes
---@param text string
---@param alternative string
---@return string
local function escapeDoubleQuotes(text, alternative)
    if text == nil then
        return alternative
    end
    local result, _ = text:gsub("\"", "\\\"")
    return result
end

dofile(modInfoPath)

local modID = GetModIdFromPath(targetModDirPath)
local modInfo = {
    id = modID,
    name = escapeDoubleQuotes(name, "?"),
    author = escapeDoubleQuotes(author, "?"),
    version = escapeDoubleQuotes(version, "?"),
    description = escapeDoubleQuotes(description, "?"),
    configuration_options = configuration_options,
}

local outputFilePath = outputDirPath.."/"..locale.."."..modID..".json"
local jsonStr = ItemToJson(modInfo, 0)
WriteToFile(outputFilePath, jsonStr)

print("Completed!")
print("Output directory: "..outputDirPath)
