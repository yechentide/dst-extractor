---check if a file exists
---@param path string path
---@param isDir boolean? true=dir, false=file, nil=both
---@return boolean true if target exists
function FileExists(path, isDir)
    local cmd = "[ "
    if isDir == nil then
        cmd = cmd.."-e "
    elseif isDir then
        cmd = cmd.."-d "
    else
        cmd = cmd.."-f "
    end
    cmd = cmd.."\""..path.."\" ]"
    return ExecuteShellCommand(true, cmd)
end

---unzip a file
---@param zipFilePath string path of zip file
---@param destParentDirPath string path of parent directory
---@param hideOutput boolean? true if hide output
---@return boolean true if success
function UnzipFile(zipFilePath, destParentDirPath, hideOutput)
    if not FileExists(zipFilePath, false) then
        print("Zip file not found in "..zipFilePath)
        return false
    end
    if not FileExists(destParentDirPath, true) then
        print("Destination directory not found in "..destParentDirPath)
        return false
    end
    if not IsShellCommandAvailable("unzip") then
        print("unzip is not available")
        return false
    end

    local cmd = "unzip"
    if hideOutput == nil then
        hideOutput = false
    elseif hideOutput then
        cmd = cmd.." -q"
    end
    cmd = cmd.." -d \""..destParentDirPath.."\" \""..zipFilePath.."\""
    return ExecuteShellCommand(hideOutput, cmd)
end

---copy a file or directory
---@param srcFilePath string path
---@param destParentDirPath string path
---@param isDir boolean true if directory
---@param newName string? new file name
---@return boolean true if success
function CopyFile(srcFilePath, destParentDirPath, isDir, newName)
    if not FileExists(srcFilePath) then
        print("Source file not found in "..srcFilePath)
        return false
    end
    if not FileExists(destParentDirPath, true) then
        print("Destination directory not found in "..destParentDirPath)
        return false
    end

    local cmd = "cp"
    if isDir then
        cmd = cmd.." -r"
    end
    cmd = cmd.." \""..srcFilePath.."\" \""..destParentDirPath
    if newName and type(newName) == "string" and #newName > 0 then
        cmd = cmd.."/"..newName.."\""
    else
        cmd = cmd.."\""
    end
    return ExecuteShellCommand(false, cmd)
end

---remove a file or directory
---@param filePath string path
---@param isDir boolean true if directory
---@param force boolean? true if force remove
---@return boolean true if success
function RemoveFile(filePath, isDir, force)
    if not FileExists(filePath, isDir) then
        print("File not found in "..filePath)
        return true
    end

    local cmd = "rm"
    if isDir then
        cmd = cmd.." -r"
    end
    if force then
        cmd = cmd.." -f"
    end
    cmd = cmd.." \""..filePath.."\""
    return ExecuteShellCommand(false, cmd)
end

---make a directory
---@param path string path
---@param recursive boolean true if recursive
---@return boolean true if success
function MakeDir(path, recursive)
    local cmd = "mkdir"
    if recursive then
        cmd = cmd.." -p"
    end
    cmd = cmd.." \""..path.."\""
    return ExecuteShellCommand(false, cmd)
end

---remake a directory
---@param path string path
---@param force boolean? true if force remove
---@return boolean true if success
function RemakeDir(path, force)
    if FileExists(path, false) then
        print("Expect directory but found file in "..path)
        return false
    end
    if FileExists(path, true) then
        local ok = RemoveFile(path, true, force)
        if not ok then
            print("Failed to remove directory in "..path)
            return false
        end
    end
    return MakeDir(path, true)
end

---read contents from a file
---@param path string path
---@param trim boolean? true if trim
---@return string? string contents
function ReadFile(path, trim)
    local output, errMsg = io.open(path, "r")
    if output == nil then
        print(errMsg)
        return nil
    end
    local content = output:read("a")
    output:close()
    if trim then
        content = content:gsub('^[\n%s]+', '')
        content = content:gsub('[\n%s]+$', '')
    end
    return content
end

---write to a file
---@param path string path
---@param jsonStr string json
---@return boolean true if success
function WriteToFile(path, jsonStr)
    local output, errMsg01 = io.open(path, "w+")
    if output == nil then
        print(errMsg01)
        return false
    end
    local file, errMsg02 = output:write(jsonStr)
    output:close()
    if file == nil then
        print(errMsg02)
        return false
    end
    return true
end
