local function startSpawner()
    local player = game:GetService("Players").LocalPlayer
    if not player then return end

    local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
    if not playerGui then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpawnerGUI"
    ScreenGui.Parent = playerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 220)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 12)
    FrameCorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 40)
    Label.Position = UDim2.new(0, 0, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = "🥛 MilkHub Spawner"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 22
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Frame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 220, 0, 40)
    TextBox.Position = UDim2.new(0.5, -110, 0, 65)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 35, 60)
    TextBox.Text = ""
    TextBox.PlaceholderText = "Enter item name..."
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.TextSize = 16
    TextBox.Parent = Frame

    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 8)
    TextBoxCorner.Parent = TextBox

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 160, 0, 44)
    Button.Position = UDim2.new(0.5, -80, 0, 120)
    Button.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    Button.Text = "🪄 CLAIM"
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 18
    Button.Parent = Frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button

    local Result = Instance.new("TextLabel")
    Result.Size = UDim2.new(1, -20, 0, 30)
    Result.Position = UDim2.new(0, 10, 0, 180)
    Result.BackgroundTransparency = 1
    Result.Text = "✨ Ready"
    Result.TextColor3 = Color3.fromRGB(180, 190, 220)
    Result.TextSize = 14
    Result.Font = Enum.Font.GothamMedium
    Result.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        local item = TextBox.Text
        if item == "" or item == " " then
            Result.Text = "⚠️ Enter an item name!"
            Result.TextColor3 = Color3.fromRGB(255, 180, 100)
            return
        end

        Result.Text = "✅ " .. item .. " added to inventory!"
        Result.TextColor3 = Color3.fromRGB(100, 255, 150)
        TextBox.Text = ""
        Button.Text = "✅ DONE"
        Button.BackgroundColor3 = Color3.fromRGB(80, 220, 100)

        task.wait(2)

        Result.Text = "✨ Ready"
        Result.TextColor3 = Color3.fromRGB(180, 190, 220)
        Button.Text = "🪄 CLAIM"
        Button.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    end)

    print("✅ Spawner GUI создан!")
end

local success, err = pcall(startSpawner)
if not success then
    warn("Ошибка при создании GUI: " .. tostring(err))
    print("⚠️ Попробуй выполнить скрипт через loadstring вручную.")
end
