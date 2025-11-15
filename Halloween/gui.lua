local Config = require("Halloween/config")

local GUI = {}
GUI.__index = GUI

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

function GUI.mount(playerGui)
    local self = setmetatable({}, GUI)

    local Window = Rayfield:CreateWindow({
        Name = "Alura Halloween Autofarm",
        LoadingTitle = "Halloween",
        LoadingSubtitle = "by Alura",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AluraHalloween",
            FileName = "HalloweenConfig"
        },
        KeySystem = false
    })

    local Tab = Window:CreateTab("Main", 4483362458)

    local selectedEgg = Config.defaults.selectedEgg
    local selectedHouse = Config.defaults.selectedHouse
    local toggleOpenEggs = Config.defaults.doOpenEggs
    local toggleMaxEggs = Config.defaults.doOpenMaxEggs
    local toggleOpenHouse = Config.defaults.doOpenHouse
    local toggleClaimCandy = Config.defaults.doClaimCandy
    local running = false

    Tab:CreateSection("Settings")

    Tab:CreateDropdown({
        Name = "Select Egg",
        Options = Config.EGG_OPTIONS,
        CurrentOption = selectedEgg,
        Callback = function(option)
            selectedEgg = option
        end
    })

    Tab:CreateDropdown({
        Name = "Select House",
        Options = Config.HOUSE_OPTIONS,
        CurrentOption = selectedHouse,
        Callback = function(option)
            selectedHouse = option
        end
    })

    Tab:CreateToggle({
        Name = "Open Eggs",
        CurrentValue = toggleOpenEggs,
        Callback = function(v)
            toggleOpenEggs = v
        end
    })

    Tab:CreateToggle({
        Name = "Open Max Eggs",
        CurrentValue = toggleMaxEggs,
        Callback = function(v)
            toggleMaxEggs = v
        end
    })

    Tab:CreateToggle({
        Name = "Open House",
        CurrentValue = toggleOpenHouse,
        Callback = function(v)
            toggleOpenHouse = v
        end
    })

    Tab:CreateToggle({
        Name = "Claim Candy",
        CurrentValue = toggleClaimCandy,
        Callback = function(v)
            toggleClaimCandy = v
        end
    })

    Tab:CreateSection("Autofarm")

    self._onStart = nil
    self._onStop = nil
    self._onExit = nil

    Tab:CreateToggle({
        Name = "Autofarm",
        CurrentValue = false,
        Callback = function(v)
            if v and not running then
                running = true
                if self._onStart then self._onStart() end
                Rayfield:Notify("Autofarm", "Started.", 4483362458)
            elseif not v and running then
                running = false
                if self._onStop then self._onStop() end
                Rayfield:Notify("Autofarm", "Stopped.", 4483362458)
            end
        end
    })

    Tab:CreateButton({
        Name = "Exit",
        Callback = function()
            if running and self._onStop then self._onStop() end
            if self._onExit then self._onExit() end
            Rayfield:Destroy()
        end
    })

    function self:getEgg()
        return selectedEgg
    end

    function self:getHouse()
        return selectedHouse
    end

    function self:getToggles()
        return {
            openEggs = toggleOpenEggs,
            openMaxEggs = toggleMaxEggs,
            openHouse = toggleOpenHouse,
            claimCandy = toggleClaimCandy
        }
    end

    function self:onStart(cb)
        self._onStart = cb
    end

    function self:onStop(cb)
        self._onStop = cb
    end

    function self:onExit(cb)
        self._onExit = cb
    end

    return self
end

return GUI
