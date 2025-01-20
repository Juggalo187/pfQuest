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

if pfDB.bitclasses then
  pfDB.bitclasses[2048] = "NECROMANCER"       -- 2^11
  pfDB.bitclasses[4096] = "PYROMANCER"         -- 2^12
  pfDB.bitclasses[8192] = "CULTIST"            -- 2^13
  pfDB.bitclasses[16384] = "STARCALLER"        -- 2^14
  pfDB.bitclasses[32768] = "SUNCLERIC"         -- 2^15
  pfDB.bitclasses[65536] = "TINKER"            -- 2^16
  pfDB.bitclasses[131072] = "RUNEMASTER"       -- 2^17
  pfDB.bitclasses[262144] = "PRIMALIST"        -- 2^18
  pfDB.bitclasses[524288] = "REAPER"           -- 2^19
  pfDB.bitclasses[1048576] = "VENOMANCER"      -- 2^20
  pfDB.bitclasses[2097152] = "CHRONOMANCER"    -- 2^21
  pfDB.bitclasses[4194304] = "BLOODMAGE"       -- 2^22
  pfDB.bitclasses[8388608] = "GUARDIAN"        -- 2^23
  pfDB.bitclasses[16777216] = "STORMBRINGER"   -- 2^24
  pfDB.bitclasses[33554432] = "FELSWORN"       -- 2^25
  pfDB.bitclasses[67108864] = "BARBARIAN"       -- 2^26
  pfDB.bitclasses[134217728] = "WITCHDOCTOR"    -- 2^27
  pfDB.bitclasses[268435456] = "WITCHHUNTER"    -- 2^28
  pfDB.bitclasses[536870912] = "KNIGHTOFXOROTH" -- 2^29
  pfDB.bitclasses[1073741824] = "TEMPLAR"       -- 2^30
  pfDB.bitclasses[2147483648] = "RANGER"        -- 2^31
  pfDB.bitclasses[4294967296] = "HERO"          -- 2^32
end

-- Reload all pfQuest internal database shortcuts
pfDatabase:Reload()