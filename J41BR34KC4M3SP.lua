-- CAMLOCK HARD REBUILD V.03 (ALEX)
if game.PlaceId ~= 606849621 then return end

--------------------------------------------------
-- SETTINGS
--------------------------------------------------
getgenv().Camlock_Settings = {
    PrimaryPart = "HumanoidRootPart",
    SecondaryPart = "Head",
    HeadWeight = 0.75
}

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--------------------------------------------------
-- SAFE GUI (ANTI CLEAN)
--------------------------------------------------
local function getSafeGui()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then
        repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")
        pg = LocalPlayer.PlayerGui
    end
    return pg
end

--------------------------------------------------
-- CAMLOCK VARIABLES
--------------------------------------------------
local camlockEnabled = false
local currentTarget = nil
local direction = 1
local TARGET_COLOR = Color3.fromRGB(0,255,0)

--------------------------------------------------
-- ESP CORE (IMMORTAL)
--------------------------------------------------
local ESPs = {}

local JailbreakTeams = {
    Police = Color3.fromRGB(0,170,255),
    Criminal = Color3.fromRGB(255,0,0),
    Prisoner = Color3.fromRGB(255,140,0)
}

local function getTeamColor(plr)
    if camlockEnabled and currentTarget == plr then
        return TARGET_COLOR
    end
    if plr.Team and JailbreakTeams[plr.Team.Name] then
        return JailbreakTeams[plr.Team.Name]
    end
    return Color3.fromRGB(255,255,255)
end

local function buildESP(plr)
    if plr == LocalPlayer then return end

    local esp = Instance.new("Highlight")
    esp.Name = "PERMA_ESP"
    esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    esp.FillTransparency = 0.25
    esp.OutlineTransparency = 0.25
    esp.Parent = getSafeGui()

    ESPs[plr] = esp
    return esp
end

local function forceESP(plr)
    if plr == LocalPlayer then return end

    local esp = ESPs[plr]

    if not esp
    or not esp.Parent
    or not esp:IsDescendantOf(game)
    or esp.Adornee == nil then
        ESPs[plr] = nil
        esp = buildESP(plr)
    end

    if plr.Character then
        esp.Adornee = plr.Character
    end

    local color = getTeamColor(plr)
    esp.FillColor = color
    esp.OutlineColor = color
end

--------------------------------------------------
-- WATCHDOG SUAVE (ESP INMEDIATO)
--------------------------------------------------
task.spawn(function()
    while true do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                forceESP(plr)
            end
        end
        task.wait(0.5)
    end
end)

--------------------------------------------------
-- PLAYER / CHARACTER HOOKS
--------------------------------------------------
local function hookCharacter(plr)
    plr.CharacterAdded:Connect(function()
        task.wait()
        forceESP(plr)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    hookCharacter(plr)
    forceESP(plr)
end

Players.PlayerAdded:Connect(function(plr)
    task.wait()
    hookCharacter(plr)
    forceESP(plr)
end)

--------------------------------------------------
-- CAMLOCK LOGIC
--------------------------------------------------
local function isValidEnemy(plr)
    if not plr.Team or not LocalPlayer.Team then return false end
    if LocalPlayer.Team.Name == "Police" then
        return plr.Team.Name == "Criminal" or plr.Team.Name == "Prisoner"
    else
        return plr.Team.Name == "Police"
    end
end

local function getClosestPlayerToCenter()
    local closest, shortest = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and isValidEnemy(plr)
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart") then

            local pos = plr.Character.HumanoidRootPart.Position
            local point, visible = Camera:WorldToViewportPoint(pos)

            if visible then
                local dist = (Vector2.new(point.X, point.Y) - center).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end

    return closest
end

local function updateHeadWeight()
    if direction == 1 then
        getgenv().Camlock_Settings.HeadWeight += 0.002
        if getgenv().Camlock_Settings.HeadWeight >= 0.8 then
            direction = -1
        end
    else
        getgenv().Camlock_Settings.HeadWeight -= 0.002
        if getgenv().Camlock_Settings.HeadWeight <= 0.7 then
            direction = 1
        end
    end
end

RunService.RenderStepped:Connect(function()
    if camlockEnabled and currentTarget and currentTarget.Character then
        local hrp = currentTarget.Character:FindFirstChild("HumanoidRootPart")
        local head = currentTarget.Character:FindFirstChild("Head")

        if hrp and head then
            updateHeadWeight()
            local w = getgenv().Camlock_Settings.HeadWeight
            local blend = head.Position * w + hrp.Position * (1 - w)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, blend)
        end
    end
end)

--------------------------------------------------
-- GUI CAMLOCK (DERECHA + MÁS ABAJO)
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CamlockGUI"
gui.ResetOnSpawn = false
gui.Parent = getSafeGui()

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,170,0,60)
btn.AnchorPoint = Vector2.new(1,0)
btn.Position = UDim2.new(1,-90,0,5) -- DERECHA + ABAJO
btn.Text = "HXPNOTIC"
btn.TextScaled = true
btn.Font = Enum.Font.Code
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.BackgroundTransparency = 0.75
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextTransparency = 0.5
btn.BorderSizePixel = 0
btn.Parent = gui

Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

btn.MouseButton1Click:Connect(function()
    if not camlockEnabled then
        local target = getClosestPlayerToCenter()
        if target then
            camlockEnabled = true
            currentTarget = target
            btn.Text = "  ON  "
            forceESP(currentTarget)
        end
    else
        camlockEnabled = false
        if currentTarget then
            forceESP(currentTarget)
        end
        currentTarget = nil
        btn.Text = "  OFF  "
    end
end)

--------------------------------------------------
-- 🔒 SEGURO GLOBAL: REBUILD ESP CADA 1 MINUTO
--------------------------------------------------
task.spawn(function()
    while true do
        task.wait(60)

        for plr, esp in pairs(ESPs) do
            if esp and esp:IsDescendantOf(game) then
                pcall(function()
                    esp:Destroy()
                end)
            end
            ESPs[plr] = nil
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                forceESP(plr)
            end
        end

        if camlockEnabled and currentTarget then
            forceESP(currentTarget)
        end
    end
end)
