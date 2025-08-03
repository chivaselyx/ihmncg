


local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()


local Window = Rayfield:CreateWindow({
    Name = "Flying Script",
    LoadingTitle = "Flying Script",
    LoadingSubtitle = "by Script Generator AI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FlyScriptConfig",
        FileName = "UserSettings"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false
})

-- Variables
local flying = false
local speed = 50
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")


local FlyToggle = Window:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        flying = value
        if flying then
            startFlying()
        else
            stopFlying()
        end
    end,
})

local SpeedSlider = Window:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = speed,
    Flag = "FlySpeed",
    Callback = function(value)
        speed = value
    end,
})


local bodyGyro
local bodyVelocity

function startFlying()
    -- Ensure humanoid state allows flying
    humanoid.PlatformStand = true
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e5, 9e5, 9e5)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.MaxForce = Vector3.new(9e5, 9e5, 9e5)
    bodyVelocity.Parent = rootPart

    -- Control flying movement
    local userInputService = game:GetService("UserInputService")

    local function fly()
        while flying do
            game:GetService("RunService").Heartbeat:Wait()
            local camCF = workspace.CurrentCamera.CFrame
            local moveDirection = Vector3.new(0,0,0)
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camCF.LookVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camCF.LookVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camCF.RightVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camCF.RightVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0,1,0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0,1,0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end

            bodyVelocity.Velocity = moveDirection * speed
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end

    spawn(fly)
end

function stopFlying()
    humanoid.PlatformStand = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end
