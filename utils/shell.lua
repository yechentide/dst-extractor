---check if shell is available
---@return boolean true if shell is available
function IsShellAvailable()
    local isShellAvailable = os.execute()
    if isShellAvailable then
        return true
    end
    return false
end

---execute shell command
---@param hideOutput boolean true if hide output
---@param command string command
---@param ... string args
---@return boolean true if success
function ExecuteShellCommand(hideOutput, command, ...)
    assert(type(hideOutput) == "boolean")
    assert(type(command) == "string")

    local cmd = command
    for _, arg in ipairs({...}) do
        cmd = cmd.." \""..arg.."\""
    end
    if hideOutput then
        cmd = cmd.." > /dev/null 2>&1"
    end
    local exitCode = os.execute(cmd)
    if exitCode == 0 then
        return true
    end
    return false
end

---execute shell command and get the output
---@param command string command
---@param ... string args
---@return string output
function ExecuteShellCommandReturnOutput(command, ...)
    assert(type(command) == "string")

    local cmd = command.." "..table.concat({...}, " ").." 2>&1"
    local handle = assert(io.popen(cmd, 'r'))
    local output = assert(handle:read('*a'))
    handle:close()
    output = output:gsub('^[\n%s]+', '')
    output = output:gsub('[\n%s]+$', '')
    return output
end

---check if `which` command is available
---@return boolean true if `which` command is available
local function isWitchCommandAvailable()
    local output = ExecuteShellCommandReturnOutput("which")
    if output:contains("command not found") then
        return false
    end
    return true
end

---check if a shell command is available
---@param command string command
---@return boolean true if shell command is available
function IsShellCommandAvailable(command)
    assert(type(command) == "string")

    local isWhichOk = isWitchCommandAvailable()
    if command == "which" then return isWhichOk end
    if not isWhichOk then
        print("which is not available")
        return false
    end

    local result = os.execute("which "..command.." > /dev/null 2>&1")
    if result == 0 then
        return true
    end
    return false
end
