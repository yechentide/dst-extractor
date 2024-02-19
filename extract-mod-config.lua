if #arg == 0 then
    print("Usage: lua extract-mod-config.lua ${path_to_target_mod_dir} <output_dir_path> <lang_code>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/shell")
require("utils/file")
require("utils/string")
require("mocks/mod-config/mock")
local json = require("utils/json")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- prepare

local targetModDirPath = arg[1]
local modInfoPath = targetModDirPath.."/modinfo.lua"

local currentDirPath = ExecuteShellCommandReturnOutput("pwd")
local outputDirPath = arg[2] or currentDirPath.."/output/modconfig"
locale = arg[3] or "en"

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
    name = name or "?",
    author = author or "?",
    version = version or "?",
    description = description or "",
    configuration_options = configuration_options or {},
}

local outputFilePath = outputDirPath.."/"..locale.."."..modID..".json"
local jsonStr = json.EncodeCompliant(modInfo)
WriteToFile(outputFilePath, jsonStr)

print("Completed! Output directory: "..outputDirPath)
