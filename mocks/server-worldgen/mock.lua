-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- Mock functions
-- ---------- ---------- ---------- ---------- ---------- ---------- --

BRANCH = "prod"

ModManager = {
    currentlyloadingmod = nil
}

function moderror(message, level)
    print("moderror: ", message)
end

function resolvefilepath(filepath, force_path_search, search_first_path)
    return filepath
end
