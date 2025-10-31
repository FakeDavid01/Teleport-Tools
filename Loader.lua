local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local saveFile = "TeleportSpots.json"

if player.PlayerGui:FindFirstChild("TeleportUI") then
    player.PlayerGui:FindFirstChild("TeleportUI"):Destroy()
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportUI"
gui.ResetOnSpawn = false

-- ========== TEMA WARNA HALLOWEEN ==========
local colorOrange = Color3.fromRGB(230, 130, 0)
local colorRed = Color3.fromRGB(180, 40, 40)
local colorBlack = Color3.fromRGB(18, 18, 18)
local colorGray = Color3.fromRGB(25, 25, 25)
local colorDarkGray = Color3.fromRGB(40, 40, 40)
local colorTextBlack = Color3.new(0, 0, 0)
local colorTextWhite = Color3.new(1, 1, 1)

-- ========== VARIABEL KONTROL ==========
local canSendErrorNotif = true -- PERUBAHAN: Untuk anti-spam notifikasi

-- ========== CUSTOM NOTIFICATION SYSTEM (VERSI KECIL) ==========
local function createCustomNotification(title, text, duration)
    duration = duration or 5
    local notificationGui = Instance.new("ScreenGui", player.PlayerGui)
    notificationGui.Name = "CustomNotification"
    notificationGui.ResetOnSpawn = false
    local notificationFrame = Instance.new("Frame", notificationGui)
    notificationFrame.Size = UDim2.new(0, 200, 0, 60)
    notificationFrame.Position = UDim2.new(1, 250, 1, -80)
    notificationFrame.BackgroundColor3 = colorGray
    notificationFrame.BorderSizePixel = 0
    Instance.new("UICorner", notificationFrame).CornerRadius = UDim.new(0, 8)
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = colorOrange
    titleLabel.TextColor3 = colorTextBlack
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 16
    titleLabel.TextScaled = false
    titleLabel.AutoLocalize = false
    Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 8)
    local textLabel = Instance.new("TextLabel", notificationFrame)
    textLabel.Text = text
    textLabel.Size = UDim2.new(1, -20, 0, 30)
    textLabel.Position = UDim2.new(0, 10, 0, 28)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = colorTextWhite
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextSize = 13
    textLabel.TextWrapped = true
    textLabel.TextScaled = false
    textLabel.AutoLocalize = false
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -220, 1, -80)
    })
    local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 250, 1, -80)
    })
    tweenIn:Play()
    task.spawn(function()
        task.wait(duration)
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
    return notificationGui
end

-- ========== BASIC UI CREATION (LAYOUT BARU 250x250) ==========

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0.5, -125, 0.5, -125)
frame.BackgroundColor3 = colorGray
frame.Active = true
frame.Draggable = true
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", frame).Color = colorOrange

-- TITLE BAR
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = colorBlack
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", titleBar)
title.Text = "Teleport Tools"
title.Size = UDim2.new(0.70, 0, 1, 0)
title.Position = UDim2.new(0.03, 0, 0, 0)
title.TextColor3 = colorOrange
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = false
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.AutoLocalize = false

local hideButton = Instance.new("TextButton", titleBar)
hideButton.Size = UDim2.new(0.28, 0, 0.9, 0)
hideButton.Position = UDim2.new(0.7, 0, 0.05, 0)
hideButton.Text = "Hide UI"
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextScaled = true
hideButton.BackgroundColor3 = colorOrange
hideButton.TextColor3 = colorTextBlack
hideButton.AutoLocalize = false
Instance.new("UICorner", hideButton).CornerRadius = UDim.new(0, 4)

-- CONTENT
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1

-- BARIS 1 (TOGGLES)
local toggleLabel = Instance.new("TextLabel", content)
toggleLabel.Text = "Auto Teleport :"
toggleLabel.Size = UDim2.new(0.55, 0, 0, 25)
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
toggleLabel.TextColor3 = colorTextWhite
toggleLabel.BackgroundTransparency = 1
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.TextScaled = true
toggleLabel.Font = Enum.Font.SourceSansBold
toggleLabel.AutoLocalize = false

local toggleButton = Instance.new("TextButton", content)
toggleButton.Size = UDim2.new(0.43, 0, 0, 25)
toggleButton.Position = UDim2.new(0.57, 0, 0, 0)
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = colorRed
toggleButton.TextColor3 = colorTextBlack
toggleButton.AutoLocalize = false
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

-- BARIS 2 (INPUTS)
local delayLabel = Instance.new("TextLabel", content)
delayLabel.Text = "Delay Teleport (s):"
delayLabel.Size = UDim2.new(0.55, 0, 0, 25)
delayLabel.Position = UDim2.new(0, 0, 0, 30)
delayLabel.TextColor3 = colorTextWhite
delayLabel.BackgroundTransparency = 1
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.TextScaled = true
delayLabel.Font = Enum.Font.SourceSansBold
delayLabel.AutoLocalize = false

local delayInput = Instance.new("TextBox", content)
delayInput.Size = UDim2.new(0.43, 0, 0, 25)
delayInput.Position = UDim2.new(0.57, 0, 0, 30)
delayInput.Text = "0"
delayInput.Font = Enum.Font.SourceSans
delayInput.TextScaled = true
delayInput.BackgroundColor3 = colorDarkGray
delayInput.TextColor3 = colorTextWhite
delayInput.AutoLocalize = false
Instance.new("UICorner", delayInput).CornerRadius = UDim.new(0, 4)

-- BARIS 3 (ACTION BUTTONS)
local addCurrent = Instance.new("TextButton", content)
addCurrent.Text = "Add Current Pos"
addCurrent.Size = UDim2.new(0.49, 0, 0, 30)
addCurrent.Position = UDim2.new(0, 0, 0, 60)
addCurrent.Font = Enum.Font.SourceSansBold
addCurrent.TextScaled = true
addCurrent.BackgroundColor3 = colorOrange
addCurrent.TextColor3 = colorTextBlack
addCurrent.AutoLocalize = false
Instance.new("UICorner", addCurrent).CornerRadius = UDim.new(0, 4)

local addCustom = Instance.new("TextButton", content)
addCustom.Text = "Add Custom Pos"
addCustom.Size = UDim2.new(0.49, 0, 0, 30)
addCustom.Position = UDim2.new(0.51, 0, 0, 60)
addCustom.Font = Enum.Font.SourceSansBold
addCustom.TextScaled = true
addCustom.BackgroundColor3 = colorOrange
addCustom.TextColor3 = colorTextBlack
addCustom.AutoLocalize = false
Instance.new("UICorner", addCustom).CornerRadius = UDim.new(0, 4)

-- BARIS 4 (CLEAR BUTTON)
local clearButton = Instance.new("TextButton", content)
clearButton.Text = "Clear All Position"
clearButton.Size = UDim2.new(1, 0, 0, 30)
clearButton.Position = UDim2.new(0, 0, 0, 95)
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextScaled = true
clearButton.BackgroundColor3 = colorRed
clearButton.TextColor3 = colorTextBlack
clearButton.AutoLocalize = false
Instance.new("UICorner", clearButton).CornerRadius = UDim.new(0, 4)

-- AREA LIST DIPERBESAR
local scroll = Instance.new("ScrollingFrame", content)
scroll.Size = UDim2.new(1, 0, 1, -130)
scroll.Position = UDim2.new(0, 0, 0, 130)
scroll.BackgroundColor3 = colorBlack
scroll.ScrollBarThickness = 6
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ScrollBarImageColor3 = colorOrange
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIPadding", scroll).PaddingRight = UDim.new(0, 10)

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 4)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- EMPTY STATE MESSAGE
local emptyMessage = Instance.new("TextLabel", scroll)
emptyMessage.Name = "EmptyMessage"
emptyMessage.Text = "No positions added yet!"
emptyMessage.Size = UDim2.new(1, -10, 0, 40)
emptyMessage.Position = UDim2.new(0, 5, 0, 10)
emptyMessage.TextColor3 = Color3.fromRGB(150, 150, 150)
emptyMessage.BackgroundTransparency = 1
emptyMessage.TextWrapped = true
emptyMessage.Font = Enum.Font.SourceSans
emptyMessage.TextSize = 14
emptyMessage.TextScaled = false
emptyMessage.TextXAlignment = Enum.TextXAlignment.Center -- Posisi tengah
emptyMessage.AutoLocalize = false
emptyMessage.Visible = true

-- POPUP (Add Custom)
local popup = Instance.new("Frame", gui)
popup.Size = UDim2.new(0, 220, 0, 120)
popup.Position = UDim2.new(0.5, -110, 0.5, -60)
popup.BackgroundColor3 = colorGray
popup.Visible = false
Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", popup).Color = colorOrange

local pTitle = Instance.new("TextLabel", popup)
pTitle.Text = "Add Custom Position"
pTitle.Size = UDim2.new(1, 0, 0, 25)
pTitle.Font = Enum.Font.SourceSansBold
pTitle.TextScaled = true
pTitle.TextColor3 = colorTextWhite
pTitle.BackgroundColor3 = colorBlack
pTitle.AutoLocalize = false
Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0, 4)

local coordInput = Instance.new("TextBox", popup)
coordInput.PlaceholderText = "Example: 10,10,10"
coordInput.Size = UDim2.new(1, -20, 0, 30)
coordInput.Position = UDim2.new(0, 10, 0, 35)
coordInput.BackgroundColor3 = colorDarkGray
coordInput.TextColor3 = colorTextWhite
coordInput.Font = Enum.Font.SourceSans
coordInput.TextScaled = true
coordInput.AutoLocalize = false
Instance.new("UICorner", coordInput).CornerRadius = UDim.new(0, 4)

local confirm = Instance.new("TextButton", popup)
confirm.Text = "Confirm"
confirm.Size = UDim2.new(0.45, 0, 0, 25)
confirm.Position = UDim2.new(0.05, 0, 1, -30)
confirm.BackgroundColor3 = colorOrange
confirm.Font = Enum.Font.SourceSansBold
confirm.TextScaled = true
confirm.TextColor3 = colorTextBlack
confirm.AutoLocalize = false
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 4)

local cancel = Instance.new("TextButton", popup)
cancel.Text = "Cancel"
cancel.Size = UDim2.new(0.45, 0, 0, 25)
cancel.Position = UDim2.new(0.5, 0, 1, -30)
cancel.BackgroundColor3 = colorRed
cancel.Font = Enum.Font.SourceSansBold
cancel.TextScaled = true
cancel.TextColor3 = colorTextBlack
cancel.AutoLocalize = false
Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 4)

-- ========== PERUBAHAN: POPUP KONFIRMASI (STYLE BARU) ==========
local confirmPopup = Instance.new("Frame", gui)
confirmPopup.Size = UDim2.new(0, 220, 0, 120) -- Ukuran disamakan dgn popup
confirmPopup.Position = UDim2.new(0.5, -110, 0.5, -60)
confirmPopup.BackgroundColor3 = colorGray
confirmPopup.Visible = false
Instance.new("UICorner", confirmPopup).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", confirmPopup).Color = colorRed -- Stroke merah

local confirmTitle = Instance.new("TextLabel", confirmPopup)
confirmTitle.Text = "Are you sure?"
confirmTitle.Size = UDim2.new(1, 0, 0, 25)
confirmTitle.Font = Enum.Font.SourceSansBold
confirmTitle.TextScaled = true
confirmTitle.TextColor3 = colorTextWhite
confirmTitle.BackgroundColor3 = colorBlack
confirmTitle.AutoLocalize = false
Instance.new("UICorner", confirmTitle).CornerRadius = UDim.new(0, 4)

local confirmLabel = Instance.new("TextLabel", confirmPopup)
confirmLabel.Text = "This will delete all saved positions."
confirmLabel.Size = UDim2.new(1, -20, 0, 30)
confirmLabel.Position = UDim2.new(0, 10, 0, 35)
confirmLabel.TextColor3 = colorTextWhite
confirmLabel.BackgroundTransparency = 1
confirmLabel.TextWrapped = true
confirmLabel.Font = Enum.Font.SourceSans
confirmLabel.TextSize = 14
confirmLabel.TextScaled = false
confirmLabel.AutoLocalize = false

local confirmYes = Instance.new("TextButton", confirmPopup)
confirmYes.Text = "YES"
confirmYes.Size = UDim2.new(0.45, 0, 0, 25)
confirmYes.Position = UDim2.new(0.05, 0, 1, -30)
confirmYes.BackgroundColor3 = colorRed
confirmYes.Font = Enum.Font.SourceSansBold
confirmYes.TextScaled = true
confirmYes.TextColor3 = colorTextBlack
confirmYes.AutoLocalize = false
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0, 4)

local confirmNo = Instance.new("TextButton", confirmPopup)
confirmNo.Text = "NO"
confirmNo.Size = UDim2.new(0.45, 0, 0, 25)
confirmNo.Position = UDim2.new(0.5, 0, 1, -30)
confirmNo.BackgroundColor3 = colorOrange
confirmNo.Font = Enum.Font.SourceSansBold
confirmNo.TextScaled = true
confirmNo.TextColor3 = colorTextBlack
confirmNo.AutoLocalize = false
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0, 4)

-- SHOW BUTTON
local showButton = Instance.new("TextButton", gui)
showButton.Size = UDim2.new(0, 80, 0, 30)
showButton.Position = UDim2.new(0.5, -40, 0, 2) -- PERUBAHAN: Posisi 2px dari atas
showButton.Text = "Show UI"
showButton.Font = Enum.Font.SourceSansBold
showButton.TextScaled = true
showButton.BackgroundColor3 = colorOrange
showButton.TextColor3 = colorTextBlack
showButton.Visible = false
showButton.AutoLocalize = false
Instance.new("UICorner", showButton).CornerRadius = UDim.new(0, 6)

-- ========== DATA & CORE FUNCTIONS ==========
local farmSpots = {}
local autoTeleport = false
local canTeleport = true
local currentSpot = 1
local spotUIElements = {} 

local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function flashButton(button, flashColor, duration)
    duration = duration or 0.2
    local originalColor = button.BackgroundColor3
    button.BackgroundColor3 = flashColor
    local returnTween = TweenService:Create(button, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = originalColor
    })
    returnTween:Play()
end

-- ========== WORKING SOUND SYSTEM ==========
local function playSound(soundId, volume)
    volume = volume or 0.5
    local success, result = pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = volume
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5)
        return true
    end)
    return success
end

local function playButtonSound()
    playSound(6895079853, 0.4)
end

local function playHideSound()
    playSound(154157386, 0.5)
end

local function playShowSound()
    playSound(154147007, 0.5)
end

local function playNotifySound()
    playSound(18595195017, 0.6)
end

local backgroundSound = nil
local isSoundLoaded = false

local function initializeBackgroundSound()
    if backgroundSound then return true end
    
    local success = pcall(function()
        backgroundSound = Instance.new("Sound")
        backgroundSound.SoundId = "rbxassetid://1848354536"
        backgroundSound.Volume = 0
        backgroundSound.Looped = true
        backgroundSound.Parent = gui
        backgroundSound:Play()
        isSoundLoaded = true
        return true
    end)
    
    if not success then
        backgroundSound = nil
        isSoundLoaded = false
    end
    
    return isSoundLoaded
end

local function playBackgroundSound()
    if not backgroundSound then
        if not initializeBackgroundSound() then
            return
        end
    end
    
    local tween = TweenService:Create(backgroundSound, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = 0.3
    })
    tween:Play()
end

local function pauseBackgroundSound()
    if backgroundSound then
        local tween = TweenService:Create(backgroundSound, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Volume = 0
        })
        tween:Play()
    end
end

local function stopBackgroundSound()
    if backgroundSound then
        backgroundSound:Stop()
        backgroundSound:Destroy()
        backgroundSound = nil
        isSoundLoaded = false
    end
end

-- ========== ENHANCED FEATURES ==========
local function createRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.8
    ripple.ZIndex = 5
    ripple.Parent = button
    local tween = TweenService:Create(ripple, TweenInfo.new(0.5), {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function addCooldownEffect(button, duration)
    local cooldownOverlay = Instance.new("Frame")
    cooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
    cooldownOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    cooldownOverlay.BackgroundTransparency = 0.5
    cooldownOverlay.Parent = button
    cooldownOverlay.ZIndex = 5
    local tween = TweenService:Create(cooldownOverlay, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        cooldownOverlay:Destroy()
    end)
end

-- ========== CORE LOGIC FUNCTIONS ==========
local function saveData()
    local dataToSave = {}
    for _, pos in ipairs(farmSpots) do
        table.insert(dataToSave, {x = pos.X, y = pos.Y, z = pos.Z})
    end
    local success, jsonData = pcall(HttpService.JSONEncode, HttpService, dataToSave)
    if success then
        writefile(saveFile, jsonData)
    end
end

local function loadData()
    if not isfile(saveFile) then return end
    local success, jsonData = pcall(readfile, saveFile)
    if not success or not jsonData then return end
    local success, savedData = pcall(HttpService.JSONDecode, HttpService, jsonData)
    if success and savedData then
        farmSpots = {}
        for _, data in ipairs(savedData) do
            table.insert(farmSpots, Vector3.new(data.x, data.y, data.z))
        end
    end
end

local function updateEmptyMessage()
    if scroll:FindFirstChild("EmptyMessage") then
        scroll.EmptyMessage.Visible = (#farmSpots == 0)
    end
end

local function updateToggleButton()
    if #farmSpots == 0 then
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = colorRed
        toggleButton.TextColor3 = colorTextBlack
        autoTeleport = false
    end
end

local function safeTeleport(position)
    if not canTeleport then return end
    canTeleport = false
    local ok, root = pcall(getRoot)
    if ok and root then
        root.CFrame = CFrame.new(position)
    end
    task.wait(0.1)
    canTeleport = true
end

local function updateTeleportHighlight(newIndex, oldIndex)
    if oldIndex and spotUIElements[oldIndex] then
        local pos = farmSpots[oldIndex]
        if pos then
            spotUIElements[oldIndex].Text = string.format("%d. (%.0f, %.0f, %.0f)", oldIndex, pos.X, pos.Y, pos.Z)
            spotUIElements[oldIndex].TextColor3 = colorTextWhite
        end
    end
    if newIndex and spotUIElements[newIndex] then
        local pos = farmSpots[newIndex]
        if pos then
            spotUIElements[newIndex].Text = string.format("→ %d. (%.0f, %.0f, %.0f) ←", newIndex, pos.X, pos.Y, pos.Z)
            spotUIElements[newIndex].TextColor3 = colorOrange
        end
    end
end

local function refreshList()
    for _, c in pairs(scroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    spotUIElements = {}
    updateEmptyMessage()

    if #farmSpots == 0 then
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        updateToggleButton()
        return
    end

    local itemHeight = 34
    for i, pos in ipairs(farmSpots) do
        local item = Instance.new("Frame", scroll)
        item.Size = UDim2.new(1, 0, 0, 34)
        item.BackgroundColor3 = colorDarkGray

        local coord = Instance.new("TextLabel", item)
        coord.Size = UDim2.new(0.5, 0, 1, 0)
        coord.Position = UDim2.new(0.02, 0, 0, 0)
        
        if autoTeleport and i == currentSpot then
            coord.Text = string.format("→ %d. (%.0f, %.0f, %.0f) ←", i, pos.X, pos.Y, pos.Z)
            coord.TextColor3 = colorOrange
        else
            coord.Text = string.format("%d. (%.0f, %.0f, %.0f)", i, pos.X, pos.Y, pos.Z)
            coord.TextColor3 = colorTextWhite
        end
        
        coord.BackgroundTransparency = 1
        coord.TextXAlignment = Enum.TextXAlignment.Left
        coord.Font = Enum.Font.SourceSansBold
        coord.TextScaled = false
        coord.TextSize = 12
        coord.AutoLocalize = false
        spotUIElements[i] = coord

        local tp = Instance.new("TextButton", item)
        tp.Size = UDim2.new(0.23, 0, 1, 0)
        tp.Position = UDim2.new(0.53, 0, 0, 0)
        tp.Text = "TELEPORT"
        tp.Font = Enum.Font.SourceSansBold
        tp.TextScaled = false
        tp.TextSize = 12
        tp.BackgroundColor3 = colorOrange
        tp.TextColor3 = colorTextBlack
        tp.AutoLocalize = false
        Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 4)

        local del = Instance.new("TextButton", item)
        del.Size = UDim2.new(0.23, 0, 1, 0)
        del.Position = UDim2.new(0.76, 0, 0, 0)
        del.Text = "DELETE"
        del.Font = Enum.Font.SourceSansBold
        del.TextScaled = false
        del.TextSize = 12
        del.BackgroundColor3 = colorRed
        del.TextColor3 = colorTextBlack
        del.AutoLocalize = false
        Instance.new("UICorner", del).CornerRadius = UDim.new(0, 4)

        tp.MouseButton1Click:Connect(function()
            playButtonSound()
            createRippleEffect(tp)
            addCooldownEffect(tp, 0.5)
            safeTeleport(pos)
            flashButton(tp, Color3.fromRGB(255, 150, 20))
        end)
        
        del.MouseButton1Click:Connect(function()
            playButtonSound()
            createRippleEffect(del)
            addCooldownEffect(del, 0.3)
            table.remove(farmSpots, i)
            refreshList()
            updateToggleButton()
            saveData()
            flashButton(del, Color3.fromRGB(200, 60, 60))
        end)
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, #farmSpots * itemHeight)
    updateToggleButton()
end

-- ========== EVENT HANDLERS ==========
addCurrent.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(addCurrent)
    addCooldownEffect(addCurrent, 0.3)
    local ok, root = pcall(getRoot)
    if ok and root then
        table.insert(farmSpots, root.Position)
        refreshList()
        saveData()
        flashButton(addCurrent, Color3.fromRGB(255, 150, 20))
    end
end)

addCustom.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(addCustom)
    addCooldownEffect(addCustom, 0.3)
    coordInput.Text = ""
    coordInput.PlaceholderText = "Example: 10,10,10"
    popup.Visible = true
    task.wait(0.1)
    coordInput:CaptureFocus()
end)

cancel.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(cancel)
    addCooldownEffect(cancel, 0.3)
    popup.Visible = false
end)

confirm.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(confirm)
    addCooldownEffect(confirm, 0.3)
    local input = coordInput.Text:gsub("%s+", "")
    local x, y, z = input:match("^([%d%.-]+),([%d%.-]+),([%d%.-]+)$")
    
    if x and y and z then
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        if x and y and z and math.abs(x) < 100000 and math.abs(y) < 100000 and math.abs(z) < 100000 then
            table.insert(farmSpots, Vector3.new(x, y, z))
            refreshList()
            saveData()
            popup.Visible = false
            flashButton(addCustom, Color3.fromRGB(255, 150, 20))
            return
        end
    end
    coordInput.Text = ""
    coordInput.PlaceholderText = "Invalid format!"
    task.wait(1.5)
    coordInput.PlaceholderText = "Example: 10,10,10"
end)

coordInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        confirm.MouseButton1Click:Wait()
    end
end)

clearButton.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(clearButton)
    addCooldownEffect(clearButton, 0.5)
    confirmPopup.Visible = true -- Tampilkan popup
end)

confirmYes.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(confirmYes)
    addCooldownEffect(confirmYes, 0.3)
    
    farmSpots = {}
    currentSpot = 1
    refreshList()
    saveData()
    flashButton(clearButton, Color3.fromRGB(200, 60, 60))
    confirmPopup.Visible = false
end)

confirmNo.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(confirmNo)
    addCooldownEffect(confirmNo, 0.3)
    confirmPopup.Visible = false
end)

toggleButton.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(toggleButton)
    addCooldownEffect(toggleButton, 0.3)
    
    if #farmSpots == 0 then
        -- PERUBAHAN: Anti-spam notifikasi
        if canSendErrorNotif then
            canSendErrorNotif = false
            createCustomNotification("Error", "No positions have been added yet.", 3)
            playNotifySound()
            task.spawn(function()
                task.wait(3)
                canSendErrorNotif = true
            end)
        end
        return 
    end
    
    autoTeleport = not autoTeleport
    if autoTeleport then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = colorOrange
        toggleButton.TextColor3 = colorTextBlack
        flashButton(toggleButton, Color3.fromRGB(255, 150, 20))
        currentSpot = 1
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = colorRed
        toggleButton.TextColor3 = colorTextBlack
        flashButton(toggleButton, Color3.fromRGB(200, 60, 60))
        updateTeleportHighlight(nil, currentSpot)
    end
end)

hideButton.MouseButton1Click:Connect(function()
    playButtonSound()
    playHideSound()
    createRippleEffect(hideButton)
    addCooldownEffect(hideButton, 0.3)
    frame.Visible = false
    showButton.Visible = true
    popup.Visible = false
    confirmPopup.Visible = false
    pauseBackgroundSound()
end)

showButton.MouseButton1Click:Connect(function()
    playButtonSound()
    playShowSound()
    createRippleEffect(showButton)
    addCooldownEffect(showButton, 0.3)
    frame.Visible = true
    showButton.Visible = false
    playBackgroundSound()
end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        playButtonSound()
        frame.Visible = not frame.Visible
        showButton.Visible = not frame.Visible
        popup.Visible = false
        confirmPopup.Visible = false
        
        if frame.Visible then
            playShowSound()
            playBackgroundSound()
        else
            playHideSound()
            pauseBackgroundSound()
        end
    end
end)

delayInput:GetPropertyChangedSignal("Text"):Connect(function()
    delayInput.Text = delayInput.Text:gsub("[^%d%.]", "")
end)

-- AUTO TELEPORT LOOP
task.spawn(function()
    while true do
        task.wait(0.1)
        if autoTeleport and #farmSpots > 0 and canTeleport then
            local delayTime = tonumber(delayInput.Text) or 0
            local oldIndex = nil
            
            for i, spot in ipairs(farmSpots) do
                if not autoTeleport then 
                    updateTeleportHighlight(nil, oldIndex)
                    break 
                end
                
                currentSpot = i
                updateTeleportHighlight(currentSpot, oldIndex)
                safeTeleport(spot)
                task.wait(math.clamp(delayTime, 0, 60))
                oldIndex = i
                
                if not autoTeleport then
                    updateTeleportHighlight(nil, oldIndex)
                    break
                end
            end
            
            if autoTeleport then
                updateTeleportHighlight(nil, oldIndex)
                currentSpot = 1
            end
        end
    end
end)

-- ERROR RECOVERY
player.CharacterAdded:Connect(function()
    task.wait(1)
    if autoTeleport and #farmSpots > 0 then
        currentSpot = math.max(1, currentSpot - 1)
    end
end)


-- ========== URUTAN LOADING YANG DIPERBAIKI ==========

-- 1. Muat data dari file
loadData() 

-- 2. Siapkan UI di background (masih frame.Visible = false)
refreshList()
updateToggleButton()

-- 3. Inisialisasi BGM (Volume masih 0)
initializeBackgroundSound() 

-- 4. Kirim notifikasi "Selesai"
playNotifySound()
createCustomNotification(
    "Teleport Tools", 
    "Script Successfully Loaded\n" .. #farmSpots .. " positions loaded.", 
    5
)

-- 5. Tunggu 5 detik (durasi notifikasi)
task.wait(5) 

-- 6. Baru tampilkan UI dan naikkan volume BGM
frame.Visible = true
playBackgroundSound() -- Ini akan tween volume dari 0 ke 0.3
