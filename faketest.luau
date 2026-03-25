repeat task.wait() until game:IsLoaded()
task.wait(50)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FPS_CAP = 1

task.spawn(function()
    while true do
        task.wait(1)
        if setfpscap then setfpscap(FPS_CAP) end
    end
end)

task.spawn(function()
    local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
    local data = ClientData.get_data()
    local playerData = data and data[Players.LocalPlayer.Name]
    local money = playerData and playerData.money
    local firstTime = true
    print("current money ", money)
    while true do
        if firstTime then
            firstTime = false
            task.wait(400)
        else
            task.wait(400)
        end
        print("atfer money", playerData.money)
        if money == playerData.money then
            Players.LocalPlayer:Kick()
        end
        money = playerData.money
    end
end)

task.spawn(function()
    getgenv().Config = {
        Dashboard = {
            Enabled = false, -- Connect to Adopt Me dashboard To Control Script/View Stats (https://zekehub.com/dashboard/adoptme)
            GroupName = "vps1", -- Group name for organizing accounts on dashboard
        },
        BabyFarm = true, -- Does baby farm
        AutoCertificate = false, -- Auto use Pet Handler Pro Certificate when less than 30 days remaining
        PetFarm = {
            Enabled = true, -- Enables the Pet Farm
            FarmEggs = true, -- If true, equips eggs to hatch them. If false, equips regular pets
            BuyEggs = true, -- If FarmEggs is true and no eggs in inventory, buy eggs automatically
            EggTypes = {"cracked_egg"}, -- Which eggs to equip ({} = any egg, or {"cracked_egg", "royal_egg"} for specific)
            BuyEggType = "cracked_egg", -- Which egg to buy when BuyEggs is true ("any" or specific egg ID)
            MaxPets = 1, -- How many pets to equip at once (1 = free, 2 = requires Robux gamepass)
            FarmUntilFullGrown = true, -- If true, selects pets that aren't full grown first
            PrioritizeFriendship = false, -- If true, selects pets with higher friendship level first
            SelectiveFarm = false, -- If true, only farm pets in SelecatedPetTypes list
            SelectedPetTypes = {}, -- Pet IDs to farm when SelectiveFarm is true (e.g., {"dog", "cat"})
        },
        EventFarm = {
            CandyCliff = false, -- Automatically complete Candy Cliff event tasks and buys a chissle
            MochiNail = false, -- Automatically complete Mochi Nail event and buys the tool needed
        },
        AutoTrade = {
            Enabled = true, -- Enable auto trading
            AutoAcceptTrades = true, -- Accept incoming trade requests
            AutoLeaveAfterTrades = false, -- Leave the game after completing trades
            Usernames = {"ZeroALTS2", "XxAardvark_lqn4u","sallow402670","Drezraclub","Jaxhazelstudi011","Itsharpereditsrbx39"}, -- Players to send trades to
            TradeMode = "specific", -- "all" = everything in categories, "specific" = only Items list
            Categories = {"pets"}, -- {"pets", "toys", "food", "transport", "gifts", "stickers", "pet_accessories", "roleplay"}
            Items = {"royal_egg", "pet_recycler_2025_crystal_egg", "basic_egg_2022_alicorn", "basic_egg_2022_ancient_dragon", "basic_egg_2022_dragonfly", "diamond_unicorn", "diamond_griffin", "food_pets_2026_dragonfruit_fox", "pet_recycler_2025_giant_panda", "pet_recycler_2025_emberlight"}, -- Item IDs when TradeMode = "specific"
            ItemCounts = {}, -- Max count per item in Items array
            PetTypes = {}, -- {} = all, {"regular", "neon", "mega"}
            PetVersionFilter = {}, -- Per-pet version filter e.g. {turtle = {"mega"}, whale = {"neon"}, cat = {"regular"}} - if pet listed here only those versions trade, otherwise falls back to global PetTypes
            Ages = {}, -- {} = all, {1, 2, 3, 4, 5, 6}
        },
        AutoNeon = {
            Enabled = true, -- Enable auto neon/mega fusion
            MakeMega = false, -- Fuse neons into mega neons
            NeonAll = true, -- Neon everything possible
            SelectedPets = {"basic_egg_2022_dragonfly", "basic_egg_2022_ancient_dragon", "basic_egg_2022_alicorn"}, -- {} when NeonAll = true, otherwise {"dog", "cat"} etc
            MaxPerType = {}, -- {} = unlimited, {dog = 2, cat = 1} = limits per pet type
        },
        AutoPotion = {
            Enabled = true, -- Use age potions on pets to level them up
            SelectedPets = {"basic_egg_2022_dragonfly", "basic_egg_2022_ancient_dragon", "basic_egg_2022_alicorn"}, -- Pet IDs to use potions on (empty = does nothing)
        },
        AutoBuy = {
            Enabled = true, -- Automatically buy items from shops
            SelectedItems = {"pets|pet_recycler_2025_crystal_egg"}, -- Item IDs to buy
            BuyAmounts = {}, -- How many of each item to buy. Example: {5, 10} buys 5 cracked_eggs and 10 sandwiches. Empty {} buys infinite of each item. If there are more items than amounts, remaining items default to infinite.
        },
        AutoPay = {
            Enabled = false, -- Send bucks to another player
            TargetPlayer = "", -- Username of player to pay bucks to
        },
        AutoOpen = {
            Enabled = false, -- Open gift boxes, baits, etc automatically
            Items = {}, -- Item IDs to auto open
        },
        AutoRecycle = {
            Enabled = true, -- Toggle auto recycling on/off
            RarityFilter = {
                -- Each rarity maps to a list of versions to recycle
                -- Versions: "regular", "neon", "mega"
                -- If a rarity is not listed or empty, pets of that rarity will NOT be recycled
                -- If a rarity has versions listed, ONLY those versions will be recycled

                -- common = {"regular", "neon", "mega"},  -- Recycle all common versions
                -- uncommon = {"neon"},                    -- Only recycle neon uncommons
                -- rare = {"regular", "neon", "mega"},     -- Recycle all rare versions
                -- ultra_rare = {"regular", "neon", "mega"}, -- Recycle all ultra rare versions
                -- legendary = {"mega"},                   -- Only recycle mega legendaries
                common = {"regular", "neon", "mega"},
                uncommon = {"regular", "neon", "mega"},
                rare = {"regular", "neon", "mega"},
                ultra_rare = {"regular", "neon", "mega"},
            },
            
            AgeFilter = {4}, -- Empty = all ages, or specific ages e.g. {1, 2, 3, 4, 5, 6} (1=Newborn, 6=Full Grown)
            ExcludedPets = {"diamond_unicorn", "diamond_griffin", "food_pets_2026_dragonfruit_fox", "pet_recycler_2025_giant_panda", "pet_recycler_2025_emberlight", "cat", "dog", "pet_recycler_2025_crystal_egg"}, -- Pet IDs to never recycle e.g. {"dog", "cat", "shadow_dragon"}
        },
        IdleProgression = {
            Enabled = true, -- Put pets in pet pen for idle leveling
            SelectedPets = {'basic_egg_2022_ant', 'basic_egg_2022_ant','basic_egg_2022_camel','basic_egg_2022_donkey','basic_egg_2022_poodle','basic_egg_2022_orangutan','basic_egg_2022_parakeet','basic_egg_2022_zebra','basic_egg_2022_corgi','basic_egg_2022_robot','basic_egg_2022_swordfish'}, -- Pet IDs to put in pet pen (empty = use all)
            ExcludedPets = {"pet_recycler_2025_crystal_egg"}, -- Pet IDs to never put in pet pen
            PriorityOrder = {"regular", "neon", "mega"}, -- Order: first = highest priority for pen slots (e.g. {"neon", "regular", "mega"})
        },
        AccountManager = {
            Enabled = false, -- Master toggle for account management
            Tool = "", -- "yummy", "farmsync"
            Yummy = {
                Action = "completed", -- "completed" = remove cookie/stop, "swap" = next cookie
                Reason = "Done", -- Suffix for completed file (Completed-{Reason})
            },
            FarmSync = {
                Action = "completed", -- "completed" = move to done folder, "swap" = move and replace
                FromFolderId = "", -- Fresh cookies folder ID
                ToFolderId = "", -- Done cookies folder ID
                ChangeWithoutReplacement = false, -- Remove even if no replacement available
                ConfigId = nil, -- Config for new account (nil = same config)
            },
            Triggers = {
                AfterTradeComplete = false, -- Requires AutoTrade.AutoLeaveAfterTrades to be enabled
                MinBucks = 0, -- Change account when bucks >= this (0 = off)
                MinPotions = 0, -- Change account when potions >= this (0 = off)
            },
        },
        Settings = {
            AutoShowUI = true, -- Load the UI on script start (main overlay disable for less memory usage)
            ShowOverlay = true, -- Show stats overlay (disables 3D rendering)
            ReduceGraphics = true, -- Reduce graphics quality to minimum
            FPSCap = 1, -- FPS cap option (0 = uncapped)
            LureId = "ice_dimension_2025_ice_soup_bait" -- what lure to use for example: "ice_dimension_2025_ice_soup_bait"
        },
        Webhook = {
            Enabled = false, -- Send webhook notifications to Discord
            URL = "https://discord.com/api/", -- Discord webhook URL for notifications
            PetUnlock = {
                Enabled = false, -- Send webhook when hatching/unlocking a pet
                URL = "https://discord.com/api/webhooks/", -- Webhook URL for pet unlocks
                FilterRarities = {"legendary", "ultra_rare"}, -- Only send for these rarities
            },
        },
        TaskExclusion = {
            Enabled = false, -- Skip certain farming tasks
            ExcludedTasks = {}, -- Task IDs to skip (e.g., {"buccaneer_band", "summerfest_bonfire"})
        },
    };
    getgenv().scriptkey="euTAZeNfTEWcruviqseWDjorRhqGNgdv"
    loadstring(game:HttpGet("https://zekehub.com/scripts/AdoptMe/MassFarm.lua"))()
end)

task.spawn(function()
    _G.Config={UserID="7150eda6-481e-487d-9a47-0bfbad1d3d43",discord_id="541529117959651328",Note="Pc"}local s;for i=1,5 do s=pcall(function()loadstring(game:HttpGet("https://cdn.yummydata.click/scripts/adoptmee"))()end)if s then break end wait(5)end
end)
