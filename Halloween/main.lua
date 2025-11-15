local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local GUI = require("Halloween/gui")
local Functions = require("Halloween/functions")

local gui = GUI.mount(playerGui)

gui:onStart(function()
    Functions.start(gui)
end)

gui:onStop(function()
    Functions.stop()
end)

gui:onExit(function()
    Functions.stop()
end)

local quests = Functions.readQuests()
print(quests.easy)
print(quests.medium)
print(quests.hard)
print(quests.extreme)
