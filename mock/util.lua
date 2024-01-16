-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- All functions here are copied from scripts/util.lua
-- ---------- ---------- ---------- ---------- ---------- ---------- --

function table.contains(table, element)
    if table == nil then return false end

    for _, value in pairs(table) do
        if value == element then
          return true
        end
    end
    return false
end

function table.invert(t)
    local invt = {}
    for k, v in pairs(t) do
        invt[v] = k
    end
    return invt
end

function FunctionOrValue(func_or_val, ...)
    if type(func_or_val) == "function" then
        return func_or_val(...)
    end
    return func_or_val
end

function GetTableSize(table)
	local numItems = 0
	if table ~= nil then
		for k,v in pairs(table) do
		    numItems = numItems + 1
		end
	end
	return numItems
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function shallowcopy(orig, dest)
    local copy
    if type(orig) == 'table' then
        copy = dest or {}
        for k, v in pairs(orig) do
            copy[k] = v
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function IsTableEmpty(t)
    -- https://stackoverflow.com/a/1252776/79125
    return next(t) == nil
end

function MergeMapsDeep(...)
    local keys = {}
    for i,map in ipairs({...}) do
        for k,v in pairs(map) do
            if keys[k] == nil then
                keys[k] = type(v)
            else
                assert(keys[k] == type(v), "Attempting to merge incompatible tables.")
            end
        end
    end

    local ret = {}
    for k,t in pairs(keys) do
        if t == "table" then
            local subtables = {}
            for i,map in ipairs({...}) do
                if map[k] ~= nil then
                    table.insert(subtables, map[k])
                end
            end
            ret[k] = MergeMapsDeep(unpack(subtables))
        else
            for i,map in ipairs({...}) do
                if map[k] ~= nil then
                    ret[k] = map[k]
                end
            end
        end
    end

    return ret
end

function GetRandomItem(choices)
    local numChoices = GetTableSize(choices)

    if numChoices < 1 then
        return
    end

 	local choice = math.random(numChoices) -1

 	local picked = nil
 	for k,v in pairs(choices) do
 		picked = v
 		if choice<= 0 then
 			break
 		end
 		choice = choice -1
 	end
 	assert(picked~=nil)
	return picked
end
