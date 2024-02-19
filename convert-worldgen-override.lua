if #arg == 0 then
    print("Usage: lua convert-worldgen-override.lua ${path_to_shard_dir} <output_dir_path>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/shell")
require("utils/file")
local json = require("utils/json")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- prepare

local shardDirPath = arg[1]
local overrideFilePath
local currentDirPath = ExecuteShellCommandReturnOutput("pwd")
local outputDirPath = arg[2] or currentDirPath.."/output"

if FileExists(shardDirPath.."/worldgenoverride.lua", false) then
    overrideFilePath = shardDirPath.."/worldgenoverride.lua"
elseif FileExists(shardDirPath.."/leveldataoverride.lua", false) then
    overrideFilePath = shardDirPath.."/leveldataoverride.lua"
else
    print("Worldgen override file not found in "..shardDirPath)
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

local config = dofile(overrideFilePath)
local result = {
    version = config.version or 0,
    id = config.id or "ENDLESS",
    localtion = config.location or "forest",
    playstyle = config.playstyle or "endless",
    overrides = config.overrides or {},
}
local jsonStr = json.EncodeCompliant(result)

local outputFilePath = outputDirPath.."/worldgenoverride.json"
WriteToFile(outputFilePath, jsonStr)

print("Completed! Output: "..outputFilePath)
