--Player Gui Background
local PlayerGui = script.Parent
--PlayerGuiBackgroundColorKey Key Object
local PlayerGuiBackgroundColorKey = game.ReplicatedStorage:WaitForChild("PlayerGuiBackgroundColorKey")
--Team colors and neutral color
local neutralColor = Color3.fromRGB(127, 127, 127) --Neutral Team Color
local blueColor = Color3.fromRGB(0, 0, 153) --NH101 Team Color
local redColor = Color3.fromRGB(204, 0, 0) --Enemy Team Color
local brownColor = Color3.fromRGB(128, 43, 0) --Spectator Team Color
--Player
local Player = game.Players.LocalPlayer

--Changes Player GUI's background color to RED, BLUE, or NEUTRAL
function changeBackgroundColor__RED_OR_BLUE()
	
	--May need to add more code
	
	
	if PlayerGuiBackgroundColorKey.Value == 0 then
		PlayerGui.BackgroundColor3 = neutralColor
	else
		--Changes Player GUI background color to blue (NH101 Team) or red (Enemy Team)
		if Player.Team.Name == "Ninja Heroes 101" then
			PlayerGui.BackgroundColor3 = blueColor
		else
			PlayerGui.BackgroundColor3 = redColor
		end
	end
end

--Changes Player GUI Background color to BROWN (SPECTATORS ONLY)
function changeBackgroundColor__BROWN() PlayerGui.BackgroundColor3 = brownColor end

--Occurs when the player is added into RED or BLUE team or removed from the team
game.ReplicatedStorage:FindFirstChild("ChangePlayerGUIBackgroundColor").OnClientEvent:Connect(changeBackgroundColor__RED_OR_BLUE)

--Occurs when the player is added into BROWN team (SPECTATORS ONLY)
game.ReplicatedStorage:FindFirstChild("ChangePlayerGUIBackgroundColor_BROWN").OnClientEvent:Connect(changeBackgroundColor__BROWN)

--[[This occurs whenever the player respawns. To change the 
background color of the Player GUI. The player has to be in
a team. The background color with be either brown, red, or blue.]]
if Player.Team then
	print()
	if Player.Team.Name == "Spectators" then
		changeBackgroundColor__BROWN()
	else
		changeBackgroundColor__RED_OR_BLUE()
	end
end
