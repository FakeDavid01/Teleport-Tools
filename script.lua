local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- ========== ANTI-DUPLICATE SCRIPT ==========
-- Hapus script sebelumnya jika ada
if player.PlayerGui:FindFirstChild("TeleportUI") then
    player.PlayerGui:FindFirstChild("TeleportUI"):Destroy()
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportUI"
gui.ResetOnSpawn = false

-- ========== CUSTOM NOTIFICATION SYSTEM ==========
local function createCustomNotification(title, text, duration)
    duration = duration or 5
    
    local notificationGui = Instance.new("ScreenGui", player.PlayerGui)
    notificationGui.Name = "CustomNotification"
    notificationGui.ResetOnSpawn = false
    
    local notificationFrame = Instance.new("Frame", notificationGui)
    notificationFrame.Size = UDim2.new(0, 300, 0, 100)
    notificationFrame.Position = UDim2.new(1, 350, 1, -120) -- Start from right outside
    notificationFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    notificationFrame.BorderSizePixel = 0
    Instance.new("UICorner", notificationFrame).CornerRadius = UDim.new(0, 8)
    
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextScaled = true
    titleLabel.AutoLocalize = false
    Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 8)
    
    local textLabel = Instance.new("TextLabel", notificationFrame)
    textLabel.Text = text
    textLabel.Size = UDim2.new(1, -20, 0, 60)
    textLabel.Position = UDim2.new(0, 10, 0, 35)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    textLabel.TextScaled = false
    textLabel.AutoLocalize = false
    
    -- ANIMATION IN (SMOOTH ENTRY)
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -120)
    })
    
    -- ANIMATION OUT (SMOOTH EXIT)
    local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 350, 1, -120)
    })
    
    -- Play entry animation
    tweenIn:Play()
    
    -- Auto remove after duration
    task.spawn(function()
        task.wait(duration)
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
    
    return notificationGui
end

-- ========== BASIC UI CREATION FIRST ==========

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 320)
frame.Position = UDim2.new(0.5, -150, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

-- TITLE BAR
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local title = Instance.new("TextLabel", titleBar)
title.Text = "Teleport Tools"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.03, 0, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.AutoLocalize = false

local hideButton = Instance.new("TextButton", titleBar)
hideButton.Size = UDim2.new(0.25, 0, 0.9, 0)
hideButton.Position = UDim2.new(0.72, 0, 0.05, 0)
hideButton.Text = "Hide UI"
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextScaled = true
hideButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.AutoLocalize = false
Instance.new("UICorner", hideButton).CornerRadius = UDim.new(0, 4)

-- CONTENT
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1

-- AUTO TELEPORT
local toggleLabel = Instance.new("TextLabel", content)
toggleLabel.Text = "Auto Teleport:"
toggleLabel.Size = UDim2.new(0.6, 0, 0, 25)
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
toggleLabel.TextColor3 = Color3.new(1, 1, 1)
toggleLabel.BackgroundTransparency = 1
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.TextScaled = true
toggleLabel.Font = Enum.Font.SourceSansBold
toggleLabel.AutoLocalize = false

local toggleButton = Instance.new("TextButton", content)
toggleButton.Size = UDim2.new(0.35, 0, 0, 25)
toggleButton.Position = UDim2.new(0.63, 0, 0, 0)
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.AutoLocalize = false
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

-- DELAY INPUT
local delayLabel = Instance.new("TextLabel", content)
delayLabel.Text = "Delay Teleport (s):"
delayLabel.Size = UDim2.new(0.6, 0, 0, 25)
delayLabel.Position = UDim2.new(0, 0, 0, 30)
delayLabel.TextColor3 = Color3.new(1, 1, 1)
delayLabel.BackgroundTransparency = 1
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.TextScaled = true
delayLabel.Font = Enum.Font.SourceSansBold
delayLabel.AutoLocalize = false

local delayInput = Instance.new("TextBox", content)
delayInput.Size = UDim2.new(0.35, 0, 0, 25)
delayInput.Position = UDim2.new(0.63, 0, 0, 30)
delayInput.Text = "0"
delayInput.Font = Enum.Font.SourceSans
delayInput.TextScaled = true
delayInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.AutoLocalize = false
Instance.new("UICorner", delayInput).CornerRadius = UDim.new(0, 4)

-- BUTTONS
local addCurrent = Instance.new("TextButton", content)
addCurrent.Text = "Add Current Pos"
addCurrent.Size = UDim2.new(0.48, 0, 0, 30)
addCurrent.Position = UDim2.new(0, 0, 0, 65)
addCurrent.Font = Enum.Font.SourceSansBold
addCurrent.TextScaled = true
addCurrent.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
addCurrent.TextColor3 = Color3.new(1, 1, 1)
addCurrent.AutoLocalize = false
Instance.new("UICorner", addCurrent).CornerRadius = UDim.new(0, 4)

local addCustom = Instance.new("TextButton", content)
addCustom.Text = "Add Custom Pos"
addCustom.Size = UDim2.new(0.48, 0, 0, 30)
addCustom.Position = UDim2.new(0.52, 0, 0, 65)
addCustom.Font = Enum.Font.SourceSansBold
addCustom.TextScaled = true
addCustom.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
addCustom.TextColor3 = Color3.new(1, 1, 1)
addCustom.AutoLocalize = false
Instance.new("UICorner", addCustom).CornerRadius = UDim.new(0, 4)

local clearButton = Instance.new("TextButton", content)
clearButton.Text = "Clear All Position"
clearButton.Size = UDim2.new(1, 0, 0, 30)
clearButton.Position = UDim2.new(0, 0, 0, 100)
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextScaled = true
clearButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
clearButton.TextColor3 = Color3.new(1, 1, 1)
clearButton.AutoLocalize = false
Instance.new("UICorner", clearButton).CornerRadius = UDim.new(0, 4)

-- SCROLL
local scroll = Instance.new("ScrollingFrame", content)
scroll.Size = UDim2.new(1, 0, 1, -140)
scroll.Position = UDim2.new(0, 0, 0, 135)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scroll.ScrollBarThickness = 6
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 4)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ========== EMPTY STATE MESSAGE ==========
local emptyMessage = Instance.new("TextLabel", scroll)
emptyMessage.Name = "EmptyMessage"
emptyMessage.Text = "No positions added yet!\nClick 'Add Current Pos' or 'Add Custom Pos' to start."
emptyMessage.Size = UDim2.new(1, -10, 0, 60)
emptyMessage.Position = UDim2.new(0, 5, 0, 10)
emptyMessage.TextColor3 = Color3.fromRGB(150, 150, 150)
emptyMessage.BackgroundTransparency = 1
emptyMessage.TextWrapped = true
emptyMessage.Font = Enum.Font.SourceSans
emptyMessage.TextSize = 14
emptyMessage.TextScaled = false
emptyMessage.AutoLocalize = false
emptyMessage.Visible = true

-- POPUP
local popup = Instance.new("Frame", gui)
popup.Size = UDim2.new(0, 220, 0, 120)
popup.Position = UDim2.new(0.5, -110, 0.5, -60)
popup.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
popup.Visible = false
Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)

local pTitle = Instance.new("TextLabel", popup)
pTitle.Text = "Add Custom Position"
pTitle.Size = UDim2.new(1, 0, 0, 25)
pTitle.Font = Enum.Font.SourceSansBold
pTitle.TextScaled = true
pTitle.TextColor3 = Color3.new(1, 1, 1)
pTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
pTitle.AutoLocalize = false
Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0, 4)

local coordInput = Instance.new("TextBox", popup)
coordInput.PlaceholderText = "Example: 10,10,10"
coordInput.Size = UDim2.new(1, -20, 0, 30)
coordInput.Position = UDim2.new(0, 10, 0, 35)
coordInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
coordInput.TextColor3 = Color3.new(1, 1, 1)
coordInput.Font = Enum.Font.SourceSans
coordInput.TextScaled = true
coordInput.AutoLocalize = false
Instance.new("UICorner", coordInput).CornerRadius = UDim.new(0, 4)

local confirm = Instance.new("TextButton", popup)
confirm.Text = "Confirm"
confirm.Size = UDim2.new(0.45, 0, 0, 25)
confirm.Position = UDim2.new(0.05, 0, 1, -30)
confirm.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
confirm.Font = Enum.Font.SourceSansBold
confirm.TextScaled = true
confirm.TextColor3 = Color3.new(1, 1, 1)
confirm.AutoLocalize = false
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 4)

local cancel = Instance.new("TextButton", popup)
cancel.Text = "Cancel"
cancel.Size = UDim2.new(0.45, 0, 0, 25)
cancel.Position = UDim2.new(0.5, 0, 1, -30)
cancel.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
cancel.Font = Enum.Font.SourceSansBold
cancel.TextScaled = true
cancel.TextColor3 = Color3.new(1, 1, 1)
cancel.AutoLocalize = false
Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 4)

-- SHOW BUTTON
local showButton = Instance.new("TextButton", gui)
showButton.Size = UDim2.new(0, 100, 0, 40)
showButton.Position = UDim2.new(1, -110, 0, 10)
showButton.Text = "Show UI"
showButton.Font = Enum.Font.SourceSansBold
showButton.TextScaled = true
showButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
showButton.TextColor3 = Color3.new(1, 1, 1)
showButton.Visible = false
showButton.AutoLocalize = false
Instance.new("UICorner", showButton).CornerRadius = UDim.new(0, 6)

-- ========== DATA & CORE FUNCTIONS ==========
local farmSpots = {}
local autoTeleport = false
local canTeleport = true
local currentSpot = 1

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

-- WORKING SOUND FUNCTION
local function playSound(soundId, volume)
    volume = volume or 0.5
    local success, result = pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = volume
        sound.Parent = workspace
        sound:Play()
        
        -- Auto cleanup
        game:GetService("Debris"):AddItem(sound, 5)
        return true
    end)
    return success
end

-- SOUND SHORTCUTS
local function playButtonSound()
    playSound(6895079853, 0.4)  -- Button click sound
end

local function playHideSound()
    playSound(154157386, 0.5)   -- Hide UI sound
end

local function playShowSound()
    playSound(154147007, 0.5)   -- Show UI sound
end

-- NOTIFICATION SOUND
local function playNotifySound()
    playSound(18595195017, 0.6)  -- Sound notifikasi baru
end

-- WORKING BACKGROUND SOUND (FIXED VERSION)
local backgroundSound = nil
local isSoundLoaded = false

local function initializeBackgroundSound()
    if backgroundSound then return true end
    
    local success = pcall(function()
        backgroundSound = Instance.new("Sound")
        backgroundSound.SoundId = "rbxassetid://1848354536"
        backgroundSound.Volume = 0.3  -- Default volume when UI is visible
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
        initializeBackgroundSound()
    else
        -- Smooth volume transition
        local tween = TweenService:Create(backgroundSound, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Volume = 0.3
        })
        tween:Play()
    end
end

local function pauseBackgroundSound()
    if backgroundSound then
        -- Smooth volume transition to mute
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

-- SIMPLE RIPPLE EFFECT
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

-- COOLDOWN EFFECT
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

local function updateEmptyMessage()
    if scroll:FindFirstChild("EmptyMessage") then
        scroll.EmptyMessage.Visible = (#farmSpots == 0)
    end
end

local function updateToggleButton()
    if #farmSpots == 0 then
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
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

local function refreshList()
	-- Clear existing items
	for _, c in pairs(scroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	-- Show empty message if no positions
	updateEmptyMessage()

	-- If no positions, stop here
	if #farmSpots == 0 then
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		updateToggleButton()
		return
	end

	local itemHeight = 34
	for i, pos in ipairs(farmSpots) do
		local item = Instance.new("Frame", scroll)
		item.Size = UDim2.new(1, 0, 0, 34)
		item.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

		local coord = Instance.new("TextLabel", item)
		coord.Size = UDim2.new(0.55, 0, 1, 0)
		coord.Position = UDim2.new(0.02, 0, 0, 0)
		
		if autoTeleport and i == currentSpot then
			coord.Text = string.format("→ %d. (%.2f, %.2f, %.2f) ←", i, pos.X, pos.Y, pos.Z)
			coord.TextColor3 = Color3.fromRGB(255, 255, 100)
		else
			coord.Text = string.format("%d. (%.2f, %.2f, %.2f)", i, pos.X, pos.Y, pos.Z)
			coord.TextColor3 = Color3.new(1, 1, 1)
		end
		
		coord.BackgroundTransparency = 1
		coord.TextXAlignment = Enum.TextXAlignment.Left
		coord.Font = Enum.Font.SourceSansBold
		coord.TextSize = 14
		coord.AutoLocalize = false

		local tp = Instance.new("TextButton", item)
		tp.Size = UDim2.new(0.22, 0, 1, 0)
		tp.Position = UDim2.new(0.59, 0, 0, 0)
		tp.Text = "TELEPORT"
		tp.Font = Enum.Font.SourceSansBold
		tp.TextSize = 14
		tp.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
		tp.TextColor3 = Color3.new(1, 1, 1)
		tp.AutoLocalize = false
		Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 4)

		local del = Instance.new("TextButton", item)
		del.Size = UDim2.new(0.15, 0, 1, 0)
		del.Position = UDim2.new(0.82, -4, 0, 0)
		del.Text = "DELETE"
		del.Font = Enum.Font.SourceSansBold
		del.TextSize = 14
		del.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
		del.TextColor3 = Color3.new(1, 1, 1)
		del.AutoLocalize = false
		Instance.new("UICorner", del).CornerRadius = UDim.new(0, 4)

		tp.MouseButton1Click:Connect(function()
            playButtonSound()
            createRippleEffect(tp)
            addCooldownEffect(tp, 0.5)
			safeTeleport(pos)
			flashButton(tp, Color3.fromRGB(100, 200, 100))
		end)
		
		del.MouseButton1Click:Connect(function()
            playButtonSound()
            createRippleEffect(del)
            addCooldownEffect(del, 0.3)
			table.remove(farmSpots, i)
			refreshList()
			updateToggleButton()
			flashButton(del, Color3.fromRGB(255, 100, 100))
		end)
	end

	scroll.CanvasSize = UDim2.new(0, 0, 0, #farmSpots * itemHeight)
	updateToggleButton()
end

-- ========== EVENT HANDLERS ==========

-- ADD CURRENT POSITION
addCurrent.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(addCurrent)
    addCooldownEffect(addCurrent, 0.3)
	local ok, root = pcall(getRoot)
	if ok and root then
		table.insert(farmSpots, root.Position)
		refreshList()
		flashButton(addCurrent, Color3.fromRGB(100, 200, 100))
	end
end)

-- CUSTOM POSITION EVENTS
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
			popup.Visible = false
            flashButton(addCustom, Color3.fromRGB(100, 100, 200))
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
	farmSpots = {}
    currentSpot = 1
	refreshList()
    flashButton(clearButton, Color3.fromRGB(255, 100, 100))
end)

-- TOGGLE BUTTON
toggleButton.MouseButton1Click:Connect(function()
    playButtonSound()
    createRippleEffect(toggleButton)
    addCooldownEffect(toggleButton, 0.3)
    if #farmSpots == 0 then return end
    
	autoTeleport = not autoTeleport
	if autoTeleport then
		toggleButton.Text = "ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
        flashButton(toggleButton, Color3.fromRGB(100, 255, 100))
	else
		toggleButton.Text = "OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
        flashButton(toggleButton, Color3.fromRGB(255, 100, 100))
	end
end)

-- HIDE / SHOW UI
hideButton.MouseButton1Click:Connect(function()
    playButtonSound()
    playHideSound()
    createRippleEffect(hideButton)
    addCooldownEffect(hideButton, 0.3)
    frame.Visible = false
    showButton.Visible = true
    popup.Visible = false
    pauseBackgroundSound() -- Smooth pause dengan volume transition
end)

showButton.MouseButton1Click:Connect(function()
    playButtonSound()
    playShowSound()
    createRippleEffect(showButton)
    addCooldownEffect(showButton, 0.3)
    frame.Visible = true
    showButton.Visible = false
    playBackgroundSound() -- Smooth play dengan volume transition
end)

-- KEYBOARD SHORTCUT
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        playButtonSound()
        frame.Visible = not frame.Visible
        showButton.Visible = not frame.Visible
        popup.Visible = false
        
        if frame.Visible then
            playShowSound()
            playBackgroundSound() -- Smooth volume transition to 0.3
        else
            playHideSound()
            pauseBackgroundSound() -- Smooth volume transition to 0
        end
    end
end)

-- NUMERIC FILTER
delayInput:GetPropertyChangedSignal("Text"):Connect(function()
	delayInput.Text = delayInput.Text:gsub("[^%d%.]", "")
end)

-- AUTO TELEPORT LOOP
task.spawn(function()
	while true do
		task.wait(0.1)
		if autoTeleport and #farmSpots > 0 and canTeleport then
			local delayTime = tonumber(delayInput.Text) or 0
			for i, spot in ipairs(farmSpots) do
				if not autoTeleport then break end
                currentSpot = i
                refreshList()
				safeTeleport(spot)
				task.wait(math.clamp(delayTime, 0, 60))
			end
            currentSpot = 1
            refreshList()
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

-- GLOWING EFFECTS
task.spawn(function()
    while true do
        for i = 0, 1, 0.05 do
            local r = 60 + math.sin(i * math.pi) * 40
            local g = 100 + math.sin(i * math.pi) * 50
            addCurrent.BackgroundColor3 = Color3.fromRGB(r, g, 60)
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while true do
        for i = 0, 1, 0.05 do
            local r = 80 + math.sin(i * math.pi) * 30
            local g = 80 + math.sin(i * math.pi) * 30  
            local b = 120 + math.sin(i * math.pi) * 50
            addCustom.BackgroundColor3 = Color3.fromRGB(r, g, b)
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while true do
        for i = 0, 1, 0.05 do
            local r = 120 + math.sin(i * math.pi) * 50
            local g = 40 + math.sin(i * math.pi) * 20
            local b = 40 + math.sin(i * math.pi) * 20
            clearButton.BackgroundColor3 = Color3.fromRGB(r, g, b)
            task.wait(0.1)
        end
    end
end)

-- INITIALIZE BACKGROUND SOUND ON START
task.spawn(function()
    task.wait(2) -- Wait for everything to load
    initializeBackgroundSound()
end)

-- INITIAL UPDATE
refreshList()
updateToggleButton()

-- SEND CUSTOM NOTIFICATION WHEN LOADED (WITH SMOOTH ANIMATIONS)
playNotifySound()
createCustomNotification("Teleport Tools", "Script Successfully Loaded\nPress RightCtrl to Show/Hide UI", 5)
