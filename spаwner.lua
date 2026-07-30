local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 40)
Label.Position = UDim2.new(0, 0, 0, 20)
Label.BackgroundTransparency = 1
Label.Text = "🥛 MilkHub"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextSize = 24
Label.Font = Enum.Font.GothamBold
Label.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 200, 0, 35)
TextBox.Position = UDim2.new(0.5, -100, 0, 70)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
TextBox.Text = ""
TextBox.PlaceholderText = "Enter item name"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.GothamMedium
TextBox.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 150, 0, 40)
Button.Position = UDim2.new(0.5, -75, 0, 120)
Button.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
Button.Text = "CLAIM"
Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18
Button.Parent = Frame

local Result = Instance.new("TextLabel")
Result.Size = UDim2.new(1, 0, 0, 30)
Result.Position = UDim2.new(0, 0, 0, 170)
Result.BackgroundTransparency = 1
Result.Text = "Ready"
Result.TextColor3 = Color3.fromRGB(200, 200, 200)
Result.TextSize = 14
Result.Font = Enum.Font.GothamMedium
Result.Parent = Frame

Button.MouseButton1Click:Connect(function()
    local item = TextBox.Text
    if item == "" then
        Result.Text = "⚠️ Enter an item!"
        return
    end
    
    Result.Text = "✅ " .. item .. " added!"
    TextBox.Text = ""
    task.wait(2)
    Result.Text = "Ready"
end)

print("GUI created!")
