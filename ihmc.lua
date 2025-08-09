-- Auto Reel Script + Rayfield GUI

local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local reelingGui = player.PlayerGui:WaitForChild("Reeling")

-- Ambil element GUI
local outerFrame = reelingGui:WaitForChild("Frame")
local innerFrame = outerFrame:WaitForChild("Frame")
local whiteBar = innerFrame:WaitForChild("WhiteBar")
local redBar = innerFrame:WaitForChild("RedBar")
local progressBar = outerFrame:WaitForChild("ProgressBg"):WaitForChild("ProgressBar")

local fishing = false
local connection

-- Fungsi start auto reel
local function startReeling()
    if connection then connection:Disconnect() end
    fishing = true
    connection = rs.RenderStepped:Connect(function(dt)
        local wPos = whiteBar.AbsolutePosition
        local wSize = whiteBar.AbsoluteSize
        local rPos = redBar.AbsolutePosition
        local rSize = redBar.AbsoluteSize

        local overlap = (rPos.X < wPos.X + wSize.X) and (wPos.X < rPos.X + rSize.X) and
                        (rPos.Y < wPos.Y + wSize.Y) and (wPos.Y < rPos.Y + rSize.Y)

        if overlap then
            progressBar.Size = UDim2.new(math.min(progressBar.Size.X.Scale + 0.08 * dt, 1), 0, progressBar.Size.Y.Scale, progressBar.Size.Y.Offset)
        else
            progressBar.Size = UDim2.new(math.max(progressBar.Size.X.Scale - 0.09 * dt, 0), 0, progressBar.Size.Y.Scale, progressBar.Size.Y.Offset)
        end
    end)
end

-- Fungsi stop auto reel
local function stopReeling()
    fishing = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Buat GUI di Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Auto Fishing",
    LoadingTitle = "Fishing Script",
    LoadingSubtitle = "by ChatGPT",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "AutoFishing",
       FileName = "config"
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateButton({
    Name = "Start Auto Reel",
    Callback = function()
        startReeling()
    end,
})

Tab:CreateButton({
    Name = "Stop Auto Reel",
    Callback = function()
        stopReeling()
    end,
})
