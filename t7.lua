-- ============================================
-- MILK HUB - РАБОЧАЯ ВЕРСИЯ ДЛЯ MM2
-- GUI через CoreGui + объекты в мире
-- ============================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ====== ФЛАГИ ======
local Flags = {
    Fly = false,
    Speed = false,
    NoClip = false,
    Invisible = false,
    ESP = false
}

-- ====== СОЗДАНИЕ GUI ЧЕРЕЗ COREGUI ======
local function CreateCoreGUI()
    -- Пробуем CoreGui (он реже блокируется)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MilkHub"
    gui.ResetOnSpawn = false
    
    local success = pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        -- Если CoreGui не работает, создаем через StarterGui
        pcall(function()
            gui.Parent = game:GetService("StarterGui")
        end)
    end
    
    -- Главное окно
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 220, 0, 280)
    main.Position = UDim2.new(0.5, -110, 0.5, -140)
    main.BackgroundColor3 = Color3.fromRGB(8, 8, 28)
    main.BackgroundTransparency = 0.2
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    
    -- Скругление
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = main
    
    -- Обводка
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Transparency = 0.3
    stroke.Parent = main
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    title.Text = "🥛 MILK HUB"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = main
    
    -- Кнопка закрытия
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 22)
    close.Position = UDim2.new(1, -28, 0, 4)
    close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextScaled = true
    close.Font = Enum.Font.GothamBold
    close.Parent = main
    close.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)
    
    -- Контейнер
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 1, -38)
    container.Position = UDim2.new(0, 5, 0, 34)
    container.BackgroundTransparency = 1
    container.Parent = main
    
    local y = 5
    
    -- Создание кнопок
    local function MakeBtn(text, key, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 28)
        btn.Position = UDim2.new(0.025, 0, 0, y)
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 55)
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(220, 220, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local state = Flags[key] or false
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            btn.BackgroundTransparency = 0
            btn.Text = text .. " ✅"
        end
        
        btn.MouseButton1Click:Connect(function()
            state = not state
            Flags[key] = state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or (color or Color3.fromRGB(30, 30, 55))
            btn.BackgroundTransparency = state and 0 or 0.2
            btn.Text = state and (text .. " ✅") or text
        end)
        y = y + 33
        return btn
    end
    
    -- Создаем кнопки
    MakeBtn("🕊️ Fly", "Fly", Color3.fromRGB(30, 50, 80))
    MakeBtn("⚡ Speed", "Speed", Color3.fromRGB(30, 50, 80))
    MakeBtn("🌀 NoClip", "NoClip", Color3.fromRGB(30, 50, 80))
    MakeBtn("👻 Invisible", "Invisible", Color3.fromRGB(30, 50, 80))
    MakeBtn("👁️ ESP", "ESP", Color3.fromRGB(40, 30, 70))
    
    -- Kill All (отдельная кнопка)
    local killBtn = Instance.new("TextButton")
    killBtn.Size = UDim2.new(0.95, 0, 0, 28)
    killBtn.Position = UDim2.new(0.025, 0, 0, y)
    killBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    killBtn.BackgroundTransparency = 0.2
    killBtn.Text = "💀 Kill All"
    killBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
    killBtn.TextScaled = true
    killBtn.Font = Enum.Font.GothamBold
    killBtn.Parent = container
    
    local killCorner = Instance.new("UICorner")
    killCorner.CornerRadius = UDim.new(0, 6)
    killCorner.Parent = killBtn
    
    killBtn.MouseButton1Click:Connect(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local h = plr.Character:FindFirstChild("Humanoid")
                if h then h.Health = 0 end
            end
        end
        killBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        task.wait(0.3)
        killBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    end)
    
    -- Статус бар
    local status = Instance.new("Frame")
    status.Size = UDim2.new(1, 0, 0, 18)
    status.Position = UDim2.new(0, 0, 1, -18)
    status.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
    status.BackgroundTransparency = 0.5
    status.Parent = main
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "🟢 Готов"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.Gotham
    statusText.TextSize = 10
    statusText.Parent = status
    
    return gui
end

-- ====== СОЗДАЕМ GUI ======
local guiCreated = pcall(CreateCoreGUI)

-- Если GUI не создался, создаем уведомление в мире
if not guiCreated then
    local part = Instance.new("Part")
    part.Size = Vector3.new(8, 1, 8)
    part.Position = Vector3.new(0, 40, 0)
    part.BrickColor = BrickColor.new("Bright blue")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.Parent = workspace
    
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 250, 0, 40)
    bill.Adornee = part
    bill.Parent = part
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🥛 MILK HUB РАБОТАЕТ!"
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    print("✅ GUI не создался, но скрипт работает! Ищите синюю платформу в небе!")
end

-- ====== ПЕРЕТАСКИВАНИЕ (если GUI создался) ======
if guiCreated then
    local main = game:GetService("CoreGui"):FindFirstChild("MilkHub"):FindFirstChildOfClass("Frame")
    if main then
        local dragging = false
        local dragStart = nil
        local startPos = nil
        local title = main:FindFirstChildOfClass("TextLabel")
        
        if title then
            title.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = main.Position
                end
            end)
            
            title.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    local delta = input.Position - dragStart
                    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            title.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end
    end
end

-- ====== ESP ======
local ESPObjects = {}

local function UpdateESP()
    pcall(function()
        for i = #ESPObjects, 1, -1 do
            local v = ESPObjects[i]
            if v and v.Parent then
                v:Destroy()
            end
            ESPObjects[i] = nil
        end
        ESPObjects = {}
        
        if not Flags.ESP then return end
        
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        -- Имя
                        local tag = Instance.new("TextLabel")
                        tag.Size = UDim2.new(0, 150, 0, 18)
                        tag.Position = UDim2.new(0, pos.X - 75, 0, pos.Y - 50)
                        tag.BackgroundTransparency = 1
                        tag.Text = plr.Name
                        tag.TextColor3 = Color3.fromRGB(255, 255, 255)
                        tag.TextScaled = true
                        tag.Font = Enum.Font.GothamBold
                        tag.Parent = game:GetService("CoreGui")
                        table.insert(ESPObjects, tag)
                        
                        -- Бокс
                        local box = Instance.new("Frame")
                        local s = math.clamp(80 / (pos.Z + 1), 15, 40)
                        box.Size = UDim2.new(0, s, 0, s * 1.4)
                        box.Position = UDim2.new(0, pos.X - s/2, 0, pos.Y - s*0.7)
                        box.BackgroundTransparency = 0.5
                        box.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
                        box.BorderSizePixel = 1
                        box.BorderColor3 = Color3.fromRGB(255, 255, 255)
                        box.Parent = game:GetService("CoreGui")
                        table.insert(ESPObjects, box)
                    end
                end
            end
        end
    end)
end

-- ====== ОСНОВНОЙ ЦИКЛ ======
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        -- FLY
        if Flags.Fly then
            local v = Vector3.new()
            local speed = 35
            if UIS:IsKeyDown(Enum.KeyCode.W) then v = v + Camera.CFrame.LookVector * speed end
            if UIS:IsKeyDown(Enum.KeyCode.S) then v = v - Camera.CFrame.LookVector * speed end
            if UIS:IsKeyDown(Enum.KeyCode.A) then v = v - Camera.CFrame.RightVector * speed end
            if UIS:IsKeyDown(Enum.KeyCode.D) then v = v + Camera.CFrame.RightVector * speed end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0, speed, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then v = v - Vector3.new(0, speed, 0) end
            root.AssemblyLinearVelocity = v
            hum.PlatformStand = true
        else
            hum.PlatformStand = false
        end
        
        -- SPEED
        if Flags.Speed then
            hum.WalkSpeed = 50
        else
            hum.WalkSpeed = 16
        end
        
        -- NOCLIP
        if Flags.NoClip then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
        
        -- INVISIBLE
        if Flags.Invisible then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Transparency = 1
                end
            end
        end
    end)
end)

-- ESP цикл
RunService.Stepped:Connect(UpdateESP)

print("✅ MILK HUB ДЛЯ MM2 ЗАГРУЖЕН!")
print("📌 Управление: F - Fly, G - Speed, K - Kill All")
print("📌 Меню должно появиться через CoreGui")
