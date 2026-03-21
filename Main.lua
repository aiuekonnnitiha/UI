local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

if CoreGui:FindFirstChild("LoggerHub_Yellow") then CoreGui.LoggerHub_Yellow:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "LoggerHub_Yellow"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MinimizeBtn = Instance.new("ImageButton", ScreenGui)
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 45, 0, 45)
MinimizeBtn.Position = UDim2.new(0, 20, 0.5, -22)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MinimizeBtn.Image = "rbxassetid://17316645495"
MinimizeBtn.Visible = false
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)
local BtnStroke = Instance.new("UIStroke", MinimizeBtn)
BtnStroke.Thickness = 2
BtnStroke.Color = Color3.fromRGB(255, 230, 0)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MainStroke.Color = Color3.fromRGB(255, 230, 0)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(0, 110, 0, 45)
TitleLabel.Position = UDim2.new(0, 5, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ろがーはぶ"
TitleLabel.TextColor3 = Color3.fromRGB(255, 230, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18

local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Size = UDim2.new(0, 110, 1, -50)
SideBar.Position = UDim2.new(0, 5, 0, 45)
SideBar.BackgroundTransparency = 1
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 2
SideBar.ScrollBarImageColor3 = Color3.fromRGB(255, 230, 0)
SideBar.CanvasSize = UDim2.new(0, 0, 0, 0)
local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideBar.CanvasSize = UDim2.new(0, 0, 0, SideLayout.AbsoluteContentSize.Y + 10)
end)

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -125, 1, -55)
TabContainer.Position = UDim2.new(0, 120, 0, 50)
TabContainer.BackgroundTransparency = 1

local UI = { tabCount = 0, isMinimized = false, isClosing = false, mainTargetPos = MainFrame.Position }

function UI:CreateTab(name)
    self.tabCount = self.tabCount + 1
    local Page = Instance.new("ScrollingFrame", TabContainer)
    Page.Name = name.."Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.BorderSizePixel = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    local Btn = Instance.new("TextButton", SideBar)
    Btn.Size = UDim2.new(0, 100, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.LayoutOrder = self.tabCount
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(TabContainer:GetChildren()) do p.Visible = false end
        for _, b in pairs(SideBar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(200, 200, 200) end end
        Page.Visible = true
        Btn.TextColor3 = Color3.fromRGB(255, 230, 0)
    end)
    if #TabContainer:GetChildren() == 1 then Page.Visible = true Btn.TextColor3 = Color3.fromRGB(255, 230, 0) end
    return Page
end

function UI:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton", parent)
    Button.Size = UDim2.new(0.95, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    Button.MouseButton1Click:Connect(callback)
end

function UI:CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.95, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local TBtn = Instance.new("TextButton", Frame)
    TBtn.Size = UDim2.new(0, 45, 0, 22)
    TBtn.Position = UDim2.new(1, -50, 0.5, -11)
    TBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TBtn.Text = ""
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(1, 0)
    local Ind = Instance.new("Frame", TBtn)
    Ind.Size = UDim2.new(0, 16, 0, 16)
    Ind.Position = UDim2.new(0, 3, 0.5, -8)
    Ind.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)

    local on = false
    TBtn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(Ind, TweenInfo.new(0.3), {
            Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and Color3.fromRGB(255, 230, 0) or Color3.fromRGB(150, 150, 150)
        }):Play()
        callback(on)
    end)
end

local function GetMinBtnCenter() return MinimizeBtn.Position + UDim2.new(0, 22, 0, 22) end

local function Minimize()
    if UI.isMinimized or UI.isClosing then return end
    UI.isMinimized = true
    local t = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
    TweenService:Create(MainFrame, t, {Position = GetMinBtnCenter(), Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    TweenService:Create(MainStroke, t, {Transparency = 1}):Play()
    task.wait(0.5)
    if UI.isMinimized then MainFrame.Visible = false MinimizeBtn.Visible = true end
end

local function Restore()
    if not UI.isMinimized or UI.isClosing then return end
    UI.isMinimized = false
    MainFrame.Visible = true
    MinimizeBtn.Visible = false
    MainFrame.Position = GetMinBtnCenter()
    MainFrame.Size = UDim2.new(0,0,0,0)
    local t = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
    TweenService:Create(MainFrame, t, {Position = UI.mainTargetPos, Size = UDim2.new(0,450,0,320), BackgroundTransparency = 0}):Play()
    TweenService:Create(MainStroke, t, {Transparency = 0}):Play()
end

local function FadeDestroy()
    if UI.isClosing then return end
    UI.isClosing = true
    local t = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
    TweenService:Create(MainFrame, t, {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainStroke, t, {Transparency = 1}):Play()
    for _, v in pairs(MainFrame:GetDescendants()) do
        pcall(function()
            if v:IsA("TextLabel") or v:IsA("TextButton") then TweenService:Create(v, t, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            elseif v:IsA("ScrollingFrame") then TweenService:Create(v, t, {ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
            elseif v:IsA("ImageButton") then TweenService:Create(v, t, {ImageTransparency = 1, BackgroundTransparency = 1}):Play() end
        end)
    end
    task.wait(0.5)
    ScreenGui:Destroy()
end

local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.Text = "×"; Close.BackgroundTransparency = 1; Close.TextColor3 = Color3.fromRGB(255, 230, 0); Close.Font = Enum.Font.GothamBold; Close.TextSize = 30
Close.MouseButton1Click:Connect(FadeDestroy)

local MinF = Instance.new("TextButton", MainFrame)
MinF.Size = UDim2.new(0, 35, 0, 35)
MinF.Position = UDim2.new(1, -80, 0, 5)
MinF.Text = "−"; MinF.BackgroundTransparency = 1; MinF.TextColor3 = Color3.fromRGB(255, 230, 0); MinF.Font = Enum.Font.GothamBold; MinF.TextSize = 30
MinF.MouseButton1Click:Connect(Minimize)
MinimizeBtn.MouseButton1Click:Connect(Restore)

local function Drag(obj, target)
    local drag, start, pos
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true start = i.Position pos = target.Position end end)
    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - start
        target.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        if target == MainFrame then UI.mainTargetPos = target.Position end
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
end
Drag(MainFrame, MainFrame); Drag(MinimizeBtn, MinimizeBtn)

task.spawn(function()
    task.wait(3)
    StarterGui:SetCore("SendNotification", {
        Title = "住所ロガーです",
        Text = "お前の住所もーらい",
        Duration = 5
    })
end)

local SeaTab = UI:CreateTab("Sea Event")
local SelectedBoat = "Boat"
_G.AutoSail = false

local BoatDisplay = Instance.new("TextLabel")
BoatDisplay.Size = UDim2.new(0.95, 0, 0, 35)
BoatDisplay.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
BoatDisplay.Text = "選択中: " .. SelectedBoat
BoatDisplay.TextColor3 = Color3.fromRGB(255, 230, 0)
BoatDisplay.Font = Enum.Font.Gotham
BoatDisplay.Parent = TabContainer:FindFirstChild("Sea EventPage")
Instance.new("UICorner", BoatDisplay).CornerRadius = UDim.new(0, 6)

UI:CreateButton(SeaTab, "船を 'Boat' に設定", function()
    SelectedBoat = "Boat"
    BoatDisplay.Text = "選択中: " .. SelectedBoat
end)

UI:CreateButton(SeaTab, "船を 'Grand Enforcer' に設定", function()
    SelectedBoat = "Grand Enforcer"
    BoatDisplay.Text = "選択中: " .. SelectedBoat
end)

UI:CreateButton(SeaTab, "選択中の船を購入する", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", SelectedBoat)
end)

UI:CreateToggle(SeaTab, "ボート自動航行", function(state)
    _G.AutoSail = state
    if state then
        task.spawn(function()
            while _G.AutoSail do
                task.wait(0.5)
                local char = game.Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                
                local myBoat = nil
                for _, v in pairs(workspace.Boats:GetChildren()) do
                    if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer.Name then
                        myBoat = v
                        break
                    end
                end
                
                if not myBoat then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", SelectedBoat)
                    continue
                end
                
                local seat = myBoat:FindFirstChildOfClass("VehicleSeat")
                if seat then
                    if char.Humanoid.SeatPart ~= seat then
                        root.CFrame = seat.CFrame
                    else
                        seat.Throttle = 1
                    end
                end
            end
        end)
    else
        pcall(function()
            local seat = game.Players.LocalPlayer.Character.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then seat.Throttle = 0 end
        end)
    end
end)
