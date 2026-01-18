local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "YB Hub | LEGACY FINAL v9.8",
   LoadingTitle = "Ultimate Survivor-Killer Hybrid",
   LoadingSubtitle = "by YB",
   ConfigurationSaving = {Enabled = true, FolderName = "YB_Configs"}
})

-- [[ GLOBAL SETTINGS ]]
local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local Ligh = game:GetService("Lighting")
local VU = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera

_G.WalkSpeed = 16
_G.DesyncEnabled = false
_G.DesyncIntensity = 5
_G.Noclip = false
_G.InvisMode = false
_G.GodMode = false
_G.TouchFling = false
_G.AutoCarry = false
_G.InstantEscape = false
_G.HitboxSize = 2
_G.AutoAim = false
_G.AutoParry = false
_G.NoFog = false
_G.AntiAfk = true

-- [[ 1. MAIN FEATURES ]]
local TabMain = Window:CreateTab("Main")
TabMain:CreateToggle({
   Name = "Centered Crosshair (Red Dot)",
   CurrentValue = false,
   Callback = function(v)
       local old = game:GetService("CoreGui"):FindFirstChild("YBCross")
       if v then
           local sg = Instance.new("ScreenGui", game:GetService("CoreGui")); sg.Name = "YBCross"
           local f = Instance.new("Frame", sg); f.Size = UDim2.new(0,5,0,5); f.Position = UDim2.new(0.5,-2,0.5,-2); f.BackgroundColor3 = Color3.new(1,0,0); f.BorderSizePixel = 0
       elseif old then old:Destroy() end
   end,
})

-- [[ 2. EXPLOITS (MOVEMENT & WORLD) ]]
local TabExp = Window:CreateTab("Exploits")
TabExp:CreateToggle({Name = "Desync (Ghost Mode/Lag)", CurrentValue = false, Callback = function(v) _G.DesyncEnabled = v end})
TabExp:CreateToggle({Name = "Invisible Mode (Hantu)", CurrentValue = false, Callback = function(v) 
    if v and lp.Character then lp.Character:MoveTo(Vector3.new(0, 1000, 0)); task.wait(0.1); lp.Character.LowerTorso:Destroy() end
end})
TabExp:CreateToggle({Name = "Noclip (Tembus Tembok)", CurrentValue = false, Callback = function(v) _G.Noclip = v end})
TabExp:CreateToggle({Name = "Anti-AFK (Anti Kick)", CurrentValue = true, Callback = function(v) _G.AntiAfk = v end})
TabExp:CreateToggle({Name = "Instant Escape (Auto Unhook)", CurrentValue = false, Callback = function(v) _G.InstantEscape = v end})
TabExp:CreateButton({Name = "Skip Cutscene", Callback = function() 
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do if v:IsA("VideoFrame") or v.Name == "Cutscene" then v:Destroy() end end 
end})

-- [[ 3. VISUALS (WALLHACK ESP) ]]
local TabVis = Window:CreateTab("Visuals")
TabVis:CreateToggle({Name = "Full Bright / No Fog", CurrentValue = false, Callback = function(v) _G.NoFog = v end})
TabVis:CreateButton({Name = "Enable IY Style ESP (Killer/Player)", Callback = function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local b = Instance.new("BoxHandleAdornment", v.Character); b.AlwaysOnTop = true; b.Size = v.Character:GetExtentsSize(); b.Transparency = 0.5; b.Adornee = v.Character
            b.Color3 = v.Character:FindFirstChild("Knife") and Color3.new(1,0,0) or Color3.new(0,1,0)
            local t = Instance.new("BillboardGui", v.Character.Head); t.Size = UDim2.new(0,100,0,50); t.AlwaysOnTop = true; t.ExtentsOffset = Vector3.new(0,3,0)
            local l = Instance.new("TextLabel", t); l.Text = v.Name.." | HP: "..math.floor(v.Character.Humanoid.Health); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.TextStrokeTransparency = 0
        end
    end
end})

-- [[ 4. COMBAT (KILLER MODE) ]]
local TabComb = Window:CreateTab("Combat")
TabComb:CreateToggle({Name = "Touch Fling (Insta-Kill)", CurrentValue = false, Callback = function(v) _G.TouchFling = v end})
TabComb:CreateToggle({Name = "Aggressive Carry (Survivor)", CurrentValue = false, Callback = function(v) _G.AutoCarry = v end})
TabComb:CreateToggle({Name = "Auto Aim Killer", CurrentValue = false, Callback = function(v) _G.AutoAim = v end})
TabComb:CreateToggle({Name = "Auto Parry Dagger", CurrentValue = false, Callback = function(v) _G.AutoParry = v end})
TabComb:CreateToggle({Name = "God Mode (Immortal)", CurrentValue = false, Callback = function(v) _G.GodMode = v end})
TabComb:CreateSlider({Name = "Hitbox Expander", Range = {2, 50}, Increment = 1, CurrentValue = 2, Callback = function(v) _G.HitboxSize = v end})

-- [[ 5. REJOIN & MISC ]]
local TabMisc = Window:CreateTab("Misc")
TabMisc:CreateSlider({Name = "WalkSpeed Multiplier", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) _G.WalkSpeed = v end})
TabMisc:CreateButton({Name = "FPS Boost (Anti-Lag)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end
end})
TabMisc:CreateButton({Name = "Server Jump (Rejoin)", Callback = function() TS:Teleport(game.PlaceId, lp) end})

-- [[ CORE LOGICS ]]
RS.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        if _G.Noclip then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if _G.GodMode then lp.Character.Humanoid.Health = 100 end
        if _G.AutoCarry then
            local target = nil
            for _,v in pairs(game.Players:GetPlayers()) do if v ~= lp and v.Character and (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 12 then target = v.Character break end end
            if target then target.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0.5) * CFrame.Angles(math.rad(90), math.rad(90), 0) end
        end
        if _G.InstantEscape and lp.Character.Humanoid.SeatPart then lp.Character.Humanoid.Jump = true; lp.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 10, 0) end
    end
end)

RS.Heartbeat:Connect(function()
    if _G.DesyncEnabled and lp.Character:FindFirstChild("HumanoidRootPart") then
        local cf = lp.Character.HumanoidRootPart.CFrame
        lp.Character.HumanoidRootPart.CFrame = cf * CFrame.new(math.random(-_G.DesyncIntensity, _G.DesyncIntensity), 0, math.random(-_G.DesyncIntensity, _G.DesyncIntensity))
        RS.RenderStepped:Wait(); lp.Character.HumanoidRootPart.CFrame = cf
    end
    if _G.TouchFling then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 5 then
                    v.Character.HumanoidRootPart.Velocity = Vector3.new(0, 10000, 0)
                end
            end
        end
    end
end)

RS.RenderStepped:Connect(function()
    if _G.NoFog then Ligh.Ambient = Color3.new(1,1,1); Ligh.Brightness = 2; Ligh.FogEnd = 1e5 end
    local killer = nil
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp and v.Character and v.Character:FindFirstChild("Knife") then killer = v break end end
    if _G.AutoAim and killer then Camera.CFrame = CFrame.new(Camera.CFrame.Position, killer.Character.HumanoidRootPart.Position) end
    if _G.AutoParry and killer and (killer.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 12 then
        local d = lp.Character:FindFirstChild("Dagger") or lp.Backpack:FindFirstChild("Dagger")
        if d then if d.Parent == lp.Backpack then lp.Character.Humanoid:EquipTool(d) end; d:Activate(); VIM:SendMouseButtonEvent(0,0,0,true,game,0); VIM:SendMouseButtonEvent(0,0,0,false,game,0) end
    end
end)

-- Hitbox Expander Loop
task.spawn(function()
    while true do
        if _G.HitboxSize > 2 then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency = 0.8
                end
            end
        end
        task.wait(1)
    end
end)

-- Anti-AFK
lp.Idled:Connect(function() if _G.AntiAfk then VU:Button2Down(Vector2.new(0,0), Camera.CFrame); task.wait(1); VU:Button2Up(Vector2.new(0,0), Camera.CFrame) end end)

Rayfield:LoadConfiguration()
