local allowedPlace = 606849621
if game.PlaceId ~= allowedPlace then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error";
        Text = "Este script no es compatible con este juego.";
        Duration = 5;
    })
    return
end


getgenv().Camlock_Settings = {
    PrimaryPart = "HumanoidRootPart",
    SecondaryPart = "Head",
    Smoothing = 0.15
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera


local JailbreakTeams = {
    ["Police"] = Color3.fromRGB(0, 170, 255),
    ["Criminal"] = Color3.fromRGB(255, 0, 0),
    ["Prisoner"] = Color3.fromRGB(255, 140, 0)
}

local ESPObjects = {}


local function isValidTargetEnemy(plr)
    if not plr.Team then return false end
    if not LocalPlayer.Team then return false end
    if plr == LocalPlayer then return false end

    local myTeam = LocalPlayer.Team.Name
    local targetTeam = plr.Team.Name

    if myTeam == "Prisoner" or myTeam == "Criminal" then
        return targetTeam == "Police"
    end

    if myTeam == "Police" then
        return (targetTeam == "Prisoner" or targetTeam == "Criminal")
    end

    return false
end


local function createESP(plr)
    if not plr.Character then return end
    if not plr.Team then return end
    if not JailbreakTeams[plr.Team.Name] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = JailbreakTeams[plr.Team.Name]
    highlight.OutlineColor = JailbreakTeams[plr.Team.Name]
    highlight.Adornee = plr.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = game.CoreGui

    ESPObjects[plr] = highlight
end

local function removeESP(plr)
    if ESPObjects[plr] then
        ESPObjects[plr]:Destroy()
        ESPObjects[plr] = nil
    end
end

local function updateESP(plr)
    removeESP(plr)
    createESP(plr)
end

local function setupPlayer(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        updateESP(plr)

        local humanoid = plr.Character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            removeESP(plr)
        end)
    end)

    plr:GetPropertyChangedSignal("Team"):Connect(function()
        updateESP(plr)
    end)

    if plr.Character then
        updateESP(plr)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        setupPlayer(plr)
    end
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removeESP)


local camlockEnabled = false
local currentTarget = nil

local function getClosestValidEnemy()
    local closest = nil
    local closestDist = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if isValidTargetEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = plr
                end
            end
        end
    end

    return closest
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        camlockEnabled = not camlockEnabled
        if camlockEnabled then
            currentTarget = getClosestValidEnemy()
        else
            currentTarget = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if camlockEnabled and currentTarget and currentTarget.Character then
        local part = currentTarget.Character:FindFirstChild(getgenv().Camlock_Settings.PrimaryPart)
        if part then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, part.Position),
                getgenv().Camlock_Settings.Smoothing
            )
        end
    end
end)
