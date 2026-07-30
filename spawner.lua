local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ItemSpawnerGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 450)
Frame.Position = UDim2.new(0.5, -210, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
Frame.BackgroundTransparency = 0.05
Frame.BorderColor3 = Color3.fromRGB(200, 180, 100)
Frame.BorderSizePixel = 2
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 24)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🎯 Item Spawner · MM2"
Title.TextColor3 = Color3.fromRGB(240, 210, 80)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local CategoryLabel = Instance.new("TextLabel")
CategoryLabel.Size = UDim2.new(1, -40, 0, 30)
CategoryLabel.Position = UDim2.new(0, 20, 0, 60)
CategoryLabel.BackgroundTransparency = 1
CategoryLabel.Text = "Select Category:"
CategoryLabel.TextColor3 = Color3.fromRGB(160, 175, 210)
CategoryLabel.TextSize = 14
CategoryLabel.Font = Enum.Font.GothamMedium
CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
CategoryLabel.Parent = Frame

local CategoryContainer = Instance.new("Frame")
CategoryContainer.Size = UDim2.new(1, -40, 0, 40)
CategoryContainer.Position = UDim2.new(0, 20, 0, 90)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.Parent = Frame

local categories = {"🔪 Knives", "🔫 Guns", "🐾 Pets"}

local categoryButtons = {}
for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 115, 0, 35)
    btn.Position = UDim2.new(0, (i-1) * 120, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 40, 65)
    btn.BorderColor3 = Color3.fromRGB(200, 180, 100)
    btn.BorderSizePixel = 1
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 210, 240)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = CategoryContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    categoryButtons[i] = btn
end

local SelectedCatLabel = Instance.new("TextLabel")
SelectedCatLabel.Size = UDim2.new(1, -40, 0, 25)
SelectedCatLabel.Position = UDim2.new(0, 20, 0, 135)
SelectedCatLabel.BackgroundTransparency = 1
SelectedCatLabel.Text = "Selected: 🔪 Knives"
SelectedCatLabel.TextColor3 = Color3.fromRGB(240, 210, 80)
SelectedCatLabel.TextSize = 13
SelectedCatLabel.Font = Enum.Font.GothamMedium
SelectedCatLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedCatLabel.Parent = Frame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, -40, 0, 25)
InputLabel.Position = UDim2.new(0, 20, 0, 165)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "Enter item name:"
InputLabel.TextColor3 = Color3.fromRGB(160, 175, 210)
InputLabel.TextSize = 14
InputLabel.Font = Enum.Font.GothamMedium
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 280, 0, 40)
TextBox.Position = UDim2.new(0.5, -140, 0, 195)
TextBox.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
TextBox.BorderColor3 = Color3.fromRGB(200, 180, 100)
TextBox.BorderSizePixel = 2
TextBox.Text = ""
TextBox.PlaceholderText = "e.g. Chroma Lightbringer"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 15
TextBox.Font = Enum.Font.GothamMedium
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 12)
TextBoxCorner.Parent = TextBox

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 180, 0, 48)
Button.Position = UDim2.new(0.5, -90, 0, 255)
Button.BackgroundColor3 = Color3.fromRGB(220, 180, 50)
Button.BorderSizePixel = 0
Button.Text = "🪄 CLAIM ITEM"
Button.TextColor3 = Color3.fromRGB(20, 22, 35)
Button.TextSize = 18
Button.Font = Enum.Font.GothamBold
Button.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 14)
ButtonCorner.Parent = Button

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, -40, 0, 30)
TimerLabel.Position = UDim2.new(0, 20, 0, 315)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "⏳ Ready to claim!"
TimerLabel.TextColor3 = Color3.fromRGB(180, 190, 220)
TimerLabel.TextSize = 16
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Parent = Frame

local ResultLabel = Instance.new("TextLabel")
ResultLabel.Size = UDim2.new(1, -40, 0, 30)
ResultLabel.Position = UDim2.new(0, 20, 0, 355)
ResultLabel.BackgroundTransparency = 1
ResultLabel.Text = "✨ Select a category and enter an item!"
ResultLabel.TextColor3 = Color3.fromRGB(180, 190, 220)
ResultLabel.TextSize = 13
ResultLabel.Font = Enum.Font.GothamMedium
ResultLabel.TextWrapped = true
ResultLabel.Parent = Frame

local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(0, 280, 0, 8)
ProgressBarBg.Position = UDim2.new(0.5, -140, 0, 395)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(40, 45, 70)
ProgressBarBg.BorderSizePixel = 0
ProgressBarBg.Parent = Frame

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(0, 4)
ProgressBarCorner.Parent = ProgressBarBg

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(240, 210, 80)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBarBg

local ProgressBarCorner2 = Instance.new("UICorner")
ProgressBarCorner2.CornerRadius = UDim.new(0, 4)
ProgressBarCorner2.Parent = ProgressBar

local currentCategory = "🔪 Knives"
local selectedCategoryIndex = 1
local claimedItems = {}
local isProcessing = false

local categoryItems = {
    ["🔪 Knives"] = {
        "Chroma Lightbringer", "Chroma Darkbringer", "Eternal", "Eternal II", "Eternal III",
        "Eternal IV", "Luger", "Chroma Luger", "Ginger Luger", "Icebreaker",
        "Heat", "Chroma Heat", "Tides", "Chroma Tides", "Darkbringer",
        "Lightbringer", "Heartblade", "Sparkle", "Iceshard", "Snowflake"
    },
    ["🔫 Guns"] = {
        "Chroma Laser", "Laser", "Chroma Blaster", "Blaster", "Slime",
        "Chroma Slime", "Pumpkin", "Chroma Pumpkin", "Overseer", "Chroma Overseer",
        "Eggblade", "Chroma Eggblade", "JD", "Chroma JD", "Candy",
        "Chroma Candy", "Ghost", "Chroma Ghost", "Vampire", "Chroma Vampire"
    },
    ["🐾 Pets"] = {
        "Neon Turtle", "Mega Unicorn", "Shadow Dragon", "Bat Dragon", "Giraffe",
        "Frost Dragon", "Owl", "Parrot", "Crow", "Evil Unicorn",
        "Arctic Reindeer", "Turtle", "Kangaroo", "King Monkey", "Queen Bee",
        "Diamond Pet", "Golden Pet", "Albino", "Mega Pet", "Neon Pet"
    }
}

local function startTimer(duration, callback)
    isProcessing = true
    Button.Visible = false
    local startTime = tick()
    local elapsed = 0
    
    TimerLabel.Text = "⏳ Processing... " .. duration .. "s"
    TimerLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    TextBox.Visible = false
    
    while elapsed < duration do
        elapsed = tick() - startTime
        local remaining = math.floor(duration - elapsed)
        TimerLabel.Text = "⏳ Processing... " .. remaining .. "s"
        
        local progress = elapsed / duration
        ProgressBar.Size = UDim2.new(progress, 0, 1, 0)
        
        if progress < 0.5 then
            ProgressBar.BackgroundColor3 = Color3.fromRGB(240, 210, 80)
        elseif progress < 0.8 then
            ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        else
            ProgressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        task.wait(0.1)
    end
    
    ProgressBar.Size = UDim2.new(1, 0, 1, 0)
    TimerLabel.Text = "✅ Ready!"
    TimerLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    task.wait(0.5)
    
    if callback then
        callback()
    end
        isProcessing = false
    Button.Visible = true
    TextBox.Visible = true
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    TimerLabel.Text = "⏳ Ready to claim!"
    TimerLabel.TextColor3 = Color3.fromRGB(180, 190, 220)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(240, 210, 80)
end

local function createVisualItem(itemName, category)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "SpawnerItem_" .. itemName
    itemFrame.Size = UDim2.new(0, 60, 0, 60)
    itemFrame.Position = UDim2.new(0, #claimedItems * 65 + 10, 0, 10)
    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 65)
    itemFrame.BorderColor3 = Color3.fromRGB(200, 180, 100)
    itemFrame.BorderSizePixel = 2
    itemFrame.BackgroundTransparency = 0.1
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 12)
    itemCorner.Parent = itemFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0.6, 0)
    iconLabel.Position = UDim2.new(0, 0, 0, 5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 20
    iconLabel.Font = Enum.Font.GothamBold
    
    if category == "🔪 Knives" then
        iconLabel.Text = "🔪"
    elseif category == "🔫 Guns" then
        iconLabel.Text = "🔫"
    elseif category == "🐾 Pets" then
        iconLabel.Text = "🐾"
    else
        iconLabel.Text = "⭐"
    end
    iconLabel.Parent = itemFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = string.sub(itemName, 1, 8)
    nameLabel.TextColor3 = Color3.fromRGB(240, 210, 80)
    nameLabel.TextSize = 9
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = itemFrame
    
    local hotbarContainer = Player.PlayerGui:FindFirstChild("SpawnerInventoryContainer")
    if not hotbarContainer then
        hotbarContainer = Instance.new("Frame")
        hotbarContainer.Name = "SpawnerInventoryContainer"
        hotbarContainer.Size = UDim2.new(0, #claimedItems * 65 + 20, 0, 80)
        hotbarContainer.Position = UDim2.new(0.5, -((#claimedItems * 65 + 20) / 2), 1, -90)
        hotbarContainer.BackgroundTransparency = 0.3
        hotbarContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        hotbarContainer.BorderColor3 = Color3.fromRGB(200, 180, 100)
        hotbarContainer.BorderSizePixel = 2
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 16)
        containerCorner.Parent = hotbarContainer
        
        hotbarContainer.Parent = Player.PlayerGui
    else
        hotbarContainer.Size = UDim2.new(0, #claimedItems * 65 + 20, 0, 80)
        hotbarContainer.Position = UDim2.new(0.5, -((#claimedItems * 65 + 20) / 2), 1, -90)
    end
    
    itemFrame.Position = UDim2.new(0, #claimedItems * 65 + 10, 0, 10)
    itemFrame.Parent = hotbarContainer
    
    table.insert(claimedItems, {name = itemName, frame = itemFrame, container = hotbarContainer})
    
    ResultLabel.Text = "📦 Added " .. itemName .. " to inventory!"
    ResultLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
end

local function updateCategory(category, index)
    currentCategory = category
    selectedCategoryIndex = index
    SelectedCatLabel.Text = "Selected: " .. category
    
    for i, btn in ipairs(categoryButtons) do
        if i == index then
            btn.BackgroundColor3 = Color3.fromRGB(60, 65, 100)
            btn.BorderColor3 = Color3.fromRGB(255, 215, 80)
            btn.TextColor3 = Color3.fromRGB(255, 215, 80)
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 40, 65)
            btn.BorderColor3 = Color3.fromRGB(200, 180, 100)
            btn.TextColor3 = Color3.fromRGB(200, 210, 240)
        end
    end
    
    local examples = {
        ["🔪 Knives"] = "e.g. Flora",
        ["🔫 Guns"] = "e.g. GinderLuger",
        ["🐾 Pets"] = "e.g. Dog"
    }
    TextBox.PlaceholderText = examples[category] or "Enter item name..."
end

for i, btn in ipairs(categoryButtons) do
    btn.MouseButton1Click:Connect(function()
        local cat = categories[i]
        updateCategory(cat, i)
        ResultLabel.Text = "✨ Selected: " .. cat .. " — enter an item!"
        ResultLabel.TextColor3 = Color3.fromRGB(180, 190, 220)
    end)
    
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(60, 65, 100) then
            btn.BackgroundColor3 = Color3.fromRGB(45, 50, 80)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(60, 65, 100) then
            btn.BackgroundColor3 = Color3.fromRGB(35, 40, 65)
        end
    end)
end

Button.MouseEnter:Connect(function()
    if not isProcessing then
        Button.BackgroundColor3 = Color3.fromRGB(245, 210, 80)
        Button.Text = "⚡ CLAIM ITEM"
    end
end)

Button.MouseLeave:Connect(function()
    if not isProcessing then
        Button.BackgroundColor3 = Color3.fromRGB(220, 180, 50)
        Button.Text = "🪄 CLAIM ITEM"
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        ScreenGui:Destroy()
        local hotbar = Player.PlayerGui:FindFirstChild("FakeInventoryContainer")
        if hotbar then
            hotbar:Destroy()
        end
    end
end)

Button.MouseButton1Click:Connect(function()
    if isProcessing then
        ResultLabel.Text = "⏳ Please wait for current claim to finish!"
        ResultLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
        return
    end
    
    local itemName = TextBox.Text
    if itemName == "" or itemName == " " then
        ResultLabel.Text = "⚠️ Please enter an item name!"
        ResultLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
        return
    end
    
    local itemsInCategory = categoryItems[currentCategory] or {}
    local itemFound = false
    for _, item in ipairs(itemsInCategory) do
        if string.lower(item) == string.lower(itemName) then
            itemFound = true
            break
        end
    end
    
    local timerDuration = math.random(15, 30)
    ResultLabel.Text = "⏳ Claiming " .. itemName .. "..."
    ResultLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    startTimer(timerDuration, function()
        local successMessages = {
            "✅ " .. itemName .. " added to your inventory!",
            "🎉 You received " .. itemName .. "!",
            "📦 " .. itemName .. " has been claimed!",
            "✨ " .. itemName .. " is now in your visual inventory!",
            "💎 Congratulations! You got " .. itemName .. "!",
            "🛍️ " .. itemName .. " added to inventory.",
            "🌟 " .. itemName .. " has been delivered!",
            "🎁 You unlocked " .. itemName .. "!"
        }
        
        local randomIndex = math.random(1, #successMessages)
        local msg = successMessages[randomIndex]
        
        if not itemFound then
            msg = "🎲 " .. itemName .. " added to inventory! (Rare find!)"
        end
        
        ResultLabel.Text = msg
        ResultLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        
        createVisualItem(itemName, currentCategory)
        
        Button.BackgroundColor3 = Color3.fromRGB(80, 220, 100)
        task.wait(0.4)
        Button.BackgroundColor3 = Color3.fromRGB(220, 180, 50)
        
        task.wait(1.5)
        TextBox.Text = ""
        ResultLabel.Text = "✨ ready for next item..."
        ResultLabel.TextColor3 = Color3.fromRGB(180, 190, 220)
        Button.Text = "🪄 CLAIM ITEM"
    end)
end)

TextBox.Focused:Connect(function()
    TextBox.BorderColor3 = Color3.fromRGB(255, 215, 80)
end)

TextBox.FocusLost:Connect(function()
    TextBox.BorderColor3 = Color3.fromRGB(200, 180, 100)
end)

updateCategory("🔪 Knives", 1)

game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Player.Parent then
        local hotbar = Player.PlayerGui:FindFirstChild("FakeInventoryContainer")
        if hotbar then
            hotbar:Destroy()
        end
    end
end)
