loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "VD Mobile | Grok v7.2 FULL",
   LoadingTitle = "Loading Full Features",
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateToggle({Name = "Auto Repair", CurrentValue = true, Callback = function(v) _G.AutoRepair = v end})
Tab:CreateToggle({Name = "Auto Escape", CurrentValue = true, Callback = function(v) _G.AutoEscape = v end})
Tab:CreateToggle({Name = "ESP Generator + Gate", CurrentValue = true, Callback = function(v) _G.ESP = v end})
Tab:CreateToggle({Name = "Auto Parry", CurrentValue = true, Callback = function(v) _G.AutoParry = v end})
Tab:CreateToggle({Name = "God Mode", CurrentValue = true, Callback = function(v) _G.GodMode = v end})
Tab:CreateToggle({Name = "Auto Skill Check", CurrentValue = true, Callback = function(v) _G.AutoSkillCheck = v end})
Tab:CreateToggle({Name = "Anti Stun", CurrentValue = true, Callback = function(v) _G.AntiStun = v end})
Tab:CreateToggle({Name = "🔴 Auto Kill (Killer)", CurrentValue = false, Callback = function(v) _G.AutoKill = v end})

Tab:CreateSlider({Name = "WalkSpeed", Range = {40, 100}, Increment = 5, CurrentValue = 55, Callback = function(v) _G.WalkSpeed = v end})

Rayfield:Notify({Title = "FULL FITUR LOADED", Content = "Semua fitur ada. Gunakan Auto Kill dengan bijak.", Duration = 8})

-- ================= FULL LOGIC =================
spawn(function()
    while wait() do
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end

            if _G.WalkSpeed then hum.WalkSpeed = _G.WalkSpeed end
            if _G.GodMode then hum.Health = 9999; hum.MaxHealth = 9999 end
            if _G.AntiStun then hum.PlatformStand = false end

            -- Auto Kill
            if _G.AutoKill then
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr \~= game.Players.LocalPlayer and plr.Character then
                        local sroot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if sroot then
                            local dist = (root.Position - sroot.Position).Magnitude
                            if dist < 120 then
                                root.CFrame = sroot.CFrame * CFrame.new(0, 3, 5)
                                local tool = char:FindFirstChildWhichIsA("Tool")
                                if tool then tool:Activate() end
                            end
                        end
                    end
                end
            end

            -- Auto Repair + Skill Check
            if _G.AutoRepair or _G.AutoSkillCheck then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("gen") then
                        local p = obj:FindFirstChildWhichIsA("ProximityPrompt")
                        if p and (root.Position - obj.Position).Magnitude < 22 then
                            fireproximityprompt(p)
                        end
                    end
                end
            end

            -- Auto Parry
            if _G.AutoParry then
                for _, killer in pairs(game.Players:GetPlayers()) do
                    if killer \~= game.Players.LocalPlayer and killer.Character then
                        local kroot = killer.Character:FindFirstChild("HumanoidRootPart")
                        if kroot and (root.Position - kroot.Position).Magnitude < 20 then
                            local tool = char:FindFirstChildWhichIsA("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Escape
spawn(function()
    while wait(0.6) do
        if not _G.AutoEscape then continue end
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, gate in pairs(workspace:GetDescendants()) do
                    if gate.Name:lower():find("exit") or gate.Name:lower():find("gate") then
                        if (char.HumanoidRootPart.Position - gate.Position).Magnitude < 70 then
                            char.HumanoidRootPart.CFrame = gate.CFrame + Vector3.new(0,5,0)
                            local p = gate:FindFirstChildWhichIsA("ProximityPrompt")
                            if p then fireproximityprompt(p) end
                        end
                    end
                end
            end
        end)
    end
end)
