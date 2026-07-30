-- ============================================
-- MILK HUB - ПРОСТЕЙШАЯ ВЕРСИЯ
-- ============================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Ждем PlayerGui
repeat task.wait() until LP:FindFirstChild("PlayerGui")

-- СОЗДАЕМ GUI (как в тесте)
local gui = Instance.new("ScreenGui")
gui.Name = "MilkHub"
gui.Parent = LP.PlayerGui

-- Окно (как в тесте, но чуть больше)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 200)
main.Position = UDim2.new(0.5, -125, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
main.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "MILK HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = main

-- КНОПКИ (создаем прямо как в тесте)
local btn1 = Instance.new("TextButton")
btn1.Size = UDim2.new(0.8, 0, 0, 30)
btn1.Position = UDim2.new(0.1, 0, 0.15, 0)
btn1.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
btn1.Text = "Fly [OFF]"
btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
btn1.TextScaled = true
btn1.Font = Enum.Font.GothamBold
btn1.Parent = main

local flyState = false
btn1.MouseButton1Click:Connect(function()
    flyState = not flyState
    btn1.Text = flyState and "Fly [ON]" or "Fly [OFF]"
    btn1.BackgroundColor3 = flyState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 60)
end)

local btn2 = Instance.new("TextButton")
btn2.Size = UDim2.new(0.8, 0, 0, 30)
btn2.Position = UDim2.new(0.1, 0, 0.35, 0)
btn2.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
btn2.Text = "Speed [OFF]"
btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
btn2.TextScaled = true
btn2.Font = Enum.Font.GothamBold
btn2.Parent = main

local speedState = false
btn2.MouseButton1Click:Connect(function()
    speedState = not speedState
    btn2.Text = speedState and "Speed [ON]" or "Speed [OFF]"
    btn2.BackgroundColor3 = speedState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 60)
end)

local btn3 = Instance.new("TextButton")
btn3.Size = UDim2.new(0.8, 0, 0, 30)
btn3.Position = UDim2.new(0.1, 0, 0.55, 0)
btn3.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
btn3.Text = "NoClip [OFF]"
btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
btn3.TextScaled = true
btn3.Font = Enum.Font.GothamBold
btn3.Parent = main

local noclipState = false
btn3.MouseButton1Click:Connect(function()
    noclipState = not noclipState
    btn3.Text = noclipState and "NoClip [ON]" or "NoClip [OFF]"
    btn3.BackgroundColor3 = noclipState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 60)
end)

print("✅ MILK HUB ПРОСТЕЙШАЯ загружена!")

-- ====== ЛОГИКА ======
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        -- FLY
        if flyState then
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
        if speedState then
            hum.WalkSpeed = 50
        else
            hum.WalkSpeed = 16
        end
        
        -- NOCLIP
        if noclipState then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end)
end)
