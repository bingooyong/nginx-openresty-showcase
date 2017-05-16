
local P = {}

local function merge_table(a, b)
    local c = {}
    for k,v in pairs(a) do
        c[k] = v
    end
    for k,v in pairs(b) do
        c[k] = v
    end
    return c
end

local function copy_table(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copy_table(v)
        end
    end
    return tab
end


local function tobool(v)
    if not v then
        return false
    end
    return tostring(v) == "1"
end

local function check_is_local_ip(ip)
    if type(ip) ~= "string" then return false end
    -- 内网默认为10.0.0.0/8
    local i,j = string.find(ip, "^10%.")
    if i == nil and j == nil then
        return false
    end
    return true
end

local function table_is_empty(t)
    return next(t) == nil
end

local function table_is_array(t)
  if type(t) ~= "table" then return false end
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then return false end
  end
  return true
end

local function table_is_map(t)
  if type(t) ~= "table" then return false end
  for k,_ in pairs(t) do
    if type(k) == "number" then  return false end
  end
  return true
end

local function check_is_valid_ip(ip)
    if type(ip) ~= "string" then return false end
    local _, _, ipa, ipb, ipc, ipd = string.find(ip, "(%d+)%.(%d+)%.(%d+)%.(%d+)")

    if ipa and ipb and ipc and ipd then
        local ipnum = ipa*16777216 + ipb*65536 + ipc*256 + ipd
        if ipnum > 2^32 or ipnum < 0 then
            return false
        else
            return true
        end
    else
        return false
    end
end

------------------------------------------------------------------------
--                              Utils
------------------------------------------------------------------------

local function split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end


P.merge_table = merge_table
P.copy_table = copy_table
P.tobool = tobool
P.check_is_local_ip = check_is_local_ip
P.check_is_valid_ip = check_is_valid_ip
P.table_is_empty = table_is_empty
P.table_is_map = table_is_map
P.table_is_array = table_is_array
P.split = split

return P

