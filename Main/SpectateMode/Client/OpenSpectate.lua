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

--Makes Shop, Sell, Spectate, and Speed buttons appear or disappear
function ButtonVisibility(visibility_state)
	SpectateModeButton.Visible = visibility_state
	script.Parent.Parent.Parent:FindFirstChild("ShopGUI").ShopButton.Visible = visibility_state
	script.Parent.Parent.Parent:FindFirstChild("SellWeaponGUI").SellButton.Visible = visibility_state
	script.Parent.Parent.Parent:FindFirstChild("SpeedGUI").SpeedButton.Visible = visibility_state
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

--Fires when the player exits Spectate Mode; Makes Shop, Sell, Teleport, Spectate, and Speed button reaappear
game.ReplicatedStorage:FindFirstChild("AddCertainButtons").OnClientEvent:Connect(ButtonVisibility)

--Goes on Spectate Mode
YesButton.MouseButton1Click:Connect(function()
	
	--Warning message disappears
	WarningMessages.Visible = false
	
	--Makes buttons disappear
	ButtonVisibility(false)
	
	--Tells the server to have player go on Spectate Mode
	game.ReplicatedStorage:FindFirstChild("OnSpectateMode"):FireServer()
end)

--Closes warning message
NoButton.MouseButton1Click:Connect(function() WarningMessages.Visible = false end)

--Both the Spectate button and the warning message disappear if the player decided not to enter Spectate Mode
game.ReplicatedStorage:FindFirstChild("RemoveSpectateComponents").OnClientEvent:Connect(function()
	SpectateModeButton.Visible = false
	WarningMessages.Visible = false
end)

--Spectate Mode button is invisible throughout the match
if not game.ReplicatedStorage:FindFirstChild("Can Use Spectate Mode Button").Value then SpectateModeButton.Visible = false end 

--When player respawns and is on "Spectators" Team, then buttons must disappear
if Player.Team and Player.Team.Name == "Spectators" then ButtonVisibility(false) end