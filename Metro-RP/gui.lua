local Functions = require("Metro-RP/functions")

local GUI = {}
GUI.__index = GUI

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

function GUI.mount(playerGui)
    local self = setmetatable({}, GUI)

    local Window = Rayfield:CreateWindow({
        Name = "Alura Movement Menu",
        LoadingTitle = "Movement Tools",
        LoadingSubtitle = "by Alura",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AluraMovement",
            FileName = "MovementConfig"
        },
        KeySystem = false
    })

    local Tab = Window:CreateTab("Main", 4483362458)

    Tab:CreateSection("Teleport System")

    local selectedPlayer = nil

    local dropdown = Tab:CreateDropdown({
        Name = "Select Player",
        Options = Functions.getPlayers(),
        CurrentOption = nil,
        Callback = function(option)
            selectedPlayer = typeof(option) == "table" and option[1] or option
        end
    })

    task.spawn(function()
        while true do
            dropdown.Options = Functions.getPlayers()
            Rayfield:Refresh()
            task.wait(5)
        end
    end)

    Tab:CreateButton({
        Name = "Teleport",
        Callback = function()
            if not selectedPlayer then
                Rayfield:Notify("Teleport", "No player selected", 4483362458)
                return
            end
            local ok, err = Functions.teleportToPlayer(selectedPlayer)
            if ok then
                Rayfield:Notify("Teleport", "Teleported to " .. selectedPlayer, 4483362458)
            else
                Rayfield:Notify("Teleport Error", err or "failed", 4483362458)
            end
        end
    })

    Tab:CreateSection("Fly Movement")

    Tab:CreateToggle({
        Name = "Fly (WASD + Space/Shift)",
        CurrentValue = false,
        Callback = function(v)
            if v then
                Functions.enableFly()
            else
                Functions.disableFly()
            end
        end
    })

    return self
end

return GUI
