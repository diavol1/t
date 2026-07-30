-- ============================================
-- MILK HUB - ОБХОД БЛОКИРОВКИ MM2
-- Исправленная версия для loadstring
-- ============================================

-- 1. ПЕРЕХВАТ ОШИБОК (чтобы скрипт не падал)
local function SafeCall(func)
    local success, err = pcall(func)
    if not success then
        warn("Ошибка в скрипте: " .. tostring(err))
    end
    return success
end

-- 2. ОСНОВНАЯ ЛОГИКА В ЗАЩИЩЕННОМ БЛОКЕ
SafeCall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    
    -- ФЛАГИ (сохраняются между запусками)
    local Flags = {
        Fly = false,
        Speed = false,
        NoClip = false,
        Invisible = false,
        ESP = false
    }
    
    -- УПРАВЛЕНИЕ С КЛАВИАТУРЫ (работает всегда)
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            Flags.Fly = not Flags.Fly
            print(Flags.Fly and "🕊️ Fly ON" or "🕊️ Fly OFF")
        end
        if input.KeyCode == Enum.KeyCode.G then
            Flags.Speed = not Flags.Speed
            print(Flags.Speed and "⚡ Speed ON" or "⚡ Speed OFF")
        end
        if input.KeyCode == Enum.KeyCode.K then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local h = plr.Character:FindFirstChild("Humanoid")
                    if h then h.Health = 0 end
                end
            end
            print("💀 Kill All")
        end
        if input.KeyCode == Enum.KeyCode.E then
            Flags.ESP = not Flags.ESP
            print(Flags.ESP and "👁️ ESP ON" or "👁️ ESP OFF")
        end
        if input.KeyCode == Enum.KeyCode.N then
            Flags.NoClip = not Flags.NoClip
            print(Flags.NoClip and "🌀 NoClip ON" or "🌀 NoClip OFF")
        end
        if input.KeyCode == Enum.KeyCode.I then
            Flags.Invisible = not Flags.Invisible
            print(Flags.Invisible and "👻 Invisible ON" or "👻 Invisible OFF")
        end
    end)
    
    -- СОЗДАЕМ УВЕДОМЛЕНИЕ В МИРЕ (вместо GUI)
    local function CreateWorldNotification()
        local part = Instance.new("Part")
        part.Size = Vector3.new(10, 1, 10)
        part.Position = Vector3.new(0, 45, 0)
        part.BrickColor = BrickColor.new("Bright blue")
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.3
        part.Parent = workspace
        
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 300, 0, 40)
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
        
        return part
    end
    
    SafeCall(CreateWorldNotification)
    print("✅ Уведомление создано в небе (Y=45)")
    
    -- ESP
    local ESPObjects = {}
    
    local function UpdateESP()
        SafeCall(function()
            for i = #ESPObjects, 1, -1 do
                local v = ESPObjects[i]
                if v and v.Parent then v:Destroy() end
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
    
    -- ОСНОВНОЙ ЦИКЛ
    RunService.Heartbeat:Connect(function()
        SafeCall(function()
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
    
    -- ESP ЦИКЛ
    RunService.Stepped:Connect(UpdateESP)
    
    print("✅ MILK HUB ЗАГРУЖЕН!")
    print("📌 Клавиши:")
    print("   F - Fly | G - Speed | N - NoClip")
    print("   I - Invisible | E - ESP | K - Kill All")
    print("📌 Синяя платформа с надписью в небе (Y=45)")
end)

-- Если что-то пошло не так, показываем сообщение
if not SafeCall then
    print("❌ Ошибка загрузки MILK HUB. Попробуйте перезапустить скрипт.")
end
