local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NVB Hub | VIP v13.0 FINAL",
   LoadingTitle = "ALL FEATURES RESTORED",
   LoadingSubtitle = "by neveryourbae - Mobile",
   ConfigurationSaving = { Enabled = true, FolderName = "NVB_Configs" }
})

-- [[ GLOBAL VARIABLES ]]
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local SelectedPlayer = nil

_G.AutoAim = false
_G.AimTargetMode = "Killer"
_G.HitboxEnabled = false
_G.HitboxSize = 2
_G.GodMode = false
_G.Noclip = false
_G.EspPlayer = false
_G.EspKiller = false
_G.FullBright = false
_G.CH_Enabled = false
_G.CH_Color = Color3.fromRGB(255, 0, 0)

-- [[ CROSSHAIR ENGINE ]]
local CrosshairGUI = Instance.new("ScreenGui", game.CoreGui)
local CH_Container = Instance.new("Frame", CrosshairGUI)
CH_Container.BackgroundTransparency = 1; CH_Container.Size = UDim2.new(0, 50, 0, 50); CH_Container.AnchorPoint = Vector2.new(0.5, 0.5); CH_Container.Position = UDim2.new(0.5, 0, 0.5, 0)

local function UpdateCH()
    CH_Container:ClearAllChildren()
    CH_Container.Visible = _G.CH_Enabled
    local d = Instance.new("Frame", CH_Container); d.Size = UDim2.new(0, 4, 0, 4); d.Position = UDim2.new(0.5, -2, 0.5, -2); d.BackgroundColor3 = _G.CH_Color; d.BorderSizePixel = 0
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
end

-- [[ FUNGSI TAG REALTIME ESP ]]
local function createTag(char, color, name)
    local head = char:WaitForChild("Head", 5)
    if head then
        local tag = head:FindFirstChild("NVBTag") or Instance.new("BillboardGui", head)
        tag.Name = "NVBTag"; tag.Size = UDim2.new(0, 150, 0, 70); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0, 3, 0)
        local tl = tag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tag)
        tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.TextColor3 = color; tl.TextStrokeTransparency = 0; tl.TextSize = 13; tl.Font = Enum.Font.SourceSansBold
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local dist = (myRoot and root) and math.floor((myRoot.Position - root.Position).Magnitude) or 0
        tl.Text = name .. "\nHP: " .. (hum and math.floor(hum.Health) or 0) .. "\n[" .. dist .. " Studs]"
    end
end

-- [[ TOMBOL BULAT FLOATING (AUTO AIM) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local AimBtn = Instance.new("TextButton", ScreenGui)
AimBtn.Name = "AimButton"; AimBtn.Size = UDim2.new(0, 60, 0, 60); AimBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); AimBtn.Text = "AIM: OFF"; AimBtn.TextColor3 = Color3.new(1,1,1)
AimBtn.Font = Enum.Font.SourceSansBold; AimBtn.TextSize = 14; Instance.new("UICorner", AimBtn).CornerRadius = UDim.new(1, 0)

local dragging, dragStart, startPos
AimBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = AimBtn.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; AimBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function() dragging = false end)
AimBtn.MouseButton1Click:Connect(function() _G.AutoAim = not _G.AutoAim; AimBtn.BackgroundColor3 = _G.AutoAim and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AimBtn.Text = _G.AutoAim and "AIM: ON" or "AIM: OFF" end)

-- [[ TABS ]]
local TabComb = Window:CreateTab("Combat", 4483362458)
TabComb:CreateToggle({Name = "Enable Crosshair", CurrentValue = false, Callback = function(V) _G.CH_Enabled = V; UpdateCH() end})
TabComb:CreateDropdown({Name = "Auto Aim Target", Options = {"Killer", "Survivors", "All Players"}, CurrentOption = {"Killer"}, Callback = function(Option) _G.AimTargetMode = Option[1] end})
TabComb:CreateToggle({Name = "Hitbox Expander", CurrentValue = false, Callback = function(V) _G.HitboxEnabled = V end})
TabComb:CreateSlider({Name = "Hitbox Size", Range = {2, 50}, Increment = 1, CurrentValue = 2, Callback = function(V) _G.HitboxSize = V end})

local TabTele = Window:CreateTab("Teleport", 4483362458)
local Dropdown = TabTele:CreateDropdown({Name = "Pilih Pemain", Options = {}, Callback = function(Option) SelectedPlayer = Option[1] end})
TabTele:CreateButton({Name = "Refresh & Teleport", Callback = function()
    local pList = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(pList, v.Name) end end
    Dropdown:Refresh(pList, true)
    if SelectedPlayer and game.Players:FindFirstChild(SelectedPlayer) then lp.Character.HumanoidRootPart.CFrame = game.Players[SelectedPlayer].Character.HumanoidRootPart.CFrame end
end})

local TabVis = Window:CreateTab("Visuals", 4483362458)
TabVis:CreateToggle({Name = "ESP Killer", CurrentValue = false, Callback = function(V) _G.EspKiller = V end})
TabVis:CreateToggle({Name = "ESP Player", CurrentValue = false, Callback = function(V) _G.EspPlayer = V end})

local TabAtm = Window:CreateTab("Camera", 4483362458)
TabAtm:CreateSlider({Name = "Field of View (FOV)", Range = {30, 120}, Increment = 1, CurrentValue = 70, Callback = function(V) cam.FieldOfView = V end})

local TabExp = Window:CreateTab("Exploits", 4483362458)
TabExp:CreateToggle({Name = "God Mode", CurrentValue = false, Callback = function(V) _G.GodMode = V end})
TabExp:CreateToggle({Name = "Ghost Mode", CurrentValue = false, Callback = function(V) 
    local rj = lp.Character.HumanoidRootPart:FindFirstChild("RootJoint") or lp.Character.LowerTorso:FindFirstChild("RootJoint")
    if rj then rj.C0 = V and rj.C0 * CFrame.new(0, -100, 0) or rj.C0 * CFrame.new(0, 100, 0) end
end})
TabExp:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) _G.Noclip = V end})
TabExp:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(V) _G.FullBright = V end})

-- [[ CORE LOGIC ]]
RunService.Stepped:Connect(function()
    if _G.Noclip and lp.Character then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if _G.GodMode and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.Health = 100 end
    if _G.AutoAim then
        local target = nil; local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local isK = p.Character:FindFirstChild("Weapon") or p.Character:FindFirstChild("Knife") or p:FindFirstChild("IsKiller")
                local canT = (_G.AimTargetMode == "Killer" and isK) or (_G.AimTargetMode == "Survivors" and not isK) or (_G.AimTargetMode == "All Players")
                if canT then
                    local d = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; target = p.Character.HumanoidRootPart end
                end
            end
        end
        if target then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
    end
end)

task.spawn(function()
    while true do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if _G.HitboxEnabled then p.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize); p.Character.HumanoidRootPart.Transparency = 0.7 end
                local isK = p.Character:FindFirstChild("Weapon") or p.Character:FindFirstChild("Knife") or p:FindFirstChild("IsKiller")
                if (_G.EspKiller and isK) or (_G.EspPlayer and not isK) then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    h.FillColor = isK and Color3.new(1,0,0) or Color3.new(1,1,1); h.Enabled = true
                    createTag(p.Character, isK and Color3.new(1,0,0) or Color3.new(1,1,1), isK and "KILLER: "..p.Name or p.Name)
                else
                    if p.Character:FindFirstChild("Highlight") then p.Character.Highlight.Enabled = false end
                    if p.Character.Head:FindFirstChild("NVBTag") then p.Character.Head.NVBTag:Destroy() end
                end
            end
        end
        task.wait(0.2)
    end
end)

RunService.RenderStepped:Connect(function() if _G.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false end end)
