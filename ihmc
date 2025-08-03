-- Script Auto Mancing Indo Hangout dengan Rayfield GUI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local vu = game:GetService("VirtualUser")
local player = game.Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Indo Hangout Auto Mancing",
   LoadingTitle = "Belajar Scripting",
   LoadingSubtitle = "Script by Kamu",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

local Tab = Window:CreateTab("Main")

local autoFishing = false

Tab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Callback = function(Value)
        autoFishing = Value
        if autoFishing then
            task.spawn(function()
                while autoFishing do
                    -- step 1: klik sekali buat lempar pancing
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    wait(0.1)
                    vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    print("Lempar pancing")

                    -- step 2: tunggu progress bar muncul
                    local foundBar = nil
                    local tries = 0
                    repeat
                        wait(0.1)
                        tries = tries + 1
                        local gui = player.PlayerGui:FindFirstChild("FishingGui") -- Ganti dengan nama GUI di game
                        if gui then
                            foundBar = gui:FindFirstChild("ProgressBar") -- Ganti dengan nama bar di GUI
                        end
                        if tries > 50 then
                            break
                        end
                    until foundBar or not autoFishing

                    if foundBar and autoFishing then
                        print("Progress bar muncul, tahan klik...")
                        -- step 3: tahan klik
                        vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

                        wait(2) -- sesuaikan waktu lepas klik

                        -- step 4: lepas klik
                        vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        print("Lepas klik")
                    end

                    wait(3) -- tunggu animasi mancing selesai
                end
            end)
        else
            print("Auto fishing dimatikan")
        end
    end,
})

Tab:CreateButton({
    Name = "Stop Auto Fishing",
    Callback = function()
        autoFishing = false
        print("Auto fishing dihentikan manual")
    end,
})
