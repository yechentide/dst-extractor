-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- Mock functions
-- ---------- ---------- ---------- ---------- ---------- ---------- --

BRANCH = ""

ModManager = {
    currentlyloadingmod = nil
}

function IsConsole()
  return false
end

function IsNotConsole()
    return true
end

function IsSteam()
    return true
end

function IsPS4()
    return false
end

function IsXB1()
    return false
end

function moderror(message, level)
    print("moderror: ", message)
end

function resolvefilepath(filepath, force_path_search, search_first_path)
    return filepath
end

