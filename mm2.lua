local Players=game:GetService("Players")
local CoreGui=game:GetService("CoreGui")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")

local gui=Instance.new("ScreenGui",CoreGui)
gui.Name="BustinHub"
gui.IgnoreGuiInset=true
gui.ResetOnSpawn=false

local mainFrame=Instance.new("Frame",gui)
mainFrame.Size=UDim2.new(0,520,0,400)
mainFrame.Position=UDim2.new(0.5,-260,0.5,-200)
mainFrame.BackgroundColor3=Color3.fromRGB(25,25,25)
mainFrame.BackgroundTransparency=0.15
mainFrame.BorderSizePixel=0
mainFrame.Active=true
mainFrame.Draggable=true
Instance.new("UICorner",mainFrame).CornerRadius=UDim.new(0,12)

local title=Instance.new("TextLabel",mainFrame)
title.Size=UDim2.new(1,0,0,45)
title.BackgroundTransparency=1
title.Text="Bustin Hub [BETA]"
title.TextColor3=Color3.fromRGB(255,255,255)
title.Font=Enum.Font.GothamSemibold
title.TextSize=22
title.Parent=mainFrame

local sidebar=Instance.new("Frame",mainFrame)
sidebar.Size=UDim2.new(0,140,1,-45)
sidebar.Position=UDim2.new(0,0,0,45)
sidebar.BackgroundTransparency=1
sidebar.Parent=mainFrame

local contentFrame=Instance.new("Frame",mainFrame)
contentFrame.Size=UDim2.new(1,-150,1,-50)
contentFrame.Position=UDim2.new(0,150,0,45)
contentFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
contentFrame.BackgroundTransparency=0.1
contentFrame.BorderSizePixel=0
contentFrame.Visible=false
Instance.new("UICorner",contentFrame).CornerRadius=UDim.new(0,10)
contentFrame.Parent=mainFrame

local function clearContent()
	for _,c in pairs(contentFrame:GetChildren())do
		if not c:IsA("UICorner")then c:Destroy()end
	end
end

local VisualStates={
	MurdererESP=false,
	SheriffESP=false,
	AllPlayerESP=false
}

local function getRoleColor(p)
	local role
	local check=function(container)
		for _,v in pairs(container:GetChildren())do
			if v:IsA("Tool")then
				if v.Name=="Knife"then role="Murderer"end
				if v.Name=="Gun"then role="Sheriff"end
			end
		end
	end
	if p.Character then check(p.Character)end
	if p:FindFirstChild("Backpack") then check(p.Backpack)end
	if VisualStates.AllPlayerESP then
		if role=="Murderer"then return Color3.fromRGB(255,0,0)
		elseif role=="Sheriff"then return Color3.fromRGB(0,0,255)
		else return Color3.fromRGB(0,255,0)end
	end
	if role=="Murderer" and VisualStates.MurdererESP then return Color3.fromRGB(255,0,0)end
	if role=="Sheriff" and VisualStates.SheriffESP then return Color3.fromRGB(0,0,255)end
	return nil
end

local function applyESP()
	for _,p in pairs(Players:GetPlayers())do
		if p~=Players.LocalPlayer and p.Character then
			local h=p.Character:FindFirstChild("Highlight")
			if h then h:Destroy()end
			local roleColor=getRoleColor(p)
			if roleColor then
				local h=Instance.new("Highlight",p.Character)
				h.FillColor=roleColor
				h.OutlineColor=Color3.new(1,1,1)
				h.FillTransparency=0.25
				h.OutlineTransparency=0
			end
		end
	end
end

local function refreshESP()
	while true do
		wait(1)
		applyESP()
	end
end

for _,p in pairs(Players:GetPlayers())do
	p.CharacterAdded:Connect(function()
		wait(0.5)
		applyESP()
	end)
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(0.5)
		applyESP()
	end)
end)

task.spawn(refreshESP)
local function makeBox(y,h)
	local b=Instance.new("Frame",contentFrame)
	b.Size=UDim2.new(1,-20,0,h)
	b.Position=UDim2.new(0,10,0,y)
	b.BackgroundColor3=Color3.fromRGB(35,35,35)
	b.BackgroundTransparency=0.1
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
	return b
end

local function showPlayerSection()
	clearContent()
	contentFrame.Visible=true

	local t=Instance.new("TextLabel",contentFrame)
	t.Size=UDim2.new(1,0,0,30)
	t.Position=UDim2.new(0,0,0,0)
	t.BackgroundTransparency=1
	t.Text="Player"
	t.TextColor3=Color3.fromRGB(255,255,255)
	t.Font=Enum.Font.GothamSemibold
	t.TextSize=20
	t.Parent=contentFrame

	local box=makeBox(40,50)
	local b=Instance.new("TextButton",box)
	b.Size=UDim2.new(1,0,1,0)
	b.BackgroundTransparency=1
	b.Text="Execute Infinite Yield"
	b.TextColor3=Color3.fromRGB(255,255,255)
	b.Font=Enum.Font.Gotham
	b.TextSize=16
	b.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end)

	local n=makeBox(100,70)
	local l=Instance.new("TextLabel",n)
	l.Position=UDim2.new(0,10,0,6)
	l.Size=UDim2.new(0.6,0,0,20)
	l.Text="Noclip"
	l.Font=Enum.Font.GothamMedium
	l.TextSize=16
	l.TextColor3=Color3.new(1,1,1)
	l.BackgroundTransparency=1
	l.TextXAlignment=Enum.TextXAlignment.Left

	local d=Instance.new("TextLabel",n)
	d.Position=UDim2.new(0,10,0,34)
	d.Size=UDim2.new(0.8,0,0,18)
	d.Text="Walk through walls"
	d.TextColor3=Color3.fromRGB(180,180,180)
	d.Font=Enum.Font.Gotham
	d.TextSize=13
	d.BackgroundTransparency=1
	d.TextXAlignment=Enum.TextXAlignment.Left

	local t=Instance.new("Frame",n)
	t.Size=UDim2.new(0,50,0,24)
	t.Position=UDim2.new(1,-60,0.5,-12)
	t.BackgroundColor3=Color3.fromRGB(50,50,50)
	Instance.new("UICorner",t).CornerRadius=UDim.new(1,0)
	local k=Instance.new("Frame",t)
	k.Size=UDim2.new(0,20,0,20)
	k.Position=UDim2.new(0,2,0,2)
	k.BackgroundColor3=Color3.fromRGB(120,120,120)
	Instance.new("UICorner",k).CornerRadius=UDim.new(1,0)

	local e=false
	local c
	t.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			e=not e
			if e then
				k:TweenPosition(UDim2.new(1,-22,0,2),"Out","Quad",0.2,true)
				k.BackgroundColor3=Color3.fromRGB(255,255,255)
				c=RunService.Stepped:Connect(function()
					if Players.LocalPlayer.Character then
						for _,v in pairs(Players.LocalPlayer.Character:GetDescendants())do
							if v:IsA("BasePart")then v.CanCollide=false end
						end
					end
				end)
			else
				k:TweenPosition(UDim2.new(0,2,0,2),"Out","Quad",0.2,true)
				k.BackgroundColor3=Color3.fromRGB(120,120,120)
				if c then c:Disconnect()end
			end
		end
	end)
	k.Parent=t

	local ws=makeBox(180,110)
	local wl=Instance.new("TextLabel",ws)
	wl.Position=UDim2.new(0,10,0,8)
	wl.Size=UDim2.new(1,-20,0,20)
	wl.Text="WalkSpeed"
	wl.TextColor3=Color3.new(1,1,1)
	wl.Font=Enum.Font.GothamMedium
	wl.TextSize=16
	wl.TextXAlignment=Enum.TextXAlignment.Left
	wl.BackgroundTransparency=1

	local val=Instance.new("TextLabel",ws)
	val.Size=UDim2.new(0,60,0,18)
	val.Position=UDim2.new(1,-70,0,10)
	val.BackgroundTransparency=1
	val.Text="16"
	val.TextColor3=Color3.fromRGB(255,255,255)
	val.Font=Enum.Font.Gotham
	val.TextSize=14
	val.TextXAlignment=Enum.TextXAlignment.Right

	local s=Instance.new("Frame",ws)
	s.Size=UDim2.new(1,-20,0,6)
	s.Position=UDim2.new(0,10,0,50)
	s.BackgroundColor3=Color3.fromRGB(200,200,200)
	Instance.new("UICorner",s).CornerRadius=UDim.new(1,0)

	local fill=Instance.new("Frame",s)
	fill.BackgroundTransparency=1
	fill.Size=UDim2.new(0,0,1,0)

	local dragging=false
	s.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true mainFrame.Draggable=false end
	end)
	s.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false mainFrame.Draggable=true end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
			local pct=math.clamp((i.Position.X-s.AbsolutePosition.X)/s.AbsoluteSize.X,0,1)
			fill.Size=UDim2.new(pct,0,1,0)
			local spd=math.floor(1+(200-1)*pct)
			val.Text=tostring(spd)
			local h=Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
			if h then h.WalkSpeed=spd end
		end
	end)
	fill.Parent=s

	local reset=Instance.new("TextButton",ws)
	reset.Size=UDim2.new(0,120,0,24)
	reset.Position=UDim2.new(0,10,0,70)
	reset.BackgroundColor3=Color3.fromRGB(50,50,50)
	reset.Text="Reset to Default"
	reset.TextColor3=Color3.new(1,1,1)
	reset.Font=Enum.Font.Gotham
	reset.TextSize=14
	Instance.new("UICorner",reset).CornerRadius=UDim.new(0,6)
	reset.MouseButton1Click:Connect(function()
		val.Text="16"
		fill.Size=UDim2.new((16-1)/(200-1),0,1,0)
		local h=Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if h then h.WalkSpeed=16 end
	end)
end
local function showVisualsSection()
	clearContent()
	contentFrame.Visible=true

	local title=Instance.new("TextLabel",contentFrame)
	title.Size=UDim2.new(1,0,0,30)
	title.Position=UDim2.new(0,0,0,0)
	title.BackgroundTransparency=1
	title.Text="Visuals"
	title.TextColor3=Color3.fromRGB(255,255,255)
	title.Font=Enum.Font.GothamSemibold
	title.TextSize=20
	title.Parent=contentFrame

	local function makeToggle(y,name,desc,stateKey)
		local box=Instance.new("Frame",contentFrame)
		box.Size=UDim2.new(1,-20,0,70)
		box.Position=UDim2.new(0,10,0,y)
		box.BackgroundColor3=Color3.fromRGB(35,35,35)
		box.BackgroundTransparency=0.1
		Instance.new("UICorner",box).CornerRadius=UDim.new(0,8)

		local label=Instance.new("TextLabel",box)
		label.Position=UDim2.new(0,10,0,6)
		label.Size=UDim2.new(0.6,0,0,20)
		label.Text=name
		label.Font=Enum.Font.GothamMedium
		label.TextSize=16
		label.TextColor3=Color3.new(1,1,1)
		label.BackgroundTransparency=1
		label.TextXAlignment=Enum.TextXAlignment.Left

		local description=Instance.new("TextLabel",box)
		description.Position=UDim2.new(0,10,0,34)
		description.Size=UDim2.new(0.8,0,0,18)
		description.Text=desc
		description.TextColor3=Color3.fromRGB(180,180,180)
		description.Font=Enum.Font.Gotham
		description.TextSize=13
		description.BackgroundTransparency=1
		description.TextXAlignment=Enum.TextXAlignment.Left

		local toggle=Instance.new("Frame",box)
		toggle.Size=UDim2.new(0,50,0,24)
		toggle.Position=UDim2.new(1,-60,0.5,-12)
		toggle.BackgroundColor3=Color3.fromRGB(50,50,50)
		Instance.new("UICorner",toggle).CornerRadius=UDim.new(1,0)

		local circle=Instance.new("Frame",toggle)
		circle.Size=UDim2.new(0,20,0,20)
		circle.Position=UDim2.new(0,2,0,2)
		circle.BackgroundColor3=Color3.fromRGB(120,120,120)
		Instance.new("UICorner",circle).CornerRadius=UDim.new(1,0)
		circle.Parent=toggle

		local function updateVisual(state)
			if state then
				circle:TweenPosition(UDim2.new(1,-22,0,2),"Out","Quad",0.2,true)
				circle.BackgroundColor3=Color3.fromRGB(255,255,255)
			else
				circle:TweenPosition(UDim2.new(0,2,0,2),"Out","Quad",0.2,true)
				circle.BackgroundColor3=Color3.fromRGB(120,120,120)
			end
		end

		updateVisual(VisualStates[stateKey])

		toggle.InputBegan:Connect(function(input)
			if input.UserInputType==Enum.UserInputType.MouseButton1 then
				VisualStates[stateKey]=not VisualStates[stateKey]
				updateVisual(VisualStates[stateKey])
				applyESP()
			end
		end)
	end

	makeToggle(40,"Murderer ESP","Shows murderer players through walls","MurdererESP")
	makeToggle(120,"Sheriff ESP","Shows sheriff player","SheriffESP")
	makeToggle(200,"All Player ESP","Shows all players with role-based colors","AllPlayerESP")
	applyESP()
end
local tabs={"AutoFarms","Combat","Misc","Player","Visuals","Settings"}

for i,name in ipairs(tabs)do
	local tab=Instance.new("TextButton",sidebar)
	tab.Size=UDim2.new(1,-20,0,36)
	tab.Position=UDim2.new(0,10,0,(i-1)*42)
	tab.BackgroundColor3=Color3.fromRGB(35,35,35)
	tab.BackgroundTransparency=0.2
	tab.BorderSizePixel=0
	tab.Text=name
	tab.TextColor3=Color3.fromRGB(255,255,255)
	tab.Font=Enum.Font.Gotham
	tab.TextSize=16
	tab.AutoButtonColor=false
	Instance.new("UICorner",tab).CornerRadius=UDim.new(0,8)

	tab.MouseEnter:Connect(function()
		tab.BackgroundColor3=Color3.fromRGB(55,55,55)
	end)
	tab.MouseLeave:Connect(function()
		tab.BackgroundColor3=Color3.fromRGB(35,35,35)
	end)

	if name=="Player"then
		tab.MouseButton1Click:Connect(showPlayerSection)
	elseif name=="Visuals"then
		tab.MouseButton1Click:Connect(showVisualsSection)
	else
		tab.MouseButton1Click:Connect(function()
			contentFrame.Visible=false
		end)
	end
end

