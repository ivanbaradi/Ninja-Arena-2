--Player
local Player = game.Players.LocalPlayer

--All GUI components from WarningMessages Frame
local WarningMessages = script.Parent.Parent:FindFirstChild("Warning Messages")
local Message1 = WarningMessages:FindFirstChild("Message 1")
local Message2 = WarningMessages:FindFirstChild("Message 2")
local YesButton = WarningMessages:FindFirstChild("Yes")
local NoButton = WarningMessages:FindFirstChild("No")

--Fires when the player presses "Spectate Mode" button
script.Parent.MouseButton1Click:Connect(function()
	
	--Closes other GUIs
	local StarterGUI = script.Parent.Parent.Parent
	local ShopGUI = StarterGUI:FindFirstChild("ShopGUI").ShopGui
	local SellWeaponGUI = StarterGUI:FindFirstChild("SellWeaponGUI").SellGui
	local TeleportGUI = StarterGUI:FindFirstChild("TeleportToPlaceGUI"):FindFirstChild("Warning Message")
	
	ShopGUI.Visible = false
	SellWeaponGUI.Visible = false
	TeleportGUI.Visible = false
	
	--Displays warning message
	if not WarningMessages.Visible then
		WarningMessages.Visible = true
	else
		WarningMessages.Visible = false
	end
end)

--Goes on Spectate Mode
YesButton.MouseButton1Click:Connect(function()
	WarningMessages.Visible = false
	game.ReplicatedStorage:FindFirstChild("OnSpectateMode"):FireServer()
end)

--Closes warning message
NoButton.MouseButton1Click:Connect(function()
	WarningMessages.Visible = false
end)