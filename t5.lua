-- ============================================
-- MILK HUB - КРАСИВАЯ ВЕРСИЯ
-- ОСНОВАНА НА РАБОЧЕЙ ЭКСТРИМ ВЕРСИИ
-- ============================================

local LP = game:GetService("Players").LocalPlayer
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
    KillAll = false
}

-- ====== СОЗДАНИЕ GUI ======
repeat task.wait() until LP:FindFirstChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "MilkHub"
gui.ResetOnSpawn = false
gui.Parent = LP.PlayerGui

-- ====== ГЛАВНОЕ ОКНО (красивое) ======
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 280)
main.Position = UDim2.new(0.5, -110, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 28)
main.BackgroundTransparency = 0.1
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

-- ====== ЗАГОЛОВОК ======
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 32)
titleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
titleFrame.BackgroundTransparency = 0.3
titleFrame.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🥛 MILK HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleFrame

-- Версия
local ver = Instance.new("TextLabel")
ver.Size = UDim2.new(0.2, 0, 0.5, 0)
ver.Position = UDim2.new(0.78, 0, 0.5, 0)
ver.BackgroundTransparency = 1
ver.Text = "v2"
ver.TextColor3 = Color3.fromRGB(80, 80, 130)
ver.TextScaled = true
ver.Font = Enum.Font.Gotham
ver.Parent = titleFrame

-- Кнопка закрытия
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 24)
close.Position = UDim2.new(1, -32, 0, 4)
close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
close.BackgroundTransparency = 0.2
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = titleFrame
close.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ====== КОНТЕЙНЕР ======
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -10, 1, -40)
container.Position = UDim2.new(0, 5, 0, 36)
container.BackgroundTransparency = 1
container.Parent = main

local y = 5

-- ====== СОЗДАНИЕ КНОПОК ======
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
    
    -- Скругление
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = false
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

-- ====== СОЗДАНИЕ МЕНЮ ======
MakeBtn("🕊️ Fly", "Fly", Color3.fromRGB(30, 50, 80))
MakeBtn("⚡ Speed", "Speed", Color3.fromRGB(30, 50, 80))
MakeBtn("🌀 NoClip", "NoClip", Color3.fromRGB(30, 50, 80))
MakeBtn("👻 Invisible", "Invisible", Color3.fromRGB(30, 50, 80))

-- Кнопка Kill All
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
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChild("Humanoid")
            if h then h.Health = 0 end
        end
    end
    killBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    task.wait(0.3)
    killBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
end)

-- ====== СТАТУС БАР ======
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

print("✅ MILK HUB КРАСИВЫЙ загружен!")

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
