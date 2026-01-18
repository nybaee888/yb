local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NVB Hub | VIP v9.5 ULTIMATE",
   LoadingTitle = "FULL FEATURES - NO REMOVAL",
   LoadingSubtitle = "by neveryourbae - Mobile Edition",
   ConfigurationSaving = { Enabled = true, FolderName = "NVB_Configs" }
})

-- [[ GLOBAL VARIABLES ]]
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local SelectedPlayer = nil

_G.CH_Enabled = false; _G.CH_Shape = "Dot"; _G.CH_X = 0; _G.CH_Y = 0; _G.CH_Color = Color3.fromRGB(255, 0, 0)
_G.Noclip = false; _G.DesyncEnabled = false; _G.GhostMode = false; _G.AutoAim = false
_G.HitboxEnabled = false; _G.HitboxSize = 2; _G.FullBright = false; _G.GodMode = false
_G.EspPlayer = false; _G.EspKiller = false

-- [[ FUNGSI TAG REALTIME (NAMA, HP, STUDS) ]]
local function createTag(char, color, name)
    local head = char:WaitForChild("Head", 5)
    if head then
        local tag = head:FindFirstChild("NVBTag") or Instance.new("BillboardGui", head)
        tag.Name = "NVBTag"; tag.Size = UDim2.new(0, 150, 0, 70); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0, 3, 0)
        local tl = tag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tag)
        tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.TextColor3 = color; tl.TextStrokeTransparency = 0
        tl.TextSize = 13; tl.Font = Enum.Font.SourceSansBold
        
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        
        local dist = (myRoot and root) and math.floor((myRoot.Position - root.Position).Magnitude) or 0
        tl.Text = name .. "\nHP: " .. (hum and math.floor(hum.Health) or 0) .. "\n[" .. dist .. " Studs]"
    end
end

-- [[ UI CROSSHAIR ENGINE ]]
local CrosshairGUI = Instance.new("ScreenGui", game.CoreGui)
local CH_Container = Instance.new("Frame", CrosshairGUI)
CH_Container.BackgroundTransparency = 1; CH_Container.Size = UDim2.new(0, 50, 0, 50); CH_Container.AnchorPoint = Vector2.new(0.5, 0.5)

local function UpdateCH()
    CH_Container:ClearAllChildren()
    CH_Container.Position = UDim2.new(0.5, _G.CH_X, 0.5, _G.CH_Y)
    CH_Container.Visible = _G.CH_Enabled
    if _G.CH_Shape == "Dot" then
        local d = Instance.new("Frame", CH_Container); d.Size = UDim2.new(0, 6, 0, 6); d.Position = UDim2.new(0.5, -3, 0.5, -3); d.BackgroundColor3 = _G.CH_Color; d.BorderSizePixel = 0
    elseif _G.CH_Shape == "Cross" then
        local v = Instance.new("Frame", CH_Container); v.Size = UDim2.new(0, 2, 0, 20); v.Position = UDim2.new(0.5, -1, 0.5, -10); v.BackgroundColor3 = _G.CH_Color; v.BorderSizePixel = 0
        local h = Instance.new("Frame", CH_Container); h.Size = UDim2.new(0, 20, 0, 2); h.Position = UDim2.new(0.5, -10, 0.5, -1); h.BackgroundColor3 = _G.CH_Color; h.BorderSizePixel = 0
    end
end

-- [[ TAB 1: MAIN & CROSSHAIR ]]
local TabMain = Window:CreateTab("Main", 4483362458)
TabMain:CreateToggle({Name = "Enable Crosshair", CurrentValue = false, Callback = function(V) _G.CH_Enabled = V; UpdateCH() end})
TabMain:CreateDropdown({Name = "Shape", Options = {"Dot", "Cross"}, CurrentOption = {"Dot"}, Callback = function(Option) _G.CH_Shape = Option[1]; UpdateCH() end})
TabMain:CreateColorPicker({Name = "Color", Color = Color3.fromRGB(255,0,0), Callback = function(V) _G.CH_Color = V; UpdateCH() end})

-- [[ TAB 2: EXPLOITS ]]
local TabExp = Window:CreateTab("Exploits", 4483362458)
TabExp:CreateToggle({Name = "Ghost Mode (Invisible)", CurrentValue = false, Callback = function(V) 
    _G.GhostMode = V
    local char = lp.Character
    local rj = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("RootJoint") or char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint")
    if rj then rj.C0 = _G.GhostMode and rj.C0 * CFrame.new(0, -100, 0) or rj.C0 * CFrame.new(0, 100, 0) end
end})
TabExp:CreateToggle({Name = "Desync (Fake Lag)", CurrentValue = false, Callback = function(V) 
    _G.DesyncEnabled = V 
    task.spawn(function() while _G.DesyncEnabled do if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lp.Character.HumanoidRootPart.Anchored = true; task.wait(0.1); lp.Character.HumanoidRootPart.Anchored = false end; task.wait(0.05) end end)
end})
TabExp:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) _G.Noclip = V end})
TabExp:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(V) _G.FullBright = V end})

-- [[ TAB 3: COMBAT & TELEPORT ]]
local TabComb = Window:CreateTab("Combat", 4483362458)
TabComb:CreateToggle({Name = "God Mode (Anti Mati)", CurrentValue = false, Callback = function(V) _G.GodMode = V end})
TabComb:CreateToggle({Name = "Auto Aim (Lock Killer)", CurrentValue = false, Callback = function(V) _G.AutoAim = V end})
TabComb:CreateToggle({Name = "Hitbox Expander", CurrentValue = false, Callback = function(V) _G.HitboxEnabled = V end})
TabComb:CreateSlider({Name = "Hitbox Size", Range = {2, 50}, Increment = 1, CurrentValue = 2, Callback = function(V) _G.HitboxSize = V end})

TabComb:CreateSection("Teleport Player")
local Dropdown = TabComb:CreateDropdown({Name = "Pilih Pemain", Options = {}, Callback = function(Option) SelectedPlayer = Option[1] end})
TabComb:CreateButton({Name = "Refresh & Teleport", Callback = function()
    local pList = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(pList, v.Name) end end
    Dropdown:Refresh(pList, true)
    if SelectedPlayer and game.Players:FindFirstChild(SelectedPlayer) then 
        lp.Character.HumanoidRootPart.CFrame = game.Players[SelectedPlayer].Character.HumanoidRootPart.CFrame 
    end
end})

-- [[ TAB 4: VISUALS (ESP REALTIME) ]]
local TabVis = Window:CreateTab("Visuals", 4483362458)
TabVis:CreateToggle({Name = "ESP Killer (Name/HP/Studs)", CurrentValue = false, Callback = function(V) _G.EspKiller = V end})
TabVis:CreateToggle({Name = "ESP Player (Name/HP/Studs)", CurrentValue = false, Callback = function(V) _G.EspPlayer = V end})

-- [[ TAB 5: MISC ]]
local TabMisc = Window:CreateTab("Misc", 4483362458)
TabMisc:CreateSlider({Name = "Speed Hack", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(V) if lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = V end end})
TabMisc:CreateButton({Name = "FPS Boost", Callback = function()
    for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" elseif v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end
    Lighting.GlobalShadows = false
end})

-- [[ LOGIKA AUTO JOIN PLAYER ]]
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if _G.EspPlayer or _G.EspKiller then
            Rayfield:Notify({Title = "New Player Detected", Content = player.Name .. " masuk radar ESP.", Duration = 3})
        end
    end)
end)

-- [[ CORE LOOP ]]
RunService.Stepped:Connect(function()
    if _G.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if _G.GodMode and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.Health = 100
    end
    if _G.AutoAim then
        local target = nil; local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local isK = p.Character:FindFirstChild("Weapon") or p.Character:FindFirstChild("Knife") or p:FindFirstChild("IsKiller")
                if isK then
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
                    createTag(p.Character, isK and Color3.new(1,0,0) or Color3.new(1,1,1), isK and "KILLER" or p.Name)
                else
                    if p.Character:FindFirstChild("Highlight") then p.Character.Highlight.Enabled = false end
                    if p.Character.Head:FindFirstChild("NVBTag") then p.Character.Head.NVBTag:Destroy() end
                end
            end
        end
        task.wait(0.2)
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false end
end)

Rayfield:Notify({Title = "V9.5 ULTIMATE LOADED", Content = "Semua Fitur Tanpa Terkecuali Aktif!", Duration = 5})
