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
                -- Klik sekali untuk lempar pancing
                vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(0.1)
                vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                print("Lempar pancing")

                while autoFishing do
                    local fishingGui
                    repeat
                        wait(0.1)
                        fishingGui = player.PlayerGui:FindFirstChild("FishingGui") -- Ganti sesuai nama GUI
                    until fishingGui or not autoFishing

                    if not autoFishing then break end

                    local blackBar = fishingGui:FindFirstChild("BlackBar") -- bar abu
                    local redBar = fishingGui:FindFirstChild("RedBar") -- bar merah

                    if blackBar and redBar then
                        print("Mulai tahan klik dan ikutin bar merah")

                        -- tahan klik
                        vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

                        -- loop update posisi bar abu supaya selalu sama posisi bar merah
                        while autoFishing and fishingGui and blackBar and redBar do
                            -- update posisi bar abu ikut posisi bar merah
                            blackBar.Position = redBar.Position

                            -- update referensi, kalau bar ilang berhenti
                            blackBar = fishingGui:FindFirstChild("BlackBar")
                            redBar = fishingGui:FindFirstChild("RedBar")
                            if not blackBar or not redBar then break end

                            wait(0.03)
                        end

                        -- lepas klik saat selesai
                        vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        print("Lepas klik, selesai mancing")

                        -- tunggu animasi selesai
                        wait(3)
                    else
                        print("Bar GUI tidak ditemukan, coba lagi")
                    end

                    -- lempar pancing lagi untuk cycle berikutnya
                    if autoFishing then
                        vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        wait(0.1)
                        vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        print("Lempar pancing")
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
