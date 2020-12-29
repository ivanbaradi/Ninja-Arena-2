--Player
local Player = game.Players.LocalPlayer

--Spectate Mode Button
local SpectateModeButton = script.Parent

--All GUI components from WarningMessages Frame
local WarningMessages = script.Parent.Parent:FindFirstChild("Warning Messages")
local Message1 = WarningMessages:FindFirstChild("Message 1")
local Message2 = WarningMessages:FindFirstChild("Message 2")
local YesButton = WarningMessages:FindFirstChild("Yes")
local NoButton = WarningMessages:FindFirstChild("No")

--Makes Shop, Sell, Teleport, Spectate, and Speed buttons disappear
function ButtonInvisibility()
	
	local ShopButton = script.Parent.Parent.Parent:FindFirstChild("ShopGUI").ShopButton
	local SellButton = script.Parent.Parent.Parent:FindFirstChild("SellWeaponGUI").SellButton
	local TeleportButton = script.Parent.Parent.Parent:FindFirstChild("TeleportToPlaceGUI").TeleportButton
	local SpeedButton = script.Parent.Parent.Parent:FindFirstChild("SpeedGUI").SpeedButton

	SpectateModeButton.Visible = false
	ShopButton.Visible = false
	SellButton.Visible = false
	SpeedButton.Visible = false
end

--Fires when the player presses "Spectate Mode" button
SpectateModeButton.MouseButton1Click:Connect(function()
	
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
	
	--Warning message disappears
	WarningMessages.Visible = false
	
	--Makes buttons disappear
	ButtonInvisibility()
	
	--Tells the server to have player go on Spectate Mode
	game.ReplicatedStorage:FindFirstChild("OnSpectateMode"):FireServer()
end)

--Closes warning message
NoButton.MouseButton1Click:Connect(function()
	WarningMessages.Visible = false
end)

--When player respawns and is on "Spectators" Team, then buttons must disappear
if Player.Team and Player.Team.Name == "Spectators" then ButtonInvisibility() end