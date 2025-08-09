-- Load Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Auto Mancing",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Fishing Simulator"
})

getgenv().AutoMancing = false

-- Tab
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Toggle Auto Mancing
Tab:AddToggle({
    Name = "Auto Mancing",
    Default = false,
    Callback = function(Value)
        getgenv().AutoMancing = Value
        if Value then
            while getgenv().AutoMancing do
                -- Logic auto mancing di sini
                print("Mancing...")
                task.wait(1)
            end
        end
    end
})

OrionLib:Init()
