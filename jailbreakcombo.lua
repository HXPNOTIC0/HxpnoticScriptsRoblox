-- Estado inicial del combo
local comboActive = false

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

    for i, datos in ipairs(_G.scripts) do
        if not comboActive then break end  -- Si el usuario apaga el combo, se detiene
        ejecutarArma(datos[1], datos[2])  -- Ejecutar acción del arma
        task.wait(_G.tiempos[i])  -- Esperar el tiempo exacto antes de continuar
    end
end
