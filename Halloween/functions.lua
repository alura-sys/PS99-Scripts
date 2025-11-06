local Config = require("Halloween/config")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Network = ReplicatedStorage:WaitForChild("Network")

local clientPlot = require(
    ReplicatedStorage:WaitForChild("Library")
        :WaitForChild("Client")
        :WaitForChild("PlotCmds")
        :WaitForChild("ClientPlot")
)

local myPlot
local function Plot()
    if not myPlot then myPlot = clientPlot.GetByPlayer(Player) end
    return myPlot
end

local function tryGetPlotId(p)
    if not p then return nil end
    if p.PlotId ~= nil then return p.PlotId end
    if p.Id ~= nil then return p.Id end
    if p.ID ~= nil then return p.ID end
    local sv = rawget(p, "SaveVariables")
    if type(sv) == "table" then
        if sv.PlotId ~= nil then return sv.PlotId end
        if sv.Id ~= nil then return sv.Id end
        if sv.ID ~= nil then return sv.ID end
    end
    return nil
end

local function GetPlotId()
    local pid = tryGetPlotId(Plot())
    if not pid then
        warn("[Plot] PlotId not found; default to 0")
        pid = 0
    end
    return pid
end

local M = {}
local running = false
local thread = nil

function M.start(uiObj)
    if running then return end
    running = true
    local plotId = GetPlotId()
    thread = task.spawn(function()
        while running do
            local egg = uiObj.getEgg()
            local house = tonumber(uiObj.getHouse())
            local t = uiObj:getToggles()
            if t.openEggs then
                if t.openMaxEggs then
                    for slot = 1, 10 do
                        pcall(function() Network.HalloweenWorld_PlaceEgg:InvokeServer(slot, egg) end)
                    end
                    for slot = 1, 10 do
                        pcall(function() Network.HalloweenWorld_PickUp:InvokeServer(slot) end)
                    end
                else
                    for _, slot in ipairs(Config.SLOTS) do
                        pcall(function() Network.HalloweenWorld_PlaceEgg:InvokeServer(slot, egg) end)
                        pcall(function() Network.HalloweenWorld_PickUp:InvokeServer(slot) end)
                    end
                end
            end
            if t.openHouse then
                pcall(function()
                    Network.Plots_Invoke:InvokeServer(plotId, "PurchaseEgg", house, 3)
                end)
            end
            if t.claimCandy then
                for claimId = 1, 10 do
                    pcall(function() Network.HalloweenWorld_Claim:InvokeServer(claimId) end)
                end
            end
            task.wait(Config.LOOP_DELAY)
        end
    end)
end

function M.stop()
    running = false
end

return M

