local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RodRemoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RodRemoteEvent")
local RunService = game:GetService("RunService")

local autoMancing = false
local reelingActive = false
local autoReelConnection
local autoMancingThread

local function equipRod()
    local rod = player.Backpack:FindFirstChild("Basic Rod") or player.Character:FindFirstChild("Basic Rod")
    if rod then
        rod.Parent = player.Character
        print("[AutoMancing] Basic Rod equipped!")
    else
        warn("[AutoMancing] Basic Rod tidak ditemukan!")
    end
end

local function castRod()
    local mousePos = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
    VirtualUser:Button1Down(mousePos)
    task.wait(0.05)
    VirtualUser:Button1Up(mousePos)
    print("[AutoMancing] Rod casted!")
end

local function autoReel(arg2)
    local gui = player.PlayerGui:FindFirstChild("FishingUI")
    if not gui then return end
    local frame = gui:FindFirstChild("Frame")
    local whiteBar = frame:FindFirstChild("WhiteBar")
    local progressBar = frame.ProgressBg.ProgressBar

    local direction = 1
    reelingActive = true

    if autoReelConnection then
        autoReelConnection:Disconnect()
        autoReelConnection = nil
    end

    autoReelConnection = RunService.RenderStepped:Connect(function(dt)
        if not reelingActive then return end

        local newPosX = whiteBar.Position.X.Scale + 0.5 * dt * direction
        if newPosX > 0.9 then
            direction = -1
            newPosX = 0.9
        elseif newPosX < 0 then
            direction = 1
            newPosX = 0
        end
        whiteBar.Position = UDim2.new(newPosX, 0, whiteBar.Position.Y.Scale, 0)

        if progressBar.Size.X.Scale >= 1 then
            reelingActive = false
            RodRemoteEvent:FireServer("Reeling", arg2, true)
            if autoReelConnection then
                autoReelConnection:Disconnect()
                autoReelConnection = nil
            end
            print("[AutoMancing] Fish caught!")
        elseif progressBar.Size.X.Scale <= 0 then
            reelingActive = false
            RodRemoteEvent:FireServer("Reeling", arg2, false)
            if autoReelConnection then
                autoReelConnection:Disconnect()
                autoReelConnection = nil
            end
            print("[AutoMancing] Fish escaped!")
        end
    end)
end

local function startAutoMancing()
    if autoMancing then
        print("[AutoMancing] Sudah berjalan!")
        return
    end
    autoMancing = true
    autoMancingThread = task.spawn(function()
        while autoMancing do
            if not reelingActive then
                equipRod()
                task.wait(0.3)
                castRod()
            else
                task.wait(0.1)
            end
            task.wait(0.2)
        end
    end)
    print("[AutoMancing] Dimulai!")
end

local function stopAutoMancing()
    autoMancing = false
    reelingActive = false
    if autoReelConnection then
        autoReelConnection:Disconnect()
        autoReelConnection = nil
    end
    if autoMancingThread then
        -- Tidak perlu explicit cancel task.spawn tapi biar jelas
        autoMancingThread = nil
    end
    print("[AutoMancing] Dihentikan!")
end

-- Event handler untuk mulai auto reeling
RodRemoteEvent.OnClientEvent:Connect(function(action, arg2)
    if action == "Reeling" then
        print("[AutoMancing] Reeling started!")
        autoReel(arg2)
    end
end)

-- Kamu bisa panggil startAutoMancing() untuk mulai
-- dan stopAutoMancing() untuk berhenti

-- Contoh:
-- startAutoMancing()
-- task.wait(10)
-- stopAutoMancing()
