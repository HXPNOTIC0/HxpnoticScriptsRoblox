-- =============================================================================
-- SECCIÓN 1: INICIALIZACIÓN Y CONFIGURACIÓN DE LA INTERFAZ
-- =============================================================================
print("Loading Hxpnotic Hub -- Booga Booga Reborn")
print("-----------------------------------------")
-- Carga de librerías externas para la interfaz Fluent
local Library = loadstring(game:HttpGetAsync("https://github.com/1dontgiveaf/Fluent-Renewed/releases/download/v1.0/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/InterfaceManager.luau"))()

-- Creación de la ventana principal de la interfaz
local Window = Library:CreateWindow{
    Title = "HXPNOTIC HUB",
    SubTitle = "BOOGA BOOGA REBORN",
    TabWidth = 160,
    Size = UDim2.fromOffset(1300, 800),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}

-- =============================================================================
-- SECCIÓN 2: DEFINICIÓN DE PESTAÑAS Y SERVICIOS DEL JUEGO
-- =============================================================================
-- Creación de todas las pestañas disponibles en el menu
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "menu" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "axe" }),
    Map = Window:AddTab({ Title = "Map", Icon = "trees" }),
    Pickup = Window:AddTab({ Title = "Pickup", Icon = "backpack" }),
    Farming = Window:AddTab({ Title = "Farming", Icon = "sprout" }),
    Extra = Window:AddTab({ Title = "Extra", Icon = "plus" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Obtención de servicios esenciales del juego
local rs = game:GetService("ReplicatedStorage")
local packets = require(rs.Modules.Packets) -- Módulo para enviar paquetes al servidor
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local runs = game:GetService("RunService")
local httpservice = game:GetService("HttpService")
local Players = game:GetService("Players")
local localiservice = game:GetService("LocalizationService")
local marketservice = game:GetService("MarketplaceService")
local rbxservice = game:GetService("RbxAnalyticsService")
local placestructure
local tspmo = game:GetService("TweenService")

-- Lista de items disponibles en el juego
local itemslist = {
    "Adurite", "Berry", "Bloodfruit", "Bluefruit", "Coin", "Essence", "Hide", 
    "Ice Cube", "Iron", "Jelly", "Leaves", "Log", "Steel", "Stone", "Wood", 
    "Gold", "Raw Gold", "Crystal Chunk", "Raw Emerald", "Pink Diamond", 
    "Raw Adurite", "Raw Iron", "Coal"
}
local Options = Library.Options

-- =============================================================================
-- SECCIÓN 3: ELEMENTOS DE LA PESTAÑA MAIN (PRINCIPAL)
-- =============================================================================
-- Configuración de movimiento del personaje
local wstoggle = Tabs.Main:CreateToggle("wstoggle", { Title = "Walkspeed", Default = 22 })
local wsslider = Tabs.Main:CreateSlider("wsslider", { Title = "Value", Min = 1, Max = 35, Rounding = 1, Default = 16 })
local jptoggle = Tabs.Main:CreateToggle("jptoggle", { Title = "JumpPower", Default = false })
local jpslider = Tabs.Main:CreateSlider("jpslider", { Title = "Value", Min = 1, Max = 65, Rounding = 1, Default = 50 })
local hheighttoggle = Tabs.Main:CreateToggle("hheighttoggle", { Title = "HipHeight", Default = false })
local hheightslider = Tabs.Main:CreateSlider("hheightslider", { Title = "Value", Min = 0.1, Max = 6.5, Rounding = 1, Default = 2 })
local msatoggle = Tabs.Main:CreateToggle("msatoggle", { Title = "No Mountain Slip", Default = false })
-- Botones de utilidad para copiar información del juego
Tabs.Main:CreateButton({Title = "Copy Job ID", Callback = function() setclipboard(game.JobId) end})
Tabs.Main:CreateButton({Title = "Copy HWID", Callback = function() setclipboard(rbxservice:GetClientId()) end})
Tabs.Main:CreateButton({Title = "Copy SID", Callback = function() setclipboard(rbxservice:GetSessionId()) end})

-- =============================================================================
-- SECCIÓN 4: ELEMENTOS DE LA PESTAÑA COMBAT (COMBATE)
-- =============================================================================
-- Sistema de Kill Aura para atacar automáticamente a jugadores cercanos
local killauratoggle = Tabs.Combat:CreateToggle("killauratoggle", { Title = "Kill Aura", Default = false })
local killaurarangeslider = Tabs.Combat:CreateSlider("killaurarange", { Title = "Range", Min = 1, Max = 9, Rounding = 1, Default = 9 })
local katargetcountdropdown = Tabs.Combat:CreateDropdown("katargetcountdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local kaswingcooldownslider = Tabs.Combat:CreateSlider("kaswingcooldownslider", { Title = "Attack Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })
-- SECCIÓN 5: ELEMENTOS DE LA PESTAÑA MAP (MAPA)
-- =============================================================================
-- Sistema de Resource Aura para recolectar recursos automáticamente
local resourceauratoggle = Tabs.Map:CreateToggle("resourceauratoggle", { Title = "Resource Aura", Default = false })
local resourceaurarange = Tabs.Map:CreateSlider("resourceaurarange", { Title = "Range", Min = 1, Max = 20, Rounding = 1, Default = 20 })
local resourcetargetdropdown = Tabs.Map:CreateDropdown("resourcetargetdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local resourcecooldownslider = Tabs.Map:CreateSlider("resourcecooldownslider", { Title = "Swing Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })

-- Sistema de Critter Aura para atacar criaturas automáticamente
local critterauratoggle = Tabs.Map:CreateToggle("critterauratoggle", { Title = "Critter Aura", Default = false })
local critterrangeslider = Tabs.Map:CreateSlider("critterrangeslider", { Title = "Range", Min = 1, Max = 20, Rounding = 1, Default = 20 })
local crittertargetdropdown = Tabs.Map:CreateDropdown("crittertargetdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local crittercooldownslider = Tabs.Map:CreateSlider("crittercooldownslider", { Title = "Swing Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })

-- =============================================================================
-- SECCIÓN 6: ELEMENTOS DE LA PESTAÑA PICKUP (RECOLECCIÓN)
-- =============================================================================
-- Sistema de recolección automática de items
local autopickuptoggle = Tabs.Pickup:CreateToggle("autopickuptoggle", { Title = "Auto Pickup", Default = false })
local chestpickuptoggle = Tabs.Pickup:CreateToggle("chestpickuptoggle", { Title = "Auto Pickup From Chests", Default = false })
local pickuprangeslider = Tabs.Pickup:CreateSlider("pickuprange", { Title = "Pickup Range", Min = 1, Max = 35, Rounding = 1, Default = 35 })
local itemdropdown = Tabs.Pickup:CreateDropdown("itemdropdown", {
    Title = "Items", 
    Values = {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Raw Meat", "Spirit Key", "Cooked Meat", "Crystal Chunk", "Coin", "Coins", "Coin2", "Coin Stack", "Essence", "Emerald", "Raw Emerald", "Pink Diamond", "Raw Pink Diamond", "Void Shard","Jelly", "Magnetite", "Raw Magnetite", "Adurite", "Raw Adurite", "Ice Cube", "Stone", "Iron", "Raw Iron", "Steel", "Hide", "Leaves", "Log", "Wood", "Pie"}, 
    Multi = true, 
    Default = {}
})

-- Sistema de drop automático de items
local droptoggle = Tabs.Pickup:AddToggle("droptoggle", { Title = "Auto Drop", Default = false })
local dropdropdown = Tabs.Pickup:AddDropdown("dropdropdown", {
    Title = "Select Item to Drop", 
    Values = { "Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood" }, 
    Default = "Bloodfruit"
})
local droptogglemanual = Tabs.Pickup:AddToggle("droptogglemanual", { Title = "Auto Drop Custom", Default = false })
local droptextbox = Tabs.Pickup:AddInput("droptextbox", { Title = "Custom Item", Default = "Bloodfruit", Numeric = false, Finished = false })
-- =============================================================================
-- SECCIÓN 7: BOTÓN AUTO DROP ALL CON INTERFAZ GRÁFICA
-- =============================================================================
Tabs.Pickup:CreateButton({Title = "AutoDropAll", Callback = function()
    -- Eliminar GUI existente si existe
    if game.CoreGui:FindFirstChild("FireButtonGUI") then
        game.CoreGui.FireButtonGUI:Destroy()
    end

    -- Crear ScreenGui para el botón de drop all
    local gui = Instance.new("ScreenGui")
    gui.Name = "FireButtonGUI"
    gui.Parent = game:GetService("CoreGui")
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Crear botón arrastrable
    local button = Instance.new("TextButton")
    button.Parent = gui
    button.Size = UDim2.new(0, 120, 0, 45)
    button.Position = UDim2.new(0.4, 0, 0.5, 0)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = "OFF"
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Active = true
    button.Draggable = true
    button.BackgroundTransparency = 0.2
    button.BorderSizePixel = 2

    -- Variables de control del botón
    local activo = false
    local ultimoClick = 0
    local delayDobleClick = 0.3
    local loopActivo = false

    -- Función principal que ejecuta el drop all
    local function ejecutar()
        while activo and task.wait() do
            local args = {
                buffer.fromstring("E\001\000")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))
        end
    end

    -- Sistema de doble toque para activar/desactivar
    button.MouseButton1Click:Connect(function()
        local ahora = tick()
        if ahora - ultimoClick <= delayDobleClick then
            activo = not activo
            if activo then
                button.Text = "ON"
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                if not loopActivo then
                    loopActivo = true
                    task.spawn(function()
                        ejecutar()
                        loopActivo = false
                    end)
                end
            else
                button.Text = "OFF"
                button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            end
        end
        ultimoClick = ahora
    end)
end})

-- =============================================================================
-- SECCIÓN 8: ELEMENTOS DE LA PESTAÑA FARMING (CULTIVO)
-- =============================================================================
-- Sistema de cultivo automático
local fruitdropdown = Tabs.Farming:CreateDropdown("fruitdropdown", {
    Title = "Select Fruit",
    Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry", "Strangefruit", "Strawberry", "Sunjfruit", "Pumpkin", "Prickly Pear", "Apple",  "Barley", "Cloudberry", "Carrot"}, 
    Default = "Bloodfruit"
})
local planttoggle = Tabs.Farming:CreateToggle("planttoggle", { Title = "Auto Plant", Default = false })
local plantrangeslider = Tabs.Farming:CreateSlider("plantrange", { Title = "Plant Range", Min = 1, Max = 30, Rounding = 1, Default = 30 })
local plantdelayslider = Tabs.Farming:CreateSlider("plantdelay", { Title = "Plant Delay (s)", Min = 0.01, Max = 1, Rounding = 2, Default = 0.1 })
local harvesttoggle = Tabs.Farming:CreateToggle("harvesttoggle", { Title = "Auto Harvest", Default = false })
local harvestrangeslider = Tabs.Farming:CreateSlider("harvestrange", { Title = "Harvest Range", Min = 1, Max = 30, Rounding = 1, Default = 30 })

-- Elementos de texto informativo
Tabs.Farming:CreateParagraph("Aligned Paragraph", {
    Title = "Tween Stuff", 
    Content = "wish this ui was more like linoria :(", 
    TitleAlignment = "Middle", 
    ContentAlignment = Enum.TextXAlignment.Center
})

-- Sistema de movimiento automático (Tween)
local tweenplantboxtoggle = Tabs.Farming:AddToggle("tweentoplantbox", { Title = "Tween to Plant Box", Default = false })
local tweenbushtoggle = Tabs.Farming:AddToggle("tweentobush", { Title = "Tween to Bush + Plant Box", Default = false })
local tweenrangeslider = Tabs.Farming:AddSlider("tweenrange", { Title = "Range", Min = 1, Max = 250, Rounding = 1, Default = 250 })

-- Botones para colocar estructuras de cultivo
Tabs.Farming:CreateParagraph("Aligned Paragraph", {
    Title = "Plantbox Stuff", 
    Content = "wish this ui was more like linoria :(", 
    TitleAlignment = "Middle", 
    ContentAlignment = Enum.TextXAlignment.Center
})
Tabs.Farming:CreateButton({Title = "Place 16x16 Plantboxes (256)", Callback = function() placestructure(16) end })
Tabs.Farming:CreateButton({Title = "Place 15x15 Plantboxes (225)", Callback = function() placestructure(15) end })
Tabs.Farming:CreateButton({Title = "Place 10x10 Plantboxes (100)", Callback = function() placestructure(10) end })
Tabs.Farming:CreateButton({Title = "Place 5x5 Plantboxes (25)", Callback = function() placestructure(5) end })
-- ================================================
-- ESP PARA MOSTRAR TODAS LAS COORDENADAS DEL FAR1.JSON
-- ================================================

local espFAR = Tabs.Farming:AddToggle("espFAR", {
    Title = "Mostrar ESP de FAR1.json",
    Default = false
})

local HttpService = game:GetService("HttpService")
local cam = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local RouteFile = "FAR/FAR1.json"
local ESP_POINTS = {}

-- ============================
-- RANGOS DE VELOCIDAD 21
-- ============================

local SpeedRanges = {
    {5, 7},
    {17, 29},
    {36, 42},
    {48, 60},
    {67, 93},
    {99, 112},
    {128, 159},
    {165, 186},
    {195, 231},
    {240, 295},
    {302, 324},
    {342, 363},
    {369, 415},
    {421, 430},
    {436, 452},
    {459, 477},
    {488, 520},
    {527, 559},
    {574, 576},
    {581, 620},
}

local function IsTurboIndex(i)
    for _, range in ipairs(SpeedRanges) do
        if i >= range[1] and i <= range[2] then
            return true
        end
    end
    return false
end

-- ---- FUNCIONES ----

local function LoadRoute()
    local raw = readfile(RouteFile)
    local data = HttpService:JSONDecode(raw)

    if not data.positions or typeof(data.positions) ~= "table" then
        warn("El archivo FAR1.json no contiene posiciones.")
        return {}
    end

    return data.positions
end

local function CreatePointESP(index, pos)
    local isTurbo = IsTurboIndex(index)

    local dot = Drawing.new("Circle")
    dot.Visible = true
    dot.Color = isTurbo and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 255)
    dot.Thickness = 2
    dot.NumSides = 20
    dot.Filled = true
    dot.Radius = 4

    local text = Drawing.new("Text")
    text.Visible = true
    text.Size = 14
    text.Center = true
    text.Color = isTurbo and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    text.Text = tostring(index)

    ESP_POINTS[#ESP_POINTS+1] = {dot = dot, text = text, position = pos}
end

local function ClearESP()
    for _, v in ipairs(ESP_POINTS) do
        v.dot:Remove()
        v.text:Remove()
    end
    ESP_POINTS = {}
end

-- ---- ACTIVACIÓN / DESACTIVACIÓN ----

espFAR:OnChanged(function(state)
    if state then
        ClearESP()

        local route = LoadRoute()
        for i, point in ipairs(route) do
            CreatePointESP(i, Vector3.new(point.X, point.Y, point.Z))
        end
    else
        ClearESP()
    end
end)

-- ---- LOOP PARA ACTUALIZAR PROYECCIÓN ----

RunService.RenderStepped:Connect(function()
    if not espFAR.Value then return end

    for _, v in ipairs(ESP_POINTS) do
        local screenPos, onScreen = cam:WorldToViewportPoint(v.position)

        if onScreen then
            v.dot.Visible = true
            v.text.Visible = true

            v.dot.Position = Vector2.new(screenPos.X, screenPos.Y)
            v.text.Position = Vector2.new(screenPos.X, screenPos.Y - 12)
        else
            v.dot.Visible = false
            v.text.Visible = false
        end
    end
end)
-- =============================================================================
-- SISTEMA DE TWEEN LEYENDO ARCHIVO FAR1.JSON EN FORMATO PERSONALIZADO (OPTIMIZADO)
-- =============================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Crear carpeta FAR si no existe
if not isfolder("FAR") then
    makefolder("FAR")
end

-- Archivo de ruta
local RouteFile = "FAR/FAR1.json"

-- Si no existe, crear archivo vacío con estructura correcta
if not isfile(RouteFile) then
    writefile(RouteFile, HttpService:JSONEncode({
        positions = {},
        waits = {}
    }))
end

-- Función para cargar el archivo FAR1.json
local function LoadRoute()
    local raw = readfile(RouteFile)
    local data = HttpService:JSONDecode(raw)

    if not data.positions or typeof(data.positions) ~= "table" then
        warn("El archivo FAR1.json no contiene 'positions'")
        return {}
    end

    return data.positions
end

-- Toggle UI
local tweenFAR = Tabs.Farming:AddToggle("tweenFAR", {
    Title = "Tween FAR1.json Route",
    Default = false
})

-- ============================
-- SISTEMA DE VELOCIDADES DINÁMICAS
-- ============================

local SpeedRanges = {
    {5, 7},
    {17, 29},
    {36, 42},
    {48, 60},
    {67, 93},
    {99, 112},
    {128, 159},
    {165, 186},
    {195, 231},
    {240, 295},
    {302, 324},
    {342, 363},
    {369, 415},
    {421, 430},
    {436, 452},
    {459, 477},
    {488, 520},
    {527, 559},
    {574, 576},
    {581, 620},
}

local function GetSpeedForIndex(i)
    for _, range in ipairs(SpeedRanges) do
        local minI = range[1]
        local maxI = range[2]
        if i >= minI and i <= maxI then
            return 21 -- velocidad rápida
        end
    end
    return 16 -- velocidad normal
end

-- ============================
-- MOVIMIENTO SUAVE
-- ============================

local function SmoothMoveTo(targetPos, speed)
    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude
    local duration = distance / speed

    local stepTime = 0.03
    local steps = math.max(1, math.floor(duration / stepTime))

    for i = 1, steps do
        if not tweenFAR.Value then return end

        local alpha = i / steps
        local newPos = startPos:Lerp(targetPos, alpha)
        hrp.CFrame = CFrame.new(newPos)

        task.wait(stepTime)
    end
end

-- ============================
-- LOOP PRINCIPAL
-- ============================

task.spawn(function()
    while task.wait(0.15) do
        if tweenFAR.Value then
            local Route = LoadRoute()

            for index, point in ipairs(Route) do
                if not tweenFAR.Value then break end

                local speed = GetSpeedForIndex(index)

                SmoothMoveTo(Vector3.new(point.X, point.Y, point.Z), speed)
            end
        end
    end
end)
-- AUTO FOOD 30s CYCLE
local autoFood30 = Tabs.Farming:AddToggle("autoFood30", {
Title = "Auto Food 30s Cycle",
Default = false
})

local function FireEat()
local args = { buffer.fromstring("+\001\000") }
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))
end

task.spawn(function()
while true do
    task.wait(1)

    if autoFood30.Value then
        local countdown = 30  -- cada 30 segundos

        while autoFood30.Value and countdown > 0 do
            task.wait(1)
            countdown -= 1

            -- Mostrar segundos restantes cada 5 segundos
            if countdown % 5 == 0 or countdown == 0 then
                warn("⏳ Restan " .. countdown .. " segundos para ejecutar 2 FireServer")
            end
        end

        -- Si el toggle se apagó mientras contaba → cancelar
        if not autoFood30.Value then
            warn("❌ AutoFood30 desactivado. Ciclo cancelado.")
            continue
        end

        -- Ejecutar 2 FireServer
        warn("⚡ Ejecutando 2 FireServer...")
        for i = 1, 2 do
            if not autoFood30.Value then
                warn("❌ Toggle apagado, deteniendo fires.")
                break
            end
            FireEat()
            task.wait(0.05)
        end

        warn("✅ Fires ejecutados. Reiniciando ciclo de 30 segundos.")
    end
end
end)
-- =============================================================================
-- SECCIÓN 9: ELEMENTOS DE LA PESTAÑA EXTRA (EXTRAS)
-- =============================================================================
-- Botón para cargar Infinite Yield (script externo)
Tabs.Extra:CreateButton({
    Title = "Infinite Yield", 
    Description = "inf yield chat", 
    Callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/decryp1/herklesiy/refs/heads/main/hiy"))()
    end
})

-- Sistema de Orbit para items
Tabs.Extra:CreateParagraph("Aligned Paragraph", {
    Title = "orbit breaks sometimes", 
    Content = "i dont give a shit", 
    TitleAlignment = "Middle", 
    ContentAlignment = Enum.TextXAlignment.Center
})
local orbittoggle = Tabs.Extra:CreateToggle("orbittoggle", { Title = "Item Orbit", Default = false })
local orbitrangeslider = Tabs.Extra:CreateSlider("orbitrange", { Title = "Grab Range", Min = 1, Max = 50, Rounding = 1, Default = 20 })
local orbitradiusslider = Tabs.Extra:CreateSlider("orbitradius", { Title = "Orbit Radius", Min = 0, Max = 30, Rounding = 1, Default = 10 })
local orbitspeedslider = Tabs.Extra:CreateSlider("orbitspeed", { Title = "Orbit Speed", Min = 0, Max = 10, Rounding = 1, Default = 5 })
local itemheightslider = Tabs.Extra:CreateSlider("itemheight", { Title = "Item Height", Min = -3, Max = 10, Rounding = 1, Default = 3 })

-- =============================================================================
-- SECCIÓN 10: SISTEMA DE MOVIMIENTO DEL PERSONAJE
-- =============================================================================
local wscon, hhcon

-- Función para actualizar WalkSpeed y JumpPower
local function updws()
    if wscon then wscon:Disconnect() end

    if Options.wstoggle.Value or Options.jptoggle.Value then
        wscon = runs.RenderStepped:Connect(function()
            if hum then
                hum.WalkSpeed = Options.wstoggle.Value and Options.wsslider.Value or 16
                hum.JumpPower = Options.jptoggle.Value and Options.jpslider.Value or 50
            end
        end)
    end
end

-- Función para actualizar HipHeight
local function updhh()
    if hhcon then hhcon:Disconnect() end

    if Options.hheighttoggle.Value then
        hhcon = runs.RenderStepped:Connect(function()
            if hum then
                hum.HipHeight = Options.hheightslider.Value
            end
        end)
    end
end

-- Manejo de cambio de personaje
local function onplradded(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")

    updws()
    updhh()
end

plr.CharacterAdded:Connect(onplradded)
Options.wstoggle:OnChanged(updws)
Options.jptoggle:OnChanged(updws)
Options.hheighttoggle:OnChanged(updhh)

-- =============================================================================
-- SECCIÓN 11: SISTEMA ANTI-DESLIZAMIENTO EN MONTAÑAS
-- =============================================================================
local slopecon
local function updmsa()
    if slopecon then slopecon:Disconnect() end

    if Options.msatoggle.Value then
        slopecon = game:GetService("RunService").RenderStepped:Connect(function()
            if hum then
                hum.MaxSlopeAngle = 90
            end
        end)
    else
        if hum then
            hum.MaxSlopeAngle = 46
        end
    end
end

Options.msatoggle:OnChanged(updmsa)

-- =============================================================================
-- SECCIÓN 12: FUNCIONES DE INTERACCIÓN CON EL JUEGO
-- =============================================================================
-- Función para obtener el layout order de un item en el inventario
local function getlayout(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then
        return nil
    end
    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            return child.LayoutOrder
        end
    end
    return nil
end

-- Función para usar herramienta (ataque)
local function swingtool(tspmogngicl)
    if packets.SwingTool and packets.SwingTool.send then
        packets.SwingTool.send(tspmogngicl)
    end
end

-- Función para recoger items
local function pickup(entityid)
    if packets.Pickup and packets.Pickup.send then
        packets.Pickup.send(entityid)
    end
end

-- Función para soltar items
local function drop(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then return end

    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            if packets and packets.DropBagItem and packets.DropBagItem.send then
                packets.DropBagItem.send(child.LayoutOrder)
            end
        end
    end
end

-- =============================================================================
-- SECCIÓN 13: SISTEMA DE KILL AURA
-- =============================================================================
task.spawn(function()
    while true do
        if not Options.killauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.killaurarange.Value) or 20
        local targetCount = tonumber(Options.katargetcountdropdown.Value) or 1
        local cooldown = tonumber(Options.kaswingcooldownslider.Value) or 0.1
        local targets = {}

        -- Buscar jugadores en el rango especificado
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                local playerfolder = workspace.Players:FindFirstChild(player.Name)
                if playerfolder then
                    local rootpart = playerfolder:FindFirstChild("HumanoidRootPart")
                    local entityid = playerfolder:GetAttribute("EntityID")

                    if rootpart and entityid then
                        local dist = (rootpart.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, { eid = entityid, dist = dist })
                        end
                    end
                end
            end
        end

        -- Atacar a los objetivos encontrados
        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

-- =============================================================================
-- SECCIÓN 14: SISTEMA DE RESOURCE AURA
-- =============================================================================
task.spawn(function()
    while true do
        if not Options.resourceauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.resourceaurarange.Value) or 20
        local targetCount = tonumber(Options.resourcetargetdropdown.Value) or 1
        local cooldown = tonumber(Options.resourcecooldownslider.Value) or 0.1
        local targets = {}
        local allresources = {}

        -- Recolectar todos los recursos disponibles
        for _, r in pairs(workspace.Resources:GetChildren()) do
            table.insert(allresources, r)
        end
        for _, r in pairs(workspace:GetChildren()) do
            if r:IsA("Model") and r.Name == "Gold Node" then
                table.insert(allresources, r)
            end
        end

        -- Filtrar recursos en el rango especificado
        for _, res in pairs(allresources) do
            if res:IsA("Model") and res:GetAttribute("EntityID") then
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        -- Atacar recursos encontrados
        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

-- =============================================================================
-- SECCIÓN 15: SISTEMA DE CRITTER AURA
-- =============================================================================
task.spawn(function()
    while true do
        if not Options.critterauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.critterrangeslider.Value) or 20
        local targetCount = tonumber(Options.crittertargetdropdown.Value) or 1
        local cooldown = tonumber(Options.crittercooldownslider.Value) or 0.1
        local targets = {}

        -- Buscar criaturas en el rango especificado
        for _, critter in pairs(workspace.Critters:GetChildren()) do
            if critter:IsA("Model") and critter:GetAttribute("EntityID") then
                local eid = critter:GetAttribute("EntityID")
                local ppart = critter.PrimaryPart or critter:FindFirstChildWhichIsA("BasePart")

                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        -- Atacar criaturas encontradas
        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

-- =============================================================================
-- SECCIÓN 16: SISTEMA DE AUTO PICKUP
-- =============================================================================
-- Configuración de items seleccionados para pickup
local selecteditems = {}
itemdropdown:OnChanged(function(Value)
    selecteditems = {} 
    for item, State in pairs(Value) do
        if State then
            table.insert(selecteditems, item)
        end
    end
end)

task.spawn(function()
    while true do
        local range = tonumber(Options.pickuprange.Value) or 35

        -- Auto pickup de items en el suelo
        if Options.autopickuptoggle.Value then
            for _, item in ipairs(workspace.Items:GetChildren()) do
                if item:IsA("BasePart") or item:IsA("MeshPart") then
                    local selecteditem = item.Name
                    local entityid = item:GetAttribute("EntityID")

                    if entityid and table.find(selecteditems, selecteditem) then
                        local dist = (item.Position - root.Position).Magnitude
                        if dist <= range then
                            pickup(entityid)
                        end
                    end
                end
            end
        end

        -- Auto pickup de items en cofres
        if Options.chestpickuptoggle.Value then
            for _, chest in ipairs(workspace.Deployables:GetChildren()) do
                if chest:IsA("Model") and chest:FindFirstChild("Contents") then
                    for _, item in ipairs(chest.Contents:GetChildren()) do
                        if item:IsA("BasePart") or item:IsA("MeshPart") then
                            local selecteditem = item.Name
                            local entityid = item:GetAttribute("EntityID")

                            if entityid and table.find(selecteditems, selecteditem) then
                                local dist = (chest.PrimaryPart.Position - root.Position).Magnitude
                                if dist <= range then
                                    pickup(entityid)
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.01)
    end
end)

-- =============================================================================
-- SECCIÓN 17: SISTEMA DE AUTO DROP
-- =============================================================================
local debounce = 0
local cd = 0 -- Cooldown para evitar spam de drops

-- Auto drop de items seleccionados
runs.Heartbeat:Connect(function()
    if Options.droptoggle.Value then
        if tick() - debounce >= cd then
            local selectedItem = Options.dropdropdown.Value
            drop(selectedItem)
            debounce = tick()
        end
    end
end)

-- Auto drop de items personalizados
runs.Heartbeat:Connect(function()
    if Options.droptogglemanual.Value then
        if tick() - debounce >= cd then
            local itemname = Options.droptextbox.Value
            drop(itemname)
            debounce = tick()
        end
    end
end)

-- =============================================================================
-- SECCIÓN 18: SISTEMA DE CULTIVO AUTOMÁTICO
-- =============================================================================
local plantedboxes = {}
-- Mapeo de frutas a sus IDs correspondientes
local fruittoitemid = {
    Bloodfruit = 94,
    Bluefruit = 377,
    Lemon = 99,
    Coconut = 1,
    Jelly = 604,
    Banana = 606,
    Orange = 602,
    Oddberry = 32,
    Berry = 35,
    Strangefruit = 302,
    Strawberry = 282,
    Sunfruit = 128,
    Pumpkin = 80,
    ["Prickly Pear"] = 378,
    Apple = 243,
    Barley = 247,
    Cloudberry = 101,
    Carrot = 147
}

-- Función para plantar en una caja de cultivo
local function plant(entityid, itemID)
    if packets.InteractStructure and packets.InteractStructure.send then
        packets.InteractStructure.send({ entityID = entityid, itemID = itemID })
        plantedboxes[entityid] = true
    end
end

-- Función para obtener cajas de cultivo en un rango
local function getpbs(range)
    local plantboxes = {}
    for _, deployable in ipairs(workspace.Deployables:GetChildren()) do
        if deployable:IsA("Model") and deployable.Name == "Plant Box" then
            local entityid = deployable:GetAttribute("EntityID")
            local ppart = deployable.PrimaryPart or deployable:FindFirstChildWhichIsA("BasePart")
            if entityid and ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    table.insert(plantboxes, { entityid = entityid, deployable = deployable, dist = dist })
                end
            end
        end
    end
    return plantboxes
end

-- Función para obtener arbustos en un rango
local function getbushes(range, fruitname)
    local bushes = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:find(fruitname) then
            local ppart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    local entityid = model:GetAttribute("EntityID")
                    if entityid then
                        table.insert(bushes, { entityid = entityid, model = model, dist = dist })
                    end
                end
            end
        end
    end
    return bushes
end

-- =============================================================================
-- SECCIÓN 19: SISTEMA DE MOVIMIENTO AUTOMÁTICO (TWEEN)
-- =============================================================================
local tweening = nil

-- Función para mover el personaje a una posición específica
local function tween(target)
    if tweening then tweening:Cancel() end
    local distance = (root.Position - target.Position).Magnitude
    local duration = distance / 21
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = tspmo:Create(root, tweenInfo, { CFrame = target })
    tween:Play()

    tweening = tween
end

-- Función para moverse a cajas de cultivo
local function tweenplantbox(range)
    while tweenplantboxtoggle.Value do
        local plantboxes = getpbs(range)
        table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

        for _, box in ipairs(plantboxes) do
            if not box.deployable:FindFirstChild("Seed") then
                local target = box.deployable.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                tween(target)
                break
            end
        end

        task.wait(0.1)
    end
end

-- Función para moverse a arbustos y cajas de cultivo
local function tweenpbs(range, fruitname)
    while tweenbushtoggle.Value do
        local bushes = getbushes(range, fruitname)
        table.sort(bushes, function(a, b) return a.dist < b.dist end)

        if #bushes > 0 then
            for _, bush in ipairs(bushes) do
                local target = bush.model.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                tween(target)
                break
            end
        else
            local plantboxes = getpbs(range)
            table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    local target = box.deployable.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    tween(target)
                    break
                end
            end
        end

        task.wait(0.1)
    end
end

-- =============================================================================
-- SECCIÓN 20: SISTEMA DE PLANTACIÓN AUTOMÁTICA
-- =============================================================================
task.spawn(function()
    while true do
        if not Options.planttoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.plantrange.Value) or 30
        local delay = tonumber(Options.plantdelay.Value) or 0.1
        local selectedfruit = Options.fruitdropdown.Value
        local itemID = fruittoitemid[selectedfruit] or 94
        local plantboxes = getpbs(range)
        table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

        -- Plantar en cajas vacías
        for _, box in ipairs(plantboxes) do
            if not box.deployable:FindFirstChild("Seed") then
                plant(box.entityid, itemID)
            else
                plantedboxes[box.entityid] = true
            end
        end
        task.wait(delay)
    end
end)

-- =============================================================================
-- SECCIÓN 21: SISTEMA DE COSECHA AUTOMÁTICA
-- =============================================================================
task.spawn(function()
    while true do
        if not Options.harvesttoggle.Value then
            task.wait(0.1)
            continue
        end
        local harvestrange = tonumber(Options.harvestrange.Value) or 30
        local selectedfruit = Options.fruitdropdown.Value
        local bushes = getbushes(harvestrange, selectedfruit)
        table.sort(bushes, function(a, b) return a.dist < b.dist end)
        for _, bush in ipairs(bushes) do
            pickup(bush.entityid)
        end
        task.wait(0.1)
    end
end)

-- =============================================================================
-- SECCIÓN 22: EJECUCIÓN DE SISTEMAS DE MOVIMIENTO AUTOMÁTICO
-- =============================================================================
task.spawn(function()
    while true do
        if not tweenplantboxtoggle.Value then
            task.wait(0.1)
            continue
        end
        local range = tonumber(Options.tweenrange.Value) or 250
        tweenplantbox(range)
    end
end)

task.spawn(function()
    while true do
        if not tweenbushtoggle.Value then
            task.wait(0.1)
            continue
        end
        local range = tonumber(Options.tweenrange.Value) or 20
        local selectedfruit = Options.fruitdropdown.Value
        tweenpbs(range, selectedfruit)
    end
end)

-- =============================================================================
-- SECCIÓN 23: SISTEMA DE COLOCACIÓN DE ESTRUCTURAS
-- =============================================================================
placestructure = function(gridsize)
    if not plr or not plr.Character then return end

    local torso = plr.Character:FindFirstChild("HumanoidRootPart")
    if not torso then return end

    local startpos = torso.Position - Vector3.new(0, 3, 0)
    local spacing = 6.04

    -- Crear grid de cajas de cultivo
    for x = 0, gridsize - 1 do
        for z = 0, gridsize - 1 do
            task.wait(0.3)
            local position = startpos + Vector3.new(x * spacing, 0, z * spacing)

            if packets.PlaceStructure and packets.PlaceStructure.send then
                packets.PlaceStructure.send{
                    ["buildingName"] = "Plant Box",
                    ["yrot"] = 45,
                    ["vec"] = position,
                    ["isMobile"] = false
                }
            end
        end
    end
end

-- =============================================================================
-- SECCIÓN 24: SISTEMA DE ORBIT DE ITEMS
-- =============================================================================
local orbiton, range, orbitradius, orbitspeed, itemheight = false, 20, 10, 5, 3
local attacheditems, itemangles, lastpositions = {}, {}, {}
local itemsfolder = workspace:WaitForChild("Items")

-- Configuración del toggle de orbit
orbittoggle:OnChanged(function(value)
    orbiton = value
    if not orbiton then
        -- Limpiar todos los items orbitando
        for _, bp in pairs(attacheditems) do bp:Destroy() end
        table.clear(attacheditems)
        table.clear(itemangles)
        table.clear(lastpositions)
    else
        -- Iniciar sistema de verificación de items estáticos
        task.spawn(function()
            while orbiton do
                for item, bp in pairs(attacheditems) do
                    if item then
                        local currentpos = item.Position
                        local lastpos = lastpositions[item]

                        -- Forzar interacción si el item no se mueve
                        if lastpos and (currentpos - lastpos).Magnitude < 0.1 then
                            if packets.ForceInteract and packets.ForceInteract.send then
                                packets.ForceInteract.send(item:GetAttribute("EntityID"))
                            end
                        end

                        lastpositions[item] = currentpos
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Configuración de parámetros del orbit
orbitrangeslider:OnChanged(function(value) range = value end)
orbitradiusslider:OnChanged(function(value) orbitradius = value end)
orbitspeedslider:OnChanged(function(value) orbitspeed = value end)
itemheightslider:OnChanged(function(value) itemheight = value end)

-- Actualización de posición de items en órbita
runs.RenderStepped:Connect(function()
    if not orbiton then return end
    local time = tick() * orbitspeed
    for item, bp in pairs(attacheditems) do
        if item then
            local angle = itemangles[item] + time
            bp.Position = root.Position + Vector3.new(math.cos(angle) * orbitradius, itemheight, math.sin(angle) * orbitradius)
        end
    end
end)

-- Sistema de captura de items para orbitar
task.spawn(function()
    while true do
        if orbiton then
            local children, index = itemsfolder:GetChildren(), 0
            local anglestep = (math.pi * 2) / math.max(#children, 1)

            for _, item in pairs(children) do
                local primary = item:IsA("BasePart") and item or item:IsA("Model") and item.PrimaryPart
                if primary and (primary.Position - root.Position).Magnitude <= range then
                    if not attacheditems[primary] then
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce, bp.D, bp.P, bp.Parent = Vector3.new(math.huge, math.huge, math.huge), 1500, 25000, primary
                        attacheditems[primary], itemangles[primary], lastpositions[primary] = bp, index * anglestep, primary.Position
                        index += 1
                    end
                end
            end
        end
        task.wait()
    end
end)
-- =============================================================================
-- SECCIÓN NUEVA: ORBIT ITEMS TO OTHER PLAYERS (CON ANTI-DROP Y REINICIO CORRECTO)
-- =============================================================================

local selectedOrbitPlayer = nil
local orbitOtherEnabled = false
local orbitPlayerList = {}

local orbitPlayerSection = Tabs.Extra:CreateSection("Orbit Other Players", true)

-- Dropdown jugadores
local orbitPlayerDropdown = Tabs.Extra:CreateDropdown("orbitPlayerDropdown", {
    Title = "Select Player",
    Values = {},
    Default = nil
})

-- Botón refrescar lista
Tabs.Extra:CreateButton({
    Title = "Refresh Player List",
    Callback = function()
        orbitPlayerList = {}
        local values = {}

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr then
                table.insert(values, p.Name)
                orbitPlayerList[p.Name] = p
            end
        end

        orbitPlayerDropdown:SetValues(values)
    end
})

-- Toggle activar/desactivar
local orbitOtherToggle = Tabs.Extra:CreateToggle("orbitOtherToggle", {
    Title = "Orbit Items to Selected Player",
    Default = false
})

orbitOtherToggle:OnChanged(function(state)
    orbitOtherEnabled = state

    if not state then
        -- Limpiar órbita
        for _, bp in pairs(attacheditems) do
            if bp then
                pcall(function() bp:Destroy() end)
            end
        end
        table.clear(attacheditems)
        table.clear(itemangles)
        table.clear(lastpositions)

    else
        -- SISTEMA ANTI-DROP (copiado exacto del orbit original)
        task.spawn(function()
            while orbitOtherEnabled do
                for item, bp in pairs(attacheditems) do
                    if item then
                        local currentpos = item.Position
                        local lastpos = lastpositions[item]

                        if lastpos and (currentpos - lastpos).Magnitude < 0.1 then
                            if packets.ForceInteract and packets.ForceInteract.send then
                                packets.ForceInteract.send(item:GetAttribute("EntityID"))
                            end
                        end

                        lastpositions[item] = currentpos
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Cambio de jugador seleccionado
orbitPlayerDropdown:OnChanged(function(value)
    selectedOrbitPlayer = orbitPlayerList[value]

    -- Reiniciar órbita completamente al seleccionar otro jugador
    if orbitOtherEnabled then
        for _, bp in pairs(attacheditems) do
            if bp then pcall(function() bp:Destroy() end) end
        end
        table.clear(attacheditems)
        table.clear(itemangles)
        table.clear(lastpositions)
    end
end)

-- Sistema de movimiento de órbita
runs.RenderStepped:Connect(function()
    if not orbitOtherEnabled then return end
    if not selectedOrbitPlayer then return end
    if not selectedOrbitPlayer.Character then return end

    local targetRoot = selectedOrbitPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local time = tick() * orbitspeed

    for item, bp in pairs(attacheditems) do
        if item and bp then
            local angle = itemangles[item] + time
            bp.Position = targetRoot.Position + Vector3.new(
                math.cos(angle) * orbitradius,
                itemheight,
                math.sin(angle) * orbitradius
            )
        end
    end
end)

-- Captura EXACTA del orbit original pero redirigida al target
task.spawn(function()
    while true do
        if orbitOtherEnabled and selectedOrbitPlayer then
            local children, index = itemsfolder:GetChildren(), 0
            local anglestep = (math.pi * 2) / math.max(#children, 1)

            for _, item in pairs(children) do
                local primary =
                    (item:IsA("BasePart") and item)
                    or (item:IsA("Model") and item.PrimaryPart)

                -- Igual que tu orbit original: captura por TU rango
                if primary and (primary.Position - root.Position).Magnitude <= range then
                    if not attacheditems[primary] then
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bp.D = 1500
                        bp.P = 25000
                        bp.Parent = primary

                        attacheditems[primary] = bp
                        itemangles[primary] = index * anglestep
                        lastpositions[primary] = primary.Position

                        index += 1
                    end
                end
            end
        end

        task.wait()
    end
end)
-- =============================================================================
-- SECCIÓN 25: CONFIGURACIÓN FINAL Y NOTIFICACIÓN
-- =============================================================================
-- Configuración de sistemas de guardado e interfaz
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Inicialización final
Window:SelectTab(1)
Library:Notify{
    Title = "Hxpnotoc Hub",
    Content = "Cargado, Disfruta!",
    Duration = 1
}
SaveManager:LoadAutoloadConfig()
print("¡Listo, Disfruta del script!")
