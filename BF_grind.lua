local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vim = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- local VirtualUser = game:GetService("VirtualUser")
-- local HttpService = game:GetService("HttpService")
-- local TeleportService = game:GetService("TeleportService")

local Remotes = {}
pcall(function()
    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
    if remotesFolder then
        Remotes.CommF_ = remotesFolder:FindFirstChild("CommF_")
        Remotes.CommE = remotesFolder:FindFirstChild("CommE")
        Remotes.Chest = remotesFolder:FindFirstChild("Chest")
        Remotes.Stats = remotesFolder:FindFirstChild("Stats")
        Remotes.Redeem = remotesFolder:FindFirstChild("Redeem")
        Remotes.Leviathan = remotesFolder:FindFirstChild("Leviathan")
        Remotes.Temple = remotesFolder:FindFirstChild("Temple")
        Remotes.TempleObby = remotesFolder:FindFirstChild("TempleObby")
        Remotes.DracoTrial = remotesFolder:FindFirstChild("DracoTrial")
    end
    
    local EventsFolder = ReplicatedStorage:FindFirstChild("Events")
    if EventsFolder then
        Remotes.ActivateRaceV4 = EventsFolder:FindFirstChild("ActivateRaceV4")
        Remotes.UsedRaceSkill = EventsFolder:FindFirstChild("UsedRaceSkill")
    end
end)

pcall(function()
    local modules = ReplicatedStorage:FindFirstChild("Modules")
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    if modules then
        if Net then
            Remotes.RegisterAttack = Net:FindFirstChild("RE/RegisterAttack")
            Remotes.RegisterHit = Net:FindFirstChild("RE/RegisterHit")
            Remotes.FishingAPI = Net:FindFirstChild("RF/FishingAPI")
            Remotes.CollectBlueEmber = Net:FindFirstChild("RE/CollectBlueEmber")
            Remotes.KitsuneStatuePray = Net:FindFirstChild("RF/KitsuneStatuePray")
            Remotes.TouchKitsuneStatue = Net:FindFirstChild("RE/TouchKitsuneStatue")
            Remotes.BlueMoonTimerTick = Net:FindFirstChild("RE/BlueMoonTimerTick")
        end
    end
end)

local Locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")
local UncheckedChests = {}
FirstRun = true
FirstRunBerry = true

_G.WebhookURL = "https://discord.com/api/webhooks/1552244677984522310/G7M5Gku0Z5xWQr4OSJyao0EuFgZOCmnatvK9enOzLFd3CRaEAPN5_MYzj8JYBkNL-LGy"
_G.EnableWebhook = true
_G.AntiAFK = true

_G.TweenSpeed = 200
_G.SaveTweenSpeed = 200
_G.CurrentTween = nil
_G.CancelFlight = false
_G.Noclip = false
_G.Clip = false

_G.Killaura = false
_G.AuraRange = 60
_G.KillOffsetX = 0
_G.KillOffsetY = 30
_G.KillOffsetZ = 0
_G.KillOffset = Vector3.new(_G.KillOffsetX, _G.KillOffsetY, _G.KillOffsetZ)
_G.SelectWeapon = "Melee"
_G.AutoBuso = true
_G.BringMob = false
_G.BringAllMob = false
_G.BringDistance = 500
_G.NotAutoEquip = false
_G.FindRange = 6000
_G.V4 = true

_G.AutoFarm = false
_G.SelectedMob = {}
_G.KillMobByName = false
_G.GetMobQuest = false

_G.Lumen = false

_G.AutoChestFarm = false
_G.AutoFruit = false
_G.AutoStoreFruit = false

_G.AutoStats = false
_G.PointStats = 3
_G.StatsToUpgrade = {
    ["Melee"] = false,
    ["Defense"] = false,
    ["Sword"] = false,
    ["Gun"] = false,
    ["Blox Fruit"] = false
}

_G.ChestESP = false
_G.FruitESP = false
_G.IslandESP = false
_G.PlayersESP = false
_G.MobsESP = false
_G.FlowerESP = false
_G.LsdESP = false
_G.AfdESP = false
_G.RealFruitESP = false



_G.AutoBuyChip = false
_G.Auto_Raid = false
_G.LumenRaid = false
_G.Auto_Awakener = false
_G.RaidCount = 0
_G.RaidTweenSpeed = 200
_G.SaveTweenSpeed = 200

_G.AutoFarmMastery = false
_G.SelectWeaponMastery = "Melee"
_G.AutoSkillZ = false
_G.AutoSkillX = false
_G.AutoSkillC = false
_G.AutoSkillV = false
_G.AutoSkillF = false
_G.PercentFarm = 25



local function getIslandsList()
    local islands = {}
    
    local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not worldOrigin then
        return {"Islands doesnt exists"}
    end
    
    local spawnsRoot = worldOrigin:FindFirstChild("PlayerSpawns")
    if not spawnsRoot then
        return {"PlayerSpawns doesnt exists"}
    end
    
    local pirates = spawnsRoot:FindFirstChild("Pirates")
    if not pirates then
        return {"Pirates не найдены"}
    end
    
    for _, island in ipairs(pirates:GetChildren()) do
        if island:IsA("Model") then
            local hasSpawnPart = false
            for _, child in ipairs(island:GetDescendants()) do
                if child:IsA("BasePart") then
                    hasSpawnPart = true
                    break
                end
            end
            if hasSpawnPart then
                table.insert(islands, island.Name)
            end
        end
    end
    
    table.sort(islands)
    
    if #islands == 0 then
        return {"Islands doesnt exists"}
    end
    
    return islands
end

if game.PlaceId == 2753915549 then
    World1 = true
    World = 1
elseif game.PlaceId == 4442272183 then
    World2 = true
    World = 2
elseif game.PlaceId == 7449423635 then
    World3 = true
    World = 3
else
    local worldIslands = getIslandsList()
    if table.find(worldIslands, "Jungle") then
        World1 = true
        World = 1
    elseif table.find(worldIslands, "DressTown") then
        World2 = true
        World = 2
        PlaceIDIslands = 4442272183
    else
        World3 = true
        World = 3
        PlaceIDIslands = 7449423635
    end
end

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)


function SendDiscordWebhook(title, description, color, fields)
    if not _G.EnableWebhook or _G.WebhookURL == "" or #_G.WebhookURL < 15 then return end
    task.spawn(function()
        pcall(function()
            local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
            if not req then return end
            
            local embedData = {
                ["title"] = "Parasma - " .. title,
                ["description"] = description,
                ["color"] = color or 65535,
                ["fields"] = fields or {},
                ["footer"] = {
                    ["text"] = "Parasma v1.0 - " .. os.date("%d/%m/%Y %H:%M:%S")
                }
            }
            
            req({
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    ["username"] = "Notifications",
                    ["avatar_url"] = "https://i.imgur.com/8Q1qD8r.png",
                    ["embeds"] = {embedData}
                })
            })
        end)
    end)
end

function Hop()
    local PlaceID = game.PlaceId or PlaceIDIslands
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    function Teleport() 
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end  

spawn(function()
    while task.wait() do
        if not _G.Noclip then continue end
        pcall(function()
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = not _G.Noclip
                end
            end
        end)
    end
end)

spawn(function()
    while task.wait() do
        if _G.Clip then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                if not hrp:FindFirstChild("BodyClip") then
                    local clip = Instance.new("BodyVelocity")
                    clip.Name = "BodyClip"
                    clip.Parent = hrp
                    clip.MaxForce = Vector3.new(100000, 100000, 100000)
                    clip.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        else
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local clip = hrp:FindFirstChild("BodyClip")
                        if clip then
                            clip:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

function GetDistance(target)
    return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end

function topos(Pos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local Distance = (Pos.Position - hrp.Position).Magnitude
    local duration = Distance / _G.TweenSpeed
    
    if _G.CurrentTween then
        _G.CurrentTween:Pause()
    end
    
    local tween = game:GetService("TweenService"):Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    )
    
    _G.CurrentTween = tween
    _G.CancelFlight = false
    
    tween:Play()
    tween.Completed:Wait()
    
    if _G.CurrentTween == tween then
        _G.CurrentTween = nil
    end
end

-- Функция отмены (вызывай из треда, из GUI-кнопки, откуда угодно)
function cancelFlight()
    _G.CancelFlight = true
    if _G.CurrentTween then
        _G.CurrentTween:Cancel()  -- мгновенно останавливает
        _G.CurrentTween = nil
    end
end

function BTP(P)
	repeat wait(1)
		game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
		task.wait()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
	until (P.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1500
end

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.V4 then
                game:GetService("VirtualInputManager"):SendKeyEvent(true,"Y",false,game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Y",false,game)
            end
        end)
    end
end)

function findEnemy(mobName)
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local bestDist = _G.FindRange
    local bestMob = nil
    
    for _, v in pairs(enemiesFolder:GetChildren()) do
        if v.Name == mobName 
            and v:FindFirstChild("HumanoidRootPart") 
            and v:FindFirstChild("Humanoid") 
            and v.Humanoid.Health > 0 then
            
            local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestMob = v
            end
        end
    end
    
    return bestMob
end

function findNearestEnemy()
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local bestDist = _G.FindRange
    local bestMob = nil
    
    for _, v in pairs(enemiesFolder:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") 
            and v:FindFirstChild("Humanoid") 
            and v.Humanoid.Health > 0 then
            
            local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestMob = v
            end
        end
    end
    
    return bestMob
end

function getSessionId()
    local userIdSlice = tostring(LocalPlayer.UserId):sub(2, 4)
    local threadSlice = tostring(coroutine.running()):sub(11, 15)
    return userIdSlice .. threadSlice
end

local CombatFrameworkModule = nil
pcall(function()
    if LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework") then
        CombatFrameworkModule = require(LocalPlayer.PlayerScripts.CombatFramework)
    end
end)

function PerformFastAttack(targetMob)
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
        
        if CombatFrameworkModule and CombatFrameworkModule.activeController then
            local ac = CombatFrameworkModule.activeController
            ac.hitboxMagnitude = 60
            ac.timeToNextAttack = 0
            ac.attacking = false
            pcall(function() ac:attack() end)
        end
        
        if Remotes.RegisterAttack then
            Remotes.RegisterAttack:FireServer(0)
        end
        
        if Remotes.RegisterHit and targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
            local targetHrp = targetMob.HumanoidRootPart
            Remotes.RegisterHit:FireServer(targetHrp, {
                [1] = {
                    [1] = targetHrp,
                    [2] = targetHrp.Position
                }
            })
        end
    end)
end

spawn(function()
    local sessionId = getSessionId()
    while task.wait(0.08) do
        if not _G.Killaura then continue end
        
        if _G.Killaura then
            if _G.SafeKillaura then
                PerformFastAttack(findNearestEnemy())
            end
            pcall(function()
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not enemiesFolder or not hrp then return end
                
                local bestDist = _G.AuraRange
                local hrpPos = hrp.Position
                local nearestEnemy = nil
                local nearestHead = nil
                
                for _, v in ipairs(enemiesFolder:GetChildren()) do
                    local enemyHrp = v:FindFirstChild("HumanoidRootPart")
                    if enemyHrp then
                        local dist = (enemyHrp.Position - hrpPos).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            nearestEnemy = v
                            nearestHead = v:FindFirstChild("Head")
                        end
                    end
                end
                
                if nearestEnemy and nearestHead then
                    Remotes.RegisterAttack:FireServer(0)
                    local args = {
                        nearestHead,
                        {},
                        sessionId
                    }
                    Remotes.RegisterHit:FireServer(unpack(args))
                end
            end)
        end
    end
end)


function BringNearbyMobs(targetMobName, centerCFrame)
    if not _G.BringMob then return end
    pcall(function()
        local enemies = Workspace:FindFirstChild("Enemies")
        if not enemies then return end
        
        for _, mob in ipairs(enemies:GetChildren()) do
            if (mob.Name == targetMobName or string.find(mob.Name, targetMobName)) and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                local hrp = mob.HumanoidRootPart
                if (hrp.Position - centerCFrame.Position).Magnitude <= _G.BringDistance then
                    hrp.CFrame = centerCFrame;
                    --hrp.Size = Vector3.new(60, 60, 60);
                    hrp.Transparency = 1;
                    mob.Humanoid.JumpPower = 0;
                    mob.Humanoid.WalkSpeed = 0;
                    if mob.Humanoid:FindFirstChild("Animator") then
                        mob.Humanoid.Animator:Destroy();
                    end
                    hrp.CanCollide = false;
                    mob.Head.CanCollide = false;
                    mob.Humanoid:ChangeState(11);
                    mob.Humanoid:ChangeState(14);
                end
            end
        end
    end)
end

function BringAllMobs(centerCFrame)
    if not _G.BringAllMob then return end
    pcall(function()
        local enemies = Workspace:FindFirstChild("Enemies")
        if not enemies then return end
        
        for _, mob in ipairs(enemies:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                local hrp = mob.HumanoidRootPart
                if (hrp.Position - centerCFrame.Position).Magnitude <= _G.BringDistance then
                    hrp.CFrame = centerCFrame;
                    --hrp.Size = Vector3.new(60, 60, 60);
                    hrp.Transparency = 1;
                    mob.Humanoid.JumpPower = 0;
                    mob.Humanoid.WalkSpeed = 0;
                    if mob.Humanoid:FindFirstChild("Animator") then
                        mob.Humanoid.Animator:Destroy();
                    end
                    hrp.CanCollide = false;
                    mob.Head.CanCollide = false;
                    mob.Humanoid:ChangeState(11);
                    mob.Humanoid:ChangeState(14);
                end
            end
        end
    end)
end

function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            Tool = LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait(.1)
            LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end
end

function UnEquipWeapon(Weapon)
    if LocalPlayer.Character:FindFirstChild(Weapon) then
        _G.NotAutoEquip = true
        wait(.2)
        LocalPlayer.Character:FindFirstChild(Weapon).Parent = LocalPlayer.Backpack
        wait(.2)
        _G.NotAutoEquip = false
    end
end

function AutoHaki()
    if not LocalPlayer.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

task.spawn(function()
    while task.wait() do
        if not _G.AutoBuso then continue end
        pcall(function()
            AutoHaki()
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for i ,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        if LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for i ,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        if LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for i ,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        if LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            elseif _G.SelectWeapon == "Fruit" then
                for i ,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        if LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

local codes = {
    "SUB2GAMERROBOT_EXP1", "KITT_RESET", "Sub2Fer999", "StrawHatMaine",
    "Sub2OfficialNoobie", "THEGREATACE", "AXIORE", "TantaiGaming",
    "BLUXXY", "fudd10", "BIGNEWS", "CHANDLER", "FUDD10_V2", 
    "EASTEREXP", "MagicBUS", "JCWK", "Enyu_is_Pro", "StarcodeHEO", 
    "KittGaming", "Sub2CaptainMaui", "TheGreatAce", "Sub2NoobMaster123", 
    "Sub2Daigrock"
}
function RedeemCodes()
    for _, code in ipairs(codes) do
        pcall(function()
            if Remotes.Redeem then
                Remotes.Redeem:InvokeServer(code)
            end
        end)
        task.wait(0.25)
    end
end

local QuestConfig = {
    -- World 1
    {minLevel = 1, maxLevel = 9, world = 1,
        name = "BanditQuest1",
        mobName = "Bandit",
        levelQuest = 1,
        cframeQuest = CFrame.new(1051.65869140625, 14.702945709228516, 1555.0863037109375, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544),
        cframeMob = CFrame.new(1043.281005859375, 72.83850860595703, 1610.26904296875)
    },
    {minLevel = 10, maxLevel = 14, world = 1,
        name = "JungleQuest",
        mobName = "Monkey",
        levelQuest = 1,
        cframeQuest = CFrame.new(-1682.60693359375, 50.08207321166992, 174.2893829345703, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        cframeMob = CFrame.new(-1547.15576171875, 51.9180908203125, 77.78812408447266)
    },
    {minLevel = 15, maxLevel = 29, world = 1,
        name = "JungleQuest",
        mobName = "Gorilla",
        levelQuest = 2,
        cframeQuest = CFrame.new(-1682.60693359375, 50.08207321166992, 174.2893829345703, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        cframeMob = CFrame.new(-1278.68505859375, 31.629758834838867, -602.36950683593755)
    },
    {minLevel = 30, maxLevel = 39, world = 1,
        name = "BuggyQuest1",
        mobName = "Pirate",
        levelQuest = 1,
        cframeQuest = CFrame.new(-1152.073486328125, 17.30712127685547, 3860.0361328125, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627),
        cframeMob = CFrame.new(-1331.6962890625, 60.29766082763672, 3989.569091796875)
    },
    {minLevel = 40, maxLevel = 59, world = 1,
        name = "BuggyQuest1",
        mobName = "Brute",
        levelQuest = 2,
        cframeQuest = CFrame.new(-1152.073486328125, 17.30712127685547, 3860.0361328125, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627),
        cframeMob = CFrame.new(-1226.409423828125, 33.89626693725586, 4340.26220703125)
    },
    {minLevel = 60, maxLevel = 74, world = 1,
        name = "DesertQuest",
        mobName = "Desert Bandit",
        levelQuest = 1,
        cframeQuest = CFrame.new(925.632080078125, 5.91048002243042, 4201.37109375, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693),
        cframeMob = CFrame.new(958.723388671875, 24.473085403442383, 4436.53076171875)
    },
    {minLevel = 75, maxLevel = 89, world = 1,
        name = "DesertQuest",
        mobName = "Desert Officer",
        levelQuest = 2,
        cframeQuest = CFrame.new(925.632080078125, 5.91048002243042, 4201.37109375, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693),
        cframeMob = CFrame.new(1653.33349609375, 27.739702224731445, 4157.30859375)
    },
    {minLevel = 90, maxLevel = 99, world = 1,
        name = "SnowQuest",
        mobName = "Snow Bandit",
        levelQuest = 1,
        cframeQuest = CFrame.new(1398.8524169921875, 78.04167938232422, -1311.1799316406, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685),
        cframeMob = CFrame.new(1323.9677734375, 97.42578887939453, -1480.2110595703125)
    },
    {minLevel = 100, maxLevel = 119, world = 1,
        name = "SnowQuest",
        mobName = "Snowman",
        levelQuest = 2,
        cframeQuest = CFrame.new(1398.8524169921875, 78.04167938232422, -1311.1799316406, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685),
        cframeMob = CFrame.new(1361.5057373046875, 130.9940948486328, -1665.85009765625)
    },
    {minLevel = 120, maxLevel = 149, world = 1,
        name = "MarineQuest2",
        mobName = "Chief Petty Officer",
        levelQuest = 1,
        cframeQuest = CFrame.new(-4697.4267578125, 5.89398193359375, 4226.408203125, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-4716.41748046875, 64.20682525634766, 4320.4130859375)
    },
    {minLevel = 150, maxLevel = 174, world = 1,
        name = "SkyQuest",
        mobName = "Sky Bandit",
        levelQuest = 1,
        cframeQuest = CFrame.new(-4749.41552734375, 967.4083862304688, -744.0294189453125, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),
        cframeMob = CFrame.new(-5119.07958984375, 375.13201904296875, -1086.4410400390625)
    },
    {minLevel = 175, maxLevel = 189, world = 1,
        name = "SkyQuest",
        mobName = "Dark Master",
        levelQuest = 2,
        cframeQuest = CFrame.new(-4749.41552734375, 967.4083862304688, -744.0294189453125, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),
        cframeMob = CFrame.new(-5237.8134765625, 505.7674865722656, -286.4775695800781)
    },
    {minLevel = 190, maxLevel = 209, world = 1,
        name = "PrisonerQuest",
        mobName = "Prisoner",
        levelQuest = 1,
        cframeQuest = CFrame.new(5203.08642578125, 19.56385612487793, 737.2538452148438, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712),
        cframeMob = CFrame.new(5282.59326171875, 19.56382179260254, 518.71875)
    },
    {minLevel = 210, maxLevel = 249, world = 1,
        name = "PrisonerQuest",
        mobName = "Dangerous Prisoner",
        levelQuest = 2,
        cframeQuest = CFrame.new(5203.08642578125, 19.56385612487793, 737.2538452148438, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712),
        cframeMob = CFrame.new(5328.7880859375, 53.03626251220703, 636.2301025390625)
    },
    {minLevel = 250, maxLevel = 274, world = 1,
        name = "ColosseumQuest",
        mobName = "Toga Warrior",
        levelQuest = 1,
        cframeQuest = CFrame.new(-1344.2752685546875, 12.7493258476257324, -2927.0087890625, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298),
        cframeMob = CFrame.new(-1787.5328369140625, 62.33088302612305, -2825.187255859375)
    },
    {minLevel = 275, maxLevel = 299, world = 1,
        name = "ColosseumQuest",
        mobName = "Gladiator",
        levelQuest = 2,
        cframeQuest = CFrame.new(-1344.2752685546875, 12.7493258476257324, -2927.0087890625, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298),
        cframeMob = CFrame.new(-1179.4410400390625, 54.90968322753906, -3077.36865234375)
    },
    {minLevel = 300, maxLevel = 324, world = 1,
        name = "MagmaQuest",
        mobName = "Military Soldier",
        levelQuest = 1,
        cframeQuest = CFrame.new(-5313.0859375, 18.482173919677734, 8486.0830078125, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469),
        cframeMob = CFrame.new(-5550.291015625, 78.08203125, 8456.740234375)
    },
    {minLevel = 325, maxLevel = 374, world = 1,
        name = "MagmaQuest",
        mobName = "Military Spy",
        levelQuest = 2,
        cframeQuest = CFrame.new(-5313.0859375, 18.482173919677734, 8486.0830078125, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469),
        cframeMob = CFrame.new(-5880.8291015625, 99.12271881103516, 8803.958984375)
    },
    {minLevel = 375, maxLevel = 399, world = 1,
        name = "FishmanQuest",
        mobName = "Fishman Warrior",
        levelQuest = 1,
        cframeQuest = CFrame.new(61400.6015625, 24.94552993774414, 1628.64892578125),
        cframeMob = CFrame.new(60850.46484375, 71.20795440673828, 1575.6097412109375)
    },
    {minLevel = 400, maxLevel = 449, world = 1,
        name = "FishmanQuest",
        mobName = "Fishman Commando",
        levelQuest = 2,
        cframeQuest = CFrame.new(61400.6015625, 24.94552993774414, 1628.64892578125),
        cframeMob = CFrame.new(62043.515625, 53.59070587158203, 1307.4395751953125)
    },
    {minLevel = 450, maxLevel = 524, world = 1,
        name = "SkyExp1Quest",
        mobName = "God's Guard",
        levelQuest = 1,
        cframeQuest = CFrame.new(-4878.4521484375, 927.4027099609375, -1031.525146484375, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859),
        cframeMob = CFrame.new(-4295.556640625, 1116.7418212890625, -514.9412841796875)
    },
    {minLevel = 525, maxLevel = 549, world = 1,
        name = "SkyExp2Quest",
        mobName = "Royal Squad",
        levelQuest = 1,
        cframeQuest = CFrame.new(-7028.7177734375, 5591.91650390625, 1351.43951416015625, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-6801.28369140625, 5576.24560546875, 1256.010498046875)
    },
    {minLevel = 550, maxLevel = 624, world = 1,
        name = "SkyExp2Quest",
        mobName = "Royal Soldier",
        levelQuest = 2,
        cframeQuest = CFrame.new(-7028.7177734375, 5591.91650390625, 1351.43951416015625, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-7125.8720703125, 5575.5078125, 853.623779296875)
    },
    {minLevel = 625, maxLevel = 649, world = 1,
        name = "FountainQuest",
        mobName = "Galley Pirate",
        levelQuest = 1,
        cframeQuest = CFrame.new(5260.3017578125, 76.1012954711914, 4084.3828125, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381),
        cframeMob = CFrame.new(5481.30224609375, 114.91928100585938, 3906.6953125)
    },
    {minLevel = 650, maxLevel = 9999, world = 1,
        name = "FountainQuest",
        mobName = "Galley Captain",
        levelQuest = 2,
        cframeQuest = CFrame.new(5260.3017578125, 76.1012954711914, 4084.3828125, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381),
        cframeMob = CFrame.new(5599.130859375, 133.0387725830078, 4704.07666015625)
    },
    -- World 2
    {minLevel = 700, maxLevel = 724, world = 2,
        name = "Area1Quest",
        mobName = "Raider",
        levelQuest = 1,
        cframeQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985),
        cframeMob = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
    },
    {minLevel = 725, maxLevel = 774, world = 2,
        name = "Area1Quest",
        mobName = "Mercenary",
        levelQuest = 2,
        cframeQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985),
        cframeMob = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
    },
    {minLevel = 775, maxLevel = 799, world = 2,
        name = "Area2Quest",
        mobName = "Swan Pirate",
        levelQuest = 1,
        cframeQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906),
        cframeMob = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
    },
    {minLevel = 800, maxLevel = 874, world = 2,
        name = "Area2Quest",
        mobName = "Factory Staff",
        levelQuest = 2,
        cframeQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369),
        cframeMob = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
    },
    {minLevel = 875, maxLevel = 899, world = 2,
        name = "MarineQuest3",
        mobName = "Marine Lieutenant",
        levelQuest = 1,
        cframeQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),
        cframeMob = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
    },
    {minLevel = 900, maxLevel = 949, world = 2,
        name = "MarineQuest3",
        mobName = "Marine Captain",
        levelQuest = 2,
        cframeQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),
        cframeMob = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
    },
    {minLevel = 950, maxLevel = 974, world = 2,
        name = "ZombieQuest",
        mobName = "Zombie",
        levelQuest = 1,
        cframeQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146),
        cframeMob = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
    },
    {minLevel = 975, maxLevel = 999, world = 2,
        name = "ZombieQuest",
        mobName = "Vampire",
        levelQuest = 2,
        cframeQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146),
        cframeMob = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
    },
    {minLevel = 1000, maxLevel = 1049, world = 2,
        name = "SnowMountainQuest",
        mobName = "Snow Trooper",
        levelQuest = 1,
        cframeQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106),
        cframeMob = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
    },
    {minLevel = 1050, maxLevel = 1099, world = 2,
        name = "SnowMountainQuest",
        mobName = "Winter Warrior",
        levelQuest = 2,
        cframeQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106),
        cframeMob = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
    },
    {minLevel = 1100, maxLevel = 1124, world = 2,
        name = "IceSideQuest",
        mobName = "Lab Subordinate",
        levelQuest = 1,
        cframeQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578),
        cframeMob = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
    },
    {minLevel = 1125, maxLevel = 1174, world = 2,
        name = "IceSideQuest",
        mobName = "Horned Warrior",
        levelQuest = 2,
        cframeQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578),
        cframeMob = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
    },
    {minLevel = 1175, maxLevel = 1199, world = 2,
        name = "FireSideQuest",
        mobName = "Magma Ninja",
        levelQuest = 1,
        cframeQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),
        cframeMob = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
    },
    {minLevel = 1200, maxLevel = 1249, world = 2,
        name = "FireSideQuest",
        mobName = "Lava Pirate",
        levelQuest = 2,
        cframeQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),
        cframeMob = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
    },
    {minLevel = 1250, maxLevel = 1274, world = 2,
        name = "ShipQuest1",
        mobName = "Ship Deckhand",
        levelQuest = 1,
        cframeQuest = CFrame.new(1037.80127, 125.092171, 32911.6016),
        cframeMob = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)
    },
    {minLevel = 1275, maxLevel = 1299, world = 2,
        name = "ShipQuest1",
        mobName = "Ship Engineer",
        levelQuest = 2,
        cframeQuest = CFrame.new(1037.80127, 125.092171, 32911.6016),
        cframeMob = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)
    },
    {minLevel = 1300, maxLevel = 1324, world = 2,
        name = "ShipQuest2",
        mobName = "Ship Steward",
        levelQuest = 1,
        cframeQuest = CFrame.new(968.80957, 125.092171, 33244.125),
        cframeMob = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)
    },
    {minLevel = 1325, maxLevel = 1349, world = 2,
        name = "ShipQuest2",
        mobName = "Ship Officer",
        levelQuest = 2,
        cframeQuest = CFrame.new(968.80957, 125.092171, 33244.125),
        cframeMob = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
    },
    {minLevel = 1350, maxLevel = 1374, world = 2,
        name = "FrostQuest",
        mobName = "Arctic Warrior",
        levelQuest = 1,
        cframeQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909),
        cframeMob = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)
    },
    {minLevel = 1375, maxLevel = 1424, world = 2,
        name = "FrostQuest",
        mobName = "Snow Lurker",
        levelQuest = 2,
        cframeQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909),
        cframeMob = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
    },
    {minLevel = 1425, maxLevel = 1449, world = 2,
        name = "ForgottenQuest",
        mobName = "Sea Soldier",
        levelQuest = 1,
        cframeQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376),
        cframeMob = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
    },
    {minLevel = 1450, maxLevel = 9999, world = 2,
        name = "ForgottenQuest",
        mobName = "Water Fighter",
        levelQuest = 2,
        cframeQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376),
        cframeMob = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)
    },
    -- World 3
    {minLevel = 1500, maxLevel = 1524, world = 3,
        name = "PiratePortQuest",
        mobName = "Pirate Millionaire",
        levelQuest = 1,
        cframeQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627),
        cframeMob = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
    },
    {minLevel = 1525, maxLevel = 1574, world = 3,
        name = "PiratePortQuest",
        mobName = "Pistol Billionaire",
        levelQuest = 2,
        cframeQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627),
        cframeMob = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875)
    },
    {minLevel = 1575, maxLevel = 1599, world = 3,
        name = "DragonCrewQuest",
        mobName = "Dragon Crew Warrior",
        levelQuest = 1,
        cframeQuest = CFrame.new(6736.0146484375, 127.41270446777344, -712.7033081054688),
        cframeMob = CFrame.new(6994.86279296875, 98.9521713256836,-886.8801879882812)
    },
    {minLevel = 1600, maxLevel = 1624, world = 3,
        name = "DragonCrewQuest",
        mobName = "Dragon Crew Archer",
        levelQuest = 2,
        cframeQuest = CFrame.new(6736.0146484375, 127.41270446777344, -712.7033081054688),
        cframeMob = CFrame.new(6800.63232421875, 518.0557250976562, 227.6985321044922)
    },
    {minLevel = 1625, maxLevel = 1649, world = 3,
        name = "VenomCrewQuest",
        mobName = "Hydra Enforcer",
        levelQuest = 1,
        cframeQuest = CFrame.new(5211.62939453125, 1004.1000366210938, 756.85791015625),
        cframeMob = CFrame.new(4567.6982421875, 1147.8519287109375, 855.6863403320312)
    },
    {minLevel = 1650, maxLevel = 1699, world = 3,
        name = "VenomCrewQuest",
        mobName = "Venomous Assailant",
        levelQuest = 2,
        cframeQuest = CFrame.new(5211.62939453125, 1004.1000366210938, 756.85791015625),
        cframeMob = CFrame.new(4527.623046875, 1002.2584838867188, 444.6448669433594)
    },
    {minLevel = 1700, maxLevel = 1724, world = 3,
        name = "MarineTreeIsland",
        mobName = "Marine Commodore",
        levelQuest = 1,
        cframeQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747),
        cframeMob = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)
    },
    {minLevel = 1725, maxLevel = 1774, world = 3,
        name = "MarineTreeIsland",
        mobName = "Marine Rear Admiral",
        levelQuest = 2,
        cframeQuest = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813),
        cframeMob = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)
    },
    {minLevel = 1775, maxLevel = 1799, world = 3,
        name = "DeepForestIsland3",
        mobName = "Fishman Raider",
        levelQuest = 1,
        cframeQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),
        cframeMob = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
    },
    {minLevel = 1800, maxLevel = 1824, world = 3,
        name = "DeepForestIsland3",
        mobName = "Fishman Captain",
        levelQuest = 2,
        cframeQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),
        cframeMob = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)
    },
    {minLevel = 1825, maxLevel = 1849, world = 3,
        name = "DeepForestIsland",
        mobName = "Forest Pirate",
        levelQuest = 1,
        cframeQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247),
        cframeMob = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
    },
    {minLevel = 1850, maxLevel = 1899, world = 3,
        name = "DeepForestIsland",
        mobName = "Mythological Pirate",
        levelQuest = 2,
        cframeQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247),
        cframeMob = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
    },
    {minLevel = 1900, maxLevel = 1924, world = 3,
        name = "DeepForestIsland2",
        mobName = "Jungle Pirate",
        levelQuest = 1,
        cframeQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002),
        cframeMob = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
    },
    {minLevel = 1925, maxLevel = 1974, world = 3,
        name = "DeepForestIsland2",
        mobName = "Musketeer Pirate",
        levelQuest = 2,
        cframeQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002),
        cframeMob = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
    },
    {minLevel = 1975, maxLevel = 1999, world = 3,
        name = "HauntedQuest1",
        mobName = "Reborn Skeleton",
        levelQuest = 1,
        cframeQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        cframeMob = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
    },
    {minLevel = 2000, maxLevel = 2024, world = 3,
        name = "HauntedQuest1",
        mobName = "Living Zombie",
        levelQuest = 2,
        cframeQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        cframeMob = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
    },
    {minLevel = 2025, maxLevel = 2049, world = 3,
        name = "HauntedQuest2",
        mobName = "Demonic Soul",
        levelQuest = 1,
        cframeQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
    },
    {minLevel = 2050, maxLevel = 2074, world = 3,
        name = "HauntedQuest2",
        mobName = "Posessed Mummy",
        levelQuest = 2,
        cframeQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
    },
    {minLevel = 2075, maxLevel = 2099, world = 3,
        name = "NutsIslandQuest",
        mobName = "Peanut Scout",
        levelQuest = 1,
        cframeQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
    },
    {minLevel = 2100, maxLevel = 2124, world = 3,
        name = "NutsIslandQuest",
        mobName = "Peanut President",
        levelQuest = 2,
        cframeQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
    },
    {minLevel = 2125, maxLevel = 2149, world = 3,
        name = "IceCreamIslandQuest",
        mobName = "Ice Cream Chef",
        levelQuest = 1,
        cframeQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
    },
    {minLevel = 2150, maxLevel = 2199, world = 3,
        name = "IceCreamIslandQuest",
        mobName = "Ice Cream Commander",
        levelQuest = 2,
        cframeQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0),
        cframeMob = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
    },
    {minLevel = 2200, maxLevel = 2224, world = 3,
        name = "CakeQuest1",
        mobName = "Cookie Crafter",
        levelQuest = 1,
        cframeQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931),
        cframeMob = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
    },
    {minLevel = 2225, maxLevel = 2249, world = 3,
        name = "CakeQuest1",
        mobName = "Cake Guard",
        levelQuest = 2,
        cframeQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931),
        cframeMob = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
    },
    {minLevel = 2250, maxLevel = 2274, world = 3,
        name = "CakeQuest2",
        mobName = "Baking Staff",
        levelQuest = 1,
        cframeQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446),
        cframeMob = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
    },
    {minLevel = 2275, maxLevel = 2299, world = 3,
        name = "CakeQuest2",
        mobName = "Head Baker",
        levelQuest = 2,
        cframeQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446),
        cframeMob = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
    },
    {minLevel = 2300, maxLevel = 2324, world = 3,
        name = "ChocQuest1",
        mobName = "Cocoa Warrior",
        levelQuest = 1,
        cframeQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375),
        cframeMob = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
    },
    {minLevel = 2325, maxLevel = 2349, world = 3,
        name = "ChocQuest1",
        mobName = "Chocolate Bar Battler",
        levelQuest = 2,
        cframeQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375),
        cframeMob = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
    },
    {minLevel = 2350, maxLevel = 2374, world = 3,
        name = "ChocQuest2",
        mobName = "Sweet Thief",
        levelQuest = 1,
        cframeQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875),
        cframeMob = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
    },
    {minLevel = 2375, maxLevel = 2399, world = 3,
        name = "ChocQuest2",
        mobName = "Candy Rebel",
        levelQuest = 2,
        cframeQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875),
        cframeMob = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
    },
    {minLevel = 2400, maxLevel = 2424, world = 3,
        name = "CandyQuest1",
        mobName = "Candy Pirate",
        levelQuest = 1,
        cframeQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375),
        cframeMob = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
    },
    {minLevel = 2425, maxLevel = 2449, world = 3,
        name = "CandyQuest1",
        mobName = "Snow Demon",
        levelQuest = 2,
        cframeQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375),
        cframeMob = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)
    },
    {minLevel = 2450, maxLevel = 2474, world = 3,
        name = "TikiQuest1",
        mobName = "Isle Outlaw",
        levelQuest = 1,
        cframeQuest = CFrame.new(-16545.9355, 55.6863556, -173.230499),
        cframeMob = CFrame.new(-16120.6035, 116.520554, -103.038849)
    },
    {minLevel = 2475, maxLevel = 2499, world = 3,
        name = "TikiQuest1",
        mobName = "Island Boy",
        levelQuest = 2,
        cframeQuest = CFrame.new(-16545.9355, 55.6863556, -173.230499),
        cframeMob = CFrame.new(-16751.3125, 121.226219, -264.015015)
    },
    {minLevel = 2500, maxLevel = 2524, world = 3,
        name = "TikiQuest2",
        mobName = "Sun-kissed Warrior",
        levelQuest = 1,
        cframeQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625),
        cframeMob = CFrame.new(-16294.6748, 32.7874393, 1062.4856)
    },
    {minLevel = 2525, maxLevel = 2549, world = 3,
        name = "TikiQuest2",
        mobName = "Isle Champion",
        levelQuest = 2,
        cframeQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625),
        cframeMob = CFrame.new(-16933.2129, 93.3503036, 999.450989)
    },
    {minLevel = 2550, maxLevel = 2574, world = 3,
        name = "TikiQuest3",
        mobName = "Serpent Hunter",
        levelQuest = 1,
        cframeQuest = CFrame.new(-16665.216, 105.284, 1575.768),
        cframeMob = CFrame.new(-16534.2129, 97.3503036, 1602.450989)
    },
    {minLevel = 2575, maxLevel = 9999, world = 3,
        name = "TikiQuest3",
        mobName = "Skull Slayer",
        levelQuest = 2,
        cframeQuest = CFrame.new(-16665.216, 105.284, 1575.768),
        cframeMob = CFrame.new(-16718.2129, 144.3503036, 1649.450989)
    }
}

function getQuestConfig()
    local currentLevel = LocalPlayer.Data.Level.Value
    local currentWorld = World
    local bestConfig = nil
    local bestMinLevel = 0
    
    for _, config in ipairs(QuestConfig) do
        if config.world == currentWorld and currentLevel >= config.minLevel and config.minLevel > bestMinLevel then
            bestConfig = config
            bestMinLevel = config.minLevel
        end
    end
    
    return bestConfig
end

spawn(function()
    while task.wait() do
        if not _G.AutoFarm then continue end
        
        pcall(function()
            if not _G.SafeKillaura then
                _G.Killaura = true
            else
                _G.Killaura = false
            end
            _G.Noclip = true
            _G.Clip = true
            local currentConfig = getQuestConfig()
            local correctQuest = false

            if LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame") then
                local questTitle = LocalPlayer.PlayerGui.TrackedQuestFrame.Frame.description.Text
                correctQuest = string.find(questTitle, currentConfig.mobName, 1, true) ~= nil
            end

            if not correctQuest then
                if LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                    task.wait(0.1)
                end
                topos(currentConfig.cframeQuest)
                task.wait(0.1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentConfig.name, currentConfig.levelQuest)
            end

            local bestMob  = findEnemy(currentConfig.mobName)
            local offset = _G.KillOffset
            if bestMob  then
                if _G.BringMob then
                    topos(bestMob.HumanoidRootPart.CFrame + offset)
                end
                while bestMob 
                    and bestMob.Parent 
                    and bestMob:FindFirstChild("Humanoid") 
                    and bestMob.Humanoid.Health > 0 
                    and bestMob:FindFirstChild("HumanoidRootPart")
                    and _G.AutoFarm
                do
                    if not _G.BringMob then
                        topos(bestMob.HumanoidRootPart.CFrame + offset)
                    end
                    EquipWeapon(_G.SelectWeapon)
                    AutoHaki()
                    if _G.BringMob then
                        BringNearbyMobs(currentConfig.mobName, bestMob.HumanoidRootPart.CFrame)
                    end
                    if _G.SafeKillaura then
                        PerformFastAttack(bestMob)
                        task.wait(0.08)
                    end
                    task.wait()
                end
            else
                topos(currentConfig.cframeMob)
                task.wait()
            end
            _G.Clip = false
            _G.Noclip = false
            _G.Killaura = false
        end)
    end
end)

spawn(function()
    while task.wait() do
        if not _G.Lumen then continue end
        
        pcall(function()
            if not _G.SafeKillaura then
                _G.Killaura = true
            else
                _G.Killaura = false
            end
            _G.Noclip = true
            _G.Clip = true

            local bestMob  = findNearestEnemy()
            local offset = _G.KillOffset
            if _G.BringAllMob then
                topos(bestMob.HumanoidRootPart.CFrame + offset)
            end
            while bestMob 
                and bestMob.Parent 
                and bestMob:FindFirstChild("Humanoid") 
                and bestMob.Humanoid.Health > 0 
                and bestMob:FindFirstChild("HumanoidRootPart")
                and _G.Lumen
            do
                if not _G.BringAllMob then
                    topos(bestMob.HumanoidRootPart.CFrame + offset)
                end
                EquipWeapon(_G.SelectWeapon)
                AutoHaki()
                if _G.BringAllMob then
                    BringAllMobs(bestMob.HumanoidRootPart.CFrame)
                end
                if _G.SafeKillaura then
                    PerformFastAttack(bestMob)
                    task.wait(0.08)
                end
                task.wait()
            end
            _G.Noclip = false
            _G.Clip = false
            _G.Killaura = false
        end)
    end
end)


if World1 then
    _G.AllSelectedMob = {
        "Bandit",
        "Monkey",
        "Gorilla",
        "Pirate",
        "Brute",
        "Desert Bandit",
        "Desert Officer",
        "Snow Bandit",
        "Snowman",
        "Chief Petty Officer",
        "Sky Bandit",
        "Dark Master",
        "Prisoner",
        "Dangerous Prisoner",
        "Toga Warrior",
        "Gladiator",
        "Military Soldier",
        "Military Spy",
        "Fishman Warrior",
        "Fishman Commando",
        "God's Guard",
        "Royal Squad",
        "Royal Soldier",
        "Galley Pirate",
        "Galley Captain",
    }
end
if World2 then
    _G.AllSelectedMob = {
        "Raider",
        "Mercenary",
        "Swan Pirate",
        "Factory Staff",
        "Marine Lieutenant",
        "Marine Captain",
        "Zombie",
        "Vampire",
        "Snow Trooper",
        "Winter Warrior",
        "Lab Subordinate",
        "Horned Warrior",
        "Magma Ninja",
        "Lava Pirate",
        "Ship Deckhand",
        "Ship Engineer",
        "Ship Steward",
        "Ship Officer",
        "Arctic Warrior",
        "Snow Lurker",
        "Sea Soldier",
        "Water Fighter",
    }
end
if World3 then
    _G.AllSelectedMob = {
        "Pirate Millionaire",
        "Pistol Billionaire",
        "Dragon Crew Warrior",
        "Dragon Crew Archer",
        "Female Islander",
        "Giant Islander",
        "Marine Commodore",
        "Marine Rear Admiral",
        "Fishman Raider",
        "Fishman Captain",
        "Forest Pirate",
        "Mythological Pirate",
        "Jungle Pirate",
        "Musketeer Pirate",
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Posessed Mummy",
        "Peanut Scout",
        "Peanut President",
        "Ice Cream Chef",
        "Ice Cream Commander",
        "Cookie Crafter",
        "Cake Guard",
        "Baking Staff",
        "Head Baker",
        "Cocoa Warrior",
        "Chocolate Bar Battler",
        "Sweet Thief",
        "Candy Rebel",
        "Candy Pirate",
        "Snow Demon",
        "Isle Outlaw",
        "Island Boy",
        "Sun-kissed Warrior",
        "Isle Champion",
    }
end

function getMobQuestConfig()
    local currentLevel = LocalPlayer.Data.Level.Value
    local currentWorld = World
    local bestConfig = nil
    local bestMinLevel = 0
    
    for _, config in ipairs(QuestConfig) do
        if config.world == currentWorld 
            and currentLevel >= config.minLevel 
            and config.minLevel > bestMinLevel 
            and config.mobName == _G.CurrentSelectedMob 
        then
            bestConfig = config
            bestMinLevel = config.minLevel
        end
    end
    
    return bestConfig
end

spawn(function()
    while task.wait() do
        if not _G.KillMobByName then continue end
        
        pcall(function()

            if _G.GetMobQuest then
                local currentConfig = getMobQuestConfig()
                local correctQuest = false

                if LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame") then
                    local questTitle = LocalPlayer.PlayerGui.TrackedQuestFrame.Frame.description.Text
                    correctQuest = string.find(questTitle, currentConfig.mobName) ~= nil
                end

                if not correctQuest then
                    if LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        task.wait(0.1)
                    end
                    topos(currentConfig.cframeQuest)
                    task.wait(0.1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentConfig.name, currentConfig.levelQuest)
                end
            end
            if not _G.SafeKillaura then
                _G.Killaura = true
            else
                _G.Killaura = false
            end
            _G.Noclip = true
            _G.Clip = true
            local bestMob  = findEnemy(_G.CurrentSelectedMob)
            local offset = _G.KillOffset
            if bestMob then
                while bestMob 
                    and bestMob.Parent 
                    and bestMob:FindFirstChild("Humanoid") 
                    and bestMob.Humanoid.Health > 0 
                    and bestMob:FindFirstChild("HumanoidRootPart")
                    and _G.KillMobByName
                do
                    topos(bestMob.HumanoidRootPart.CFrame + offset)
                    EquipWeapon(_G.SelectWeapon)
                    AutoHaki()
                    if _G.BringMob then
                        BringNearbyMobs(_G.CurrentSelectedMob, bestMob.HumanoidRootPart.CFrame)
                    end
                    if _G.SafeKillaura then
                        PerformFastAttack(bestMob)
                        task.wait(0.08)
                    end
                    task.wait()
                end
            else
                topos(currentConfig.cframeMob)
                task.wait()
            end
            _G.Noclip = false
            _G.Clip = false
            _G.Killaura = false
        end)
    end
end)

local function DistanceFromPlrSort(ObjectList)
    local hrp = LocalPlayer.Character:FindFirstChild("LowerTorso") or LocalPlayer.Character.HumanoidRootPart
    table.sort(ObjectList, function(a, b)
        local rp = hrp.Position
        return (rp - a.Position).Magnitude < (rp - b.Position).Magnitude
    end)
end

local function getChestsSorted()
    if FirstRun then
        FirstRun = false
        for _, obj in ipairs(game:GetDescendants()) do
            if obj.Name:find("Chest") and obj.ClassName == "Part" then
                table.insert(UncheckedChests, obj)
            end
        end
    end

    local chests = {}
    for _, chest in ipairs(UncheckedChests) do
        if chest and chest.Parent and chest:FindFirstChild("TouchInterest") then
            table.insert(chests, chest)
        end
    end

    DistanceFromPlrSort(chests)
    return chests
end

spawn(function()
    while task.wait(1) do
        if not _G.AutoChestFarm then continue end

        pcall(function()
            local chests = getChestsSorted()
            if #chests > 0 then
                local chest = chests[1]
                if chest and chest.Parent and GetDistance(chest.CFrame) <= 6000 then
                    topos(chest.CFrame)
                end
            else
                task.wait(1)
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1.5)
        if _G.AutoStats and Remotes.CommF_ then
            pcall(function()
                local points = LocalPlayer.Data:FindFirstChild("Points") and LocalPlayer.Data.Points.Value or 0
                if points > 0 then
                    local chunk = math.min(points, _G.PointStats)
                    for statName, isEnabled in pairs(_G.StatsToUpgrade) do
                        if isEnabled and points > 0 then
                            Remotes.CommF_:InvokeServer("AddPoint", statName, chunk)
                            task.wait(0.08)
                        end
                    end
                end
            end)
        end
    end
end)

function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)

function UpdateMobsChams()
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    for _, v in pairs(enemiesFolder:GetChildren()) do
        pcall(function()
            if _G.MobsESP then 
                if not v:FindFirstChild('NameEsp') then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name = 'NameEsp'
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = "GothamBold"
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(152, 236, 7)
                else
                    v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude/3) ..' Distance')
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function UpdateIslandESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if _G.IslandESP then 
                if v.Name ~= "Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(7, 236, 240)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function UpdatePlayerChams()
    for i,v in pairs(game:GetService'Players':GetChildren()) do
        pcall(function()
            if not isnil(v.Character) then
                if _G.PlayersESP then
                    if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v.Character.Head)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance')
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Team == game.Players.LocalPlayer.Team then
                            name.TextColor3 = Color3.new(0,255,0)
                        else
                            name.TextColor3 = Color3.new(255,0,0)
                        end
                    else
                        v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                    end
                else
                    if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                        v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateChestChams()
    for i, v in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") and string.find(v.Name, "Chest") and v:FindFirstChild("TouchInterest") then
                if _G.ChestESP then
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Name == "Chest1" then
                            name.TextColor3 = Color3.fromRGB(109, 109, 109)
                            name.Text = ("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name == "Chest2" then
                            name.TextColor3 = Color3.fromRGB(173, 158, 21)
                            name.Text = ("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name == "Chest3" then
                            name.TextColor3 = Color3.fromRGB(85, 255, 255)
                            name.Text = ("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                else
                    if v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end
        end)
    end
end

local newEspCount = 0
local newEspNames  = {}
function UpdateDevilChams()
    newEspCount = 0
    newEspNames = {}
    for i, v in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if _G.FruitESP then
                if string.find(v.Name, "Fruit") then
                    if not v.Handle:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui', v.Handle)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true

                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')

                        newEspCount = newEspCount + 1
                        table.insert(newEspNames, v.Name)
                    else
                        v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end)
    end

    if newEspCount > 0 then
        SendDiscordWebhook(
            "Обнаружены фрукты", "Создан ESP для **" .. newEspCount .. "** фрукт(ов):\n" .. "`" .. table.concat(newEspNames, "`, `") .. "`", 65280,
            {
                {name = "Всего ESP создано", value = tostring(newEspCount), inline = true},
                {name = "Время", value = os.date("%H:%M:%S"), inline = true}
            }
        )
    end
end
function UpdateFlowerChams() 
    for i,v in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if _G.FlowerESP then 
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        if v.Name == "Flower1" then 
                            name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                            name.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if v.Name == "Flower2" then
                            name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                            name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                else
                    if v:FindFirstChild('NameEsp'..Number) then
                    v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end   
        end)
    end
end
function UpdateRealFruitChams() 
    for i,v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if _G.RealFruitESP then 
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end 
        end
    end
    for i,v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if _G.RealFruitESP then 
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 174, 0)
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end 
        end
    end
    for i,v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if _G.RealFruitESP then 
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(57, 255, 42)
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end 
        end
    end
end
function UpdateAfdESP() 
    for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        pcall(function()
            if _G.AfdESP then 
                if v.Name == "Advanced Fruit Dealer" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
LsdCount = 0
function UpdateLsdESP() 
    for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        pcall(function()
            if _G.LsdESP then 
                if v.Name == "Legendary Sword Dealer" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        LsdCount = LsdCount + 1
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
        if LsdCount > 0 then
            SendDiscordWebhook(
                "Обнаружен Legendary Sword Dealer", "Создан ESP для LSD", 65280,
                {
                    {name = "Время", value = os.date("%H:%M:%S"), inline = true}
                }
            )
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        UpdateChestChams()
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        UpdateDevilChams() 
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        UpdateIslandESP() 
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        UpdatePlayerChams() 
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        UpdateMobsChams() 
    end
end)

if World2 then
    task.spawn(function()
        while task.wait(0.1) do
            UpdateFlowerChams() 
        end
    end)
    task.spawn(function()
        while task.wait(0.1) do
            UpdateLsdESP()
        end
    end)
end

if World3 then
    task.spawn(function()
        while task.wait(0.1) do
            UpdateAfdESP() 
        end
    end)
    task.spawn(function()
        while task.wait(0.1) do
            UpdateRealFruitChams() 
        end
    end)
end



spawn(function()
    pcall(function()
        while wait(0.5) do
            for i = 1, 5 do
                if game.Workspace._WorldOrigin.Locations:FindFirstChild('Island ' .. i) then
                    checkisland = i
                end
            end
        end
    end)
end)

function getRaidMap()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    local raidMap = map:FindFirstChild("RaidMap")
    return raidMap
end

spawn(function()
    pcall(function()
        while wait(0.5) do
            if _G.AutoBuyChip then
                if not LocalPlayer.Backpack:FindFirstChild("Special Microchip") or not LocalPlayer.Character:FindFirstChild("Special Microchip") then
                    if not getRaidMap():FindFirstChild("Island 1") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    end
                end
            end
        end
    end)
end)

local RaidPos = Vector3.new(0,80,0)
function getRaidIslandPart(index)
    local raidMap = getRaidMap()
    if not raidMap then return nil, nil end

    local model = raidMap:FindFirstChild("RaidIsland" .. index)
    if not model or not model:IsA("Model") then return nil, nil end

    local mainPart = model.PrimaryPart
    if not mainPart then
        mainPart = model:FindFirstChildWhichIsA("BasePart", true)
    end

    return mainPart, model
end

function getMaxRaidIndex()
    local raidMap = getRaidMap()
    if not raidMap then return 0 end
    local maxIndex = 0
    for _, child in ipairs(raidMap:GetChildren()) do
        local n = child.Name:match("^RaidIsland(%d+)$")
        if n then
            n = tonumber(n)
            if n > maxIndex then
                maxIndex = n
            end
        end
    end
    return maxIndex
end

spawn(function()
    while task.wait() do
        if not _G.LumenRaid then continue end
        
        pcall(function()
            if not _G.SafeKillaura then
                _G.Killaura = true
            else
                _G.Killaura = false
            end
            local bestMob  = findNearestEnemy()
            local offset = _G.KillOffset
            while bestMob 
                and bestMob.Parent 
                and bestMob:FindFirstChild("Humanoid") 
                and bestMob.Humanoid.Health > 0 
                and bestMob:FindFirstChild("HumanoidRootPart")
                and _G.LumenRaid
            do
                topos(bestMob.HumanoidRootPart.CFrame + offset)
                EquipWeapon(_G.SelectWeapon)
                AutoHaki()
                if _G.BringAllMob then
                    BringAllMobs(bestMob.HumanoidRootPart.CFrame)
                end
                if _G.SafeKillaura then
                    PerformFastAttack(bestMob)
                    task.wait(0.08)
                end
                task.wait()
            end
            _G.Killaura = false
        end)
    end
end)

function raidLoop()
    -- Сохраняем состояние
    local lastRaidIndex, maxIslands = 1, 0
    local raidStarted, raidCompleted = false, false
    local REQUIRED_ISLANDS = 5
    
    _G.Noclip, _G.Clip, _G.LumenRaid = true, true, true
    
    while _G.Auto_Raid and LocalPlayer.Character.Humanoid.Health > 0 do
        pcall(function()
            local raidMap = getRaidMap()
            local hasRaid = raidMap and #raidMap:GetChildren() > 0
            
            if hasRaid then
                if not raidStarted then
                    raidStarted, maxIslands, lastRaidIndex = true, 0, 1
                end
                
                local maxIndex = getMaxRaidIndex()
                if maxIndex > maxIslands then maxIslands = maxIndex end
                
                if maxIndex > lastRaidIndex then
                    local part = getRaidIslandPart(lastRaidIndex + 1)
                    if part and GetDistance(part) <= 3000 then
                        lastRaidIndex = lastRaidIndex + 1
                        _G.LumenRaid = false
                        _G.TweenSpeed = _G.SaveTweenSpeed
                        topos(part.CFrame + RaidPos)
                        task.wait(0.15)
                        _G.TweenSpeed = _G.RaidTweenSpeed
                        _G.LumenRaid = true
                    end
                end
            elseif raidStarted then
                -- Карта исчезла — рейд закончился
                if maxIslands >= REQUIRED_ISLANDS then
                    raidCompleted = true
                end
                raidStarted, maxIslands, lastRaidIndex = false, 0, 1
            end
        end)
        
        if raidCompleted then break end
        task.wait(0.2)
    end

    if raidCompleted then
        _G.RaidCount = (_G.RaidCount or 0) + 1
        SendDiscordWebhook("Raid", "Raid успешно пройден", 16711680, {
            {name = "Имя персонажа", value = LocalPlayer.Name, inline = true},
            {name = "Номер рейда", value = tostring(_G.RaidCount), inline = true}
        })
    end
    
    _G.Noclip = false
    _G.Clip = false
    _G.LumenRaid = false
    _G.Auto_Raid = false
    
    if _G.RaidToggleOff then _G.RaidToggleOff() end
end

spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.Auto_Awakener then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener","Check")
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener","Awaken")
            end
        end
    end)
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoStoreFruit and Remotes.CommF_ then
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and string.find(tool.Name, "Fruit") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Store", tool.Name)
                    task.wait(0.5)
                end
            end
        end
    end
end)


_G.Auto_Dungeon = false
_G.DungeonFindRange = 700

spawn(function()
    while task.wait() do
        if not _G.Auto_Dungeon then continue end
        
        pcall(function()
            local dungeonMap = workspace.Map:FindFirstChild("Dungeon")
            if not dungeonMap then return end
            
            local roomNumbers = {}
            for _, child in ipairs(dungeonMap:GetChildren()) do
                local num = tonumber(child.Name)
                if num then
                    table.insert(roomNumbers, num)
                end
            end
            table.sort(roomNumbers)
            
            if #roomNumbers == 0 then return end
            
            local currentRoomNumber = roomNumbers[1]
            local currentRoom = dungeonMap:FindFirstChild(tostring(currentRoomNumber))
            if not currentRoom then return end
            
            _G.Lumen = true
            _G.Noclip = true
            _G.Clip = true
            
            local bestMob = findNearestEnemy()
            if bestMob then
                local offset = _G.KillOffset
                topos(bestMob.HumanoidRootPart.CFrame + offset)
                EquipWeapon(_G.SelectWeapon)
                AutoHaki()
                if _G.BringAllMob then
                    BringAllMobs(bestMob.HumanoidRootPart.CFrame)
                end
            else
                local nearestMob = findNearestEnemy()
                local distanceToMob = _G.DungeonFindRange
                if nearestMob and nearestMob:FindFirstChild("HumanoidRootPart") then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        distanceToMob = (nearestMob.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    end
                end
                
                if distanceToMob > 700 then
                    local prevRoomNumber = nil
                    for i = #roomNumbers, 1, -1 do
                        if roomNumbers[i] < currentRoomNumber then
                            prevRoomNumber = roomNumbers[i]
                            break
                        end
                    end
                    
                    if prevRoomNumber then
                        local prevRoom = dungeonMap:FindFirstChild(tostring(prevRoomNumber))
                        if prevRoom and prevRoom:FindFirstChild("EntranceTeleporter") 
                            and prevRoom.EntranceTeleporter:FindFirstChild("Root") then
                            topos(prevRoom.EntranceTeleporter.Root.CFrame)
                        end
                    end
                else
                    if currentRoom:FindFirstChild("ExitTeleporter") 
                        and currentRoom.ExitTeleporter:FindFirstChild("Root") then
                        topos(currentRoom.ExitTeleporter.Root.CFrame)
                    end
                end
            end
            
            _G.Lumen = false
            _G.Noclip = false
            _G.Clip = false

        end)
    end
end)



local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/tygyfy/ParasmaHub/refs/heads/main/BF_grind.lua"))()

local Window = Gui:CreateWindow({
    Title = "Parasma",
    Version = "ULTIMATE v2.1",
    Size = UDim2.new(0, 720, 0, 440),
    Position = UDim2.new(0.5, -360, 0.5, -220),
    EnableKeySystem = true, -- или true
    MasterKeys = {"PARASMA_VIP"},
    ShowFloatingButton = true,
    MenuKeybind = Enum.KeyCode.RightControl
})

local infoTab = Window:CreateTab("INFO TAB", "")
infoTab:AddSection("Info")
infoTab:AddLabel("Version: 2.1")
infoTab:AddToggle("Webhook System", true, function(Value)
    _G.EnableWebhook = Value
end)
infoTab:AddButton("Server Hop", function(Value)
    Hop()
    Window:Notify("Server hop", "Looking for servers...", 3)
end)
infoTab:AddButton("Redeem All codes", function(Value)
    RedeemCodes()
    Window:Notify("Redeem codes", "All codes has been redeemed", 3)
end)
infoTab:AddButton("Reboot Service", function(Value)
    _G.TweenSpeed = 200
    _G.CurrentTween = nil
    _G.CancelFlight = false
    _G.Noclip = false
    _G.Clip = false
    _G.Killaura = false
    _G.AuraRange = 60
    _G.KillOffsetX = 0
    _G.KillOffsetY = 30
    _G.KillOffsetZ = 0
    _G.KillOffset = Vector3.new(_G.KillOffsetX, _G.KillOffsetY, _G.KillOffsetZ)
    _G.SelectWeapon = "Melee"
    _G.AutoBuso = true
    _G.BringMob = false
    _G.BringAllMob = false
    _G.BringDistance = 500
    _G.NotAutoEquip = false
    _G.FindRange = 6000
    _G.V4 = true
    _G.AutoFarm = false
    _G.SelectedMob = {}
    _G.KillMobByName = false
    _G.GetMobQuest = false
    _G.Lumen = false
    _G.AutoChestFarm = false
    _G.AutoStats = false
    _G.PointStats = 3
    _G.StatsToUpgrade = {
        ["Melee"] = false,
        ["Defense"] = false,
        ["Sword"] = false,
        ["Gun"] = false,
        ["Blox Fruit"] = false
    }
    _G.ESP_Players = false
    _G.ESP_Fruits = false
    _G.ESP_Chests = false
    _G.ESP_Mobs = false
    _G.AutoBuyChip = false
    _G.Auto_Raid = false
    _G.LumenRaid = false
    _G.Auto_Awakener = false
    _G.AutoFarmMastery = false
    _G.SelectWeaponMastery = "Melee"
    _G.AutoSkillZ = false
    _G.AutoSkillX = false
    _G.AutoSkillC = false
    _G.AutoSkillV = false
    _G.AutoSkillF = false
    _G.PercentFarm = 25
end)

local LocalPlayerTab = Window:CreateTab("LOCAL PLAYER", "")
LocalPlayerTab:AddSection("Debug buttons")
LocalPlayerTab:AddToggle("Noclip", false, function(Value)
    _G.Noclip = Value
end)
LocalPlayerTab:AddToggle("Clip", false, function(Value)
    _G.Clip = Value
end)
LocalPlayerTab:AddButton("Cancel Flight", function(Value)
    cancelFlight()
    Window:Notify("Cancel flight", "Current fly has been removed", 3)
end)

local MainFarm = Window:AddTab("MAIN FARM")
MainFarm:AddSection("Auto Farm")
MainFarm:AddToggle("Auto Farm Level", false, function(Value)
    _G.AutoFarm = Value
end)
MainFarm:AddToggle("Kill the nearest", false, function(Value)
    _G.Lumen= Value
end)
MainFarm:AddToggle("Kill current mob", false, function(Value)
    _G.KillMobByName = Value
end)
MainFarm:AddDropdown("Select current mob", _G.AllSelectedMob, "Select mob", function(Value)
    _G.CurrentSelectedMob = Value
end)
MainFarm:AddToggle("Get quest for mob", false, function(Value)
    _G.GetMobQuest = Value
end)
MainFarm:AddLabel("Other Settings")
MainFarm:AddToggle("Auto Turn On Race v4", true, function(Value)
    _G.V4 = Value
end)
MainFarm:AddSection("Collect")
MainFarm:AddToggle("Auto collect chests", false, function(Value)
    _G.AutoChestFarm = Value
end)
MainFarm:AddToggle("Auto collect fruits", false, function(Value)
    _G.AutoFruit = Value
end)
MainFarm:AddToggle("Auto store fruit", false, function(Value)
    _G.AutoStoreFruit = Value
end)

local KillauraSettings = Window:CreateTab("Killaura Settings", "")
KillauraSettings:AddLabel("Killaura")
KillauraSettings:AddToggle("Killaura", false, function(Value)
    _G.Killaura = Value
end)
KillauraSettings:AddToggle("Killaura (Safe Tween)", false, function(Value)
    _G.SafeKillaura = Value
end)
KillauraSettings:AddLabel("Settings")
KillauraSettings:AddSlider("Aura Range", 1, 100, 60, function(Value)
    _G.AuraRange = tonumber(Value)
end)
KillauraSettings:AddDropdown("Select Weapon", {"Melee", "Sword", "Fruit", "Gun"}, "Melee", function(Value)
    _G.SelectWeapon = Value
end)
KillauraSettings:AddToggle("Bring mobs", false, function(Value)
    _G.BringMob = Value
    _G.BringAllMob = Value
end)
KillauraSettings:AddSlider("Bring mob Radius", 1, 1000, 350, function(Value)
    _G.BringDistance = tonumber(Value)
end)
KillauraSettings:AddToggle("Auto Buso Haki", true, function(Value)
    _G.AutoBuso = Value
end)
KillauraSettings:AddSlider("Fly Speed",100 , 1500, 200, function(Value)
    _G.TweenSpeed = tonumber(Value)
    _G.SaveTweenSpeed = tonumber(Value)
end)
KillauraSettings:AddSlider("Offset X", -100, 100, 0, function(Value)
    _G.KillOffsetX = tonumber(Value)
    _G.KillOffset = Vector3.new(_G.KillOffsetX, _G.KillOffsetY, _G.KillOffsetZ)
end)
KillauraSettings:AddSlider("Offset Y", -100, 100, 30, function(Value)
    _G.KillOffsetY = tonumber(Value)
    _G.KillOffset = Vector3.new(_G.KillOffsetX, _G.KillOffsetY, _G.KillOffsetZ)
end)
KillauraSettings:AddSlider("Offset Z", -100, 100, 0, function(Value)
    _G.KillOffsetZ = tonumber(Value)
    _G.KillOffset = Vector3.new(_G.KillOffsetX, _G.KillOffsetY, _G.KillOffsetZ)
end)

local Stats = Window:CreateTab("AUTO STATS", "")
Stats:AddToggle("Auto Stats", false, function(Value)
    _G.AutoStats = Value
end)
Stats:AddTextbox("Stat Point", "recommend 3", "3", function(Value)
    _G.PointStats = tonumber(Value)
end)
Stats:AddToggle("Auto Stats Melee", false, function(Value)
    _G.StatsToUpgrade["Melee"] = Value
end)
Stats:AddToggle("Auto Stats Defense", false, function(Value)
    _G.StatsToUpgrade["Defense"] = Value
end)
Stats:AddToggle("Auto Stats Sword", false, function(Value)
    _G.StatsToUpgrade["Sword"] = Value
end)
Stats:AddToggle("Auto Stats Gun", false, function(Value)
    _G.StatsToUpgrade["Gun"] = Value
end)
Stats:AddToggle("Auto Stats Fruit", false, function(Value)
    _G.StatsToUpgrade["Demon Fruit"] = Value
end)
Stats:AddButton("Refund Stats[2,500 fragment]", function(Value)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
    Window:Notify("Stat refund", "Your stats has been refunded", 3)
end)
Stats:AddButton("Race Random[3,000 fragment]", function(Value)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
    Window:Notify("Reroll race", "Your race has been changed", 3)
end)

local ESP = Window:CreateTab("ESP", "")
ESP:AddToggle("Chests ESP", false, function(Value)
    _G.ChestESP = Value
end)
ESP:AddToggle("Fruit ESP", false, function(Value)
    _G.FruitESP = Value
end)
ESP:AddToggle("Islands ESP", false, function(Value)
    _G.IslandESP = Value
end)
ESP:AddToggle("Players ESP", false, function(Value)
    _G.PlayersESP = Value
end)
ESP:AddToggle("Mobs ESP", false, function(Value)
    _G.MobsESP = Value
end)
if World2 then
    ESP:AddToggle("Flower ESP", false, function(Value)
        _G.FlowerESP = Value
    end)
    ESP:AddToggle("Legendary Sword Dealer ESP", false, function(Value)
        LsdESP = Value
        while LsdESP do
            task.wait(1)
            UpdateLsdESP()
        end
    end)
end
if World3 then
    ESP:AddToggle("Advanced Fruit Dealer ESP", false, function(Value)
        _G.AfdESP = Value
    end)
    ESP:AddToggle("Real Fruits ESP", false, function(Value)
        _G.RealFruitESP = Value
    end)
end


local Raid = Window:CreateTab("RAID", "")
Raid:AddSection("Raid menu")
_G.SelectChip = selectraids or ""
local Raidslist = {
    "Flame",
    "Ice",
    "Quake",
    "Light",
    "Dark",
    "Spider",
    "Magma",
    "Buddha",
    "Sand",
    "Dough",
    "Phoenix"
}
Raid:AddDropdown("Select Chips", Raidslist, "", function(Value)
    _G.SelectChip = Value
end)
Raid:AddToggle("Auto Buy Chip", false, function(Value)
    _G.AutoBuyChip = Value
end)
Raid:AddButton("Buy Chips Select", function(Value)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)
end)
local raidThread, raidToggle
raidToggle = Raid:AddToggle("Auto Raid", false, function(Value)
    _G.Auto_Raid = Value
    if Value and not raidThread then
        raidThread = task.spawn(function()
            pcall(raidLoop)
            raidThread = nil
        end)
    elseif not Value then
        raidThread = nil
    end
end)
_G.RaidToggleOff = function()
    if raidToggle and raidToggle.GetState() then raidToggle.SetState(false) end
end
Raid:AddToggle("Auto Awakener", false, function(Value)
    _G.Auto_Awakener = Value
end)
Raid:AddSlider("Raid Fly Speed", 100, 1500, 200, function(Value)
    _G.RaidTweenSpeed = tonumber(Value)
end)
Raid:AddTextbox("(WEBHOOK) Raid counter", "Enter raid number", "0", function(Value)
    _G.RaidCount = tonumber(Value)
end)

local Dungeon = Window:CreateTab("AUTO DUNGEONS", "")
Dungeon:AddSection("Auto Dungeon")

local ST = Window:CreateTab("Buy Specs")
ST:AddSection("Styles")
ST:AddButton("Black Leg", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
end)
ST:AddButton("Electrol", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
end)
ST:AddButton("FishMan Karate", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
end)
ST:AddButton("Dragon Claw", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
end)
ST:AddButton("SuperHuman", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
end)
ST:AddButton("Death Step", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
end)
ST:AddButton("Electric Claw", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
end)
ST:AddButton("SharkMan Karate", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
end)
ST:AddButton("Dragon Talon", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
end)
ST:AddButton("Godhuman", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
end)
ST:AddSection("Haki")
ST:AddButton("Buy Buso Haki", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
end)
ST:AddButton("Buy Geppo Haki", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
end)
ST:AddButton("Buy Flash Step(Soru)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
end)
ST:AddButton("Buy Observation(Ken) Haki", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
end)
ST:AddSection("Swords")
ST:AddButton("Cutlass Katana", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
end)
ST:AddButton("Katana", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Katana")
end)
ST:AddButton("Iron Mace", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
end)
ST:AddButton("Dual Katana", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual Katana")
end)
ST:AddButton("Triple Katana", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
end)
ST:AddButton("Pipe", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Pipe")
end)
ST:AddButton("Dual-Headed Blade", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
end)
ST:AddButton("Bisento", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Bisento")
end)
ST:AddButton("Soul Cane", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
end)
ST:AddSection("Guns")
ST:AddButton("Slingshot", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Slingshot")
end)
ST:AddButton("Musket", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Musket")
end)
ST:AddButton("Flintlock", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Flintlock")
end)
ST:AddButton("Dual Flintlock", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual Flintlock")
end)
ST:AddButton("Refined Slingshot", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Refined Slingshot")
end)
ST:AddButton("Cannon", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cannon")
end)
ST:AddButton("Kabucha [ 1,500 Fragments]", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")
end)
ST:AddButton("Bizarre Rifle [ 25 Ectoplasm ]", function()
    local A_1 = "Ectoplasm"
    local A_2 = "Buy"
    local A_3 = 1
    local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
    Event:InvokeServer(A_1, A_2, A_3)
end)
ST:AddSection("Player Stats and Race")
ST:AddButton("Refund Stats[2,500 fragment]", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
end)
ST:AddButton("Race Random[3,000 fragment]", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
end)
