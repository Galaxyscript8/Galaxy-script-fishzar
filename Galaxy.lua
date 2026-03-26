--[[
GALAXY 🌀 - AUTO FISHING + AUTO SELL + MINIGAME EXPLOIT
FULL SYSTEM WITH MINIGAME BYPASS
OWNER: Galaxy
]]

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variables
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
AutoFishing = false,
AutoSell = false,
MinRarity = "Common",
SellDelay = 0.5,
MinigameEnabled = false,
TargetSize = 0.95,
Gravity = 0.01,
ClickPower = 0.1,
AutoClick = true,
AlwaysInside = true
}

-- Stats
local Stats = {
FishCaught = 0,
FishSold = 0
}

-- ================================
-- MINIGAME EXPLOIT SECTION
-- ================================

local MinigameSystem = nil
local oldStart = nil
local oldUpdate = nil
local oldIsInside = nil
local minigameActive = false

-- Bypass Anti Cheat
local function bypassAntiCheat()
local success, mt = pcall(function()
return getrawmetatable(game)
end)

if success and mt then  
    local old_namecall = mt.__namecall  
    setreadonly(mt, false)  
      
    mt.__namecall = newcclosure(function(self, ...)  
        local method = getnamecallmethod()  
        if method == "FireServer" and tostring(self):find("AntiCheat") then  
            return nil  
        end  
        return old_namecall(self, ...)  
    end)  
      
    setreadonly(mt, true)  
    print("✅ Anti Cheat Bypassed!")  
    return true  
end  
return false
end

-- Load Minigame System
local function loadMinigameSystem()
local success = pcall(function()
local fishingSystem = replicatedStorage:FindFirstChild("FishingSystem")
if fishingSystem then
local modules = fishingSystem:FindFirstChild("FishingModules")
if modules then
MinigameSystem = require(modules:WaitForChild("MinigameSystem"))
print("✅ MinigameSystem loaded!")
return true
end
end
end)
return success
end

-- Setup Minigame Exploit
local function setupMinigameExploit()
if not MinigameSystem then return false end

-- Save original functions  
oldStart = MinigameSystem.Start  
oldUpdate = MinigameSystem.UpdateVisuals  
oldIsInside = MinigameSystem.IsInsideTarget  
  
-- Override Start function  
MinigameSystem.Start = function(self, ...)  
    if not Settings.MinigameEnabled then  
        if oldStart then return oldStart(self, ...) end  
        return  
    end  
      
    minigameActive = true  
    print("🔥 [GALAXY] Minigame Exploit ACTIVE!")  
      
    -- Call original start  
    if oldStart then oldStart(self, ...) end  
      
    -- Get the upvalue table  
    local v_u_4 = nil  
    pcall(function()  
        v_u_4 = debug.getupvalue(oldUpdate, 2)  
    end)  
      
    if v_u_4 then  
        -- Set BIG target size  
        v_u_4.targetSize = Settings.TargetSize  
        v_u_4.gravity = Settings.Gravity  
        v_u_4.clickPower = Settings.ClickPower  
        v_u_4.catchSpeed = 0.9  
        v_u_4.loseSpeed = 0.01  
          
        print("✅ Target Size: " .. v_u_4.targetSize)  
        print("✅ Gravity: " .. v_u_4.gravity)  
        print("✅ Click Power: " .. v_u_4.clickPower)  
    end  
      
    -- Auto Click  
    if Settings.AutoClick then  
        task.spawn(function()  
            while minigameActive and Settings.MinigameEnabled do  
                pcall(function()  
                    local args = {  
                        [1] = {  
                            ["Play"] = function() end  
                        },  
                        [2] = {  
                            ["AnimateImageTap"] = function() end  
                        }  
                    }  
                    if MinigameSystem and MinigameSystem.HandleClick then  
                        MinigameSystem.HandleClick(unpack(args))  
                    end  
                end)  
                task.wait(0.01)  
            end  
        end)  
    end  
end  
  
-- Override UpdateVisuals  
MinigameSystem.UpdateVisuals = function(self, ...)  
    if Settings.MinigameEnabled then  
        local v_u_4 = nil  
        pcall(function()  
            v_u_4 = debug.getupvalue(oldUpdate, 2)  
        end)  
        if v_u_4 then  
            v_u_4.targetSize = Settings.TargetSize  
            v_u_4.gravity = Settings.Gravity  
            v_u_4.clickPower = Settings.ClickPower  
        end  
    end  
    if oldUpdate then return oldUpdate(self, ...) end  
end  
  
-- Override IsInsideTarget  
if Settings.AlwaysInside then  
    MinigameSystem.IsInsideTarget = function(self)  
        return true  
    end  
else  
    MinigameSystem.IsInsideTarget = oldIsInside  
end  
  
return true
end

-- Disable Minigame Exploit
local function disableMinigameExploit()
if not MinigameSystem then return end

minigameActive = false  
  
if oldStart then  
    MinigameSystem.Start = oldStart  
end  
  
if oldUpdate then  
    MinigameSystem.UpdateVisuals = oldUpdate  
end  
  
if oldIsInside then  
    MinigameSystem.IsInsideTarget = oldIsInside  
end  
  
print("❌ Minigame Exploit Disabled")
end

-- ================================
-- AUTO FISHING SECTION
-- ================================

-- Find Fishing System
local FishingSystem = nil
for _, child in pairs(replicatedStorage:GetChildren()) do
if child.Name:lower():find("fish") then
FishingSystem = child
break
end
end

-- Find Remotes
local CastRemote = FishingSystem and FishingSystem:FindFirstChild("CastReplication")
local PrecalcRemote = FishingSystem and FishingSystem:FindFirstChild("PrecalcFish")
local AlertRemote = FishingSystem and FishingSystem:FindFirstChild("ReplicatePullAlert")
local FishGiverRemote = FishingSystem and FishingSystem:FindFirstChild("FishGiver")
local CleanupRemote = FishingSystem and FishingSystem:FindFirstChild("CleanupCast")
local SellRemote = FishingSystem and FishingSystem:FindFirstChild("SellFish")

-- Get Dynamic Coordinates
local function getCoords()
local pos = rootPart.Position
return {
castStart = Vector3.new(pos.X + 5, pos.Y + 3, pos.Z + 2),
castDir = Vector3.new(-0.1, 5, -25),
hookPos = Vector3.new(pos.X + 2, pos.Y - 1.5, pos.Z - 5)
}
end

-- Auto Fishing Function
local function doFishing()
if not Settings.AutoFishing then return end

local coords = getCoords()  
  
if CastRemote then  
    pcall(function()  
        CastRemote:FireServer(coords.castStart, coords.castDir, "Owner Rod", 91)  
    end)  
end  
task.wait(1.5)  
  
if PrecalcRemote then  
    pcall(function()  
        PrecalcRemote:InvokeServer()  
    end)  
end  
task.wait(1)  
  
if AlertRemote then  
    pcall(function()  
        AlertRemote:FireServer("rbxassetid://78467245624383")  
    end)  
end  
task.wait(1)  
  
if FishGiverRemote then  
    pcall(function()  
        FishGiverRemote:FireServer({hookPosition = coords.hookPos})  
        Stats.FishCaught = Stats.FishCaught + 1  
    end)  
end  
task.wait()  
  
if CleanupRemote then  
    pcall(function()  
        CleanupRemote:FireServer()  
    end)  
end
end

-- ================================
-- AUTO SELL SECTION
-- ================================

local function getFishId(tool)
if not tool then return nil end
if tool:FindFirstChild("fishId") then return tool.fishId.Value end
if tool:FindFirstChild("FishId") then return tool.FishId.Value end
if tool:FindFirstChild("id") then return tool.id.Value end
return tool:GetAttribute("fishId") or tool:GetAttribute("id")
end

local function getInventory()
local fishList = {}
local backpack = player:FindFirstChild("Backpack")
if backpack then
for _, tool in pairs(backpack:GetChildren()) do
if tool:IsA("Tool") then
local fishId = getFishId(tool)
if fishId then
table.insert(fishList, {
fishId = fishId,
rarity = tool:GetAttribute("rarity") or "Common",
tool = tool
})
end
end
end
end
return fishList
end

local rarityValue = {
Common = 1, Uncommon = 2, Rare = 3,
Epic = 4, Legendary = 5, Mythic = 6
}

local function sellFish(fishData)
if not SellRemote then return end

local weight = 999999999999999999999999999999  
  
pcall(function()  
    local success = false  
      
    if not success then  
        pcall(function()  
            SellRemote:FireServer("SellSingle", {  
                fishId = fishData.fishId,  
                rarity = fishData.rarity,  
                weight = weight  
            })  
            success = true  
        end)  
    end  
      
    if not success then  
        pcall(function()  
            SellRemote:FireServer({  
                fishId = fishData.fishId,  
                rarity = fishData.rarity,  
                weight = weight  
            })  
            success = true  
        end)  
    end  
      
    if not success then  
        pcall(function()  
            SellRemote:FireServer("Sell", {  
                fishId = fishData.fishId,  
                rarity = fishData.rarity,  
                weight = weight  
            })  
            success = true  
        end)  
    end  
      
    if success then  
        Stats.FishSold = Stats.FishSold + 1  
    end  
end)
end

local function doSell()
if not Settings.AutoSell then return end

local inventory = getInventory()  
local minLevel = rarityValue[Settings.MinRarity] or 1  
  
for _, fish in pairs(inventory) do  
    local fishLevel = rarityValue[fish.rarity] or 0  
    if fishLevel >= minLevel then  
        sellFish(fish)  
        task.wait(Settings.SellDelay)  
    end  
end
end

-- ================================
-- UI CREATION
-- ================================

local Window = Rayfield:CreateWindow({
Name = "Galaxy 🌀",
LoadingTitle = "Auto Fishing + Auto Sell + Minigame",
LoadingSubtitle = "by Galaxy",
ConfigurationSaving = {
Enabled = true,
FolderName = "Galaxy",
FileName = "Settings"
}
})

-- Main Tab
local MainTab = Window:CreateTab("🎣 Main", 4483362458)

MainTab:CreateSection("Auto Fishing")

MainTab:CreateToggle({
Name = "Enable Auto Fishing",
CurrentValue = false,
Callback = function(v)
Settings.AutoFishing = v
Rayfield:Notify({Title = "Galaxy", Content = v and "Auto Fishing Started!" or "Auto Fishing Stopped!"})
end
})

MainTab:CreateSection("Auto Sell")

MainTab:CreateToggle({
Name = "Enable Auto Sell",
CurrentValue = false,
Callback = function(v)
Settings.AutoSell = v
Rayfield:Notify({Title = "Galaxy", Content = v and "Auto Sell Started!" or "Auto Sell Stopped!"})
end
})

MainTab:CreateDropdown({
Name = "Minimum Rarity",
Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
CurrentOption = "Common",
Callback = function(v)
Settings.MinRarity = v
end
})

MainTab:CreateSlider({
Name = "Sell Delay",
Range = {0.1, 2},
Increment = 0.1,
Suffix = "s",
CurrentValue = 0.5,
Callback = function(v)
Settings.SellDelay = v
end
})

-- Minigame Tab
local MinigameTab = Window:CreateTab("🎮 Minigame", 4483362458)

MinigameTab:CreateSection("Minigame Exploit")

MinigameTab:CreateToggle({
Name = "Enable Minigame Exploit",
CurrentValue = false,
Callback = function(v)
Settings.MinigameEnabled = v
if v then
bypassAntiCheat()
if loadMinigameSystem() then
setupMinigameExploit()
Rayfield:Notify({Title = "Minigame", Content = "Exploit Activated! Target Size: " .. Settings.TargetSize})
else
Rayfield:Notify({Title = "Minigame", Content = "Failed to load Minigame System!", Duration = 3})
Settings.MinigameEnabled = false
end
else
disableMinigameExploit()
Rayfield:Notify({Title = "Minigame", Content = "Exploit Deactivated!"})
end
end
})

MinigameTab:CreateSection("Minigame Settings")

MinigameTab:CreateSlider({
Name = "Target Size",
Range = {0.5, 0.99},
Increment = 0.01,
Suffix = "%",
CurrentValue = 0.95,
Callback = function(v)
Settings.TargetSize = v
if Settings.MinigameEnabled then
Rayfield:Notify({Title = "Minigame", Content = "Target Size set to " .. (v * 100) .. "%"})
end
end
})

MinigameTab:CreateSlider({
Name = "Gravity",
Range = {0.001, 0.1},
Increment = 0.001,
Suffix = "",
CurrentValue = 0.01,
Callback = function(v)
Settings.Gravity = v
end
})

MinigameTab:CreateSlider({
Name = "Click Power",
Range = {0.05, 0.5},
Increment = 0.01,
Suffix = "",
CurrentValue = 0.1,
Callback = function(v)
Settings.ClickPower = v
end
})

MinigameTab:CreateToggle({
Name = "Auto Click",
CurrentValue = true,
Callback = function(v)
Settings.AutoClick = v
end
})

MinigameTab:CreateToggle({
Name = "Always Inside Target",
CurrentValue = true,
Callback = function(v)
Settings.AlwaysInside = v
if Settings.MinigameEnabled and MinigameSystem then
if v then
MinigameSystem.IsInsideTarget = function() return true end
else
MinigameSystem.IsInsideTarget = oldIsInside
end
end
end
})

-- Status Tab
local StatusTab = Window:CreateTab("📊 Status", 4483362458)

StatusTab:CreateSection("Remote Status")

StatusTab:CreateLabel(CastRemote and "✅ CastRemote: Found" or "❌ CastRemote: Not Found")
StatusTab:CreateLabel(PrecalcRemote and "✅ PrecalcRemote: Found" or "❌ PrecalcRemote: Not Found")
StatusTab:CreateLabel(AlertRemote and "✅ AlertRemote: Found" or "❌ AlertRemote: Not Found")
StatusTab:CreateLabel(FishGiverRemote and "✅ FishGiverRemote: Found" or "❌ FishGiverRemote: Not Found")
StatusTab:CreateLabel(CleanupRemote and "✅ CleanupRemote: Found" or "❌ CleanupRemote: Not Found")
StatusTab:CreateLabel(SellRemote and "✅ SellRemote: Found" or "❌ SellRemote: Not Found")

StatusTab:CreateSection("Minigame Status")

local minigameStatusLabel = StatusTab:CreateLabel("Minigame Exploit: Disabled")

StatusTab:CreateSection("Statistics")

local caughtLabel = StatusTab:CreateLabel("Fish Caught: 0")
local soldLabel = StatusTab:CreateLabel("Fish Sold: 0")

StatusTab:CreateButton({
Name = "Refresh Stats",
Callback = function()
caughtLabel:Set("Fish Caught: " .. Stats.FishCaught)
soldLabel:Set("Fish Sold: " .. Stats.FishSold)
Rayfield:Notify({Title = "Galaxy", Content = "Stats Refreshed!"})
end
})

StatusTab:CreateButton({
Name = "Check Inventory",
Callback = function()
local inv = getInventory()
local msg = "Total Fish: " .. #inv .. "\n"
for i, fish in pairs(inv) do
if i <= 5 then
msg = msg .. fish.rarity .. " fish\n"
end
end
if #inv > 5 then
msg = msg .. "... and " .. (#inv - 5) .. " more"
end
Rayfield:Notify({Title = "Inventory", Content = msg, Duration = 5})
end
})

-- Credits Tab
local CreditsTab = Window:CreateTab("👤 Credits", 4483362458)

CreditsTab:CreateParagraph({
Title = "Galaxy 🌀",
Content = "Owner & Developer: Galaxy\n\nFeatures:\n✓ Auto Fishing\n✓ Auto Sell (Multi Format)\n✓ Minigame Exploit (Target Size)\n✓ Anti Cheat Bypass\n✓ Auto Click\n✓ Dynamic Coordinates\n✓ Rayfield UI\n\nVersion: 3.0"
})

-- ================================
-- MAIN LOOPS
-- ================================

task.spawn(function()
while true do
if Settings.AutoFishing then
pcall(doFishing)
task.wait(3)
end
task.wait()
end
end)

task.spawn(function()
while true do
if Settings.AutoSell then
pcall(doSell)
task.wait(2)
end
task.wait()
end
end)

task.spawn(function()
while true do
caughtLabel:Set("Fish Caught: " .. Stats.FishCaught)
soldLabel:Set("Fish Sold: " .. Stats.FishSold)
minigameStatusLabel:Set(Settings.MinigameEnabled and "✅ Minigame Exploit: ACTIVE" or "❌ Minigame Exploit: Disabled")
task.wait(1)
end
end)

Rayfield:Notify({
Title = "Galaxy 🌀",
Content = "System Loaded! Check Minigame tab for exploit!",
Duration = 4
})

print("✅ Galaxy - Full System Loaded!")
print("🎮 Minigame Exploit ready in Minigame tab!")
print("🎣 Auto Fishing ready!")
print("💰 Auto Sell ready!")
print("👤 Owner: Galaxy")
