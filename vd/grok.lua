-- =============================================
-- VD Mobile v7.1 FULL - Auto Kill Agresif
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ================= SETTINGS =================
local AutoRepair = true
local AutoEscape = true
local ESP = true
local AutoParry = true
local GodMode = true
local AutoSkillCheck = true
local AntiStun = true
local AutoKill = false   -- Default OFF
local WalkSpeedValue = 55

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VD_Control_v7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 420)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
Title.Text = "VD Mobile v7.1 FULL"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Frame

local function createToggle(name, default, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13.5
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        default = not default
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        btn.Text = name .. ": " .. (default and "ON" or "OFF")
        callback(default)
    end)
end

createToggle("Auto Repair", AutoRepair, 45, function(s) AutoRepair = s end)
createToggle("Auto Escape", AutoEscape, 85, function(s) AutoEscape = s end)
createToggle("ESP Gen+Gate", ESP, 125, function(s) ESP = s end)
createToggle("Auto Parry", AutoParry, 165, function(s) AutoParry = s end)
createToggle("God Mode", GodMode, 205, function(s) GodMode = s end)
createToggle("Auto Skill Check", AutoSkillCheck, 245, function(s) AutoSkillCheck = s end)
createToggle("Anti Stun", AntiStun, 285, function(s) AntiStun = s end)
createToggle("🔴 AUTO KILL (Killer)", AutoKill, 325, function(s) AutoKill = s end)

-- WalkSpeed Button
local wsBtn = Instance.new("TextButton")
wsBtn.Size = UDim2.new(1, -20, 0, 35)
wsBtn.Position = UDim2.new(0, 10, 0, 365)
wsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
wsBtn.Text = "WalkSpeed: " .. WalkSpeedValue
wsBtn.TextColor3 = Color3.new(1,1,1)
wsBtn.Font = Enum.Font.Gotham
wsBtn.TextSize = 14
wsBtn.Parent = Frame

wsBtn.MouseButton1Click:Connect(function()
    WalkSpeedValue = WalkSpeedValue + 5
    if WalkSpeedValue > 90 then WalkSpeedValue = 40 end
    wsBtn.Text = "WalkSpeed: " .. WalkSpeedValue
end)

-- ================= ESP =================
local espObjects = {}
RunService.RenderStepped:Connect(function()
    if not ESP then
        for _, v in pairs(espObjects) do v:Destroy() end
        espObjects = {}
        return
    end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("gen") or obj.Name:lower():find("exit") or obj.Name:lower():find("gate")) then
            if not obj:FindFirstChild("ESPLabel") then
                local bill = Instance.new("BillboardGui", obj)
                bill.Name = "ESPLabel"
                bill.Size = UDim2.new(0, 120, 0, 50)
                bill.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Text = obj.Name:lower():find("gen") and "🟢 GEN" or "🚪 GATE"
                txt.TextColor3 = obj.Name:lower():find("gen") and Color3.new(0,1,0) or Color3.new(1,0.7,0)
                txt.TextStrokeTransparency = 0
                table.insert(espObjects, bill)
            end
        end
    end
end)

-- ================= MAIN LOOP =================
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        -- WalkSpeed
        hum.WalkSpeed = WalkSpeedValue

        -- God Mode
        if GodMode then
            hum.MaxHealth = 9999
            hum.Health = 9999
        end

        -- Anti Stun
        if AntiStun then
            hum.PlatformStand = false
        end

        -- Auto Repair + Skill Check
        if AutoRepair or AutoSkillCheck then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("gen") then
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt and (root.Position - obj.Position).Magnitude < 22 then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end

        -- Auto Parry
        if AutoParry then
            for _, killer in pairs(Players:GetPlayers()) do
                if killer \~= LocalPlayer and killer.Character then
                    local kRoot = killer.Character:FindFirstChild("HumanoidRootPart")
                    if kRoot and (root.Position - kRoot.Position).Magnitude < 18 then
                        local tool = char:FindFirstChildWhichIsA("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end

        -- ================= AUTO KILL AGRESIF =================
        if AutoKill then
            for _, survivor in pairs(Players:GetPlayers()) do
                if survivor \~= LocalPlayer and survivor.Character then
                    local sHum = survivor.Character:FindFirstChild("Humanoid")
                    local sRoot = survivor.Character:FindFirstChild("HumanoidRootPart")
                    if sHum and sRoot and sHum.Health > 0 then
                        local dist = (root.Position - sRoot.Position).Magnitude
                        if dist < 120 then
                            -- Teleport tanpa delay
                            if dist > 6 then
                                root.CFrame = sRoot.CFrame * CFrame.new(0, 3, 5)
                            end
                            -- Hit tanpa delay
                            local tool = char:FindFirstChildWhichIsA("Tool")
                            if tool then
                                tool:Activate()
                            end
                            break
                        end
                    end
                end
            end
        end
    end)
end)

-- Auto Escape
spawn(function()
    while wait(0.6) do
        if not AutoEscape then continue end
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, gate in pairs(Workspace:GetDescendants()) do
                    if gate.Name:lower():find("exit") or gate.Name:lower():find("gate") or gate.Name:lower():find("escape") then
                        local dist = (char.HumanoidRootPart.Position - gate.Position).Magnitude
                        if dist < 70 then
                            char.HumanoidRootPart.CFrame = gate.CFrame + Vector3.new(0,5,0)
                            local prompt = gate:FindFirstChildWhichIsA("ProximityPrompt")
                            if prompt then fireproximityprompt(prompt) end
                        end
                    end
                end
            end
        end)
    end
end)

print("✅ VD Mobile v7.1 FULL Loaded!")
game.StarterGui:SetCore("SendNotification", {Title = "VD v7.1", Text = "Auto Kill Agresif aktif! Hati-hati ban!", Duration = 8})
