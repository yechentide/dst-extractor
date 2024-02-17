-----------------------------------------------------------------------------
-- JSON4Lua: JSON encoding / decoding support for the Lua language.
-- json Module.
-- Author: Craig Mason-Jones
-- Homepage: http://json.luaforge.net/
-- Version: 0.9.40
-- This module is released under the MIT License (MIT).
-- Please see LICENCE.txt for details.
--
-- USAGE:
-- This module exposes two functions:
--   encode(o)
--     Returns the table / string / boolean / number / nil / json.null value as a JSON-encoded string.
--   decode(json_string)
--     Returns a Lua object populated with the data encoded in the JSON string json_string.
--
-- REQUIREMENTS:
--   compat-5.1 if using Lua 5.0
--
-- CHANGELOG
--   0.9.20 Introduction of local Lua functions for private functions (removed _ function prefix).
--          Fixed Lua 5.1 compatibility issues.
--   		Introduced json.null to have null values in associative arrays.
--          encode() performance improvement (more than 50%) through table.concat rather than ..
--          Introduced decode ability to ignore /**/ comments in the JSON string.
--   0.9.10 Fix to array encoding / decoding to correctly manage nil/null values in arrays.

--[[

    The MIT License

    Copyright (c) 2009 Craig Mason-Jones

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

--]]

-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Imports and dependencies
-----------------------------------------------------------------------------
local math = require('math')
local string = require("string")
local table = require("table")

_G.tracked_assert = _G.assert

local base = _G
-----------------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------------
module("json")

-- Public functions

-- Private functions
-- local decode_scanArray
-- local decode_scanComment
-- local decode_scanConstant
-- local decode_scanNumber
-- local decode_scanObject
-- local decode_scanString
-- local decode_scanWhitespace
-- local encodeString
-- local isArray
-- local isEncodable

-----------------------------------------------------------------------------
-- PUBLIC FUNCTIONS
-----------------------------------------------------------------------------

--- Encodes a string to be JSON-compliant, only use in encode_compliant(v).
local function encodeStringCompliant(s)
  s = string.gsub(s,'\\','\\\\')
  s = string.gsub(s,'"','\\"')
  --s = string.gsub(s,"'","\\'") -- json standards do not support escaping single quotes
  s = string.gsub(s,'\n','\\n')
  s = string.gsub(s,'\t','\\t')
  s = string.gsub(s,'\r','\\r')
  return s
end

-- Use this function only if you are sending data out to a web service or some other external system. The game will not be able to decode this data.
-- The supplied encodeString/decodeString function does not produce valid json files. This is okay for the save/load system but not when sending data out to the internet.
-- NOTE: Never add decode support from encode_compliant's returned string. This output may change without warning if new bugs in the original code are found.
function EncodeCompliant(v)
  -- Handle nil values
  if v==nil then
    return "null"
  end

  local vtype = base.type(v)

  -- Handle strings
  if vtype=='string' then
    return '"' .. encodeStringCompliant(v) .. '"'	    -- Need to handle encoding in string
  end

  -- Handle booleans
  if vtype=='number' or vtype=='boolean' then
    return base.tostring(v)
  end

  -- Handle tables
  if vtype=='table' then
    local rval = {}
    -- Consider arrays separately
    local bArray, maxCount = isArray(v)
    if bArray then
      for i = 1,maxCount do
        table.insert(rval, EncodeCompliant(v[i]))
      end
    else	-- An object, not an array
      for i,j in base.pairs(v) do
        if isEncodable(i) and isEncodable(j) then
          table.insert(rval, '"' .. encodeStringCompliant(i) .. '":' .. EncodeCompliant(j))
        end
      end
    end
    if bArray then
      return '[' .. table.concat(rval,',') ..']'
    else
      return '{' .. table.concat(rval,',') .. '}'
    end
  end

  -- Handle null values
  if vtype=='function' and v== nil then
    return 'null'
  end

  if not (false) then
    base.tracked_assert(false,'encode_compliant attempt to encode unsupported type ' .. vtype .. ':' .. base.tostring(v))
  end
end

--- Encodes a string to be JSON-compatible.
-- This just involves back-quoting inverted commas, back-quotes and newlines, I think ;-)
-- @param s The string to return as a JSON encoded (i.e. backquoted string)
-- @return The string appropriately escaped.
-- function encodeString(s)
--   s = string.gsub(s,'\\','\\\\')
--   s = string.gsub(s,'"','\\"')
--   s = string.gsub(s,"'","\\'")
--   s = string.gsub(s,'\n','\\n')
--   s = string.gsub(s,'\t','\\t')
--   s = string.gsub(s,'\r','\\r')
--   return s
-- end

-- Determines whether the given Lua type is an array or a table / dictionary.
-- We consider any table an array if it has indexes 1..n for its n items, and no
-- other data in the table.
-- I think this method is currently a little 'flaky', but can't think of a good way around it yet...
-- @param t The table to evaluate as an array
-- @return boolean, number True if the table can be represented as an array, false otherwise. If true,
-- the second returned value is the maximum
-- number of indexed elements in the array.
function isArray(t)
  -- Next we count all the elements, ensuring that any non-indexed elements are not-encodable
  -- (with the possible exception of 'n')
  local maxIndex = 0
  for k,v in base.pairs(t) do
    if (base.type(k)=='number' and math.floor(k)==k and 1<=k) then	-- k,v is an indexed pair
      if (not isEncodable(v)) then return false end	-- All array elements must be encodable
      maxIndex = math.max(maxIndex,k)
    else
      if (k=='n') then
        if v ~= #t then return false end  -- False if n does not hold the number of elements
      else -- Else of (k=='n')
        if isEncodable(v) then return false end
      end  -- End of (k~='n')
    end -- End of k,v not an indexed pair
  end  -- End of loop across all pairs
  return true, maxIndex
end

--- Determines whether the given Lua object / table / variable can be JSON encoded. The only
-- types that are JSON encodable are: string, boolean, number, nil, table and json.null.
-- In this implementation, all other types are ignored.
-- @param o The object to examine.
-- @return boolean True if the object should be JSON encoded, false if it should be ignored.
function isEncodable(o)
  local t = base.type(o)
  return (t=='string' or t=='boolean' or t=='number' or t=='nil' or t=='table') or (t=='function' and o== nil)
end

return {
  EncodeCompliant = EncodeCompliant
}
