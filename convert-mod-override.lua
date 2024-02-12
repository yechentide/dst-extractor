if #arg == 0 then
    print("Usage: lua extract-mod-override.lua ${path_to_shard_dir} <output_dir_path>")
    os.exit(1)
end

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- import util functions

require("utils/shell")
require("utils/file")
require("utils/string")
require("utils/json")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- prepare

local shardDirPath = arg[1]
local overrideFilePath = shardDirPath.."/modoverrides.lua"
local currentDirPath = ExecuteShellCommandReturnOutput("pwd")
local outputDirPath = arg[2] or currentDirPath.."/output"

if not FileExists(overrideFilePath, false) then
    print("Mod override file not found in "..shardDirPath)
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
local jsonStr = ItemToJson(config, 0)

local outputFilePath = outputDirPath.."/modoverrides.json"
WriteToFile(outputFilePath, jsonStr)

print("Completed! Output: "..outputFilePath)
