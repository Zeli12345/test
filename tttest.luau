repeat task.wait() until game:IsLoaded()
task.wait(50)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FPS_CAP = 3

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
    script_key = "MSbFgcTIEkixMXrTRudJaHagcRBUHdWr";
    getgenv().Config = {
        ["PetAMountToBuy"] = "0", -- can be 999
        ["WhatCategory"] = "pets", -- gifts if WhatCategory = "" then = pets
        ["PetRemoteToBuy"] = "Cracked Egg", -- exemple for gifts halloween_2025_spider_box

        ["check_for_2d_kitty"] = true, -- farm 2d kitty event work with eggfarm or petfarm


        ["PetFarmAutoSwitchFullGrown"] = false,
        ["PetFarmActive"] = false, -- farm potion

        ["AutoLoopBuyChisel"] = false, -- 2026 SUGAR EVENT

        ["EggFarmActive"] = true, -- farm egg, if no more eggs will farm potion, if found new egg will farm them to
        ["EggToIgnore"] = {"Crystal Egg"}, -- eggs to ignore when eggfarm active
        ["LoopBuyEgg"] = true, -- when enough bucks will buy egg, only work with eggfarm
        ["EggToBuyEgg"] = "Cracked Egg",


        ["PetPenActive"] = true, -- will put pets in pen, random pets
        ["PetPenFocusPriority"] = false, -- will focus those pets order in pen, then farm any other pets
        ["PetPenFocusPetOrder"] = {"Ant", "Mouse","Camel","Donkey","Poodle"}, -- pet names to focus in pen exemple {"Donkey","Camel","Zebra"}
        ["PetPenFocusPetRarity"] = true, -- PetPenFocusPriority must be false else will ignore
        ["PetPenFocusPetRarityOrder"] = {"common","uncommon","rare","ultra_rare","legendary"}, -- will farm pet rarity depending on order using pet pen exemple "common","uncommon","rare","ultra_rare","legendary"
        ["PetPenAutoNeon"] = false, -- will try to make neon pets, check after it remove fullgrown pet from pen
        ["PetPenAutoMega"] = false, -- will try to make mega pets, check after it remove fullgrown pet from pen
        ["PetPenNeonMegaWebhook"] = "", -- webhook to send neon/mega info


        ["HodDogStandHOLDER"] = "", -- will automatically setup hotdog stand you must own one
        ["HodDogStandHOLDERPrice"] = "50", -- 1 to 50 max if not set default is 50
        ["HodDogStandTransfer"] = false, -- enable or disable hotdog stand transfer


        ["NeonMegaFarm"] = false,
        ["BuyEgg"] = "", -- only work with NeonMegaFarm, will loop buy this egg when enough bucks


        ["AutoBuyStuffRecyclePoint"] = true, -- will automatically buy stuff in recycle point shop
        ["ItemToBuyInRecyclePoint"] = "Crystal Egg", -- item name or item kind, exemple "Crystal Egg" or "Basic Egg"


        ["AutoReleasePet"] = true, -- work with egg/pet farm, will release selected rarity
        ["OnlyReleasePetList"] = {""}, -- will ONLY release those pet, and will ignore every other release config, if you dont want it let ""
        ["GlobalBlacklist"] = {""}, -- item kind or name separated by , ; |
        ["LegendaryAllowedToRecycle"] = {""}, -- item kind or name separated by , ; |
        ["RecycleWebhook"] = "", -- webhook to send recycle info
        ["RecycleOnlyPetWithAge"] = "6", -- 6 = full grown, let "" to recycle all, 1 2 3 4 5 6 or "" not 0

        ["common"] = true,
        ["uncommon"] = true,
        ["rare"] = true,
        ["ultra_rare"] = true,
        ["legendary"] = false, -- WARNING must know what you are doing

        ["HideUselessGui"] = false,
        ["Blur_username"] = false,
        ["Blazing_Lion_Log"] = false,
        ["DiscordId"] = "123456",
        ["Webhook"] = "",
        ["LegendaryWebhook"] = "",
        ["NeonMegaWebhook"] = "",
    }
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/66567bfd337b57eb059b58dbe1badb89.lua"))()
end)

task.spawn(function()
    _G.Config={UserID="7150eda6-481e-487d-9a47-0bfbad1d3d43",discord_id="541529117959651328",Note="Pc"}local s;for i=1,5 do s=pcall(function()loadstring(game:HttpGet("https://cdn.yummydata.click/scripts/adoptmee"))()end)if s then break end wait(5)end
end)
