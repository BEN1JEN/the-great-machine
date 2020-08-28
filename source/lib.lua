--- A better standered library V1.4
-- @module lib

--- A better print function.
-- @param ... Variadic list of lua objects to print, will be seperated with tabs.
function print(...)
  local values = {...}
  for i, value in ipairs(values) do
    local strValue = tostring(value)
    if strValue:find("^[a-z]+: 0x[0-9a-f]+") then
      if type(value) == "table" then
        io.write(table.tostring(value))
      else
        io.write(strValue)
      end
    else
      io.write(strValue)
    end
    if i == #values then
      io.write("\n")
    else
      io.write(" ")
    end
  end
end

--- A propper tostring function for tables, supports other types too.
-- @param v Value to convert to a string
-- @param tabs The indentation level to use, mostly for internal recursive use.
-- @param seen What values the function has already seen, to avoid infinite recursion, mostly for internal recursive use.
-- @param path The human-readable path that this value is located at, mostly for internal recursive use.
-- @return A string version on the input value 'v'.
function table.tostring(v, tabs, seen, path)
  if not tabs then tabs = 0 end
  if not seen then seen = t{} end
  if not path then path = "root" end
  if seen[v] then
    if type(seen[v]) == "string" then
      return tostring(v) .. " (" .. tostring(seen[v]) .. ")"
    else
      return tostring(v)
    end
  end
  if type(v) == "table" or type(v) == "userdata" then
    if path == "" then
      seen[v] = true
    else
      seen[v] = path
    end
  end
  local str = ""
  local mt = getmetatable(v)
  if type(mt) == "table" and mt.__tostring then
    str = str .. tostring(v)
  elseif type(v) == "table" then
    if #v > 0 then
      str = str .. "#" .. #v .. " "
    end
    str = str .. "{ @ " .. tostring(v):sub(8) .. "\n"
    local gotInIpairs = t{}
    local first = true
    for i, v2 in ipairs(v) do
      gotInIpairs[i] = true
      if not first then
        str = str .. ",\n"
      end
      first = false
      str = str ..
        string.rep("    ", tabs+1) ..
        table.tostring(v2, tabs+1, seen, path .. "." .. tostring(i))
    end
    for k, v2 in pairs(v) do
      if not gotInIpairs[k] then
        if not first then
          str = str .. ",\n"
        end
        first = false
        str = str ..
          string.rep("    ", tabs+1) ..
          table.tostring(k, tabs+1, seen, path .. ".key(" .. tostring(k) .. ")") ..
          ": " ..
          table.tostring(v2, tabs+1, seen, path .. "." .. tostring(k))
      end
    end
    str = str .. "\n" .. string.rep("    ", tabs) .. "}"
  elseif type(v) == "string" then
    str = str .. "\"" .. tostring(v) .. "\""
  elseif type(v) == "number" then
    if v == math.floor(v) then
      str = str .. string.format("%.0fi", math.floor(v))
    else
      str = str .. string.format("%.5ff", v)
    end
  else
    str = str .. tostring(v)
  end
  if type(v) ~= "string" and mt and mt ~= table.newTableMT then
    str = str .. " (mt: " .. table.tostring(mt, tabs, seen, path .. ".mt") .. ")"
  end
  return str
end

if (not table.unpack) or (not table.pack) then
  --- Make table.unpack exist throughout Lua versions.
  -- @function table.unpack
  -- @param t The table to unpack.
  table.unpack = unpack or table.unpack
  --- Make table.pack exist throughout Lua versions.
  -- @param ... The values to put into a table.
  function table.pack(...)
    return { ... }
  end
end

bit, bit32 = bit or bit32, bit32 or bit

if love then
  compat = {}
  local major, minor, revision, version = love.getVersion()
  local os = love.system.getOS()

  function compat.colour(r, g, b, a)
    if major > 0 then
      return r, g, b, a
    else
      return r*255, g*255, b*255, a and a*255 or nil
    end
  end

  function compat.setColour(r, g, b, a)
    love.graphics.setColor(compat.colour(r, g, b, a))
  end

  function compat.mobile()
    return os == "Android" or os == "iOS", os ~= "OS X" and os ~= "Windows" and os ~= "Linux"
  end

  local scale = 1
  function compat.sizeTo(newScale)
    scale = tonumber(newScale) or 1
  end

  function compat.guiSize(...)
    local numbers  = {...}
    for i, number in ipairs(numbers) do
      numbers[i] = number*scale
    end
    return table.unpack(numbers)
  end

  function compat.hexColour(hex)
    hex = tostring(hex)
    if hex:sub(1, 1) == "#" then
      hex = hex:sub(2, -1)
    end
    local r, g, b, a = 0, 0, 0, 1
    if #hex == 3 then
      r, g, b = tonumber(hex:sub(1, 1), 16)/15, tonumber(hex:sub(2, 2), 16)/15, tonumber(hex:sub(3, 3), 16)/15
    elseif #hex == 4 then
      r, g, b, a = tonumber(hex:sub(1, 1), 16)/15, tonumber(hex:sub(2, 2), 16)/15, tonumber(hex:sub(3, 3), 16)/15, tonumber(hex:sub(4, 4), 16)/15
    elseif #hex == 6 then
      r, g, b = tonumber(hex:sub(1, 2), 16)/255, tonumber(hex:sub(3, 4), 16)/255, tonumber(hex:sub(5, 6), 16)/255
    elseif #hex == 8 then
      r, g, b, a = tonumber(hex:sub(1, 2), 16)/255, tonumber(hex:sub(3, 4), 16)/255, tonumber(hex:sub(5, 6), 16)/255, tonumber(hex:sub(7, 8), 16)/255
    else
      error("Invalid Hex Colour: " .. hex)
    end
    if not r or not g or not b or not a then
      error("Invalid Hex Colour: " .. hex)
    end
    return compat.colour(r, g, b, a)
  end
end

table.newTableMT = {__index=table}
function table.new(content)
  return setmetatable(content or t{}, table.newTableMT)
end
_G.t = table.new

function table.indexList(tab)
  local indexList = t{}
  for index in pairs(tab) do
    table.insert(indexList, index)
  end
  return indexList
end

function table.pairsList(tab)
  local pairsList = t{}
  local gotInIpairs = t{}
  for i, v in ipairs(tab) do
    table.insert(pairsList, {i, v, ipairs=true, index=i, key=i, value=v})
    gotInIpairs[i] = true
  end
  for k, v in pairs(tab) do
    if not gotInIpairs[i] then
      table.insert(pairsList, {k, v, ipairs=false, index=k, key=k, value=v})
    end
  end
  return pairsList
end

function table.merge(a, b)
  local c = t{}
  for k, v in pairs(a) do
    c[k] = v
  end
  local gotInIpairs = t{}
  for i, v in ipairs(b) do
    gotInIpairs[i] = true
    table.insert(c, v)
  end
  for k, v in pairs(b) do
    if not gotInIpairs[i] then
      c[k] = v
    end
  end
  return c
end
table.join = table.merge
table.combine = table.merge

function table.hide(t, setFunction)
  return setmetatable(t{},{__index=function(_,idx)return t end,__newindex=function(_,k,v)setFunction(k,v)end})
end

function table.copy(src)
  if type(src) == "table" then
    local tab = t{}
    for k, v in pairs(src) do
      tab[k] = table.copy(v)
    end
    if getmetatable(src) then
      return setmetatable(tab, table.copy(getmetatable(src)))
    else
      return tab
    end
  elseif type(src) == "function" then
    return load(string.dump(src))
  elseif type(src) == "string" then
    return src .. ""
  elseif type(src) == "number" and math.floor(src) == src then
    return math.floor(src)
  elseif type(src) == "number" then
    return src+0
  elseif type(src) == "boolean" then
    return not not src
  else
    return src
  end
end

function table.map(tab, f)
  local newTable = t{}
  for k, v in pairs(tab) do
    newTable[k] = f(v)
  end
  return newTable
end
table.select = table.map

function table.filter(l, f)
  local newList = t{}
  for i, v in ipairs(l) do
    if f(v, i) then
      table.insert(newList, v)
    end
  end
  return newList
end

function table.filterTable(tab, f)
  local newTable = t{}
  for k, v in ipairs(tab) do
    if f(v, k) then
      newTable[k] = v
    end
  end
  return newTable
end

function table.constructFrom(l, f)
  local newList = t{}
  for i, v in ipairs(l) do
    local values = f(v, i)
    for _, value in ipairs(values) do
      table.insert(newList, value)
    end
  end
  return newList
end
table.selectMany = table.constructFrom

function table.aggragate(l, f, total)
  for i, v in ipairs(l) do
    total = f(total, v, i)
  end
  return total
end
table.reduce = table.aggragate

function table.aggragateTable(tab, f, total)
  for k, v in pairs(tab) do
    total = f(total, v, k)
  end
  return total
end
table.reduceTable = table.aggragateTable

function table.contains(tab, check)
  return table.aggragateTable(tab, function(seen, val) return seen or val == check end, false)
end

function table.fromList(l, f)
  local newTable = t{}
  for oldi, listv in ipairs(l) do
    local k, v = f(listv, i)
    if k and v then
      newTable[k] = v
    end
  end
  return newTable
end

function table.flip(l)
  local flipped = t{}
  for i, v in ipairs(l) do
    flipped[#l-(i-1)] = v
  end
  return flipped
end
table.reverse = table.flip

function table.pick(tab, f)
  return tab[f(tab)]
end

function table.pickList(list, f)
  return list[f(#list)]
end

-- str[i] = str:sub(i, i)
local mt = getmetatable""
local tmp = mt.__index
mt.__index = function(str, idx)if tmp[idx] then return tmp[idx] elseif tonumber(idx) then return str:sub(idx, idx) end end

-- str * num = str:rep(num)
mt.__mul = string.rep

function string.gmatchlist(str, pattern)
  local list = t{}
  for s in string.gmatch(str, pattern) do
    table.insert(list, s)
  end
  return s
end

function string.lines(str)
  return string.gmatchlist(str, "[^\n]")
end

function string.stripStart(str)
  return string.gsub(str, "^[ \t\r\n]", "")
end
string.trimStart = string.stripStart

function string.stripEnd(str)
  return string.gsub(str, "[ \t\r\n]$", "")
end
string.trimEnd = string.stripEnd

function string.strip(str)
  return string.stripEnd(string.stripStart(str))
end
string.trim = string.strip

function string.isUpper(str)
  return str == string.upper(str)
end

function string.isLower(str)
  return str == string.upper(str)
end

function math.round(f)
  return math.floor(f-0.5)
end

function math.isInteger(i)
  return math.floor(i) == i
end

function isnum(t)
  return type(t) == "number"
end

function isbool(t)
  return type(t) == "boolean"
end

function isstr(t)
  return type(t) == "string"
end

function istab(t)
  return type(t) == "table"
end

function isfunc(t)
  return type(t) == "function"
end

function isnil(t)
  return t == nil
end

function TODO(...)
  if LOG_TODOS then
    print("TODO:", ...)
  end
end
