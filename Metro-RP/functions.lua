local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = require("Metro-RP/config")
local flyState = Config.fly

local localPlayer = Players.LocalPlayer

local M = {}

function M.getPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            table.insert(list, plr.Name)
        end
    end
    table.sort(list)
    return list
end

function M.teleportToPlayer(targetName)
    local target = Players:FindFirstChild(targetName)
    if not target then return false, "Player not found" end

    local myChar = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local targetChar = target.Character
    if not targetChar then return false, "Target has no character" end

    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local thrp = targetChar:FindFirstChild("HumanoidRootPart")

    if not hrp or not thrp then
        return false, "Missing HumanoidRootPart"
    end

    hrp.CFrame = thrp.CFrame + Vector3.new(0, 3, 0)
    return true
end

local function stopFlyLoop()
    if flyState.Connection then
        flyState.Connection:Disconnect()
        flyState.Connection = nil
    end

    local char = localPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
    end
end

local function startFlyLoop()
    if flyState.Connection then return end

    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = true end

    flyState.Connection = RunService.RenderStepped:Connect(function(dt)
        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not hrp or not cam then return end

        local move = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        if move.Magnitude > 0 then
            move = move.Unit
            hrp.CFrame = hrp.CFrame + move * flyState.Speed * dt
        end

        hrp.Velocity = Vector3.new(0,0,0)
        hrp.RotVelocity = Vector3.new(0,0,0)
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end)
end

function M.enableFly()
    flyState.Enabled = true
    startFlyLoop()
end

function M.disableFly()
    flyState.Enabled = false
    stopFlyLoop()
end

return M
