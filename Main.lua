local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("LoggerHub_Yellow") then
    CoreGui.LoggerHub_Yellow:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoggerHub_Yellow"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 45, 0, 45)
MinimizeBtn.Position = UDim2.new(0, 20, 0.5, -22) -- Default Position
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MinimizeBtn.Image = "rbxassetid://17316645495"
MinimizeBtn.Visible = false
MinimizeBtn.Active = true
MinimizeBtn.Parent = ScreenGui
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)
local BtnStroke = Instance.new("UIStroke", MinimizeBtn)
BtnStroke.Thickness = 2
BtnStroke.Color = Color3.fromRGB(255, 230, 0)

local draggingBtn = false
local dragStartBtn, startPosBtn

MinimizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = false -- Reset drag flag on touch start
        dragStartBtn = input.Position
        startPosBtn = MinimizeBtn.Position
    end
end)

MinimizeBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragStartBtn then
            local delta = (input.Position - dragStartBtn).Magnitude
            if delta > 5 then -- Threshold to identify dragging
                draggingBtn = true
            end
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartBtn
        MinimizeBtn.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStartBtn = nil
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160) -- Target Position
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MainStroke.Color = Color3.fromRGB(255, 230, 0)

-- [Tab System Logic (Required for UI:CreateTab)]
local SideBar = Instance.new("ScrollingFrame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 110, 1, -50)
SideBar.Position = UDim2.new(0, 5, 0, 45)
SideBar.BackgroundTransparency = 1
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 2
SideBar.ScrollBarImageColor3 = Color3.fromRGB(255, 230, 0)
SideBar.CanvasSize = UDim2.new(0, 0, 0, 0)
SideBar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideBar.CanvasSize = UDim2.new(0, 0, 0, SideLayout.AbsoluteContentSize.Y + 10)
end)

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -125, 1, -55)
TabContainer.Position = UDim2.new(0, 120, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local UI = {}
local tabCount = 0

function UI:CreateTab(name)
    tabCount = tabCount + 1
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.BorderSizePixel = 0
    TabPage.Parent = TabContainer
    Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 5)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Btn"
    TabBtn.Size = UDim2.new(0, 100, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.LayoutOrder = tabCount
    TabBtn.Parent = SideBar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(TabContainer:GetChildren()) do page.Visible = false end
        for _, btn in pairs(SideBar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(200, 200, 200) end end
        TabPage.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 230, 0)
    end)
    if #TabContainer:GetChildren() == 1 then TabPage.Visible = true TabBtn.TextColor3 = Color3.fromRGB(255, 230, 0) end
    return TabPage
end

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 230, 0)
CloseBtn.TextSize = 30
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local MinimizeFrameBtn = Instance.new("TextButton")
MinimizeFrameBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeFrameBtn.Position = UDim2.new(1, -80, 0, 5)
MinimizeFrameBtn.BackgroundTransparency = 1
MinimizeFrameBtn.Text = "−"
MinimizeFrameBtn.TextColor3 = Color3.fromRGB(255, 230, 0)
MinimizeFrameBtn.TextSize = 30
MinimizeFrameBtn.Font = Enum.Font.GothamBold
MinimizeFrameBtn.Parent = MainFrame

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
local mainTargetPos = UDim2.new(0.5, -225, 0.5, -160)
local mainTargetSize = UDim2.new(0, 450, 0, 320)
local isMinimized = false
local isClosing = false

local function GetMinBtnCenter()
    return MinimizeBtn.Position + UDim2.new(0, MinimizeBtn.Size.X.Offset / 2, 0, MinimizeBtn.Size.Y.Offset / 2)
end

local function MinimizeUI()
    if isMinimized or isClosing then return end
    isMinimized = true
    
    local minCenter = GetMinBtnCenter()
    
    local goal = {
        Position = minCenter,
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1 -- 透明にする
    }
    
    local t1 = TweenService:Create(MainFrame, tweenInfo, goal)
    local t2 = TweenService:Create(MainStroke, tweenInfo, {Transparency = 1})
    
    t1:Play()
    t2:Play()
    
    t1.Completed:Connect(function()
        if isMinimized then
            MainFrame.Visible = false
            MinimizeBtn.Visible = true
        end
    end)
end

local function RestoreUI()
    if not isMinimized or draggingBtn or isClosing then return end 
    isMinimized = false
    
    local minCenter = GetMinBtnCenter()
    
    MainFrame.Visible = true
    MinimizeBtn.Visible = false
    
    MainFrame.Position = minCenter
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    MainStroke.Transparency = 1
    
    local goal = {
        Position = mainTargetPos,
        Size = mainTargetSize,
        BackgroundTransparency = 0
    }
    
    local t1 = TweenService:Create(MainFrame, tweenInfo, goal)
    local t2 = TweenService:Create(MainStroke, tweenInfo, {Transparency = 0})
    
    t1:Play()
    t2:Play()
end

local function FadeOutAndDestroy()
    if isClosing then return end
    isClosing = true
    isMinimized = false
    MinimizeBtn.Visible = false
    MainFrame.Visible = true
    
    if MainFrame.Size.X.Offset < 10 then
        MainFrame.Position = mainTargetPos
        MainFrame.Size = mainTargetSize
        MainFrame.BackgroundTransparency = 0
        MainStroke.Transparency = 0
    end

    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
    TweenService:Create(MainFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainStroke, fadeInfo, {Transparency = 1}):Play()
    
    for _, v in pairs(MainFrame:GetDescendants()) do
        pcall(function()
            if v:IsA("TextButton") or v:IsA("TextLabel") then
                TweenService:Create(v, fadeInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            elseif v:IsA("ImageButton") or v:IsA("ImageLabel") then
                TweenService:Create(v, fadeInfo, {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
            elseif v:IsA("ScrollingFrame") then
                TweenService:Create(v, fadeInfo, {ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
            end
        end)
    end
    task.wait(0.5)
    ScreenGui:Destroy()
end

MinimizeFrameBtn.MouseButton1Click:Connect(MinimizeUI)
MinimizeBtn.MouseButton1Click:Connect(RestoreUI)
CloseBtn.MouseButton1Click:Connect(FadeOutAndDestroy)

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        mainTargetPos = MainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
