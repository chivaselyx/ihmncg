-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RodRemoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RodRemoteEvent")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- Variabel kontrol
local autoMancing = false
local delayLempar = 2
local reelingActive = false
local autoReelConnection

-- Fungsi equip rod
local function equipRod()
    VirtualUser:SendKeyEvent(true, Enum.KeyCode.One, false, game)
    task.wait(0.1)
    VirtualUser:SendKeyEvent(false, Enum.KeyCode.One, false, game)
end

-- Fungsi lempar pancing
local function castRod()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait(0.05)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

-- Auto reeling
local function autoReel(arg2)
    local progressGui = Player.PlayerGui:FindFirstChild("FishingUI") -- ganti kalau beda
    if not progressGui then return end

    local frame = progressGui:FindFirstChild("Frame")
    local whiteBar = frame:FindFirstChild("WhiteBar")
    local progressBar = frame.ProgressBg.ProgressBar

    local direction = 1
    reelingActive = true

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
        elseif progressBar.Size.X.Scale <= 0 then
            reelingActive = false
            RodRemoteEvent:FireServer("Reeling", arg2, false)
            if autoReelConnection then
                autoReelConnection:Disconnect()
                autoReelConnection = nil
            end
        end
    end)
end

-- Event dari server
RodRemoteEvent.OnClientEvent:Connect(function(action, arg2)
    if autoMancing and action == "Reeling" then
        autoReel(arg2)
    end
end)

-- Loop utama auto mancing
task.spawn(function()
    while task.wait(0.5) do
        if autoMancing and not reelingActive then
            equipRod()
            task.wait(0.2)
            castRod()
            task.wait(delayLempar)
        end
    end
end)

-- Buat GUI Rayfield
local Window = Rayfield:CreateWindow({
    Name = "Auto Mancing",
    LoadingTitle = "Auto Mancing GUI",
    LoadingSubtitle = "by ChatGPT",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "AutoMancing",
       FileName = "Config"
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

-- Tab utama
local Tab = Window:CreateTab("Main", 4483362458) -- icon asset id

-- Toggle Auto Mancing
Tab:CreateToggle({
    Name = "Aktifkan Auto Mancing",
    CurrentValue = false,
    Flag = "AutoMancing",
    Callback = function(Value)
        autoMancing = Value
    end
})

-- Slider Delay Lempar
Tab:CreateSlider({
    Name = "Delay Lempar (detik)",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = " detik",
    CurrentValue = 2,
    Flag = "DelayLempar",
    Callback = function(Value)
        delayLempar = Value
    end
})
