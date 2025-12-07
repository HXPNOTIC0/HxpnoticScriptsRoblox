---------------------------------------------------------
-- BOTÓN GLOBAL (DOBLE TOQUE)
---------------------------------------------------------

pcall(function()
    if game.CoreGui:FindFirstChild("GlobalBOT") then
        game.CoreGui.GlobalBOT:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlobalBOT"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 140, 0, 50)
Button.Position = UDim2.new(0.5, -70, 0.7, 0)
Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "OFF"
Button.TextScaled = true
Button.Font = Enum.Font.GothamBold
Button.Draggable = true

_G.GLOBAL_ON = false
local last = tick()

local function Toggle()
    _G.GLOBAL_ON = not _G.GLOBAL_ON
    if _G.GLOBAL_ON then
        Button.Text = "ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        Button.Text = "OFF"
        Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end

Button.MouseButton1Click:Connect(function()
    if tick() - last < 0.35 then
        Toggle()
    end
    last = tick()
end)


---------------------------------------------------------
-- VARIABLES / SERVICIOS
---------------------------------------------------------

local rs = game:GetService("ReplicatedStorage")
local packets = require(rs.Modules.Packets)
local HttpService = game:GetService("HttpService")

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")


---------------------------------------------------------
-- AUTO FOOD (30s)
---------------------------------------------------------

local function FireEat()
    local args = { buffer.fromstring("+\001\000") }
    game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(unpack(args))
end

task.spawn(function()
    while task.wait(1) do
        if not _G.GLOBAL_ON then continue end

        local t = 30
        repeat
            if not _G.GLOBAL_ON then break end
            task.wait(1)
            t -= 1
        until t <= 0

        if _G.GLOBAL_ON then
            FireEat()
            task.wait(0.05)
            FireEat()
        end
    end
end)


---------------------------------------------------------
-- AUTO PICKUP RAW GOLD
---------------------------------------------------------

task.spawn(function()
    while task.wait(0.05) do
        if not _G.GLOBAL_ON then continue end

        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item.Name == "Raw Gold" then
                local eid = item:GetAttribute("EntityID")
                if eid and (item.Position - hrp.Position).Magnitude <= 35 then
                    packets.Pickup.send(eid)
                end
            end
        end

        for _, chest in ipairs(workspace.Deployables:GetChildren()) do
            if chest:FindFirstChild("Contents") then
                for _, item in ipairs(chest.Contents:GetChildren()) do
                    if item.Name == "Raw Gold" then
                        local eid = item:GetAttribute("EntityID")
                        if eid and (chest.PrimaryPart.Position - hrp.Position).Magnitude <= 35 then
                            packets.Pickup.send(eid)
                        end
                    end
                end
            end
        end
    end
end)



---------------------------------------------------------
-- RESOURCE AURA (TU LÓGICA ORIGINAL)
-- range = 20 | targets = 4 | cooldown = 0.1
---------------------------------------------------------

task.spawn(function()
    while true do
        if not _G.GLOBAL_ON then
            task.wait(0.1)
            continue
        end

        local range = 20
        local targetCount = 4
        local cooldown = 0.1
        local targets = {}
        local allresources = {}

        if workspace:FindFirstChild("Resources") then
            for _, r in pairs(workspace.Resources:GetChildren()) do
                table.insert(allresources, r)
            end
        end

        for _, r in pairs(workspace:GetChildren()) do
            if r:IsA("Model") and r.Name == "Gold Node" then
                table.insert(allresources, r)
            end
        end

        for _, res in pairs(allresources) do
            if res:IsA("Model") and res:GetAttribute("EntityID") then
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart then
                    local dist = (ppart.Position - hrp.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, {eid=eid, dist=dist})
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a,b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            packets.SwingTool.send(selectedTargets)
        end

        task.wait(cooldown)
    end
end)



---------------------------------------------------------
-- TWEEN FAR1.json – Velocidad 21 + Anti Descarrilamiento
-- Mountain Climber integrado
---------------------------------------------------------

if not isfolder("FAR") then makefolder("FAR") end

local RouteFile = "FAR/FAR1.json"
if not isfile(RouteFile) then
    writefile(RouteFile, HttpService:JSONEncode({positions={}, waits={}}))
end

local FIXED_SPEED = 21

local PAUSE_POINTS = {
    [11] = true,
    [115] = true,
    [434] = true,
    [577] = true
}

local function LoadRoute()
    return HttpService:JSONDecode(readfile(RouteFile)).positions or {}
end

local function SmoothMoveToStable(targetPos)
    local startPos = hrp.Position
    local dist = (targetPos - startPos).Magnitude
    local duration = dist / FIXED_SPEED

    local step = 0.035
    local steps = math.max(1, math.floor(duration / step))

    local lastPos = hrp.Position
    local stuckTimer = 0

    for i = 1, steps do
        if not _G.GLOBAL_ON then return false end

        -- Mountain Climber
        hrp.Velocity = Vector3.new(0, 40, 0)

        local alpha = i / steps
        hrp.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))
        task.wait(step)

        local moved = (hrp.Position - lastPos).Magnitude
        if moved < 0.03 then
            stuckTimer += step
            if stuckTimer >= 0.5 then
                return "STUCK"
            end
        else
            stuckTimer = 0
        end

        lastPos = hrp.Position

        -- Desviación del camino
        if (hrp.Position - targetPos).Magnitude > 4 then
            return "DEVIATED"
        end
    end

    return "OK"
end


task.spawn(function()
    while true do
        if not _G.GLOBAL_ON then task.wait(0.1) continue end

        local route = LoadRoute()
        local lastGood = 1

        for idx = 1, #route do
            if not _G.GLOBAL_ON then break end

            local p = route[idx]
            local target = Vector3.new(p.X, p.Y, p.Z)

            local tries = 0
            local maxTries = 3

            ::retry::
            local result = SmoothMoveToStable(target)

            if result == "OK" then
                if PAUSE_POINTS[idx] then task.wait(1) end
                lastGood = idx
                continue
            end

            -- Retrocede al último bueno
            if lastGood > 1 then
                local back = route[lastGood]
                hrp.CFrame = CFrame.new(back.X, back.Y, back.Z)
                task.wait(0.15)
            end

            tries += 1
            if tries < maxTries then goto retry end
        end
    end
end)



---------------------------------------------------------
-- ANTI AFK INTEGRADO
---------------------------------------------------------

task.spawn(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/krissisis898-dev/Roblox-/refs/heads/main/Roblox%20Anti%20AFK-Script%20(updatet)"
    ))()
end)

print("SCRIPT COMPLETO FINAL ✔ (TODO FUNCIONANDO PERFECTO)")
