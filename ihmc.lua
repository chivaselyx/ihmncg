local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RodRemoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RodRemoteEvent")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI Setup (as you said, StarterGui->reeling->Frame)
local PlayerGui = player:WaitForChild("PlayerGui")
local ReelingGui = PlayerGui:WaitForChild("reeling")
local Frame = ReelingGui:WaitForChild("Frame")
local InnerFrame = Frame:WaitForChild("Frame")  -- The inner frame with bars
local WhiteBar = InnerFrame:WaitForChild("WhiteBar")
local RedBar = InnerFrame:WaitForChild("RedBar")
local ProgressBar = Frame:WaitForChild("ProgressBg"):WaitForChild("ProgressBar")

-- Hide GUI initially
ReelingGui.Enabled = false

-- Constants for the minigame
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false)

-- Reset function for the reeling GUI & connections
local function reset()
    ReelingGui.Enabled = false
    RedBar.Position = UDim2.new(0.489, 0, -0.089, 0)
    WhiteBar.Size = UDim2.new(0.4, 0, 1, 0)
    WhiteBar.Position = UDim2.new(0, 0, 0, 0)
    ProgressBar.Size = UDim2.new(0.4, 0, 1, 0)
    WhiteBar.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
end

-- Equip Basic Rod function
local function equipRod()
    local backpack = player:WaitForChild("Backpack")
    local rod = backpack:FindFirstChild("Basic Rod")
    if rod then
        player.Character.Humanoid:EquipTool(rod)
        return true
    else
        print("Rod belum ada di backpack")
        return false
    end
end

-- Auto cast rod (lempar)
local function castRod()
    RodRemoteEvent:FireServer("Cast")
end

-- Minigame vars
local reelingActive = false
local whiteMovingRight = true
local redTween = nil
local connections = {}

local function startReeling(minigameArg)
    ReelingGui.Enabled = true
    ProgressBar.Size = UDim2.new(0.4, 0, 1, 0)
    whiteMovingRight = true
    reelingActive = true

    -- Tween RedBar randomly every 1-3 seconds
    redTween = task.spawn(function()
        while reelingActive do
            local newPosX = math.random() * 0.8 + 0.1
            TweenService:Create(RedBar, tweenInfo, {Position = UDim2.new(newPosX, 0, RedBar.Position.Y.Scale, 0)}):Play()
            task.wait(math.random(1, 3))
        end
    end)

    -- Update loop to move whitebar and update progress
    local conn = RunService.RenderStepped:Connect(function(dt)
        if not reelingActive then return end

        -- Move whitebar
        local frameWidth = Frame.AbsoluteSize.X
        local whiteAbsSize = WhiteBar.AbsoluteSize.X
        local whitePosX = WhiteBar.Position.X.Scale

        local speed = 0.7 * dt -- adjust speed

        if whiteMovingRight then
            whitePosX = math.min(whitePosX + speed, (frameWidth - whiteAbsSize)
