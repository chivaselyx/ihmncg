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
    Discord = { Enabled = false },
    KeySystem = false
})

-- Variables
local flying = false
local speed = 50
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local flyConnection

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

-- Fly logic
function startFlying()
    local alignPos = Instance.new("AlignPosition", humanoidRootPart)
    local alignOri = Instance.new("AlignOrientation", humanoidRootPart)
    local attachmentA = Instance.new("Attachment", humanoidRootPart)
    local attachmentB = Instance.new("Attachment", workspace.CurrentCamera)

    alignPos.Attachment0 = attachmentA
    alignPos.Attachment1 = attachmentB
    alignPos.RigidityEnabled = false
    alignPos.MaxForce = 999999
    alignPos.Responsiveness = 25

    alignOri.Attachment0 = attachmentA
    alignOri.Attachment1 = attachmentB
    alignOri.MaxTorque = 999999
    alignOri.Responsiveness = 25

    flyConnection = runService.Heartbeat:Connect(function()
        local camCF = workspace.CurrentCamera.CFrame
        local moveDirection = Vector3.new()

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
            moveDirection = moveDirection.Unit * speed
            attachmentB.WorldCFrame = CFrame.new(humanoidRootPart.Position + moveDirection)
        else
            attachmentB.WorldCFrame = CFrame.new(humanoidRootPart.Position)
        end
    end)
end

function stopFlying()
    if flyConnection then flyConnection:Disconnect() end
    for _,v in ipairs(humanoidRootPart:GetChildren()) do
        if v:IsA("AlignPosition") or v:IsA("AlignOrientation") or v:IsA("Attachment") then
            v:Destroy()
        end
    end
end
