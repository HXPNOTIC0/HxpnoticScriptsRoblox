-- Crear GUI del botón flotante moderno
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ComboButton = Instance.new("TextButton")

-- Configuración del botón
ComboButton.Parent = ScreenGui
ComboButton.Size = UDim2.new(0, 75, 0, 40)  -- Tamaño más estilizado
ComboButton.Position = UDim2.new(0.5, -37, 0.88, -40)  -- Abajo centrado
ComboButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)  -- Verde (ON)
ComboButton.Text = "C:ON"
ComboButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Texto blanco
ComboButton.Font = Enum.Font.GothamBold  -- Fuente moderna
ComboButton.TextSize = 14  -- Tamaño adecuado
ComboButton.BorderSizePixel = 0  -- Sin borde
ComboButton.AutoButtonColor = false  -- Evita efecto predeterminado
ComboButton.Draggable = true
ComboButton.Active = true

-- Bordes redondeados
local UICorner = Instance.new("UICorner", ComboButton)
UICorner.CornerRadius = UDim.new(0, 10)  -- Esquinas más suaves

-- Sombra con efecto dinámico
local UIStroke = Instance.new("UIStroke", ComboButton)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(50, 50, 50)  -- Sombra gris oscura
UIStroke.Transparency = 0.3  -- Ligera transparencia

-- Indicador de estado
local GlowEffect = Instance.new("UIGradient", ComboButton)
GlowEffect.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
GlowEffect.Rotation = 90

-- Animación de cambio de color (suave)
local function animateColor(button, color)
    for i = 1, 10 do
        button.BackgroundColor3 = button.BackgroundColor3:Lerp(color, 0.2)
        UIStroke.Color = button.BackgroundColor3:Lerp(Color3.fromRGB(50, 50, 50), 0.3)
        task.wait(0.02)
    end
end

-- Estado inicial del combo
local comboActive = true

-- Función para activar/desactivar el combo
ComboButton.MouseButton1Click:Connect(function()
    comboActive = not comboActive
    if comboActive then
        ComboButton.Text = "C:ON"
        animateColor(ComboButton, Color3.fromRGB(0, 180, 0))  -- Verde suave
        startCombo()
    else
        ComboButton.Text = "C:OFF"
        animateColor(ComboButton, Color3.fromRGB(200, 0, 0))  -- Rojo suave
    end
end)

-- Función para ejecutar las armas
local function ejecutarArma(arma, estado)
    local args = {[1] = estado}
    game:GetService("Players").LocalPlayer.Folder[arma].InventoryEquipRemote:FireServer(unpack(args))
end

-- Función principal con sincronización perfecta
function startCombo()
    if not comboActive then return end
    if not _G.scripts or not _G.tiempos then 
        warn("No se han definido _G.scripts o _G.tiempos. Asegúrate de cargarlos antes de ejecutar el combo.")
        return 
    end

    for i, datos in ipairs(_G.scripts) do
        if not comboActive then break end  -- Si el usuario apaga el combo, se detiene
        ejecutarArma(datos[1], datos[2])  -- Ejecutar acción del arma
        task.wait(_G.tiempos[i] or 0.1)  -- Si falta un tiempo, usar 0.1s por defecto
    end
end
