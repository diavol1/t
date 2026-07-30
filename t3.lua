-- Самый простой вариант для теста
print("Скрипт начал работу!")

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

print("Игрок найден: " .. tostring(LP))

-- Ждем пока появится PlayerGui
repeat 
    wait(0.1)
    print("Ждем PlayerGui...")
until LP:FindFirstChild("PlayerGui")

print("PlayerGui найден!")

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestGUI"
ScreenGui.Parent = LP.PlayerGui

print("GUI создан!")

-- Создаем простое меню
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
Main.BackgroundTransparency = 0.3
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

print("Меню создано!")

-- Кнопка для проверки
local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(0.8, 0, 0, 50)
TestButton.Position = UDim2.new(0.1, 0, 0.3, 0)
TestButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TestButton.Text = "ТЕСТ РАБОТАЕТ!"
TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TestButton.TextScaled = true
TestButton.Font = Enum.Font.GothamBold
TestButton.Parent = Main

TestButton.MouseButton1Click:Connect(function()
    print("Кнопка нажата! СКРИПТ РАБОТАЕТ!")
    TestButton.Text = "УСПЕШНО!"
    TestButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
end)

print("🔥 Тестовый GUI загружен!")
