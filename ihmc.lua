-- GUI Auto Mancing
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)

-- Tombol Auto Mancing
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.Size = UDim2.new(1, -10, 0, 40)
ToggleButton.Position = UDim2.new(0, 5, 0, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Auto Mancing: OFF"

-- Tombol Close
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"

-- Variabel Global
getgenv().AutoMancing = false
local rodName = "Basic Rod" -- ganti kalau pakai rod lain

-- Fungsi lempar joran
local function throwRod()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    -- Equip rod
    if humanoid and player.Backpack:FindFirstChild(rodName) then
        humanoid:EquipTool(player.Backpack[rodName])
    end

    -- Klik lempar (trigger remote)
    local rod = char:FindFirstChild(rodName)
    if rod and rod:FindFirstChild("Remote") then
        rod.Remote:FireServer("Cast", math.random(1, 100))
    end
end

-- Fungsi reeling otomatis
local function reelFish()
    local rod = game.Players.LocalPlayer.Character:FindFirstChild(rodName)
    if rod and rod:FindFirstChild("Remote") then
        rod.Remote:FireServer("Reeling", math.random(1, 100), true)
    end
end

-- Main Loop Auto Mancing
local function autoFishingLoop()
    spawn(function()
        while getgenv().AutoMancing do
            throwRod()
            task.wait(math.random(2, 4)) -- tunggu ikan nyangkut
            reelFish()
            task.wait(1) -- jeda sebelum ulang
        end
    end)
end

-- Klik tombol toggle
ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoMancing = not getgenv().AutoMancing
    ToggleButton.Text = "Auto Mancing: " .. (getgenv().AutoMancing and "ON" or "OFF")

    if getgenv().AutoMancing then
        autoFishingLoop()
    end
end)

-- Klik tombol close
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    getgenv().AutoMancing = false
end)
