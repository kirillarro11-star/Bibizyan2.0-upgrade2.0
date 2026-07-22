-- ============================================================
--           BIBIZAN HUB v2.0 (Speed Keyboard Escape)
--           Быстрая скорость + бесконечный прыжок + телепорт
--           Для Delta Executor | Mobile & PC
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- === НАСТРОЙКИ ===
local Settings = {
    FastSpeed = false,
    SpeedValue = 50,
    InfiniteJump = false,
}

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- КНОПКА ОТКРЫТИЯ (перемещаемая)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 140, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "bibizan Hub"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

-- ОСНОВНОЕ МЕНЮ (размер ~7 см ≈ 320x400)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

-- РАДУЖНЫЙ ФОН
local function startRainbow()
    RunService.RenderStepped:Connect(function()
        if not MainFrame.Visible then return end
        local hue = (tick() * 0.1) % 1
        MainFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.5)
    end)
end
startRainbow()

-- ЗАГОЛОВОК (для перетаскивания)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Title.Text = "  BIBIZAN HUB  (Speed Keyboard Escape)"
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- КОНТЕЙНЕР ДЛЯ ЭЛЕМЕНТОВ
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -10, 1, -45)
Content.Position = UDim2.new(0, 5, 0, 40)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 400) -- будет расширяться
Content.ScrollBarThickness = 4
Content.Parent = MainFrame

local function addY(offset) Content.CanvasSize = UDim2.new(0,0,0,Content.CanvasSize.Y.Offset + offset) end

-- ============================================================
--  ЭЛЕМЕНТЫ УПРАВЛЕНИЯ
-- ============================================================

-- 1. Быстрая скорость (переключатель + ползунок)
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 70)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = Content
addY(70)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 150, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Быстрая скорость"
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 60, 0, 30)
speedToggle.Position = UDim2.new(1, -70, 0, 0)
speedToggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
speedToggle.Text = "OFF"
speedToggle.TextColor3 = Color3.fromRGB(255,255,255)
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 14
speedToggle.Parent = speedFrame

speedToggle.MouseButton1Click:Connect(function()
    Settings.FastSpeed = not Settings.FastSpeed
    speedToggle.BackgroundColor3 = Settings.FastSpeed and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
    speedToggle.Text = Settings.FastSpeed and "ON" or "OFF"
end)

-- Ползунок скорости
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(1, 0, 0, 30)
speedSliderFrame.Position = UDim2.new(0, 0, 0, 35)
speedSliderFrame.BackgroundTransparency = 1
speedSliderFrame.Parent = speedFrame

local speedVal = Instance.new("TextLabel")
speedVal.Size = UDim2.new(0, 40, 0, 30)
speedVal.Position = UDim2.new(1, -45, 0, 0)
speedVal.BackgroundTransparency = 1
speedVal.Text = tostring(Settings.SpeedValue)
speedVal.TextColor3 = Color3.fromRGB(255,200,100)
speedVal.Font = Enum.Font.GothamBold
speedVal.TextSize = 16
speedVal.Parent = speedSliderFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0, 200, 0, 6)
speedSlider.Position = UDim2.new(0, 0, 0.5, -3)
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,70)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = speedSliderFrame

local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new((Settings.SpeedValue-0)/(100-0), 0, 1, 0) -- min=0, max=100
speedFill.BackgroundColor3 = Color3.fromRGB(0,150,255)
speedFill.BorderSizePixel = 0
speedFill.Parent = speedSlider

local speedDrag = false
local function updateSpeed(input)
    local pos = input.Position.X - speedSlider.AbsolutePosition.X
    local p = math.clamp(pos / speedSlider.AbsoluteSize.X, 0, 1)
    local v = math.round(p * 100)
    Settings.SpeedValue = v
    speedFill.Size = UDim2.new(p, 0, 1, 0)
    speedVal.Text = tostring(v)
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDrag = true
        updateSpeed(input)
    end
end)
speedSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDrag = false
    end
end)
speedSlider.InputChanged:Connect(function(input)
    if speedDrag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateSpeed(input)
    end
end)

-- 2. Бесконечный прыжок
local jumpFrame = Instance.new("Frame")
jumpFrame.Size = UDim2.new(1, 0, 0, 40)
jumpFrame.BackgroundTransparency = 1
jumpFrame.Parent = Content
addY(40)

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 200, 0, 30)
jumpLabel.Position = UDim2.new(0, 0, 0, 5)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Бесконечный прыжок"
jumpLabel.TextColor3 = Color3.fromRGB(255,255,255)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 16
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = jumpFrame

local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0, 60, 0, 30)
jumpToggle.Position = UDim2.new(1, -70, 0, 5)
jumpToggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
jumpToggle.Text = "OFF"
jumpToggle.TextColor3 = Color3.fromRGB(255,255,255)
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.TextSize = 14
jumpToggle.Parent = jumpFrame

jumpToggle.MouseButton1Click:Connect(function()
    Settings.InfiniteJump = not Settings.InfiniteJump
    jumpToggle.BackgroundColor3 = Settings.InfiniteJump and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
    jumpToggle.Text = Settings.InfiniteJump and "ON" or "OFF"
end)

-- 3. Телепортация на станции (игроки)
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(1, 0, 0, 50)
teleportFrame.BackgroundTransparency = 1
teleportFrame.Parent = Content
addY(50)

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(1, 0, 0, 30)
teleportLabel.BackgroundTransparency = 1
teleportLabel.Text = "Телепорт к игрокам (нажми на имя)"
teleportLabel.TextColor3 = Color3.fromRGB(255,200,100)
teleportLabel.Font = Enum.Font.GothamBold
teleportLabel.TextSize = 16
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = teleportFrame

-- Контейнер для кнопок игроков
local playerList = Instance.new("Frame")
playerList.Size = UDim2.new(1, 0, 0, 200)
playerList.Position = UDim2.new(0, 0, 0, 35)
playerList.BackgroundTransparency = 1
playerList.Parent = teleportFrame
addY(200)

local function updatePlayerList()
    -- Удаляем старые кнопки
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local players = game:GetService("Players"):GetPlayers()
    local y = 0
    for _, p in ipairs(players) do
        if p == Player then continue end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.Text = p.Name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = playerList
        btn.MouseButton1Click:Connect(function()
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local root = p.Character.HumanoidRootPart
                local char = Player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 3, 0) -- немного выше
                end
            end
        end)
        y = y + 35
    end
    -- Обновляем размер
    playerList.Size = UDim2.new(1, 0, 0, y + 10)
    local totalY = 70 + 40 + 50 + y + 30 -- примерное
    Content.CanvasSize = UDim2.new(0, 0, 0, totalY)
end

updatePlayerList()
game:GetService("Players").PlayerAdded:Connect(updatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerList)

-- ============================================================
--  ЛОГИКА ПЕРСОНАЖА (скорость и прыжок)
-- ============================================================
local function applyCharacter(char)
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    local speedConn = RunService.Stepped:Connect(function()
        if Settings.FastSpeed then
            hum.WalkSpeed = Settings.SpeedValue
        else
            hum.WalkSpeed = 16 -- дефолт
        end
    end)

    local jumpConn
    if Settings.InfiniteJump then
        jumpConn = RunService.Stepped:Connect(function()
            if hum:GetState() == Enum.HumanoidStateType.Jumping then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    char:SetAttribute("Cleanup", {speedConn, jumpConn})
end

local function onCharacterAdded(char)
    char:WaitForChild("Humanoid")
    local cleanup = char:GetAttribute("Cleanup")
    if cleanup then
        for _, c in ipairs(cleanup) do
            if c and c.Disconnect then pcall(c.Disconnect, c) end
        end
    end
    applyCharacter(char)
end

if Player.Character then onCharacterAdded(Player.Character) end
Player.CharacterAdded:Connect(onCharacterAdded)

-- ============================================================
--  ПЕРЕТАСКИВАНИЕ МЕНЮ
-- ============================================================
local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
--  ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ
-- ============================================================
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("✅ BIBIZAN HUB (Speed Keyboard Escape) загружен! Нажмите кнопку для открытия.")
