require("mock")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- Load global variable STRINGS
require("strings")

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- Update global variable STRINGS

local function get_file_name(lang)
  if lang == "zh" then
    return "chinese_s.po"
  end
  if lang == "ja" then
    return "japanese.po"
  end
  return "unsupported_lang.po"
end

local function split(input, char)
  if char == nil then char = "%s" end
  local array={}
  for str in string.gmatch(input, "([^"..char.."]+)") do
      table.insert(array, str)
  end
  return array
end

local function get_value_from_strings(key)
  local list = split(key, ".")
  local v = STRINGS
  for i = 2, #list, 1 do
    v = v[list[i]]
  end
  return v
end

local function set_value_to_strings(key, value)
  local list = split(key, ".")
  local k = ""
  local index = nil
  local v = STRINGS

  for i = 2, #list-1, 1 do
    k = list[i]
    index = tonumber(list[i])
    if index then
      v = v[index]
    else
      v = v[k]
    end
  end

  k = list[#list]
  index = tonumber(k)
  if index then
    v[index] = value
  else
    v[k] = value
  end
end

-- copy from scripts/translator.lua
local function join_po_file_multiline_strings(fname)
	local lines = {}
	local workline = ""
	local started = false
	for i in io.lines(fname) do
		if i:sub(1,1) == "#" then
			started = true
		end
		if started and workline:sub(-1) == '"' and i:sub(1,1)=='"' then
			workline = workline:sub(1,-2)..i:sub(2)
		else
			lines[#lines+1] = workline
			workline = i
		end
	end
	lines[#lines+1] = workline
	return lines
end

-- copy from scripts/translator.lua
local function join_po_file_multiline(fname)
	local i = 0
	local lines = join_po_file_multiline_strings(fname)
	return function()
	      i = i + 1
	      if i > #lines then return nil
	      else return lines[i] end
	end
end

local function parse_po_file_and_update_strings(lang)
  local file_path = "./languages/"..get_file_name(lang)

	local current_id = ""
	local localized_en = ""

  for line in join_po_file_multiline(file_path) do
    
    if current_id == "" then
			local _, _, id = string.find(line, "^msgctxt%s*\"(%S*)\"")
      if id then current_id = id end
    elseif localized_en == "" then
			local _, _, en = string.find(line, "^msgid%s*\"(.+)\"")
      if en then localized_en = en end
    else
			local _, _, other = string.find(line, "^msgstr%s*\"(.+)\"")
      if other then
        set_value_to_strings(current_id, other)
        current_id = ""
        localized_en = ""
      end
    end

  end
end

parse_po_file_and_update_strings("zh")

-- ---------- ---------- ---------- ---------- ---------- ---------- --

local C = require("customize")

print("========== ========== ==========\n")

local order_list = {}
for key, data in pairs(C.WORLDGEN_GROUP) do
  order_list[data.order] = key
end

local function dump_setting_option(options)
  local str = ""
  for _, option in ipairs(options) do
    str = str..option.text..":"..option.data..", "
  end
  return str
end

for _, group_key in ipairs(order_list) do
  local group_data = C.WORLDGEN_GROUP[group_key]
  print(group_data.text)

  local prefix = "    "
  for setting_key, setting_data in pairs(group_data.items) do
    local key_prefix = "STRINGS.UI.CUSTOMIZATIONSCREEN."
    local display_name = get_value_from_strings(key_prefix..string.upper(setting_key))
    print(prefix..display_name)
    
    local id = setting_key
    local default_value = setting_data.value
    local options = nil
    if setting_data.desc then
      options = setting_data.desc
    else
      options = group_data.desc
    end
    if type(options) == "function" then
      options = options(setting_data.world[1])
    end

    print(prefix..prefix.."ID: "..id)
    print(prefix..prefix.."Default Value: "..default_value)
    print(prefix..prefix.."Options: "..dump_setting_option(options))
  end
end
