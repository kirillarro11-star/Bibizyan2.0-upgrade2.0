-- Библиотека для создания GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Создание окна
local Window = Library.CreateLib("BIBIZAN HUB", "BloodTheme")

-- Вкладка "Основные функции"
local MainTab = Window:NewTab("Основные")
local MainSection = MainTab:NewSection("Настройки")

-- Переменные для функций
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Walk Speed с регулировкой
MainSection:NewSlider("Скорость ходьбы", "Изменение скорости", 16, 100, function(s)
    Humanoid.WalkSpeed = s
end)

-- Бесконечный прыжок
local InfiniteJump = false
MainSection:NewToggle("Бесконечный прыжок", "Включить/Выключить", function(state)
    InfiniteJump = state
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfiniteJump then
                Humanoid.Jump = true
            end
        end)
    end
end)

-- Вкладка "Телепорты"
local TeleportTab = Window:NewTab("Телепорты")
local TeleportSection = TeleportTab:NewSection("К игрокам")

-- Получение списка игроков для телепортации
local function GetPlayers()
    local players = {}
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player then
            table.insert(players, v.Name)
        end
    end
    return players
end

-- Телепортация к выбранному игроку
TeleportSection:NewDropdown("Выберите игрока", "Телепорт к игроку", GetPlayers(), function(selected)
    local target = game.Players[selected]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
    end
end)

-- Noclip (сделали рабочим)
local NoclipEnabled = false
TeleportSection:NewToggle("Noclip", "Включить/Выключить", function(state)
    NoclipEnabled = state
    game:GetService("RunService").Stepped:Connect(function()
        if NoclipEnabled and Character and Character:FindFirstChild("HumanoidRootPart") then
            for i, v in pairs(Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- Вкладка "Brainrot"
local BrainrotTab = Window:NewTab("Brainrot")
local BrainrotSection = BrainrotTab:NewSection("Подсветка")

-- Подсветка дорогих бреинротов (если есть предметы)
BrainrotSection:NewToggle("Подсветка дорогих", "Показать дорогие Brainrot", function(state)
    if state then
        for i, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = v
                highlight.Adornee = v
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        for i, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Highlight") then
                v.Highlight:Destroy()
            end
        end
    end
end)

-- Создаем кнопку на экране (размер 8.5 см * 800x600)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 120, 0, 40) -- 8.5 см примерно
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "BIBIZAN HUB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold

-- Делаем кнопку перетаскиваемой
local dragging = false
local dragInput
local dragStart
local startPos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Открытие/закрытие меню по кнопке
local MenuOpen = false
ToggleButton.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Window:Toggle(MenuOpen)
end)

-- Радужный цвет для меню
spawn(function()
    while wait(0.1) do
        local hue = tick() % 1
        Window.BackgroundColor = Color3.fromHSV(hue, 1, 0.7)
        ToggleButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 0.7)
    end
end)

-- Оптимизация под телефон
game:GetService("RunService").RenderStepped:Connect(function()
    if Character and Character:FindFirstChild("Humanoid") then
        if Character.Humanoid.WalkSpeed > 100 then
            Character.Humanoid.WalkSpeed = 100
        end
    end
end)

print("BIBIZAN HUB загружен! Нажми на кнопку, чтобы открыть меню.")
