-- LocalScript inside StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Tab icons and info
local icons = {
    {id = "rbxassetid://82991797029616", text = "Commands", pos = UDim2.new(0.5, -150, 0, 10), size = UDim2.new(0, 300, 0, 90)},
    {id = "rbxassetid://110298444753000", text = "Moderation", pos = UDim2.new(0, 10, 0, 120)},
    {id = "rbxassetid://115818462755677", text = "Revenue", pos = UDim2.new(0, 170, 0, 120)},
    {id = "rbxassetid://90069281031535", text = "Settings", pos = UDim2.new(0, 10, 0, 220)},
    {id = "rbxassetid://101991570782806", text = "About", pos = UDim2.new(0, 170, 0, 220)},
}

-- === CREATE MAIN DASHBOARD GUI ===
local DashboardGui = Instance.new("ScreenGui")
DashboardGui.Name = "DashboardGui"
DashboardGui.ResetOnSpawn = false
DashboardGui.Parent = PlayerGui

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = DashboardGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(95, 75, 230)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -110, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ðŸ…½ Dashboard"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Title bar buttons
local function createTitleButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = btn
    btn.Parent = TitleBar
    return btn
end

local MinButton = createTitleButton("-", UDim2.new(1, -70, 0, 5))
local BackButton = createTitleButton("<", UDim2.new(1, -105, 0, 5))
BackButton.Visible = false
local CloseButton = createTitleButton("X", UDim2.new(1, -35, 0, 5))

-- Buttons container
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 1, -40)
ButtonContainer.Position = UDim2.new(0, 0, 0, 40)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- States
local minimized = false
local inTab = false
local currentTab = nil

-- === FUNCTION TO CREATE DASHBOARD BUTTONS ===
local function createDashboardButton(imageId, labelText, position, size)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0, 140, 0, 80)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = true
    btn.Parent = ButtonContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0.5, -20, 0, 5)
    icon.BackgroundTransparency = 1
    icon.Image = imageId
    icon.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, 50)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Parent = btn

    -- Button click to open tab
    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(ButtonContainer:GetChildren()) do
            child:Destroy()
        end
        inTab = true
        currentTab = labelText
        BackButton.Visible = true
        TitleText.Text = labelText

        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.Position = UDim2.new(0, 0, 0, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.Parent = ButtonContainer
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

        -- === TAB CONTENTS ===
        if labelText == "Commands" then
            local commands = {
                {name = ";blind/unblind", desc = "- blind target/all"},
                {name = ";freeze/unfreeze", desc = "- freeze target/all"},
                {name = ";kill", desc = "- kill target/all"},
                {name = ";kick", desc = "- kick target/all"},
                {name = ";ban", desc = "- ban target/all"},
                {name = ";bring", desc = "- bring target/all"},
            }

            local searchBox = Instance.new("TextBox")
            searchBox.Size = UDim2.new(1, -20, 0, 30)
            searchBox.Position = UDim2.new(0, 10, 0, 5)
            searchBox.PlaceholderText = "Search"
            searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            searchBox.Font = Enum.Font.Gotham
            searchBox.TextSize = 16
            searchBox.ClearTextOnFocus = false
            searchBox.Parent = scrollFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = searchBox

            local commandContainer = Instance.new("Frame")
            commandContainer.Size = UDim2.new(1, 0, 0, 0)
            commandContainer.BackgroundTransparency = 1
            commandContainer.Position = UDim2.new(0, 0, 0, 40)
            commandContainer.Parent = scrollFrame

            local uiLayout = Instance.new("UIListLayout")
            uiLayout.Padding = UDim.new(0, 5)
            uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiLayout.Parent = commandContainer

            -- Build commands dynamically
            local function buildCommandList(filter)
                for _, child in ipairs(commandContainer:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end

                for _, cmd in ipairs(commands) do
                    if not filter or cmd.name:lower():find(filter:lower()) then
                        local cmdLabel = Instance.new("TextLabel")
                        cmdLabel.Size = UDim2.new(1, -20, 0, 25)
                        cmdLabel.BackgroundTransparency = 1
                        cmdLabel.Text = cmd.name .. " - " .. cmd.desc
                        cmdLabel.Font = Enum.Font.Gotham
                        cmdLabel.TextSize = 16
                        cmdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        cmdLabel.TextXAlignment = Enum.TextXAlignment.Left
                        cmdLabel.Parent = commandContainer
                    end
                end

                -- Atualiza tamanho do container e Canvas
                commandContainer.Size = UDim2.new(1, 0, 0, uiLayout.AbsoluteContentSize.Y)
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y + 45)
            end

            buildCommandList()
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                buildCommandList(searchBox.Text)
            end)

        elseif labelText == "Settings" then
            local colors = {
                Color3.fromRGB(95, 75, 230),
                Color3.fromRGB(230, 75, 75),
                Color3.fromRGB(75, 230, 120),
                Color3.fromRGB(230, 230, 75),
                Color3.fromRGB(230, 75, 230),
                Color3.fromRGB(75, 200, 230),
            }

            local colorContainer = Instance.new("Frame")
            colorContainer.Size = UDim2.new(1, 0, 0, 80)
            colorContainer.BackgroundTransparency = 1
            colorContainer.Parent = scrollFrame

            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.Padding = UDim.new(0, 10)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = colorContainer

            for _, color in ipairs(colors) do
                local colorBox = Instance.new("TextButton")
                colorBox.Size = UDim2.new(0, 40, 0, 40)
                colorBox.BackgroundColor3 = color
                colorBox.BorderSizePixel = 0
                colorBox.Text = ""
                colorBox.AutoButtonColor = true
                colorBox.Parent = colorContainer

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = colorBox

                colorBox.MouseButton1Click:Connect(function()
                    TitleBar.BackgroundColor3 = color
                end)
            end

        elseif labelText == "Revenue" then
            local revenueLabel = Instance.new("TextLabel")
            revenueLabel.Size = UDim2.new(1, 0, 1, 0)
            revenueLabel.BackgroundTransparency = 1
            revenueLabel.Text = "Sales & Earnings data coming 2025"
            revenueLabel.Font = Enum.Font.GothamBold
            revenueLabel.TextSize = 18
            revenueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            revenueLabel.TextWrapped = true
            revenueLabel.TextXAlignment = Enum.TextXAlignment.Center
            revenueLabel.TextYAlignment = Enum.TextYAlignment.Center
            revenueLabel.Parent = scrollFrame

        elseif labelText == "About" then
            local aboutLabel = Instance.new("TextLabel")
            aboutLabel.Size = UDim2.new(1, 0, 1, 0)
            aboutLabel.BackgroundTransparency = 1
            aboutLabel.Text = "script made by PHG\nYT: @PHGS_apenas\n I'm a Brazilian programmer!"
            aboutLabel.Font = Enum.Font.GothamBold
            aboutLabel.TextSize = 16
            aboutLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            aboutLabel.TextWrapped = true
            aboutLabel.TextXAlignment = Enum.TextXAlignment.Center
            aboutLabel.TextYAlignment = Enum.TextYAlignment.Center
            aboutLabel.Parent = scrollFrame

        else
            local placeholder = Instance.new("TextLabel")
            placeholder.Size = UDim2.new(1, 0, 1, 0)
            placeholder.BackgroundTransparency = 1
            placeholder.Text = "Tab Content: " .. labelText
            placeholder.Font = Enum.Font.GothamBold
            placeholder.TextSize = 20
            placeholder.TextColor3 = Color3.fromRGB(255, 255, 255)
            placeholder.Parent = scrollFrame
        end
    end)
end

-- Rebuild dashboard buttons
local function rebuildButtons()
    for _, data in ipairs(icons) do
        createDashboardButton(data.id, data.text, data.pos, data.size)
    end
end

rebuildButtons()

-- === NAVIGATION BUTTONS ===
BackButton.MouseButton1Click:Connect(function()
    for _, child in ipairs(ButtonContainer:GetChildren()) do
        child:Destroy()
    end
    inTab = false
    currentTab = nil
    rebuildButtons()
    BackButton.Visible = false
    TitleText.Text = "Dashboard"
end)

CloseButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        DashboardGui.Enabled = false
        MainFrame.Size = UDim2.new(0,320,0,400)
        MainFrame.Position = UDim2.new(0.5,-160,0.5,-200)
        ButtonContainer:ClearAllChildren()
        rebuildButtons()
        BackButton.Visible = false
        TitleText.Text = "Dashboard"
        inTab = false
        currentTab = nil
    end)
end)

MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ButtonContainer.Visible = false
        BackButton.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,320,0,40)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,320,0,400)}):Play()
        ButtonContainer.Visible = true
        if inTab then
            BackButton.Visible = true
            TitleText.Text = currentTab or "Dashboard"
        else
            BackButton.Visible = false
            TitleText.Text = "Dashboard"
        end
    end
end)

-- === FLOATING TOGGLE BUTTON ===
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "ToggleGui"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = PlayerGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.165, 0, 0, -45)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = ""
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = ToggleGui
ToggleButton.ClipsDescendants = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = ToggleButton

local ToggleImage = Instance.new("ImageLabel")
ToggleImage.Size = UDim2.new(1, 0, 1, 0)
ToggleImage.BackgroundTransparency = 1
ToggleImage.Image = "rbxassetid://125991366522470"
ToggleImage.Parent = ToggleButton

local imageCorner = Instance.new("UICorner")
imageCorner.CornerRadius = UDim.new(0.5, 0)
imageCorner.Parent = ToggleImage

local dashboardVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    dashboardVisible = not dashboardVisible
    if dashboardVisible then
        DashboardGui.Enabled = true
        MainFrame.Position = UDim2.new(0.5, -160, 0.5, -600)
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -160, 0.5, -200)
        }):Play()
    else
        local tweenOut = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -160, 0.5, -600)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            DashboardGui.Enabled = false
        end)
    end
end)
-- =============================================
-- CARREGAR SCRIPT EXTERNO AUTOMATICAMENTE
-- =============================================

-- Função para carregar o script externo
local function carregarScriptExterno()
    -- Usar pcall para tratamento de erros (evita que o script principal quebre)
    local sucesso, erro = pcall(function()
        -- URL do script externo (substitua pelo seu link real)
        local url = "https://raw.githubusercontent.com/PHGS971/HDadmin/refs/heads/main/source%20(2).txt"
        
        -- Baixar e executar o script
        local scriptExterno = game:HttpGet(url)
        loadstring(scriptExterno)()
        
        print("Script externo carregado com sucesso!")
    end)
    
    -- Verificar se houve erro no carregamento
    if not sucesso then
        warn("Erro ao carregar script externo: " .. tostring(erro))
    end
end

-- Esperar um pouco e carregar automaticamente
task.delay(2, function()
    carregarScriptExterno()
end)

-- Mensagem de confirmação
print("Seu dashboard foi carregado! Script externo será carregado em 2 segundos...")
