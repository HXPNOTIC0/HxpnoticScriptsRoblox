-- PLACE LOCK SYSTEM (HACKER STYLE ERROR SCREEN)
local allowedPlace = 606849621

if game.PlaceId ~= allowedPlace then
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    local Screen = Instance.new("ScreenGui", CoreGui)
    Screen.IgnoreGuiInset = true
    Screen.ResetOnSpawn = false

    local Frame = Instance.new("Frame", Screen)
    Frame.Size = UDim2.new(1,0,1,0)
    Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1,0,0,100)
    Title.Position = UDim2.new(0,0,0.3,0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Arcade
    Title.TextScaled = true
    Title.TextColor3 = Color3.fromRGB(0,255,0)
    Title.Text = "ACCESS DENIED"

    local Msg = Instance.new("TextLabel", Frame)
    Msg.Size = UDim2.new(1,0,0,80)
    Msg.Position = UDim2.new(0,0,0.45,0)
    Msg.BackgroundTransparency = 1
    Msg.Font = Enum.Font.Code
    Msg.TextScaled = true
    Msg.TextColor3 = Color3.fromRGB(0,180,0)
    Msg.Text = "This script is not compatible with this experience."

    local Glitch = Instance.new("TextLabel", Frame)
    Glitch.Size = UDim2.new(1,0,0,60)
    Glitch.Position = UDim2.new(0,0,0.58,0)
    Glitch.BackgroundTransparency = 1
    Glitch.Font = Enum.Font.Code
    Glitch.TextScaled = true
    Glitch.TextColor3 = Color3.fromRGB(0,255,0)
    Glitch.Text = ">> SYSTEM PROTECTION ENABLED <<"

    -- glitch animation
    task.spawn(function()
        while true do
            task.wait(math.random(5,12)/100)
            Title.Position = UDim2.new(0, math.random(-3,3), 0.3, math.random(-3,3))
            Msg.Position = UDim2.new(0, math.random(-3,3), 0.45, math.random(-3,3))
            Glitch.Position = UDim2.new(0, math.random(-3,3), 0.58, math.random(-3,3))
            task.wait(0.05)
            Title.Position = UDim2.new(0,0,0.3,0)
            Msg.Position = UDim2.new(0,0,0.45,0)
            Glitch.Position = UDim2.new(0,0,0.58,0)
        end
    end)

    -- fade-in effect
    Frame.BackgroundTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(1.2), {BackgroundTransparency = 0}):Play()

    return
end
---------------------------------------------------------
-- FULLSCREEN LOADING UI (0% → 100%)
---------------------------------------------------------

local CoreGui = game.CoreGui
local TweenService = game:GetService("TweenService")

local loadingGui = Instance.new("ScreenGui", CoreGui)
loadingGui.Name = "HXPNOTIC_LOADING"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false

local background = Instance.new("Frame", loadingGui)
background.Size = UDim2.new(1,0,1,0)
background.Position = UDim2.new(0,0,0,0)
background.BackgroundColor3 = Color3.fromRGB(10,10,10)
background.BorderSizePixel = 0

local title = Instance.new("TextLabel", background)
title.Size = UDim2.new(1,0,0,120)
title.Position = UDim2.new(0,0,0.15,0)
title.Text = "HXPNOTIC"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1

local percent = Instance.new("TextLabel", background)
percent.Size = UDim2.new(1,0,0,80)
percent.Position = UDim2.new(0,0,0.45,0)
percent.Text = "0%"
percent.TextScaled = true
percent.Font = Enum.Font.Code
percent.TextColor3 = Color3.fromRGB(255,255,255)
percent.BackgroundTransparency = 1

local message = Instance.new("TextLabel", background)
message.Size = UDim2.new(1,0,0,60)
message.Position = UDim2.new(0,0,0.60,0)
message.Text = "Initializing modules..."
message.TextScaled = true
message.Font = Enum.Font.Code
message.TextColor3 = Color3.fromRGB(180,180,180)
message.BackgroundTransparency = 1

local loadingBarBG = Instance.new("Frame", background)
loadingBarBG.Size = UDim2.new(0.6,0,0,24)
loadingBarBG.Position = UDim2.new(0.2,0,0.80,0)
loadingBarBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
loadingBarBG.BorderSizePixel = 0
Instance.new("UICorner", loadingBarBG).CornerRadius = UDim.new(0,14)

local loadingBar = Instance.new("Frame", loadingBarBG)
loadingBar.Size = UDim2.new(0,0,1,0)
loadingBar.BackgroundColor3 = Color3.fromRGB(0,255,255)
loadingBar.BorderSizePixel = 0
Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(0,14)

-- pulsing logo effect
task.spawn(function()
	while loadingGui.Parent do
		TweenService:Create(title, TweenInfo.new(0.6), {TextColor3 = Color3.fromRGB(0,180,255)}):Play()
		task.wait(0.6)
		TweenService:Create(title, TweenInfo.new(0.6), {TextColor3 = Color3.fromRGB(0,255,255)}):Play()
		task.wait(0.6)
	end
end)

local messages = {
	"Bypass Anticheat...",
	"Loading ESP & Camlock...",
	"Loading GUI...",
	"Finalizing..."
}

task.spawn(function()
	for i = 0, 100 do
		percent.Text = i .. "%"
		TweenService:Create(loadingBar, TweenInfo.new(0.03), {Size = UDim2.new(i/100,0,1,0)}):Play()

		if i == 25 then message.Text = messages[1] end
		if i == 50 then message.Text = messages[2] end
		if i == 75 then message.Text = messages[3] end
		if i == 95 then message.Text = messages[4] end

		task.wait(0.03)
	end

	TweenService:Create(background, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
	TweenService:Create(title, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
	TweenService:Create(percent, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
	TweenService:Create(loadingBar, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadingBarBG, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
	TweenService:Create(message, TweenInfo.new(0.6), {TextTransparency = 1}):Play()

	task.wait(0.6)
	loadingGui:Destroy()

	---------------------------------------------------------
	-- MAIN SCRIPT EXECUTES NOW
	---------------------------------------------------------

	---------------------------------------------------------
	-- SETTINGS
	---------------------------------------------------------
	getgenv().Camlock_Settings = {
		PrimaryPart = "HumanoidRootPart",
		SecondaryPart = "Head",
		HeadWeight = 0.75
	}

	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera

	local ESPs = {}
	local camlockEnabled = false
	local currentTarget = nil
	local direction = 1

	---------------------------------------------------------
	-- CAMLOCK
	---------------------------------------------------------

	function getClosestPlayerToCenter()
		local closestPlayer, shortestDistance = nil, math.huge
		local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer 
				and player.Character 
				and player.Character:FindFirstChild("HumanoidRootPart") then

				local rootPos = player.Character.HumanoidRootPart.Position
				local screenPoint, onScreen = Camera:WorldToViewportPoint(rootPos)

				if onScreen then
					local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
					if distance < shortestDistance then
						shortestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
		return closestPlayer
	end

	local function updateHeadWeight()
		if direction == 1 then
			getgenv().Camlock_Settings.HeadWeight += 0.002
			if getgenv().Camlock_Settings.HeadWeight >= 0.8 then direction = -1 end
		else
			getgenv().Camlock_Settings.HeadWeight -= 0.002
			if getgenv().Camlock_Settings.HeadWeight <= 0.7 then direction = 1 end
		end
	end

	local function camlock()
		if camlockEnabled and currentTarget then
			local char = currentTarget.Character

			if char then
				local hrp = char:FindFirstChild(getgenv().Camlock_Settings.PrimaryPart)
				local head = char:FindFirstChild(getgenv().Camlock_Settings.SecondaryPart)

				if hrp and head then
					updateHeadWeight()
					local w = getgenv().Camlock_Settings.HeadWeight
					local blend = (head.Position * w) + (hrp.Position * (1 - w))
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, blend)
				end
			else
				currentTarget = nil
			end
		end
	end

	---------------------------------------------------------
	-- ESP SYSTEM
	---------------------------------------------------------

	local function removeESP(plr)
		if ESPs[plr] then
			if ESPs[plr].highlight then ESPs[plr].highlight:Destroy() end
			if ESPs[plr].billboard then ESPs[plr].billboard:Destroy() end
			ESPs[plr] = nil
		end
	end

	local function createESP(plr)
		if not plr.Character then return end
		local head = plr.Character:FindFirstChild("Head")
		if not head then return end

		removeESP(plr)

		local highlight = Instance.new("Highlight")
		highlight.Name = "XoticESP"
		highlight.Adornee = plr.Character
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0.5
		highlight.FillColor = Color3.fromRGB(0,255,0)
		highlight.OutlineColor = Color3.fromRGB(0,255,0)
		highlight.Parent = plr.Character

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "XoticBillboard"
		billboard.AlwaysOnTop = true
		billboard.Size = UDim2.new(0,180,0,45)
		billboard.StudsOffset = Vector3.new(0,3.2,0)
		billboard.Parent = head

		local text = Instance.new("TextLabel", billboard)
		text.BackgroundTransparency = 1
		text.Size = UDim2.new(1,0,1,0)
		text.Font = Enum.Font.Code
		text.TextScaled = true
		text.TextColor3 = Color3.fromRGB(255,255,255)
		text.TextStrokeTransparency = 0.5
		text.Name = "Info"

		ESPs[plr] = {highlight = highlight, billboard = billboard}
	end

	RunService.RenderStepped:Connect(function()
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer 
				and plr.Character 
				and plr.Character:FindFirstChild("HumanoidRootPart") then

				if not ESPs[plr] then
					createESP(plr)
				end

				local esp = ESPs[plr]
				local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
				local root = plr.Character:FindFirstChild("HumanoidRootPart")

				if esp and humanoid and root then
					local dist = math.floor(
						(LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
					)

					local color = Color3.fromRGB(0,255,0)

					if currentTarget == plr and camlockEnabled then
						color = Color3.fromRGB(0,170,255)
					else
						if dist < 600 then
							color = Color3.fromRGB(255,0,0)
						else
							color = Color3.fromRGB(0,255,0)
						end
					end

					esp.highlight.FillColor = color
					esp.highlight.OutlineColor = color
					esp.billboard.Info.Text =
						string.format("[%s]\n%d HP\n%d", plr.Name, math.floor(humanoid.Health), dist)
				end
			end
		end
	end)

	Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function()
			repeat task.wait() until plr.Character and plr.Character:FindFirstChild("Head")
			createESP(plr)
		end)
	end)

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			if plr.Character then
				createESP(plr)
			end
			plr.CharacterAdded:Connect(function()
				repeat task.wait() until plr.Character and plr.Character:FindFirstChild("Head")
				createESP(plr)
			end)
		end
	end

	Players.PlayerRemoving:Connect(removeESP)

	---------------------------------------------------------
	-- CAMLOCK BUTTON
	---------------------------------------------------------

	local screenGui = Instance.new("ScreenGui", CoreGui)
	local toggleButton = Instance.new("TextButton", screenGui)

	toggleButton.Size = UDim2.new(0,130,0,45)
	toggleButton.Position = UDim2.new(0,130,0,-24)
	toggleButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
	toggleButton.Text = "HXPNOTIC"
	toggleButton.TextScaled = true
	toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
	toggleButton.Font = Enum.Font.Code

	Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0,12)

	toggleButton.MouseButton1Click:Connect(function()
		if not camlockEnabled then
			local target = getClosestPlayerToCenter()
			if target then
				camlockEnabled = true
				currentTarget = target
				toggleButton.Text = "  ON  "
			end
		else
			camlockEnabled = false
			currentTarget = nil
			toggleButton.Text = "  OFF  "
		end
	end)

	RunService.RenderStepped:Connect(camlock)

end)
