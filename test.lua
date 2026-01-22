-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Modules
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local InventoryDB = require(ReplicatedStorage.ClientDB.Inventory.InventoryDB)

-- Constants
local UPDATE_INTERVAL = 120 -- seconds
local ENDPOINT_URL = "https://api-am.yummydata.click/am"

-- User configuration
local USER_CONFIG = {
    username = "Sepleormeq",
    user_id = "7150eda6-481e-487d-9a47-0bfbad1d3d43",
    discord_id = "541529117959651328",
    note = "Pc"
}

-- Pet releaser points lookup table
-- type: {rarity: {petType: {age: points}}}
local PET_RELEASER_INFO = {
    common = {
        normal = {90, 100, 150, 200, 300, 500},
        neon = {2090, 2100, 2150, 2200, 2300, 2500},
        mega_neon = 10100
    },
    uncommon = {
        normal = {112, 125, 187, 250, 375, 625},
        neon = {2612, 2625, 2687, 2750, 2875, 3125},
        mega_neon = 12625
    },
    rare = {
        normal = {135, 150, 225, 300, 450, 750},
        neon = {3135, 3150, 3225, 3300, 3450, 3750},
        mega_neon = 15150
    },
    ultra_rare = {
        normal = {270, 300, 450, 600, 900, 1500},
        neon = {6270, 6300, 6450, 6600, 6900, 7500},
        mega_neon = 30300
    },
    legendary = {
        normal = {810, 900, 1350, 1800, 2700, 4500},
        neon = {18810, 18900, 19350, 19800, 20700, 22500},
        mega_neon = 90900
    }
}

-- Get player data reference
local function getPlayerData() -- returns: table or nil
    local data = ClientData.get_data()
    if not data then return nil end
    
    local playerName = Players.LocalPlayer.Name
    return data[playerName]
end

-- Get releaser points for a pet
local function getReleaserPoints(rarity, petType, age) -- returns: number
    local rarityData = PET_RELEASER_INFO[rarity]
    if not rarityData then return 0 end
    
    local typeData = rarityData[petType]
    if not typeData then return 0 end
    
    if petType == "mega_neon" then
        return typeData
    end
    
    return typeData[age] or 0
end

-- Count potions in inventory
local function countPotions(inventory) -- returns: number
    if not inventory or not inventory.food then return 0 end
    
    local count = 0
    for _, food in pairs(inventory.food) do
        if food.kind == "pet_age_potion" then
            count += 1
        end
    end
    return count
end

-- Get event currency from player data
local function getEventCurrency(playerData) -- returns: number
    if not playerData then return 0 end
    -- Adjust this based on actual event currency field name
    return playerData.event_currency or playerData.candy or 0
end

-- Process pets inventory and return formatted data
local function processPetsData(inventory) -- returns: table, number, string
    if not inventory or not inventory.pets then 
        return {}, 0, "" 
    end
    
    local petCount = 0
    local recyclePoints = 0
    local pets = {}
    local petsCounter = {} -- tracks: {petKind: {amount: number, data: table}}
    local uniquePetNames = {}
    
    -- First pass: count pets and calculate recycle points
    for _, pet in pairs(inventory.pets) do
        petCount += 1
        
        local petDataDB = InventoryDB.pets[pet.kind]
        if not petDataDB then continue end
        
        -- Initialize counter for this pet type
        if not petsCounter[pet.kind] then
            petsCounter[pet.kind] = {
                amount = 0,
                data = petDataDB,
                neon = pet.neon or false,
                mega_neon = pet.mega_neon or false
            }
        end
        
        petsCounter[pet.kind].amount += 1
        
        -- Determine pet type for recycle calculation
        local petType = "normal"
        local properties = pet.properties
        if properties and properties.mega_neon then
            petType = "mega_neon"
        elseif properties and properties.neon then
            petType = "neon"
        end
        
        -- Calculate recycle points
        if petDataDB.is_egg == false then
            local age = properties and properties.age or 1
            recyclePoints += getReleaserPoints(
                petDataDB.rarity,
                petType,
                age
            )
        end
    end
    
    -- Second pass: build pets array
    for petKind, petInfo in pairs(petsCounter) do
        local petDataDB = petInfo.data
        local assetId = string.match(petDataDB.image or "", "%d+") or ""
        
        table.insert(pets, {
            item_name = petDataDB.name,
            amount = petInfo.amount,
            rarity = petDataDB.rarity,
            neon = petInfo.neon,
            mega_neon = petInfo.mega_neon,
            asset_id = assetId
        })
        
        table.insert(uniquePetNames, petDataDB.name)
    end
    
    -- Add recycle points entry
    table.insert(pets, {
        item_name = "Recycle points",
        amount = recyclePoints,
        rarity = "rare",
        neon = false,
        mega_neon = false,
        asset_id = "9549841158"
    })
    
    -- Create comma-separated pet names
    local petsSearch = table.concat(uniquePetNames, ",")
    
    return pets, petCount, petsSearch
end

-- Build complete data payload
local function buildDataPayload() -- returns: table
    local playerData = getPlayerData()
    if not playerData then
        warn("Failed to get player data")
        return nil
    end
    
    local inventory = playerData.inventory
    local pets, petCount, petsSearch = processPetsData(inventory)
    
    return {
        username = USER_CONFIG.username,
        user_id = USER_CONFIG.user_id,
        discord_id = USER_CONFIG.discord_id,
        Money = playerData.money or 0,
        Potion = countPotions(inventory),
        event_currency = getEventCurrency(playerData),
        total_list_pet = petCount,
        note = USER_CONFIG.note,
        pets_search = petsSearch,
        pets = pets,
        event_currency_per_min = 0,
        potion_per_min = 0
    }
end

-- Send data to endpoint
local function sendData(data) -- returns: boolean
    local success, result = pcall(function()
        return request({
            Url = ENDPOINT_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
    
    if not success then
        warn("Failed to send data:", result)
        return false
    end
    
    return true
end

-- Main loop
task.spawn(function()
    while true do
        local data = buildDataPayload()
        if data then
            task.spawn(function()
                sendData(data)
            end)
        end
        task.wait(UPDATE_INTERVAL)
    end
end)
