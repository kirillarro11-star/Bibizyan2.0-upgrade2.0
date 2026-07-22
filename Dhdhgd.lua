-- ============================================================
--           BIBIZAN HUB v1.0 (Speed Draw)
--           Авто-рисунок + радужное меню
--           Для Delta Executor
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- === НАСТРОЙКИ ===
local Settings = {
    AutoDraw = false,
}

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- КНОПКА ОТКРЫТИЯ
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "bibizan Hub"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

-- ОСНОВНОЕ МЕНЮ (620x200)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 200)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.2
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
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Title.Text = "  BIBIZAN HUB  (Speed Draw)"
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- === ПАНЕЛЬ УПРАВЛЕНИЯ ===
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, -20, 1, -40)
ControlPanel.Position = UDim2.new(0, 10, 0, 35)
ControlPanel.BackgroundTransparency = 1
ControlPanel.Parent = MainFrame

-- КНОПКА АВТО-РИСУНОК (ON/OFF)
local AutoDrawLabel = Instance.new("TextLabel")
AutoDrawLabel.Size = UDim2.new(0, 150, 0, 30)
AutoDrawLabel.Position = UDim2.new(0, 0, 0, 10)
AutoDrawLabel.BackgroundTransparency = 1
AutoDrawLabel.Text = "Авто-рисунок:"
AutoDrawLabel.TextColor3 = Color3.fromRGB(255,255,255)
AutoDrawLabel.Font = Enum.Font.Gotham
AutoDrawLabel.TextSize = 18
AutoDrawLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoDrawLabel.Parent = ControlPanel

local AutoDrawBtn = Instance.new("TextButton")
AutoDrawBtn.Size = UDim2.new(0, 80, 0, 30)
AutoDrawBtn.Position = UDim2.new(0, 160, 0, 10)
AutoDrawBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
AutoDrawBtn.Text = "OFF"
AutoDrawBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoDrawBtn.Font = Enum.Font.GothamBold
AutoDrawBtn.TextSize = 16
AutoDrawBtn.Parent = ControlPanel

AutoDrawBtn.MouseButton1Click:Connect(function()
    Settings.AutoDraw = not Settings.AutoDraw
    AutoDrawBtn.BackgroundColor3 = Settings.AutoDraw and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
    AutoDrawBtn.Text = Settings.AutoDraw and "ON" or "OFF"
    if Settings.AutoDraw then
        startAutoDraw()
    else
        stopAutoDraw()
    end
end)

-- === ЛОГИКА АВТО-РИСУНКА ===
local autoDrawRunning = false
local autoDrawThread = nil

local function getMousePosition()
    return UserInputService:GetMouseLocation()
end

local function moveMouseAbsolute(x, y)
    -- Используем стандартные функции Delta
    -- Если есть mousemoveabs, используем её, иначе пробуем виртуальный ввод
    if mousemoveabs then
        mousemoveabs(x, y)
    else
        -- Альтернатива через VirtualInputManager (не всегда работает)
        -- local VIM = game:GetService("VirtualInputManager")
        -- VIM:SendMouseMoveEvent(Vector2.new(x, y), 0)
    end
end

local function moveMouseRelative(dx, dy)
    if mousemoverel then
        mousemoverel(dx, dy)
    end
end

local function pressMouse()
    if mouse1press then mouse1press() end
end

local function releaseMouse()
    if mouse1release then mouse1release() end
end

function startAutoDraw()
    if autoDrawRunning then return end
    autoDrawRunning = true

    autoDrawThread = coroutine.create(function()
        -- Получаем центр экрана
        local viewport = Camera.ViewportSize
        local centerX = viewport.X / 2
        local centerY = viewport.Y / 2
        local radius = 150
        local steps = 100
        local angle = 0

        -- Начинаем рисование
        pressMouse()
        task.wait(0.1)

        while autoDrawRunning do
            -- Двигаем мышь по кругу
            for i = 1, steps do
                if not autoDrawRunning then break end
                local theta = (i / steps) * 2 * math.pi + angle
                local x = centerX + radius * math.cos(theta)
                local y = centerY + radius * math.sin(theta)
                moveMouseAbsolute(x, y)
                task.wait(0.01) -- плавность
            end
            angle = angle + 0.1
            -- Небольшая пауза между кругами
            task.wait(0.05)
        end

        releaseMouse()
    end)

    coroutine.resume(autoDrawThread)
end

function stopAutoDraw()
    autoDrawRunning = false
    if autoDrawThread then
        -- Ждём завершения корутины
        while coroutine.status(autoDrawThread) ~= "dead" do
            task.wait()
        end
        autoDrawThread = nil
    end
    releaseMouse()
end

-- === ПЕРЕТАСКИВАНИЕ МЕНЮ ===
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

-- === ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ ===
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("✅ BIBIZAN HUB загружен! Нажмите кнопку 'bibizan Hub' для открытия меню.")
