local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "MM2Hub"
gui.ResetOnSpawn = false
gui.Enabled = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 340)
main.Position = UDim2.new(0.5, -200, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = Color3.fromRGB(90, 90, 90)

local topbar = Instance.new("TextLabel", main)
topbar.Size = UDim2.new(1, 0, 0, 24)
topbar.BackgroundTransparency = 1
topbar.Text = ""
topbar.Name = "Topbar"
topbar.Active = true

local dragging = false
local dragInput, dragStart, startPos

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local tabHolder = Instance.new("Frame", main)
tabHolder.Size = UDim2.new(0, 120, 1, -30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", tabHolder).CornerRadius = UDim.new(0, 10)
local tabList = Instance.new("UIListLayout", tabHolder)
tabList.Padding = UDim.new(0, 6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
local tabPadding = Instance.new("UIPadding", tabHolder)
tabPadding.PaddingLeft = UDim.new(0, 10)
tabPadding.PaddingTop = UDim.new(0, 10)

local pageHolder = Instance.new("Frame", main)
pageHolder.Position = UDim2.new(0, 120, 0, 30)
pageHolder.Size = UDim2.new(1, -120, 1, -30)
pageHolder.BackgroundTransparency = 1

local sections = { "Visuals", "Combat", "Movement", "Misc" }
local pages = {}
local createdESP = {}
local createdLabels = {}
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "MM2ESPFolder"

local espEnabled = false
local gunESPEnabled = false
local showRolesEnabled = false
local gunBillboard = nil
local sheriffName = nil

for _, name in ipairs(sections) do
	local btn = Instance.new("TextButton", tabHolder)
	btn.Size = UDim2.new(0, 100, 0, 32)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local page = Instance.new("ScrollingFrame", pageHolder)
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.CanvasSize = UDim2.new(0, 0, 2, 0)
	page.ScrollBarThickness = 3
	page.BackgroundTransparency = 1
	page.Visible = false
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	local padding = Instance.new("UIPadding", page)
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	table.insert(pages, page)
	btn.MouseButton1Click:Connect(function()
		for _, p in ipairs(pages) do p.Visible = false end
		page.Visible = true
	end)
end

pages[1].Visible = true

local espToggle = Instance.new("TextButton", pages[1])
espToggle.Size = UDim2.new(1, -10, 0, 32)
espToggle.Text = "Toggle ESP"
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.Font = Enum.Font.Gotham
espToggle.TextSize = 16
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 6)

local gunToggle = Instance.new("TextButton", pages[1])
gunToggle.Size = UDim2.new(1, -10, 0, 32)
gunToggle.Text = "Toggle Gun ESP"
gunToggle.TextColor3 = Color3.new(1, 1, 1)
gunToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gunToggle.Font = Enum.Font.Gotham
gunToggle.TextSize = 16
Instance.new("UICorner", gunToggle).CornerRadius = UDim.new(0, 6)

local roleToggle = Instance.new("TextButton", pages[1])
roleToggle.Size = UDim2.new(1, -10, 0, 32)
roleToggle.Text = "Toggle Show Roles"
roleToggle.TextColor3 = Color3.new(1, 1, 1)
roleToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
roleToggle.Font = Enum.Font.Gotham
roleToggle.TextSize = 16
Instance.new("UICorner", roleToggle).CornerRadius = UDim.new(0, 6)

local function getRole(player)
	local b = player:FindFirstChild("Backpack")
	local c = player.Character
	if b and b:FindFirstChild("Gun") or (c and c:FindFirstChild("Gun")) then
		if not sheriffName or sheriffName == player.Name then
			sheriffName = player.Name
			return "Sheriff"
		else
			return "Hero"
		end
	elseif b and b:FindFirstChild("Knife") or (c and c:FindFirstChild("Knife")) then
		return "Murderer"
	end
	return "Innocent"
end

local function updateLabel(player)
	if not player.Character or not player.Character:FindFirstChild("Head") then return end
	local label = createdLabels[player]
	if not label then
		label = Instance.new("BillboardGui", ESPFolder)
		label.Size = UDim2.new(0, 100, 0, 20)
		label.StudsOffset = Vector3.new(0, 2.5, 0)
		label.AlwaysOnTop = true
		label.Adornee = player.Character.Head
		local text = Instance.new("TextLabel", label)
		text.Size = UDim2.new(1, 0, 1, 0)
		text.BackgroundTransparency = 1
		text.TextStrokeTransparency = 0
		text.Font = Enum.Font.GothamBold
		text.TextScaled = true
		createdLabels[player] = label
	end
	local role = getRole(player)
	local t = label:FindFirstChildOfClass("TextLabel")
	if t then
		t.Text = role
		if role == "Murderer" then
			t.TextColor3 = Color3.fromRGB(255, 0, 0)
		elseif role == "Sheriff" then
			t.TextColor3 = Color3.fromRGB(0, 125, 255)
		elseif role == "Hero" then
			t.TextColor3 = Color3.fromRGB(255, 255, 0)
		else
			t.TextColor3 = Color3.fromRGB(0, 255, 0)
		end
	end
end

local function applyESP(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	if not createdESP[player] or createdESP[player].Adornee ~= player.Character then
		if createdESP[player] then createdESP[player]:Destroy() end
		local h = Instance.new("Highlight")
		h.Adornee = player.Character
		h.FillTransparency = 0.25
		h.OutlineTransparency = 0
		h.OutlineColor = Color3.new(0, 0, 0)
		h.Parent = ESPFolder
		createdESP[player] = h
	end
	if showRolesEnabled then updateLabel(player) end
	local role = getRole(player)
	if role == "Murderer" then
		createdESP[player].FillColor = Color3.fromRGB(255, 0, 0)
	elseif role == "Sheriff" then
		createdESP[player].FillColor = Color3.fromRGB(0, 125, 255)
	elseif role == "Hero" then
		createdESP[player].FillColor = Color3.fromRGB(255, 255, 0)
	else
		createdESP[player].FillColor = Color3.fromRGB(0, 255, 0)
	end
end

local function refreshAllESP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player and p.Character then
			applyESP(p)
		end
	end
end

local function updateGunESP()
	if gunBillboard then gunBillboard:Destroy() gunBillboard = nil end
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Tool") and v.Name == "Gun" and v.Parent == workspace then
			local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
			if handle then
				gunBillboard = Instance.new("BillboardGui", v)
				gunBillboard.Size = UDim2.new(0, 100, 0, 30)
				gunBillboard.AlwaysOnTop = true
				gunBillboard.Adornee = handle
				local label = Instance.new("TextLabel", gunBillboard)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = "Gun"
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextStrokeTransparency = 0
				label.Font = Enum.Font.GothamBold
				label.TextScaled = true
			end
		end
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if gunESPEnabled and obj:IsA("Tool") and obj.Name == "Gun" then
		task.wait(0.25)
		updateGunESP()
	end
end)

local function resetAll()
	for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
	createdESP = {}
	createdLabels = {}
	sheriffName = nil
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(1)
		if espEnabled then applyESP(p) end
	end)
end)

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player then
		p.CharacterAdded:Connect(function()
			task.wait(1)
			if espEnabled then applyESP(p) end
		end)
	end
end

RunService.RenderStepped:Connect(function()
	if workspace:FindFirstChild("Lobby") then sheriffName = nil end
	if espEnabled then refreshAllESP() else resetAll() end
end)

espToggle.MouseButton1Click:Connect(function() espEnabled = not espEnabled end)
gunToggle.MouseButton1Click:Connect(function() gunESPEnabled = not gunESPEnabled end)
roleToggle.MouseButton1Click:Connect(function() showRolesEnabled = not showRolesEnabled end)

gui.Enabled = true
main.Visible = true
main.BackgroundTransparency = 1
tabHolder.Position = UDim2.new(0, -120, 0, 30)
pageHolder.Position = UDim2.new(0, 400, 0, 30)
TweenService:Create(main, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(tabHolder, TweenInfo.new(0.6), {Position = UDim2.new(0, 0, 0, 30)}):Play()
TweenService:Create(pageHolder, TweenInfo.new(0.6), {Position = UDim2.new(0, 120, 0, 30)}):Play()

local visible = true
UIS.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.RightControl and not gp then
		if visible then
			TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			task.wait(0.3)
			gui.Enabled = false
		else
			gui.Enabled = true
			TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
		end
		visible = not visible
	end
end)
