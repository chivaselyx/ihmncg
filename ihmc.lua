local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local vu = game:GetService("VirtualUser")
local player = game.Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Indo Hangout Auto Mancing",
   LoadingTitle = "Belajar Scripting",
   LoadingSubtitle = "Script by Kamu",
   ConfigurationSaving = { Enabled = false },
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
                -- Step 1: lempar pancing sekali aja
                vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(0.1)
                vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                print("Lempar pancing sekali")

                while autoFishing do
                    -- Step 2: tunggu progress bar muncul
                    local fishingGui = nil
                    repeat
                        wait(0.1)
                        fishingGui = player.PlayerGui:FindFirstChild("FishingGui") -- Ganti sesuai nama GUI game
                    until fishingGui or not autoFishing

                    if not autoFishing then break end

                    -- Step 3: cari bar merah dan bar abu
                    local blackBar = fishingGui:FindFirstChild("BlackBar") -- ganti sesuai nama bar abu
                    local redBar = fishingGui:FindFirstChild("RedBar") -- ganti sesuai nama bar merah

                    if blackBar and redBar then
                        print("Progress bar muncul, mulai tahan klik dan ikuti bar merah")

                        -- tahan klik
                        vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

                        -- update posisi bar abu supaya ikuti bar merah
                        while autoFishing and fishingGui and blackBar and redBar do
                            blackBar.Position = redBar.Position

                            -- refresh bar referensi
                            blackBar = fishingGui:FindFirstChild("BlackBar")
                            redBar = fishingGui:FindFirstChild("RedBar")
                            if not blackBar or not redBar then break end

                            wait(0.03)
                        end

                        -- lepas klik setelah selesai
                        vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        print("Lepas klik, selesai mancing")

                        -- tunggu animasi selesai
                        wait(3)
                    else
                        print("Bar GUI tidak ditemukan, coba lagi")
                    end

                    -- Step 4: lempar pancing lagi untuk next cycle
                    if autoFishing then
                        vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        wait(0.1)
                        vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        print("Lempar pancing lagi")
                    end

                    wait(0.5)
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
