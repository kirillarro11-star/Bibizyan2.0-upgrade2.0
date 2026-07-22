-- ============================================================
--           BIBIZZZAN HUB  v4.0  (FIXED OPEN + RAINBOW)
--           Для Delta Executor | Mobile & PC
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- === НАСТРОЙКИ (по умолчанию) ===
local Settings = {
    Noclip = false,
    Aimbot = false,
    SilentAim = false,
    SilentAimRadius = 30,   -- градусы (0-180)
    HighJump = false,
    WalkSpeed = 16,
    Esp = false,
    Lines = false,
}

-- === GUI КОНТЕЙНЕР ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false   -- сохраняется после респавна

-- ============================================================
--  ОСНОВНОЕ МЕНЮ (создаём ПЕРВЫМ, чтобы обработчики ссылались на него)
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 470)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -235)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

-- === ПЕРЕЛИВАЮЩИЙСЯ ФОН (анимация) ===
local rainbowConn
local function startRainbow()
    rainbowConn = RunService.RenderStepped:Connect(function()
        local hue = (tick() * 0.1) % 1
        local color = Color3.fromHSV(hue, 0.8, 0.4)
        MainFrame.BackgroundColor3 = color
    end)
end
startRainbow()

-- Заголовок (перетаскивание меню)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Title.Text = "  BIBIZZZAN HUB  (7.5 cm)"
Title.TextColor3 = Color3.fromRGB(255, 200, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Кнопка закрытия (крестик)
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

-- ============================================================
--  КНОПКА ОТКРЫТИЯ (создаём после MainFrame)
-- ============================================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 150, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "bibizzzan Hub"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.BackgroundTransparency = 0.15
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

-- Логика: короткое нажатие = открыть/закрыть, движение >10px = перетаскивание
local isDraggingOpen = false
local dragStartOpen, startPosOpen, hasMovedOpen

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingOpen = true
        dragStartOpen = input.Position
        startPosOpen = ToggleButton.Position
        hasMovedOpen = false
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if isDraggingOpen and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = (input.Position - dragStartOpen).Magnitude
        if delta > 10 then
            hasMovedOpen = true
            ToggleButton.Position = UDim2.new(
                startPosOpen.X.Scale, startPosOpen.X.Offset + (input.Position.X - dragStartOpen.X),
                startPosOpen.Y.Scale, startPosOpen.Y.Offset + (input.Position.Y - dragStartOpen.Y)
            )
        end
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingOpen = false
        if not hasMovedOpen then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- ============================================================
--  ЛЕВАЯ ПАНЕЛЬ (разделы Main / Esp)
-- ============================================================
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 80, 1, -35)
LeftPanel.Position = UDim2.new(0, 0, 0, 35)
LeftPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
LeftPanel.BackgroundTransparency = 0.3
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame

-- Правая панель для содержимого
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -90, 1, -45)
ContentPanel.Position = UDim2.new(0, 85, 0, 40)
ContentPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentPanel.BackgroundTransparency = 0.2
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = MainFrame

-- Хранилища вкладок
local tabButtons = {}
local tabFrames = {}

local function createTab(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.Parent = LeftPanel

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = ContentPanel

    tabButtons[name] = btn
    tabFrames[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            b.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
        frame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return btn, frame
end

local mainBtn, mainFrame = createTab("Main", 10)
local espBtn, espFrame = createTab("Esp", 50)
mainBtn.MouseButton1Click:Fire()  -- открываем Main по умолчанию

-- ============================================================
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ
-- ============================================================
local function makeToggle(parent, label, y, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 150, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(1, -70, 0, 2)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
    btn.Text = getter() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.BackgroundColor3 = new and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
        btn.Text = new and "ON" or "OFF"
    end)
    return frame
end

local function makeSlider(parent, label, y, min, max, default, setter, formatter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 150, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0, 50, 0, 20)
    val.Position = UDim2.new(1, -60, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.TextColor3 = Color3.fromRGB(255,200,100)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 14
    val.Parent = frame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0, 180, 0, 6)
    slider.Position = UDim2.new(0.5, -90, 0.5, 10)
    slider.BackgroundColor3 = Color3.fromRGB(60,60,70)
    slider.BorderSizePixel = 0
    slider.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0,150,255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local dragging = false
    local function updateSlider(input)
        local pos = input.Position.X - slider.AbsolutePosition.X
        local p = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
        local v = min + p*(max-min)
        v = math.round(v * 10) / 10
        setter(v)
        fill.Size = UDim2.new(p, 0, 1, 0)
        val.Text = formatter and formatter(v) or tostring(v)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateSlider(input)
        end
    end)
    return frame
end

-- ============================================================
--  ЗАПОЛНЯЕМ ВКЛАДКУ MAIN
-- ============================================================
local yMain = 5
makeToggle(mainFrame, "Noclip", yMain, function() return Settings.Noclip end, function(v) Settings.Noclip = v end)
yMain = yMain + 35
makeToggle(mainFrame, "Aimbot", yMain, function() return Settings.Aimbot end, function(v) Settings.Aimbot = v end)
yMain = yMain + 35
makeToggle(mainFrame, "Silent Aim", yMain, function() return Settings.SilentAim end, function(v) Settings.SilentAim = v end)
yMain = yMain + 35
makeToggle(mainFrame, "High Jump", yMain, function() return Settings.HighJump end, function(v) Settings.HighJump = v end)
yMain = yMain + 35
makeSlider(mainFrame, "Walk Speed", yMain, 0, 100, Settings.WalkSpeed, function(v) Settings.WalkSpeed = v end, function(v) return v.." spd" end)
yMain = yMain + 50
makeSlider(mainFrame, "Silent Aim Radius", yMain, 0, 180, Settings.SilentAimRadius, function(v) Settings.SilentAimRadius = v end, function(v) return v.."°" end)

-- ============================================================
--  ЗАПОЛНЯЕМ ВКЛАДКУ ESP
-- ============================================================
local yEsp = 5
makeToggle(espFrame, "ESP (Health + Name)", yEsp, function() return Settings.Esp end, function(v) Settings.Esp = v end)
yEsp = yEsp + 35
makeToggle(espFrame, "Lines to Players", yEsp, function() return Settings.Lines end, function(v) Settings.Lines = v end)

-- ============================================================
--  ЛОГИКА ESP (рисование на экране)
-- ============================================================
local espObjects = {}
local lineObjects = {}

local function clearESP()
    for _, v in pairs(espObjects) do
        if v and v.Remove then pcall(v.Remove, v) end
    end
    espObjects = {}
    for _, v in pairs(lineObjects) do
        if v and v.Remove then pcall(v.Remove, v) end
    end
    lineObjects = {}
end

local function updateESP()
    clearESP()
    if not Settings.Esp and not Settings.Lines then return end

    local players = game:GetService("Players"):GetPlayers()
    local myChar = Player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(players) do
        if p == Player then continue end
        local char = p.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not (hum and root and head) then continue end

        if Settings.Esp then
            local nameText = Drawing.new("Text")
            nameText.Text = p.Name
            nameText.Color = Color3.fromRGB(255,255,255)
            nameText.Size = 16
            nameText.Center = true
            nameText.Outline = true
            nameText.OutlineColor = Color3.fromRGB(0,0,0)
            table.insert(espObjects, nameText)

            local healthLine = Drawing.new("Line")
            healthLine.Thickness = 4
            table.insert(espObjects, healthLine)

            local conn = RunService.RenderStepped:Connect(function()
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen and Settings.Esp then
                    nameText.Visible = true
                    nameText.Position = Vector2.new(pos.X, pos.Y - 40)
                    local health = hum.Health / hum.MaxHealth
                    local barWidth = 60
                    local x1 = pos.X - barWidth/2
                    local x2 = pos.X + barWidth/2 * health
                    healthLine.Visible = true
                    healthLine.From = Vector2.new(x1, pos.Y - 20)
                    healthLine.To = Vector2.new(x2, pos.Y - 20)
                    healthLine.Color = Color3.fromRGB(255*(1-health), 255*health, 0)
                else
                    nameText.Visible = false
                    healthLine.Visible = false
                end
            end)
            table.insert(espObjects, conn)
        end

        if Settings.Lines and myRoot then
            local line = Drawing.new("Line")
            line.Color = Color3.fromRGB(100, 200, 255)
            line.Thickness = 2
            line.Transparency = 0.6
            table.insert(lineObjects, line)

            local conn = RunService.RenderStepped:Connect(function()
                if not Settings.Lines or not myRoot.Parent then
                    line.Visible = false
                    return
                end
                local a, onA = Camera:WorldToViewportPoint(myRoot.Position)
                local b, onB = Camera:WorldToViewportPoint(root.Position)
                if onA and onB then
                    line.Visible = true
                    line.From = Vector2.new(a.X, a.Y)
                    line.To = Vector2.new(b.X, b.Y)
                else
                    line.Visible = false
                end
            end)
            table.insert(lineObjects, conn)
        end
    end
end

local espUpdater = RunService.RenderStepped:Connect(function()
    if Settings.Esp or Settings.Lines then
        updateESP()
    else
        clearESP()
    end
end)

-- ============================================================
--  ЛОГИКА НА ПЕРСОНАЖЕ (Noclip, Speed, Jump, Aimbot)
-- ============================================================
local function applyCharacter(char)
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local noclipConn = RunService.Stepped:Connect(function()
        if Settings.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    local speedConn = RunService.Stepped:Connect(function()
        hum.WalkSpeed = Settings.WalkSpeed
    end)

    local jumpConn = RunService.Stepped:Connect(function()
        hum.JumpPower = Settings.HighJump and 80 or 50
    end)

    local aimbotConn
    if Settings.Aimbot or Settings.SilentAim then
        aimbotConn = RunService.RenderStepped:Connect(function()
            if not (Settings.Aimbot or Settings.SilentAim) then return end
            local target = nil
            local minDist = math.huge
            local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local radiusPx = Settings.SilentAimRadius * 3

            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local root2 = p.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(root2.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < radiusPx and dist < minDist then
                            minDist = dist
                            target = root2
                        end
                    end
                end
            end

            if target then
                local lookAt = CFrame.new(Camera.CFrame.Position, target.Position)
                if Settings.Aimbot then
                    Camera.CFrame = lookAt
                end
                if Settings.SilentAim then
                    local mouse = Player:GetMouse()
                    if mouse then
                        mouse.Hit = lookAt
                    end
                end
            end
        end)
    end

    char:SetAttribute("Cleanup", {noclipConn, speedConn, jumpConn, aimbotConn})
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

if Player.Character then
    onCharacterAdded(Player.Character)
end
Player.CharacterAdded:Connect(onCharacterAdded)

print("✅ BIBIZZZAN HUB v4.0 загружен! Нажмите кнопку для открытия.")
print("📌 Автор: bibizzzana")
