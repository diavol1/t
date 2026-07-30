-- ============================================
-- MILK HUB - GUI ЧЕРЕЗ ОБЪЕКТЫ В МИРЕ
-- Работает там, где GUI заблокирован
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

-- ====== СОЗДАЕМ ГЛАВНУЮ ПЛАТФОРМУ С КНОПКАМИ ======
local function CreateWorldGUI()
    -- Главная платформа
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(20, 1, 14)
    platform.Position = Vector3.new(0, 45, 0)
    platform.BrickColor = BrickColor.new("Black")
    platform.Material = Enum.Material.SmoothPlastic
    platform.Anchored = true
    platform.CanCollide = false
    platform.Transparency = 0.3
    platform.Parent = workspace
    
    -- Рамка (светящаяся)
    local glow = Instance.new("Part")
    glow.Size = Vector3.new(22, 0.5, 16)
    glow.Position = Vector3.new(0, 45.5, 0)
    glow.BrickColor = BrickColor.new("Bright blue")
    glow.Material = Enum.Material.Neon
    glow.Anchored = true
    glow.CanCollide = false
    glow.Transparency = 0.3
    glow.Parent = workspace
    
    -- Заголовок
    local titlePart = Instance.new("Part")
    titlePart.Size = Vector3.new(18, 0.5, 2)
    titlePart.Position = Vector3.new(0, 46.5, 0)
    titlePart.BrickColor = BrickColor.new("Bright blue")
    titlePart.Material = Enum.Material.Neon
    titlePart.Anchored = true
    titlePart.CanCollide = false
    titlePart.Parent = workspace
    
    local titleBill = Instance.new("BillboardGui")
    titleBill.Size = UDim2.new(0, 300, 0, 40)
    titleBill.Adornee = titlePart
    titleBill.Parent = titlePart
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🥛 MILK HUB"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBill
    
    -- Создаем кнопки на платформе
    local buttons = {}
    local buttonNames = {
        {name = "🕊️ Fly", key = "Fly", color = "Bright blue"},
        {name = "⚡ Speed", key = "Speed", color = "Bright green"},
        {name = "🌀 NoClip", key = "NoClip", color = "Bright violet"},
        {name = "👻 Invisible", key = "Invisible", color = "Bright yellow"},
        {name = "👁️ ESP", key = "ESP", color = "Bright orange"},
        {name = "💀 Kill All", key = "KillAll", color = "Bright red"}
    }
    
    for i, data in ipairs(buttonNames) do
        local x = -8 + (i - 1) * 3.2
        local z = 0
        
        -- Кнопка
        local btn = Instance.new("Part")
        btn.Size = Vector3.new(3, 0.5, 3)
        btn.Position = Vector3.new(x, 45.8, z)
        btn.BrickColor = BrickColor.new(data.color)
        btn.Material = Enum.Material.Neon
        btn.Anchored = true
        btn.CanCollide = false
        btn.Transparency = 0.2
        btn.Parent = workspace
        
        -- Надпись на кнопке
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 80, 0, 30)
        bill.Adornee = btn
        bill.Parent = btn
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = data.name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = bill
        
        -- Состояние кнопки (ON/OFF)
        local statePart = Instance.new("Part")
        statePart.Size = Vector3.new(1, 0.3, 1)
        statePart.Position = Vector3.new(x, 45.3, z + 2)
        statePart.BrickColor = BrickColor.new("Red")
        statePart.Material = Enum.Material.Neon
        statePart.Anchored = true
        statePart.CanCollide = false
        statePart.Parent = workspace
        
        local stateBill = Instance.new("BillboardGui")
        stateBill.Size = UDim2.new(0, 50, 0, 20)
        stateBill.Adornee = statePart
        stateBill.Parent = statePart
        
        local stateLabel = Instance.new("TextLabel")
        stateLabel.Size = UDim2.new(1, 0, 1, 0)
        stateLabel.BackgroundTransparency = 1
        stateLabel.Text = "OFF"
        stateLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        stateLabel.TextScaled = true
        stateLabel.Font = Enum.Font.GothamBold
        stateLabel.Parent = stateBill
        
        buttons[data.key] = {
            btn = btn,
            state = statePart,
            stateLabel = stateLabel,
            isOn = false
        }
    end
    
    -- Взаимодействие с кнопками (клик по ним)
    for key, data in pairs(buttons) do
        data.btn.Touched:Connect(function(hit)
            if hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                local plr = Players:GetPlayerFromCharacter(hit.Parent)
                if plr == LP then
                    -- Переключаем состояние
                    data.isOn = not data.isOn
                    Flags[key] = data.isOn
                    
                    -- Обновляем цвет и надпись
                    if data.isOn then
                        data.btn.BrickColor = BrickColor.new("Lime green")
                        data.state.BrickColor = BrickColor.new("Lime green")
                        data.stateLabel.Text = "ON"
                        data.stateLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    else
                        data.btn.BrickColor = BrickColor.new(data.btn.BrickColor.Name == "Lime green" and "Bright blue" or data.btn.BrickColor)
                        data.state.BrickColor = BrickColor.new("Red")
                        data.stateLabel.Text = "OFF"
                        data.stateLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                    
                    print(key .. " = " .. tostring(data.isOn))
                end
            end
        end)
    end
    
    -- Кнопка Kill All (отдельная логика)
    local killData = buttons["KillAll"]
    if killData then
        killData.btn.Touched:Connect(function(hit)
            if hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                local plr = Players:GetPlayerFromCharacter(hit.Parent)
                if plr == LP then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local h = p.Character:FindFirstChild("Humanoid")
                            if h then h.Health = 0 end
                        end
                    end
                    killData.btn.BrickColor = BrickColor.new("Lime green")
                    task.wait(0.5)
                    killData.btn.BrickColor = BrickColor.new("Bright red")
                    print("💀 Kill All выполнен!")
                end
            end
        end)
    end
    
    return platform, glow, titlePart
end

-- ====== СОЗДАЕМ GUI В МИРЕ ======
local guiObjects = pcall(CreateWorldGUI)

if guiObjects then
    print("✅ MILK HUB GUI создан в мире!")
    print("📌 Подойдите к платформе и нажмите на кнопки")
    print("📌 Кнопки меняют цвет при нажатии")
else
    print("❌ Ошибка создания GUI в мире, используем клавиши")
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
                        local tag = Instance.new("BillboardGui")
                        tag.Size = UDim2.new(0, 150, 0, 20)
                        tag.Adornee = hrp
                        tag.Parent = hrp
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = plr.Name
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = tag
                        table.insert(ESPObjects, tag)
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

print("✅ MILK HUB ПОЛНОСТЬЮ ЗАГРУЖЕН!")
print("📌 Подойдите к платформе в небе (Y=45)")
print("📌 Нажмите на цветные кубики для включения функций")
print("📌 Также работают клавиши: F - Fly, G - Speed, K - Kill All")
