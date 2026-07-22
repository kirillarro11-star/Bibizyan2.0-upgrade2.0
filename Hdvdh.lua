-- Библиотека для создания GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Создание окна
local Window = Library.CreateLib("BIBIZAN HUB", "BloodTheme")

-- Переменные для функций
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Вкладка "Основные функции"
local MainTab = Window:NewTab("Основные")
local MainSection = MainTab:NewSection("Настройки")

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
local BrainrotSection = BrainrotTab:NewSection("Подсветка и сбор")

-- Подсветка дорогих бреинротов
local highlightEnabled = false
BrainrotSection:NewToggle("Подсветка дорогих", "Показать дорогие Brainrot", function(state)
    highlightEnabled = state
    if state then
        for i, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                -- Проверяем ценность (если есть значение)
                local value = 0
                if v:FindFirstChild("Value") then
                    value = v.Value.Value
                elseif v:FindFirstChild("Price") then
                    value = v.Price.Value
                end
                
                if value >= 100 then -- Считаем дорогим если цена >= 100
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = v
                    highlight.Adornee = v
                    highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Золотой цвет
                    highlight.FillTransparency = 0.3
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0.2
                    
                    -- Добавляем билборд с ценой
                    local billboard = Instance.new("BillboardGui")
                    billboard.Parent = v
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.Adornee = v
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Parent = billboard
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = "💰 " .. value
                    textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                end
            end
        end
    else
        for i, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") then
                if v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
                if v:FindFirstChild("BillboardGui") then
                    v.BillboardGui:Destroy()
                end
            end
        end
    end
end)

-- Кнопка для сбора дорогих бреинротов
BrainrotSection:NewButton("Собрать дорогие Brainrot", "Телепорт к дорогим предметам", function()
    local collected = 0
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local value = 0
            if v:FindFirstChild("Value") then
                value = v.Value.Value
            elseif v:FindFirstChild("Price") then
                value = v.Price.Value
            end
            
            if value >= 100 then
                -- Телепортируемся к предмету
                if v:FindFirstChild("Handle") then
                    Character:FindFirstChild("HumanoidRootPart").CFrame = v.Handle.CFrame * CFrame.new(0, 2, 0)
                    collected = collected + 1
                    wait(0.3) -- Небольшая задержка между телепортами
                end
            end
        end
    end
    print("Собрано " .. collected .. " дорогих Brainrot!")
end)

-- Вкладка "Убийство"
local KillTab = Window:NewTab("Убийство")
local KillSection = KillTab:NewSection("Убить игрока")

-- Функция убийства игрока
local function KillPlayer(targetName)
    local target = game.Players:FindFirstChild(targetName)
    if target and target.Character then
        local targetHumanoid = target.Character:FindFirstChild("Humanoid")
        if targetHumanoid then
            targetHumanoid.Health = 0
            return true
        end
    end
    return false
end

-- Текстовое поле для ввода ника
KillSection:NewTextBox("Ник игрока", "Введите ник для убийства", function(text)
    if text ~= "" then
        local success = KillPlayer(text)
        if success then
            print("Игрок " .. text .. " убит!")
        else
            print("Игрок не найден или уже мертв")
        end
    end
end)

-- Кнопка для быстрого убийства выбранного игрока из списка
KillSection:NewDropdown("Выбрать игрока", "Убить выбранного игрока", GetPlayers(), function(selected)
    KillPlayer(selected)
end)

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui

-- Главная кнопка для открытия меню
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "BIBIZAN HUB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold

-- Функция для перетаскивания
local function MakeDraggable(button)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Делаем кнопку перетаскиваемой
MakeDraggable(ToggleButton)

-- Открытие/закрытие меню
local MenuOpen = false

ToggleButton.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Window:Toggle(MenuOpen)
    if MenuOpen then
        ToggleButton.Text = "BIBIZAN HUB ✕"
    else
        ToggleButton.Text = "BIBIZAN HUB"
    end
end)

-- Делаем всё меню перетаскиваемым
local function MakeWindowDraggable()
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    -- Находим главную панель меню
    local menuFrame = nil
    for i, v in pairs(Window.Frame:GetChildren()) do
        if v:IsA("Frame") and v.Name == "Main" then
            menuFrame = v
            break
        end
    end
    
    if menuFrame then
        menuFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = menuFrame.Position
            end
        end)
        
        menuFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        menuFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                menuFrame.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
end

-- Ждем создания меню и делаем его перетаскиваемым
spawn(function()
    wait(0.5)
    MakeWindowDraggable()
end)

-- Радужный цвет для меню и кнопок
spawn(function()
    while wait(0.1) do
        local hue = tick() % 1
        Window.BackgroundColor = Color3.fromHSV(hue, 1, 0.7)
        ToggleButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 0.7)
        ToggleButton.BorderColor3 = Color3.fromHSV((hue + 0.5) % 1, 1, 0.7)
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

-- Обновление подсветки при появлении новых предметов
spawn(function()
    while wait(2) do
        if highlightEnabled then
            for i, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") and not v:FindFirstChild("Highlight") then
                    local value = 0
                    if v:FindFirstChild("Value") then
                        value = v.Value.Value
                    elseif v:FindFirstChild("Price") then
                        value = v.Price.Value
                    end
                    
                    if value >= 100 then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = v
                        highlight.Adornee = v
                        highlight.FillColor = Color3.fromRGB(255, 215, 0)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineTransparency = 0.2
                    end
                end
            end
        end
    end
end)

print("BIBIZAN HUB загружен! Нажми на кнопку, чтобы открыть/закрыть меню.")
print("Меню можно перетаскивать за верхнюю панель.")
