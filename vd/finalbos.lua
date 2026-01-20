local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NVB Hub | VIP v23.0 ULTIMATE",
   LoadingTitle = "COMPLETE EDITION - ALL FEATURES",
   LoadingSubtitle = "by neveryourbae - Mobile",
   ConfigurationSaving = { Enabled = true, FolderName = "NVB_Configs" }
})

-- [[ GLOBAL VARIABLES ]]
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
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
_G.FlyEnabled = false
_G.FlySpeed = 50

-- [[ 1. CROSSHAIR ENGINE ]]
local CrosshairGUI = Instance.new("ScreenGui", game.CoreGui)
local CH_Container = Instance.new("Frame", CrosshairGUI)
CH_Container.BackgroundTransparency = 1; CH_Container.Size = UDim2.new(0, 50, 0, 50); CH_Container.AnchorPoint = Vector2.new(0.5, 0.5); CH_Container.Position = UDim2.new(0.5, 0, 0.5, 0)

local function UpdateCH()
    CH_Container:ClearAllChildren()
    CH_Container.Visible = _G.CH_Enabled
    local d = Instance.new("Frame", CH_Container); d.Size = UDim2.new(0, 4, 0, 4); d.Position = UDim2.new(0.5, -2, 0.5, -2); d.BackgroundColor3 = Color3.fromRGB(255,0,0); d.BorderSizePixel = 0
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
end

-- [[ 2. STATIC AIM BUTTON (POJOK KANAN ATAS) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local AimBtn = Instance.new("TextButton", ScreenGui)
AimBtn.Name = "AimButtonTopRight"; AimBtn.Size = UDim2.new(0, 60, 0, 60)
AimBtn.Position = UDim2.new(1, -70, 0, 20) -- Pojok Kanan Atas
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); AimBtn.Text = "AIM\nOFF"; AimBtn.TextColor3 = Color3.new(1,1,1)
AimBtn.Font = Enum.Font.SourceSansBold; AimBtn.TextSize = 14; Instance.new("UICorner", AimBtn).CornerRadius = UDim.new(1, 0)
local UIStroke = Instance.new("UIStroke", AimBtn); UIStroke.Thickness = 3; UIStroke.Color = Color3.new(0,0,0)

AimBtn.MouseButton1Click:Connect(function() 
    _G.AutoAim = not _G.AutoAim
    AimBtn.BackgroundColor3 = _G.AutoAim and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    AimBtn.Text = _G.AutoAim and "AIM\nON" or "AIM\nOFF"
end)

-- [[ 3. FLY ENGINE ]]
local bodyVel, bodyGyro
local function ToggleFly()
    if _G.FlyEnabled then
        bodyVel = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bodyVel.Velocity = Vector3.new(0, 0.1, 0)
        bodyGyro = Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bodyGyro.CFrame = lp.Character.HumanoidRootPart.CFrame
        task.spawn(function()
            while _G.FlyEnabled and lp.Character do
                bodyVel.Velocity = cam.CFrame.LookVector * _G.FlySpeed
                bodyGyro.CFrame = cam.CFrame
                task.wait()
            end
            if bodyVel then bodyVel:Destroy() end; if bodyGyro then bodyGyro:Destroy() end
        end)
    end
end

-- [[ 4. FUNGSI TAG ESP REALTIME (NAMA, HP, JARAK) ]]
local function createTag(char, color, name)
    local head = char:WaitForChild("Head", 5)
    if head then
        local tag = head:FindFirstChild("NVBTag") or Instance.new("BillboardGui", head)
        tag.Name = "NVBTag"; tag.Size = UDim2.new(0, 150, 0, 70); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0, 3, 0)
        local tl = tag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tag)
        tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.TextColor3 = color; tl.TextStrokeTransparency = 0; tl.TextSize = 13; tl.Font = Enum.Font.SourceSansBold
        local hum = char:FindFirstChild("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart"); local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local dist = (myRoot and root) and math.floor((myRoot.Position - root.Position).Magnitude) or 0
        tl.Text = name .. "\nHP: " .. (hum and math.floor(hum.Health) or 0) .. "\n[" .. dist .. " Studs]"
    end
end

-- [[ TABS & FEATURES ]]
local TabComb = Window:CreateTab("Combat", 4483362458)
TabComb:CreateToggle({Name = "Enable Crosshair", CurrentValue = false, Callback = function(V) _G.CH_Enabled = V; UpdateCH() end})
TabComb:CreateDropdown({Name = "Auto Aim Target", Options = {"Killer", "Survivors", "All Players"}, CurrentOption = {"Killer"}, Callback = function(Option) _G.AimTargetMode = Option[1] end})
TabComb:CreateToggle({Name = "Hitbox Expander", CurrentValue = false, Callback = function(V) _G.HitboxEnabled = V end})
TabComb:CreateSlider({Name = "Hitbox Size", Range = {2, 50}, Increment = 1, CurrentValue = 2, Callback = function(V) _G.HitboxSize = V end})

local TabTele = Window:CreateTab("Teleport", 4483362458)
local PlayerDropdown = TabTele:CreateDropdown({Name = "Select Player", Options = {}, Callback = function(Option) SelectedPlayer = Option[1] end})
TabTele:CreateButton({Name = "1. Refresh Player List", Callback = function()
    local pList = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(pList, v.Name) end end
    PlayerDropdown:Refresh(pList, true)
end})
TabTele:CreateButton({Name = "2. Teleport Now", Callback = function()
    if SelectedPlayer and game.Players:FindFirstChild(SelectedPlayer) then
        lp.Character.HumanoidRootPart.CFrame = game.Players[SelectedPlayer].Character.HumanoidRootPart.CFrame
    end
end})

local TabVis = Window:CreateTab("Visuals", 4483362458)
TabVis:CreateToggle({Name = "ESP Killer", CurrentValue = false, Callback = function(V) _G.EspKiller = V end})
TabVis:CreateToggle({Name = "ESP Player", CurrentValue = false, Callback = function(V) _G.EspPlayer = V end})

local TabExp = Window:CreateTab("Exploits", 4483362458)
TabExp:CreateToggle({Name = "Fly Mode", CurrentValue = false, Callback = function(V) _G.FlyEnabled = V; ToggleFly() end})
TabExp:CreateSlider({Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(V) _G.FlySpeed = V end})
TabExp:CreateToggle({Name = "God Mode", CurrentValue = false, Callback = function(V) _G.GodMode = V end})
TabExp:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) _G.Noclip = V end})
TabExp:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(V) _G.FullBright = V end})

local TabAtm = Window:CreateTab("Camera", 4483362458)
TabAtm:CreateSlider({Name = "Field of View (FOV)", Range = {30, 120}, Increment = 1, CurrentValue = 70, Callback = function(V) cam.FieldOfView = V end})

local TabMisc = Window:CreateTab("Misc", 4483362458)
TabMisc:CreateButton({Name = "REJOIN SERVER", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
end})
TabMisc:CreateButton({Name = "FPS BOOST (ANTI-LAG)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end
    Lighting.GlobalShadows = false
end})
TabMisc:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) if lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = V end end})

-- [[ CORE LOGIC LOOP ]]
RunService.Stepped:Connect(function()
    if _G.Noclip and lp.Character then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if _G.GodMode and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.Health = 100 end
    if _G.AutoAim then
        local target = nil; local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local isK = p.Character:FindFirstChild("Weapon") or p.Character:FindFirstChild("Knife") or p:FindFirstChild("IsKiller")
                if (_G.AimTargetMode == "Killer" and isK) or (_G.AimTargetMode == "Survivors" and not isK) or (_G.AimTargetMode == "All Players") then
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
        task.wait(0.4)
    end
end)

RunService.RenderStepped:Connect(function() if _G.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false end end)
