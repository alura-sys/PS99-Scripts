local Config = require("Halloween/config")

local GUI = {}
GUI.__index = GUI

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

function GUI.mount(playerGui)
    local self = setmetatable({}, GUI)

    local Window = Rayfield:CreateWindow({
        Name = "Alura Halloween",
        LoadingTitle = "Halloween Autofarm",
        LoadingSubtitle = "by Alura",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AluraHalloween",
            FileName = "HalloweenFarm"
        },
        KeySystem = false,
        KeySettings = {
            Title = "Alura Halloween",
            Subtitle = "Key System",
            Note = "No key required",
            SaveKey = false,
            Key = "NONE"
        }
    })

    local Tab = Window:CreateTab("Main", 4483362458)
    Tab:CreateSection("Settings")

    local selectedEgg = Config.defaults.selectedEgg
    local selectedHouse = Config.defaults.selectedHouse
    local openEggs = Config.defaults.doOpenEggs
    local openMaxEggs = Config.defaults.doOpenMaxEggs
    local openHouse = Config.defaults.doOpenHouse
    local claimCandy = Config.defaults.doClaimCandy
    local running = false

    local EggDropdown = Tab:CreateDropdown({
        Name = "Egg",
        Options = Config.EGG_OPTIONS,
        CurrentOption = selectedEgg,
        Flag = "Halloween_Egg",
        Callback = function(opt)
            selectedEgg = opt
        end,
    })

    local HouseDropdown = Tab:CreateDropdown({
        Name = "House",
        Options = Config.HOUSE_OPTIONS,
        CurrentOption = selectedHouse,
        Flag = "Halloween_House",
        Callback = function(opt)
            selectedHouse = opt
        end,
    })

    Tab:CreateSection("Actions")

    local ToggleOpenEggs = Tab:CreateToggle({
        Name = "Open Eggs",
        CurrentValue = openEggs,
        Flag = "Halloween_OpenEggs",
        Callback = function(v)
            openEggs = v
        end,
    })

    local ToggleMaxEggs = Tab:CreateToggle({
        Name = "Open Max Eggs",
        CurrentValue = openMaxEggs,
        Flag = "Halloween_OpenMaxEggs",
        Callback = function(v)
            openMaxEggs = v
        end,
    })

    local ToggleOpenHouse = Tab:CreateToggle({
        Name = "Open House",
        CurrentValue = openHouse,
        Flag = "Halloween_OpenHouse",
        Callback = function(v)
            openHouse = v
        end,
    })

    local ToggleClaimCandy = Tab:CreateToggle({
        Name = "Claim Candy",
        CurrentValue = claimCandy,
        Flag = "Halloween_ClaimCandy",
        Callback = function(v)
            claimCandy = v
        end,
    })

    self._onStart = nil
    self._onStop  = nil
    self._onExit  = nil

    local AutofarmToggle = Tab:CreateToggle({
        Name = "Autofarm",
        CurrentValue = false,
        Flag = "Halloween_Autofarm",
        Callback = function(v)
            if v and not running then
                running = true
                if self._onStart then
                    self._onStart()
                end
                Rayfield:Notify("Halloween", "Autofarm started", 4483362458)
            elseif (not v) and running then
                running = false
                if self._onStop then
                    self._onStop()
                end
                Rayfield:Notify("Halloween", "Autofarm stopped", 4483362458)
            end
        end,
    })

    Tab:CreateButton({
        Name = "Exit",
        Callback = function()
            if running and self._onStop then
                self._onStop()
            end
            if self._onExit then
                self._onExit()
            end
            Rayfield:Destroy()
        end,
    })

    function self:getEgg()
        return selectedEgg
    end

    function self:getHouse()
        return selectedHouse
    end

    function self:getToggles()
        return {
            openEggs  = openEggs,
            openMaxEggs = openMaxEggs,
            openHouse = openHouse,
            claimCandy = claimCandy,
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

    Rayfield:LoadConfiguration()

    return self
end

return GUI
