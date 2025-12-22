-- BOTONES ARMAS ALEX
-- =================================

if game.CoreGui:FindFirstChild("DragUI") then
    game.CoreGui.DragUI:Destroy()
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "DragUI"

-- Crear botón fijo
local function CrearBoton(nombre, texto, pos)
    local btn = Instance.new("TextButton")
    btn.Name = nombre
    btn.Parent = sg

    btn.Size = UDim2.new(0,80,0,35)
    btn.Position = pos

    btn.Text = string.upper(texto)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBlack
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BackgroundTransparency = 0.70
    btn.TextTransparency = 0.10
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0

    btn.Active = true
    btn.Draggable = false

    return btn
end

-- ============================
-- 📌 COORDENADAS
-- ============================

local P1 = UDim2.new(0.1, 8,   0.30, -74) -- Rifle
local P2 = UDim2.new(0.3, -187,0.30, -35) -- Pistol
local P5 = UDim2.new(0.3, -100,0.30, -35) -- Plasma
local P4 = UDim2.new(0.1, 8,   0.53, -74) -- Bubble

-- ============================
-- 🔘 BOTONES
-- ============================

local B1 = CrearBoton("BTN1", "RIFLE",  P1)
local B2 = CrearBoton("BTN2", "PISTOL", P2)
local B5 = CrearBoton("BTN5", "PLASMA", P5)
local B4 = CrearBoton("BTN4", "BUBBLE", P4)

-- ============================
-- ⚡ ULTRA FAST SYSTEM
-- ============================

local Player = game:GetService("Players").LocalPlayer
local Folder = Player:WaitForChild("Folder")

local currentWeapon = nil

local function EquiparUltra(arma)
    -- Desequipar solo el arma actual
    if currentWeapon and currentWeapon.Parent == Folder then
        local r = currentWeapon:FindFirstChild("InventoryEquipRemote")
        if r then
            r:FireServer(false)
        end
    end

    -- Equipar la nueva
    local obj = Folder:FindFirstChild(arma)
    if obj then
        obj.InventoryEquipRemote:FireServer(true)
        currentWeapon = obj
    end
end

-- ============================
-- 🔥 EVENTOS
-- ============================

B1.MouseButton1Click:Connect(function()
    EquiparUltra("Rifle")
end)

B2.MouseButton1Click:Connect(function()
    EquiparUltra("Pistol")
end)

B5.MouseButton1Click:Connect(function()
    EquiparUltra("PlasmaPistol")
end)

B4.MouseButton1Click:Connect(function()
    EquiparUltra("ForcefieldLauncher")
end)
