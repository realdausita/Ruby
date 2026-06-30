local Ruby = loadstring(game:HttpGet("https://github.com/realdausita/Ruby/releases/latest/download/main.lua"))()

local Loader = Ruby:CreateLoader({
    Title = "Ruby Hub",
    Text = "Starting Ruby...",
    Progress = 0.2
})

task.wait(0.4)
Loader:SetText("Loading interface...")
Loader:SetProgress(0.55)

task.wait(0.4)
Loader:SetText("Applying config system...")
Loader:SetProgress(0.85)

task.wait(0.3)
Loader:Close()

Ruby:SetAutoSave(true, "default")

local Window = Ruby:CreateWindow({
    Title = "Ruby Hub",
    SubTitle = "example script",
    TabWidth = 160,
    Size = UDim2.fromOffset(640, 520),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Ruby:Notify({
    Title = "Ruby",
    Content = "Example loaded.",
    SubContent = "Open the Ruby tab for menu keybind and config manager.",
    Duration = 5
})

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://7733960981"
})

local Player = Window:CreateTab({
    Name = "Player",
    Icon = "rbxassetid://7734053495"
})

local Visuals = Window:CreateTab({
    Name = "Visuals",
    Icon = "rbxassetid://7733765398"
})

local Configs = Window:CreateTab({
    Name = "Configs",
    Icon = "rbxassetid://7734056608"
})

local MainSection = Main:CreateSection("General")

MainSection:CreateParagraph({
    Title = "Ruby Example",
    Content = "This script tests buttons, toggles, inputs, keybinds, sliders, dropdowns, themes, colorpicker, loader, and configs."
})

MainSection:CreateParagraph({
    Title = "Device Info",
    Content = "Current Device Mode: " .. Ruby.Device .. " (Using " .. (Ruby:IsMobile() and "Mobile" or "Desktop") .. " Layout)"
})

MainSection:CreateButton({
    Name = "Notify",
    Callback = function()
        Ruby:Notify({
            Title = "Button",
            Content = "Button callback works.",
            Duration = 3
        })
    end
})

MainSection:CreateToggle({
    Name = "Example Toggle",
    Default = false,
    Pointer = "ExampleToggle",
    Callback = function(Value)
        print("ExampleToggle:", Value)
    end
})

MainSection:CreateSlider({
    Name = "Menu Transparency",
    Min = 0,
    Max = 0.8,
    Default = 0,
    Precise = true,
    Pointer = "MenuTransparency",
    Callback = function(Value)
        Window:SetTransparency(Value)
    end
})

MainSection:CreateInput({
    Name = "Custom Message",
    Default = "hello ruby",
    Placeholder = "write something",
    Pointer = "CustomMessage",
    Callback = function(Text)
        print("Input:", Text)
    end
})

MainSection:CreateKeybind({
    Name = "Notify Key",
    Default = Enum.KeyCode.F,
    Mode = "Toggle",
    Pointer = "NotifyKey",
    Callback = function(State)
        Ruby:Notify({
            Title = "Keybind",
            Content = "Notify key state: " .. tostring(State),
            Duration = 2
        })
    end
})

local PlayerSection = Player:CreateSection("Movement")

PlayerSection:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Precise = false,
    Pointer = "WalkSpeed",
    Callback = function(Value)
        local plr = game:GetService("Players").LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.WalkSpeed = Value
        end
    end
})

PlayerSection:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 250,
    Default = 50,
    Precise = false,
    Pointer = "JumpPower",
    Callback = function(Value)
        local plr = game:GetService("Players").LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

PlayerSection:CreateDropdown({
    Name = "Movement Preset",
    Options = { "Normal", "Legit", "Fast", "Rage" },
    Default = "Normal",
    Pointer = "MovementPreset",
    Callback = function(Value)
        print("Preset:", Value)
    end
})

local VisualSection = Visuals:CreateSection("Theme")

VisualSection:CreateDropdown({
    Name = "Theme",
    Options = Ruby:GetThemeNames(),
    Default = "Dark",
    Pointer = "ThemeDropdown",
    Callback = function(Theme)
        Ruby:SetTheme(Theme)
    end
})

VisualSection:CreateColorpicker({
    Name = "Custom Accent",
    Default = Color3.fromRGB(255, 80, 120),
    Pointer = "CustomAccent",
    Callback = function(Color)
        Ruby.Themes.Custom.Accent = Color
        Ruby.Themes.Custom.Accent2 = Color:Lerp(Color3.fromRGB(255, 255, 255), 0.25)
        Ruby:SetTheme("Custom")
    end
})

VisualSection:CreateDropdown({
    Name = "Multi Visuals",
    Options = { "ESP", "Boxes", "Names", "Tracers", "Distance", "Health" },
    Default = { "ESP", "Names" },
    Multi = true,
    Pointer = "VisualOptions",
    Callback = function(Value)
        print("Selected visuals:", table.concat(Value, ", "))
    end
})

local ConfigSection = Configs:CreateSection("Custom Config Manager")

local SelectedConfig = "default"

local ConfigName = ConfigSection:CreateInput({
    Name = "Config Name",
    Default = SelectedConfig,
    Placeholder = "my_config",
    Save = false,
    Callback = function(Value)
        if Value ~= "" then
            SelectedConfig = Value
        end
    end
})

local ConfigDropdown

ConfigDropdown = ConfigSection:CreateDropdown({
    Name = "Configs",
    Options = Ruby:ListConfigs(),
    Default = SelectedConfig,
    Save = false,
    Refresh = function()
        local List = Ruby:ListConfigs()
        if #List == 0 then
            List = { SelectedConfig }
        end
        return List
    end,
    Callback = function(Value)
        SelectedConfig = Value
        ConfigName:Set(Value, true)
    end
})

ConfigSection:CreateButton({
    Name = "Create / Save Config",
    Callback = function()
        local Name = ConfigName:Get()
        if Name == "" then
            Name = SelectedConfig
        end

        SelectedConfig = Name
        Ruby:SaveConfig(Name)
        ConfigDropdown:RefreshOptions(Ruby:ListConfigs(), true)
        ConfigDropdown:Set(Name, true)

        Ruby:Notify({
            Title = "Config",
            Content = "Saved: " .. Name,
            Duration = 3
        })
    end
})

ConfigSection:CreateButton({
    Name = "Load Selected Config",
    Callback = function()
        Ruby:LoadConfig(SelectedConfig)

        Ruby:Notify({
            Title = "Config",
            Content = "Loaded: " .. SelectedConfig,
            Duration = 3
        })
    end
})

ConfigSection:CreateButton({
    Name = "Delete Selected Config",
    Callback = function()
        Ruby:DeleteConfig(SelectedConfig)

        SelectedConfig = "default"
        ConfigName:Set(SelectedConfig, true)
        ConfigDropdown:RefreshOptions(Ruby:ListConfigs(), true)
        ConfigDropdown:Set(SelectedConfig, true)

        Ruby:Notify({
            Title = "Config",
            Content = "Deleted selected config.",
            Duration = 3
        })
    end
})
