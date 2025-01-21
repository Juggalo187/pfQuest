local loc = GetLocale()
local dbs = { "items", "quests", "quests-itemreq", "objects", "units", "zones", "professions", "areatrigger", "refloot" }
local noloc = { "items", "quests", "objects", "units" }

-- Patch databases to merge ascension data
local function patchtable(base, diff)
  for k, v in pairs(diff) do
    if base[k] and type(v) == "table" then
      patchtable(base[k], v)
    elseif type(v) == "string" and v == "_" then
      base[k] = nil
    else
      base[k] = v
    end
  end
end
-- fix map-id 1519 spawns [Stormwind]
for _, obj in pairs(pfDB["objects"]["data"]) do
  if obj.coords then
    for num, tbl in pairs(obj.coords) do
      if tbl[3] == 1519 then -- map
        tbl[1] = tbl[1] + 6.8 -- x
        tbl[2] = tbl[2] + 10.1 -- y
      end
    end
  end
end
-- fix map-id 1519 spawns [Stormwind]
for _, obj in pairs(pfDB["units"]["data"]) do
  if obj.coords then
    for num, tbl in pairs(obj.coords) do
      if tbl[3] == 1519 then -- map
        tbl[1] = tbl[1] + 6.8 -- x
        tbl[2] = tbl[2] + 10.1 -- y
      end
    end
  end
end
-- fix map-id 1519 spawns [Stormwind]
for _, obj in pairs(pfDB["areatrigger"]["data"]) do
  if obj.coords then
    for num, tbl in pairs(obj.coords) do
      if tbl[3] == 1519 then -- map
        tbl[1] = tbl[1] + 6.8 -- x
        tbl[2] = tbl[2] + 10.1 -- y
      end
    end
  end
end
local loc_core, loc_update
for _, db in pairs(dbs) do
  if pfDB[db]["data-ascension"] then
    patchtable(pfDB[db]["data"], pfDB[db]["data-ascension"])
  end

  for loc, _ in pairs(pfDB.locales) do
    if pfDB[db][loc] and pfDB[db][loc.."-ascension"] then
      loc_update = pfDB[db][loc.."-ascension"] or pfDB[db]["enUS-ascension"]
      patchtable(pfDB[db][loc], loc_update)
    end
  end
end

loc_core = pfDB["professions"][loc] or pfDB["professions"]["enUS"]
loc_update = pfDB["professions"][loc.."-ascension"] or pfDB["professions"]["enUS-ascension"]
if loc_update then patchtable(loc_core, loc_update) end

if pfDB["minimap-ascension"] then patchtable(pfDB["minimap"], pfDB["minimap-ascension"]) end
if pfDB["meta-ascension"] then patchtable(pfDB["meta"], pfDB["meta-ascension"]) end

-- Reload all pfQuest internal database shortcuts
pfDatabase:Reload()