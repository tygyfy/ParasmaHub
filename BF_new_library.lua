local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Безопасный родитель для GUI
local SafeParent = (gethui and gethui()) or (syn and syn.protect_gui and (function()
    local sg = Instance.new("Folder")
    syn.protect_gui(sg)
    sg.Parent = CoreGui
    return sg
end)()) or CoreGui:FindFirstChild("RobloxGui") or PlayerGui

-- Очистка старых экземпляров
for _, parent in ipairs({SafeParent, PlayerGui, CoreGui}) do
    local old = parent:FindFirstChild("Parasma_ScreenGui")
    if old then old:Destroy() end
end

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================
-- ГЛАВНЫЙ КЛАСС
-- ============================================
local Parasma = {}
Parasma.__index = Parasma

local windowCount = 0
local toggleButtonSpacing = 50

-- ============================================
-- KEY VALIDATION MODULE
-- ============================================
local KeySystem = {}

-- URL вашего хранилища (GitHub Gist raw / Vercel / Worker)
local KEY_API_URL = "https://gist.githubusercontent.com/tygyfy/8ec83890dccb9483e65eeb6aa49b0bad/raw/9f816d790103ce6f6b405650c27f52c6cbc5ce6d/gistfile1.txt"

-- Кэш на сессию, чтобы не долбить API
local cache = {}
local CACHE_TTL = 60 -- секунд

-- Минимальная длина ключа
local MIN_KEY_LENGTH = 18
-- Допустимые символы: только латиница + цифры
local VALID_KEY_PATTERN = "^[A-Za-z0-9]+$"

function KeySystem.IsValidFormat(key)
    if type(key) ~= "string" then return false end
    key = key:gsub("%s+", "")
    if #key < MIN_KEY_LENGTH then return false end
    if not key:match(VALID_KEY_PATTERN) then return false end
    return true, key
end

-- Получить HWID (для привязки, опционально)
local function getHWID()
    local ok, id
    if gethwid then
        ok, id = pcall(gethwid)
    elseif syn and syn.get_hwid then
        ok, id = pcall(syn.get_hwid)
    elseif request and identifyexecutor then
        ok, id = pcall(function()
            return game:GetService("RbxAnalyticsService"):GetClientId()
        end)
    end
    if ok and id then return tostring(id) end
    return "unknown"
end
KeySystem.GetHWID = getHWID

-- Скачать JSON с ключами
local function fetchKeys()
    if not request then
        return nil, "Executor does not support HTTP requests"
    end

    -- Кэш
    local cached = cache[KEY_API_URL]
    if cached and (os.time() - cached.time) < CACHE_TTL then
        return cached.data
    end

    local ok, response = pcall(function()
        return request({
            Url = KEY_API_URL .. "?t=" .. os.time(), -- обход кэша
            Method = "GET",
        })
    end)

    if not ok or not response or response.StatusCode ~= 200 then
        return nil, "Failed to fetch keys: " .. tostring(response and response.StatusCode)
    end

    local decodeOk, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(response.Body)
    end)

    if not decodeOk or not data then
        return nil, "Invalid JSON from key server"
    end

    cache[KEY_API_URL] = { data = data, time = os.time() }
    return data
end

-- Главная функция проверки
-- Возвращает: success (bool), message (string), info (table|nil)
function KeySystem.Validate(key)
    local formatOk, normalized = KeySystem.IsValidFormat(key)
    if not formatOk then
        return false, "Key must be at least " .. MIN_KEY_LENGTH .. " chars, [A-Za-z0-9] only"
    end

    local data, err = fetchKeys()
    if not data then
        -- Fallback: разрешаем работу, если API недоступен? Решайте сами.
        return false, err or "Key server unavailable"
    end

    local entry = data.keys and data.keys[normalized]
    if not entry then
        return false, "Key not found"
    end

    -- Проверка срока
    local expires = tonumber(entry.expires) or 0
    if expires > 0 and os.time() >= expires then
        return false, "Key expired on " .. os.date("%Y-%m-%d", expires)
    end

    -- Проверка HWID (если привязан)
    local boundHWID = entry.hwid
    if boundHWID and boundHWID ~= "" then
        if boundHWID ~= getHWID() then
            return false, "Key is bound to another device"
        end
    end

    return true, "OK", {
        expires = expires,
        hwid = boundHWID,
        note = entry.note,
    }
end

-- ============================================
-- СОЗДАНИЕ ОКНА
-- ============================================
function Parasma:CreateWindow(config)
    config = config or {}
    local window = setmetatable({}, Parasma)
    
    local title = config.Title or "PARASMA HUB"
    local size = config.Size or UDim2.new(0, 720, 0, 440)
    local position = config.Position or UDim2.new(0.5, -360, 0.5, -220)
    local enableKeySystem = config.EnableKeySystem or false
    local masterKeys = config.MasterKeys or {"PARASMA_VIP"}
    local keySaveFile = config.KeySaveFile or "parasma_key.txt"
    local showFloatingButton = config.ShowFloatingButton ~= false
    local menuKeybind = config.MenuKeybind or Enum.KeyCode.RightControl
    
    windowCount = windowCount + 1
    local currentWindowIndex = windowCount
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Parasma_ScreenGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = SafeParent
    window.ScreenGui = ScreenGui
    
    -- Проверка сохранённого ключа
    local verifiedKey = false
    if not enableKeySystem then
        verifiedKey = true
    elseif isfile and isfile(keySaveFile) then
        -- Читаем сохранённый ключ, но ВСЁ РАВНО валидируем его через API
        -- (чтобы не работал трюк с подменой файла)
        local ok, savedKey = pcall(readfile, keySaveFile)
        if ok and savedKey then
            savedKey = savedKey:gsub("%s+", "")
            local success, _, info = KeySystem.Validate(savedKey)
            if success then
                verifiedKey = true
                window.KeyInfo = info
            else
                -- Ключ протух / отозван — удаляем сохранение
                if delfile then pcall(delfile, keySaveFile) end
            end
        end
    end
    window.VerifiedKey = verifiedKey
    
    -- ============================================
    -- FLOATING BUTTON
    -- ============================================
    local FloatingBtn = Instance.new("TextButton")
    FloatingBtn.Name = "FloatingToggleBtn"
    FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
    local toggleYPosition = 10 + (currentWindowIndex - 1) * toggleButtonSpacing
    FloatingBtn.Position = UDim2.new(1, -70, 0, toggleYPosition)
    FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
    FloatingBtn.Text = "PR"
    FloatingBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
    FloatingBtn.Font = Enum.Font.GothamBold
    FloatingBtn.TextSize = 12
    FloatingBtn.Visible = verifiedKey and showFloatingButton
    FloatingBtn.Parent = ScreenGui
    window.FloatingBtn = FloatingBtn
    
    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatingBtn
    
    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(0, 235, 255)
    FloatStroke.Thickness = 2
    FloatStroke.Parent = FloatingBtn
    
    -- ============================================
    -- MAIN FRAME
    -- ============================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = size
    MainFrame.Position = position
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = verifiedKey
    MainFrame.Parent = ScreenGui
    window.MainFrame = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 215, 255)
    MainStroke.Thickness = 1.8
    MainStroke.Parent = MainFrame
    
    -- ============================================
    -- DRAG для FloatingBtn
    -- ============================================
    local draggingFloat, dragInputFloat, dragStartFloat, startPosFloat
    FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingFloat = true
            dragStartFloat = input.Position
            startPosFloat = FloatingBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingFloat = false
                end
            end)
        end
    end)
    FloatingBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputFloat = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputFloat and draggingFloat then
            local delta = input.Position - dragStartFloat
            FloatingBtn.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
        end
    end)
    
    -- ============================================
    -- DRAG для MainFrame (через TopBar)
    -- ============================================
    -- (будет подключено после создания TopBar)
    
    -- Клик по FloatingBtn — показать/скрыть меню
    FloatingBtn.MouseButton1Click:Connect(function()
        if draggingFloat then return end
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    -- ============================================
    -- HEADER / TOPBAR
    -- ============================================
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 48)
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    window.TopBar = TopBar
    
    -- Drag за TopBar
    local draggingMain, dragInputMain, dragStartMain, startPosMain
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            dragStartMain = input.Position
            startPosMain = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingMain = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputMain = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputMain and draggingMain then
            local delta = input.Position - dragStartMain
            MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
        end
    end)
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0, 250, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "👑 " .. string.upper(title)
    TitleLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Badge
    local SubBadge = Instance.new("TextLabel")
    SubBadge.Name = "SubBadge"
    SubBadge.Size = UDim2.new(0, 115, 0, 22)
    SubBadge.Position = UDim2.new(0, 205, 0.5, -11)
    SubBadge.BackgroundColor3 = Color3.fromRGB(245, 185, 40)
    SubBadge.Text = config.Version or "ULTIMATE v3.5"
    SubBadge.TextColor3 = Color3.fromRGB(15, 15, 15)
    SubBadge.Font = Enum.Font.GothamBold
    SubBadge.TextSize = 10
    SubBadge.Parent = TopBar
    
    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(0, 6)
    BadgeCorner.Parent = SubBadge
    
    -- Hint
    local HintLabel = Instance.new("TextLabel")
    HintLabel.Size = UDim2.new(0, 220, 1, 0)
    HintLabel.Position = UDim2.new(1, -270, 0, 0)
    HintLabel.BackgroundTransparency = 1
    HintLabel.Text = IsMobile and "📱 Bind: 👑 PR" or "💻 Bind: RightCtrl / Insert"
    HintLabel.TextColor3 = Color3.fromRGB(140, 155, 175)
    HintLabel.Font = Enum.Font.Gotham
    HintLabel.TextSize = 10
    HintLabel.TextXAlignment = Enum.TextXAlignment.Right
    HintLabel.Parent = TopBar
    
    -- Кнопка закрытия
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        FloatingBtn.Visible = showFloatingButton
    end)
    
    -- ============================================
    -- SIDEBAR
    -- ============================================
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 185, 1, -48)
    Sidebar.Position = UDim2.new(0, 0, 0, 48)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 580)
    Sidebar.Parent = MainFrame
    window.Sidebar = Sidebar
    
    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 4)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Parent = Sidebar
    
    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 8)
    SidePadding.Parent = Sidebar
    
    -- ============================================
    -- CONTENT CONTAINER
    -- ============================================
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -185, 1, -48)
    ContentContainer.Position = UDim2.new(0, 185, 0, 48)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 12, 17)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    window.ContentContainer = ContentContainer
    
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- ============================================
    -- KEY SYSTEM
    -- ============================================
    if enableKeySystem and not verifiedKey then
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeyVerificationWindow"
        KeyFrame.Size = UDim2.new(0, 430, 0, 250)
        KeyFrame.Position = UDim2.new(0.5, -215, 0.5, -125)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
        KeyFrame.BorderSizePixel = 0
        KeyFrame.Parent = ScreenGui
        
        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 12)
        KeyCorner.Parent = KeyFrame
        
        local KeyStroke = Instance.new("UIStroke")
        KeyStroke.Color = Color3.fromRGB(0, 220, 255)
        KeyStroke.Thickness = 1.8
        KeyStroke.Parent = KeyFrame
        
        local KeyHeader = Instance.new("TextLabel")
        KeyHeader.Size = UDim2.new(1, 0, 0, 36)
        KeyHeader.Position = UDim2.new(0, 0, 0, 12)
        KeyHeader.BackgroundTransparency = 1
        KeyHeader.Text = "👑 " .. string.upper(title)
        KeyHeader.TextColor3 = Color3.fromRGB(0, 240, 255)
        KeyHeader.Font = Enum.Font.GothamBold
        KeyHeader.TextSize = 16
        KeyHeader.Parent = KeyFrame
        
        local KeySub = Instance.new("TextLabel")
        KeySub.Size = UDim2.new(1, -40, 0, 20)
        KeySub.Position = UDim2.new(0, 20, 0, 48)
        KeySub.BackgroundTransparency = 1
        KeySub.Text = "Enter the license key or click GET KEY to unlock."
        KeySub.TextColor3 = Color3.fromRGB(180, 190, 210)
        KeySub.Font = Enum.Font.Gotham
        KeySub.TextSize = 11
        KeySub.Parent = KeyFrame
        
        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(1, -40, 0, 40)
        KeyInput.Position = UDim2.new(0, 20, 0, 86)
        KeyInput.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
        KeyInput.PlaceholderText = "Enter the key here..."
        KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 130, 150)
        KeyInput.Text = ""
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyInput.Font = Enum.Font.GothamSemibold
        KeyInput.TextSize = 12
        KeyInput.Parent = KeyFrame
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = KeyInput
        
        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Size = UDim2.new(0.46, 0, 0, 38)
        SubmitBtn.Position = UDim2.new(0, 20, 0, 142)
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 230)
        SubmitBtn.Text = "Confirm Key"
        SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.TextSize = 12
        SubmitBtn.Parent = KeyFrame
        
        local SubCorner = Instance.new("UICorner")
        SubCorner.CornerRadius = UDim.new(0, 8)
        SubCorner.Parent = SubmitBtn
        
        local GetKeyBtn = Instance.new("TextButton")
        GetKeyBtn.Size = UDim2.new(0.46, 0, 0, 38)
        GetKeyBtn.Position = UDim2.new(0.54, 0, 0, 142)
        GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 56)
        GetKeyBtn.Text = "Get Key (Discord)"
        GetKeyBtn.TextColor3 = Color3.fromRGB(0, 235, 255)
        GetKeyBtn.Font = Enum.Font.GothamBold
        GetKeyBtn.TextSize = 12
        GetKeyBtn.Parent = KeyFrame
        
        local GetCorner = Instance.new("UICorner")
        GetCorner.CornerRadius = UDim.new(0, 8)
        GetCorner.Parent = GetKeyBtn
        
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1, -40, 0, 24)
        StatusLabel.Position = UDim2.new(0, 20, 0, 198)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = "Master Key Support: " .. masterKeys[1] .. " | Author: Dinia"
        StatusLabel.TextColor3 = Color3.fromRGB(140, 150, 170)
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.TextSize = 10
        StatusLabel.Parent = KeyFrame
        
        SubmitBtn.MouseButton1Click:Connect(function()
            local input = KeyInput.Text:gsub("%s+", "")
            
            if input == "" then
                StatusLabel.Text = "⚠️ Enter a key"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
                return
            end
            
            StatusLabel.Text = "⏳ Checking key..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
            SubmitBtn.Active = false
            
            -- Асинхронная проверка, чтобы UI не фризился
            task.spawn(function()
                local success, message, info = KeySystem.Validate(input)
                
                if success then
                    verifiedKey = true
                    window.VerifiedKey = true
                    window.KeyInfo = info
                    
                    if writefile then
                        pcall(function() writefile(keySaveFile, input) end)
                    end
                    
                    local expiresText = "never"
                    if info and info.expires and info.expires > 0 then
                        expiresText = os.date("%Y-%m-%d %H:%M", info.expires)
                    end
                    
                    StatusLabel.Text = "✅ Welcome! Expires: " .. expiresText
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
                    task.wait(0.5)
                    KeyFrame:Destroy()
                    MainFrame.Visible = true
                    FloatingBtn.Visible = showFloatingButton
                    window:Notify("Authorized", "Welcome to " .. title .. "!", 4)
                else
                    StatusLabel.Text = "❌ " .. message
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                    SubmitBtn.Active = true
                end
            end)
        end)

        -- GetKeyBtn — открывает ссылку на выдачу, а не копирует дискорд
        GetKeyBtn.MouseButton1Click:Connect(function()
            local url = config.GetKeyURL or "https://discord.gg/PeqdRPgUY"
            if setclipboard then
                setclipboard(url)
                StatusLabel.Text = "📋 Link copied: " .. url
                StatusLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
            end
        end)
    end
    
    -- KEYBIND
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and (input.KeyCode == menuKeybind or input.KeyCode == Enum.KeyCode.Insert) then
            if verifiedKey then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end)
    
    function window:Notify(notifyTitle, message, duration)
        local dur = duration or 3
        local Toast = Instance.new("Frame")
        Toast.Size = UDim2.new(0, 270, 0, 62)
        Toast.Position = UDim2.new(1, 20, 1, -85)
        Toast.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        Toast.Parent = ScreenGui
        
        local ToastCorner = Instance.new("UICorner")
        ToastCorner.CornerRadius = UDim.new(0, 10)
        ToastCorner.Parent = Toast
        
        local ToastStroke = Instance.new("UIStroke")
        ToastStroke.Color = Color3.fromRGB(0, 220, 255)
        ToastStroke.Thickness = 1.4
        ToastStroke.Parent = Toast
        
        local ToastTitle = Instance.new("TextLabel")
        ToastTitle.Size = UDim2.new(1, -20, 0, 22)
        ToastTitle.Position = UDim2.new(0, 10, 0, 6)
        ToastTitle.BackgroundTransparency = 1
        ToastTitle.Text = "👑 " .. notifyTitle
        ToastTitle.TextColor3 = Color3.fromRGB(0, 240, 255)
        ToastTitle.Font = Enum.Font.GothamBold
        ToastTitle.TextSize = 12
        ToastTitle.TextXAlignment = Enum.TextXAlignment.Left
        ToastTitle.Parent = Toast
        
        local ToastMsg = Instance.new("TextLabel")
        ToastMsg.Size = UDim2.new(1, -20, 0, 28)
        ToastMsg.Position = UDim2.new(0, 10, 0, 28)
        ToastMsg.BackgroundTransparency = 1
        ToastMsg.Text = message
        ToastMsg.TextColor3 = Color3.fromRGB(220, 225, 235)
        ToastMsg.Font = Enum.Font.Gotham
        ToastMsg.TextSize = 11
        ToastMsg.TextXAlignment = Enum.TextXAlignment.Left
        ToastMsg.Parent = Toast
        
        TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -290, 1, -85)
        }):Play()
        
        task.delay(dur, function()
            local outTween = TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 20, 1, -85)
            })
            outTween:Play()
            outTween.Completed:Connect(function()
                Toast:Destroy()
            end)
        end)
    end
    
    function window:CreateTab(tabName, iconText)
        local tabObj = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabBtn_" .. tabName
        TabButton.Size = UDim2.new(0, 170, 0, 36)
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 23, 33)
        TabButton.Text = (iconText or "📌") .. "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 190, 210)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 11
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(0, 215, 255)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 15)
        ContentPadding.PaddingLeft = UDim.new(0, 14)
        ContentPadding.PaddingRight = UDim.new(0, 14)
        ContentPadding.Parent = TabContent
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 25)
        end)
        
        tabObj.Button = TabButton
        tabObj.Content = TabContent
        tabObj.Window = window
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(20, 23, 33)
                t.Button.TextColor3 = Color3.fromRGB(180, 190, 210)
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            window.ActiveTab = tabObj
        end)
        
        if #window.Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            window.ActiveTab = tabObj
        end
        
        table.insert(window.Tabs, tabObj)

        function tabObj:AddSection(sectionTitle)
            local SecFrame = Instance.new("Frame")
            SecFrame.Name = "Section_" .. sectionTitle
            SecFrame.Size = UDim2.new(1, 0, 0, 28)
            SecFrame.BackgroundTransparency = 1
            SecFrame.Parent = TabContent
            
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 1, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = "─── " .. string.upper(sectionTitle) .. " ───"
            SecLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 12
            SecLabel.Parent = SecFrame
        end
        
        function tabObj:AddToggle(toggleText, defaultVal, callback)
            local state = defaultVal or false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = "Toggle_" .. toggleText
            ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Parent = TabContent
            
            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 8)
            FrameCorner.Parent = ToggleFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = toggleText
            Label.TextColor3 = Color3.fromRGB(230, 235, 245)
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 38, 0, 20)
            Indicator.Position = UDim2.new(1, -48, 0.5, -10)
            Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(40, 45, 60)
            Indicator.BorderSizePixel = 0
            Indicator.Parent = ToggleFrame
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator
            
            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.BorderSizePixel = 0
            Dot.Parent = Indicator
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = Dot
            
            local function UpdateToggle()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(40, 45, 60)
                }):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                }):Play()
            end
            
            local function SetState(newState)
                state = newState
                UpdateToggle()
                if callback then
                    task.spawn(callback, state)
                end
            end
            
            ToggleFrame.MouseButton1Click:Connect(function()
                SetState(not state)
            end)
            
            return {SetState = SetState, GetState = function() return state end}
        end
        
        function tabObj:AddButton(buttonText, callback)
            local Btn = Instance.new("TextButton")
            Btn.Name = "Button_" .. buttonText
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
            Btn.Text = buttonText
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 12
            Btn.Parent = TabContent
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 220, 255)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 160, 220)}):Play()
                if callback then
                    task.spawn(callback)
                end
            end)
            
            return Btn
        end
        
        function tabObj:AddLabel(labelText)
            local InfoLabel = Instance.new("TextLabel")
            InfoLabel.Size = UDim2.new(1, 0, 0, 24)
            InfoLabel.BackgroundTransparency = 1
            InfoLabel.Text = labelText
            InfoLabel.TextColor3 = Color3.fromRGB(160, 175, 195)
            InfoLabel.Font = Enum.Font.Gotham
            InfoLabel.TextSize = 11
            InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            InfoLabel.Parent = TabContent
            return InfoLabel
        end
        
        function tabObj:AddTextbox(boxTitle, placeholder, defaultText, callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Name = "TextBox_" .. boxTitle
            BoxFrame.Size = UDim2.new(1, 0, 0, 64)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
            BoxFrame.Parent = TabContent
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 8)
            BoxCorner.Parent = BoxFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -24, 0, 22)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = boxTitle
            Label.TextColor3 = Color3.fromRGB(230, 235, 245)
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame
            
            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(1, -24, 0, 28)
            Input.Position = UDim2.new(0, 12, 0, 30)
            Input.BackgroundColor3 = Color3.fromRGB(26, 30, 42)
            Input.PlaceholderText = placeholder or "Nhập tại đây..."
            Input.PlaceholderColor3 = Color3.fromRGB(120, 130, 150)
            Input.Text = defaultText or ""
            Input.TextColor3 = Color3.fromRGB(0, 235, 255)
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 11
            Input.ClearTextOnFocus = false
            Input.Parent = BoxFrame
            
            local InCorner = Instance.new("UICorner")
            InCorner.CornerRadius = UDim.new(0, 6)
            InCorner.Parent = Input
            
            local currentValue = Input.Text
            
            Input.FocusLost:Connect(function(enterPressed)
                currentValue = Input.Text
                if callback then
                    task.spawn(callback, currentValue)
                end
            end)
            
            return {
                GetValue = function() return currentValue end,
                SetValue = function(v)
                    currentValue = v
                    Input.Text = v
                    if callback then task.spawn(callback, v) end
                end,
                Instance = Input
            }
        end
        
        function tabObj:AddDropdown(dropdownText, itemsList, defaultItem, callback)
            local selected = defaultItem or itemsList[1] or ""
            local isOpen = false
            
            local DropFrame = Instance.new("Frame")
            DropFrame.Name = "Dropdown_" .. dropdownText
            DropFrame.Size = UDim2.new(1, 0, 0, 42)
            DropFrame.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = TabContent
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = DropFrame
            
            local HeaderBtn = Instance.new("TextButton")
            HeaderBtn.Size = UDim2.new(1, 0, 0, 42)
            HeaderBtn.BackgroundTransparency = 1
            HeaderBtn.Text = ""
            HeaderBtn.Parent = DropFrame
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(0.5, 0, 1, 0)
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = dropdownText
            Title.TextColor3 = Color3.fromRGB(230, 235, 245)
            Title.Font = Enum.Font.GothamSemibold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = HeaderBtn
            
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Size = UDim2.new(0.45, -30, 1, 0)
            SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Text = tostring(selected) .. " ▼"
            SelectedLabel.TextColor3 = Color3.fromRGB(0, 235, 255)
            SelectedLabel.Font = Enum.Font.GothamBold
            SelectedLabel.TextSize = 11
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.Parent = HeaderBtn
            
            local ScrollList = Instance.new("ScrollingFrame")
            ScrollList.Size = UDim2.new(1, -16, 0, 120)
            ScrollList.Position = UDim2.new(0, 8, 0, 44)
            ScrollList.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
            ScrollList.BorderSizePixel = 0
            ScrollList.ScrollBarThickness = 3
            ScrollList.Parent = DropFrame
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = ScrollList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = ScrollList
            
            local function BuildList()
                for _, child in ipairs(ScrollList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, item in ipairs(itemsList) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Size = UDim2.new(1, 0, 0, 26)
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
                    ItemBtn.Text = tostring(item)
                    ItemBtn.TextColor3 = Color3.fromRGB(210, 215, 230)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.TextSize = 11
                    ItemBtn.Parent = ScrollList
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        SelectedLabel.Text = tostring(item) .. " ▼"
                        isOpen = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                        if callback then
                            task.spawn(callback, selected)
                        end
                    end)
                end
                ScrollList.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 28)
            end
            BuildList()
            
            HeaderBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetHeight = isOpen and 175 or 42
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            end)
            
            return {
                GetValue = function() return selected end,
                SetValue = function(v)
                    selected = v
                    SelectedLabel.Text = tostring(v) .. " ▼"
                    if callback then task.spawn(callback, v) end
                end,
                SetOptions = function(newOptions)
                    itemsList = newOptions
                    BuildList()
                end
            }
        end
        
        function tabObj:AddSlider(sliderText, min, max, defaultVal, callback)
            local currentVal = defaultVal or min
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. sliderText
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 0, 22)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = sliderText
            Label.TextColor3 = Color3.fromRGB(230, 235, 245)
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame
            
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 60, 0, 22)
            ValLabel.Position = UDim2.new(1, -72, 0, 6)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(currentVal)
            ValLabel.TextColor3 = Color3.fromRGB(0, 235, 255)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = SliderFrame
            
            local Track = Instance.new("TextButton")
            Track.Name = "Track"
            Track.Size = UDim2.new(1, -24, 0, 8)
            Track.Position = UDim2.new(0, 12, 0, 32)
            Track.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
            Track.Text = ""
            Track.AutoButtonColor = false
            Track.Parent = SliderFrame
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill
            
            local sliding = false
            local function UpdateSlider(input)
                local relX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                currentVal = math.floor(min + ((max - min) * relX))
                ValLabel.Text = tostring(currentVal)
                Fill.Size = UDim2.new(relX, 0, 1, 0)
                if callback then
                    task.spawn(callback, currentVal)
                end
            end
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            return {
                GetValue = function() return currentVal end,
                SetValue = function(v)
                    currentVal = math.clamp(v, min, max)
                    ValLabel.Text = tostring(currentVal)
                    Fill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
                    if callback then task.spawn(callback, currentVal) end
                end
            }
        end
        
        function tabObj:AddSectionWithMethods(sectionTitle)
            local SecFrame = Instance.new("Frame")
            SecFrame.Name = "Section_" .. sectionTitle
            SecFrame.Size = UDim2.new(1, 0, 0, 28)
            SecFrame.BackgroundTransparency = 1
            SecFrame.Parent = TabContent
            
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 1, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = "─── " .. string.upper(sectionTitle) .. " ───"
            SecLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 12
            SecLabel.Parent = SecFrame
            
            local sectionObj = {}
            
            function sectionObj:AddButton(config)
                return tabObj:AddButton(config.Name or "Button", config.Callback)
            end
            
            function sectionObj:AddToggle(config)
                return tabObj:AddToggle(config.Name or "Toggle", config.Default, config.Callback)
            end
            
            function sectionObj:AddLabel(config)
                return tabObj:AddLabel(config.Name or "Label")
            end
            
            function sectionObj:AddTextbox(config)
                return tabObj:AddTextbox(config.Name or "Input", config.Placeholder, config.Default, config.Callback)
            end
            
            function sectionObj:AddDropdown(config)
                return tabObj:AddDropdown(config.Name or "Dropdown", config.Options or {}, config.Default, config.Callback)
            end
            
            function sectionObj:AddSlider(config)
                return tabObj:AddSlider(config.Name or "Slider", config.Min or 0, config.Max or 100, config.Default or 0, config.Callback)
            end
            
            return sectionObj
        end
        
        return tabObj
    end
    
    function window:AddTab(tabName, iconText)
        return self:CreateTab(tabName, iconText)
    end
    
    return window
end

return Parasma