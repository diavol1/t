-- ============================================
-- MILK HUB - РАБОЧАЯ ВЕРСИЯ С СОХРАНЕНИЕМ
-- ============================================

local LP = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ====== ФЛАГИ (СОХРАНЯЮТСЯ) ======
local Flags = {
    Fly = false,
    Speed = false,
    NoClip = false,
    Invisible = false
}

-- ====== СОЗДАНИЕ GUI ======
-- Ждем PlayerGui
repeat task.wait() until LP:FindFirstChild("PlayerGui")

-- Удаляем старый GUI если есть
local oldGui = LP.PlayerGui:FindFirstChild("MilkHub")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "MilkHub"
gui.ResetOnSpawn = false
gui.Parent = LP.PlayerGui

-- Окно
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 220)
main.Position = UDim2.new(0.5, -100, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
main.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
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
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Кнопки
local y = 35

local function MakeBtn(text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = main
    
    -- Восстанавливаем состояние из флагов
    local state = Flags[key] or false
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        btn.Text = text .. " ✅"
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        Flags[key] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 55)
        btn.Text = state and (text .. " ✅") or text
    end)
    y = y + 30
    return btn
end

MakeBtn("🕊️ Fly", "Fly")
MakeBtn("⚡ Speed", "Speed")
MakeBtn("🌀 NoClip", "NoClip")
MakeBtn("👻 Invisible", "Invisible")

-- Кнопка Kill All
local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0.9, 0, 0, 25)
killBtn.Position = UDim2.new(0.05, 0, 0, y)
killBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
killBtn.Text = "💀 Kill All"
killBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
killBtn.TextScaled = true
killBtn.Font = Enum.Font.GothamBold
killBtn.Parent = main
killBtn.MouseButton1Click:Connect(function()
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChild("Humanoid")
            if h then h.Health = 0 end
        end
    end
end)

print("✅ GUI создан!")

-- ====== ПРИМЕНЕНИЕ ЭФФЕКТОВ ======
local function ApplyEffects()
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
end

-- ====== ВОССТАНОВЛЕНИЕ ПОСЛЕ СМЕРТИ ======
LP.CharacterAdded:Connect(function()
    print("🔄 Персонаж пересоздан! Восстанавливаем настройки...")
    task.wait(0.5)
    
    local char = LP.Character
    if not char then return end
    
    -- Fly
    if Flags.Fly then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = true
        end
    end
    
    -- NoClip
    if Flags.NoClip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
    
    -- Speed
    if Flags.Speed then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 50
        end
    end
    
    -- Invisible
    if Flags.Invisible then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = 1
            end
        end
    end
end)

-- ====== ЗАПУСК ======
RunService.Heartbeat:Connect(ApplyEffects)

print("✅ MILK HUB РАБОТАЕТ! Меню сохраняется после смерти!")
