-- ============================================
-- MILK HUB - ПОЛНАЯ ВЕРСИЯ ДЛЯ MM2
-- Скорость, Невидимость (скрывает всё), ESP
-- ============================================

local function SafeCall(func)
    local success, err = pcall(func)
    if not success then
        warn("Ошибка: " .. tostring(err))
    end
    return success
end

SafeCall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera

    -- ФЛАГИ
    local Flags = {
        Fly = false,
        Speed = false,
        NoClip = false,
        Invisible = false,
        ESP = false
    }

    -- ====== GUI (CoreGui) ======
    local function CreateGUI()
        local gui = Instance.new("ScreenGui")
        gui.Name = "MilkHub"
        gui.ResetOnSpawn = false

        local parent = game:GetService("CoreGui")
        pcall(function() gui.Parent = parent end)
        if not gui.Parent then
            pcall(function() gui.Parent = LP:WaitForChild("PlayerGui") end)
        end
        if not gui.Parent then
            pcall(function() gui.Parent = game:GetService("StarterGui") end)
        end

        local main = Instance.new("Frame")
        main.Size = UDim2.new(0, 320, 0, 420)
        main.Position = UDim2.new(0.5, -160, 0.5, -210)
        main.BackgroundColor3 = Color3.fromRGB(8, 8, 28)
        main.BackgroundTransparency = 0.15
        main.BorderSizePixel = 0
        main.ClipsDescendants = true
        main.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = main

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 180, 255)
        stroke.Transparency = 0.3
        stroke.Parent = main

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        title.Text = "🥛 MILK HUB"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = main

        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 45, 0, 35)
        close.Position = UDim2.new(1, -50, 0, 3)
        close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        close.Text = "✕"
        close.TextColor3 = Color3.fromRGB(255, 255, 255)
        close.TextScaled = true
        close.Font = Enum.Font.GothamBold
        close.Parent = main
        close.MouseButton1Click:Connect(function()
            main.Visible = not main.Visible
        end)

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -10, 1, -50)
        scroll.Position = UDim2.new(0, 5, 0, 45)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
        scroll.Parent = main

        local y = 5

        local function AddToggle(text, key, color)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.95, 0, 0, 45)
            btn.Position = UDim2.new(0.025, 0, 0, y)
            btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 55)
            btn.BackgroundTransparency = 0.2
            btn.Text = text .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(220, 220, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.Parent = scroll

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn

            local state = Flags[key] or false
            if state then
                btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
                btn.BackgroundTransparency = 0
                btn.Text = text .. " [ON]"
            end

            btn.MouseButton1Click:Connect(function()
                state = not state
                Flags[key] = state
                btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or (color or Color3.fromRGB(30, 30, 55))
                btn.BackgroundTransparency = state and 0 or 0.2
                btn.Text = state and (text .. " [ON]") or (text .. " [OFF]")
                
                -- Если выключаем невидимость — возвращаем всё обратно
                if key == "Invisible" and not state then
                    RestoreVisibility()
                end
            end)
            y = y + 52
            return btn
        end

        local function AddButton(text, func, color)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.95, 0, 0, 45)
            btn.Position = UDim2.new(0.025, 0, 0, y)
            btn.BackgroundColor3 = color or Color3.fromRGB(50, 40, 80)
            btn.BackgroundTransparency = 0.2
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 200, 100)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.Parent = scroll

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(func)
            y = y + 52
            return btn
        end

        AddToggle("🕊️ Fly (полет)", "Fly", Color3.fromRGB(30, 50, 80))
        AddToggle("⚡ Speed (скорость)", "Speed", Color3.fromRGB(30, 50, 80))
        AddToggle("🌀 NoClip (сквозь стены)", "NoClip", Color3.fromRGB(30, 50, 80))
        AddToggle("👻 Invisible (невидимость)", "Invisible", Color3.fromRGB(30, 50, 80))
        AddToggle("👁️ ESP (подсветка)", "ESP", Color3.fromRGB(40, 30, 70))
        AddButton("💀 Kill All (убить всех)", function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local h = plr.Character:FindFirstChild("Humanoid")
                    if h then h.Health = 0 end
                end
            end
            print("💀 Kill All выполнен!")
        end, Color3.fromRGB(80, 30, 30))

        local status = Instance.new("Frame")
        status.Size = UDim2.new(1, 0, 0, 22)
        status.Position = UDim2.new(0, 0, 1, -22)
        status.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
        status.BackgroundTransparency = 0.5
        status.Parent = main

        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, 0, 1, 0)
        statusText.BackgroundTransparency = 1
        statusText.Text = "🟢 Готов (нажми на кнопку)"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
        statusText.TextScaled = true
        statusText.Font = Enum.Font.Gotham
        statusText.TextSize = 12
        statusText.Parent = status

        return gui
    end

    -- ====== НЕВИДИМОСТЬ (сохраняем прозрачность) ======
    local InvisibleCache = {}

    local function ApplyInvisible(part)
        if not part then return end
        -- Сохраняем оригинальную прозрачность
        if not InvisibleCache[part] then
            InvisibleCache[part] = part.Transparency
        end
        part.Transparency = 1
    end

    local function RestoreVisibility()
        for part, origTrans in pairs(InvisibleCache) do
            if part and part.Parent then
                part.Transparency = origTrans
            end
        end
        InvisibleCache = {}
    end

    local function UpdateInvisibility()
        local char = LP.Character
        if not char then return end
        
        if Flags.Invisible then
            -- Скрываем всё: персонажа, одежду, аксессуары, оружие
            for _, child in pairs(char:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("Part") then
                    ApplyInvisible(child)
                end
                -- Скрываем инструменты в руках и на поясе
                if child:IsA("Tool") or child:IsA("Model") then
                    for _, part in pairs(child:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
                            ApplyInvisible(part)
                        end
                    end
                end
            end
            
            -- Скрываем оружие на поясе (нож сзади, пистолет справа)
            local backWeapon = char:FindFirstChild("BackWeapon") or char:FindFirstChild("Tool")
            if backWeapon then
                for _, part in pairs(backWeapon:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        ApplyInvisible(part)
                    end
                end
            end
            
            -- Скрываем аксессуары (шляпы, очки и т.д.)
            for _, accessory in pairs(char:GetChildren()) do
                if accessory:IsA("Accessory") or accessory:IsA("Hat") then
                    for _, part in pairs(accessory:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            ApplyInvisible(part)
                        end
                    end
                end
            end
        end
    end

    -- ====== СОЗДАЕМ GUI ======
    local gui = SafeCall(CreateGUI)

    if gui then
        print("✅ MILK HUB GUI создан!")
    else
        print("📌 GUI не создался, используйте клавиши")
    end

    -- ====== ESP (с цветами) ======
    local ESPObjects = {}
    local lastESPUpdate = 0

    local function GetPlayerRole(plr)
        -- Определяем роль по инструментам
        local hasKnife = false
        local hasGun = false
        local isSheriff = false
        
        if plr.Character then
            for _, tool in pairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = string.lower(tool.Name)
                    if string.find(name, "knife") or string.find(name, "dagger") or string.find(name, "blade") then
                        hasKnife = true
                    end
                    if string.find(name, "gun") or string.find(name, "pistol") or string.find(name, "revolver") then
                        hasGun = true
                    end
                end
            end
        end
        
        -- Определяем шерифа (у него есть пистолет)
        if hasGun then
            isSheriff = true
        end
        
        -- Если есть нож и нет пистолета — убийца
        if hasKnife and not hasGun then
            return "Murderer"
        elseif isSheriff then
            return "Sheriff"
        else
            return "Innocent"
        end
    end

    local function UpdateESP()
        SafeCall(function()
            -- Очистка старых объектов
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

            -- Подсветка игроков
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                        
                        -- Определяем роль
                        local role = GetPlayerRole(plr)
                        local color = Color3.fromRGB(0, 255, 0) -- Мирный (зелёный)
                        
                        if role == "Murderer" then
                            color = Color3.fromRGB(255, 0, 0) -- Красный
                        elseif role == "Sheriff" then
                            color = Color3.fromRGB(0, 100, 255) -- Синий
                        end
                        
                        -- Имя с ролью
                        local tag = Instance.new("BillboardGui")
                        tag.Size = UDim2.new(0, 200, 0, 30)
                        tag.Adornee = hrp
                        tag.Parent = hrp
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = plr.Name .. " [" .. role .. "]"
                        label.TextColor3 = color
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = tag
                        table.insert(ESPObjects, tag)
                        
                        -- Подсветка скелета (сквозь стены)
                        for _, part in pairs(plr.Character:GetChildren()) do
                            if part:IsA("BasePart") or part:IsA("MeshPart") then
                                local highlight = Instance.new("Highlight")
                                highlight.Parent = part
                                highlight.FillColor = color
                                highlight.FillTransparency = 0.5
                                highlight.OutlineColor = color
                                highlight.OutlineTransparency = 0.2
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                table.insert(ESPObjects, highlight)
                            end
                        end
                    end
                end
            end
            
            -- Подсветка выпавшего оружия (жёлтым)
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") or obj:IsA("BasePart") then
                    local name = string.lower(obj.Name)
                    if string.find(name, "gun") or string.find(name, "pistol") or string.find(name, "revolver") or string.find(name, "knife") then
                        if obj.Parent and not obj.Parent:FindFirstChild("Humanoid") then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = obj
                            highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Жёлтый
                            highlight.FillTransparency = 0.3
                            highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
                            highlight.OutlineTransparency = 0.1
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            table.insert(ESPObjects, highlight)
                        end
                    end
                end
            end
        end)
    end

    -- ====== ОСНОВНОЙ ЦИКЛ ======
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

            -- SPEED (исправлено)
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

            -- INVISIBLE (обновляем каждый кадр)
            if Flags.Invisible then
                UpdateInvisibility()
            end
        end)
    end)

    -- ESP ЦИКЛ (обновляется реже)
    RunService.Stepped:Connect(function()
        SafeCall(UpdateESP)
    end)

    -- Восстановление видимости при смерти
    LP.CharacterAdded:Connect(function()
        RestoreVisibility()
        print("🔄 Персонаж пересоздан, видимость восстановлена")
    end)

    -- ====== КЛАВИШИ ДЛЯ ПК ======
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            Flags.Fly = not Flags.Fly
            print(Flags.Fly and "🕊️ Fly ON" or "🕊️ Fly OFF")
        end
        if input.KeyCode == Enum.KeyCode.G then
            Flags.Speed = not Flags.Speed
            print(Flags.Speed and "⚡ Speed ON" or "⚡ Speed OFF")
        end
        if input.KeyCode == Enum.KeyCode.N then
            Flags.NoClip = not Flags.NoClip
            print(Flags.NoClip and "🌀 NoClip ON" or "🌀 NoClip OFF")
        end
        if input.KeyCode == Enum.KeyCode.I then
            Flags.Invisible = not Flags.Invisible
            if not Flags.Invisible then
                RestoreVisibility()
            end
            print(Flags.Invisible and "👻 Invisible ON" or "👻 Invisible OFF")
        end
        if input.KeyCode == Enum.KeyCode.E then
            Flags.ESP = not Flags.ESP
            print(Flags.ESP and "👁️ ESP ON" or "👁️ ESP OFF")
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
    end)

    print("✅ MILK HUB ЗАГРУЖЕН!")
    print("📌 На телефоне: нажмите на кнопки в меню")
    print("📌 На ПК: клавиши F - Fly, G - Speed, N - NoClip, I - Invisible, E - ESP, K - Kill All")
end)
