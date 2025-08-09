local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RodRemoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RodRemoteEvent")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer

-- Fungsi untuk menekan tombol '1' equip rod
local function equipRod()
    VirtualUser:SendKeyEvent(true, Enum.KeyCode.One, false, game)
    wait(0.1)
    VirtualUser:SendKeyEvent(false, Enum.KeyCode.One, false, game)
end

-- Fungsi klik kiri mouse (lempar joran)
local function castRod()
    VirtualUser:Button1Down(Vector2.new(0,0))
    wait(0.05)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

local reelingActive = false
local autoReelConnection

-- Fungsi Auto Reel
local function autoReel(arg2)
    local progressGui = Player.PlayerGui:WaitForChild("FishingUI") -- Ganti sesuai nama GUI root kalau beda
    local frame = progressGui:WaitForChild("Frame")
    local whiteBar = frame:WaitForChild("WhiteBar")
    local progressBar = frame.ProgressBg.ProgressBar

    local direction = 1 -- 1 buat maju, -1 buat mundur
    reelingActive = true

    autoReelConnection = RunService.RenderStepped:Connect(function(dt)
        if not reelingActive then return end
        -- Kita kontrol posisi whiteBar supaya terus bergerak agar progress naik
        local newPosX = whiteBar.Position.X.Scale + 0.5 * dt * direction
        if newPosX > 0.9 then
            direction = -1
            newPosX = 0.9
        elseif newPosX < 0 then
            direction = 1
            newPosX = 0
        end
        whiteBar.Position = UDim2.new(newPosX, 0, whiteBar.Position.Y.Scale, 0)

        -- Kalau progress bar penuh, kirim event tarik ikan
        if progressBar.Size.X.Scale >= 1 then
            reelingActive = false
            RodRemoteEvent:FireServer("Reeling", arg2, true)
            if autoReelConnection then
                autoReelConnection:Disconnect()
                autoReelConnection = nil
            end
        elseif progressBar.Size.X.Scale <= 0 then
            -- Kalau gagal, reset juga
            reelingActive = false
            RodRemoteEvent:FireServer("Reeling", arg2, false)
            if autoReelConnection then
                autoReelConnection:Disconnect()
                autoReelConnection = nil
            end
        end
    end)
end

-- Dengarkan event dari server yang memulai proses reeling
RodRemoteEvent.OnClientEvent:Connect(function(action, arg2)
    if action == "Reeling" then
        autoReel(arg2)
    end
end)

-- Loop utama auto mancing
while true do
    equipRod()
    wait(0.2)
    castRod()
    -- Tunggu proses reeling selesai (ditangani oleh event)
    repeat wait(0.5) until not reelingActive
    wait(2) -- jeda sebelum lempar lagi, bisa diatur
end
