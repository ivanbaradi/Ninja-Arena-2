--Player Gui Background
local PlayerGui = script.Parent
--PlayerGuiBackgroundColorKey Key Object
local PlayerGuiBackgroundColorKey = game.ReplicatedStorage:WaitForChild("PlayerGuiBackgroundColorKey")
--team colors and neutral color
local neutralColor = Color3.fromRGB(127, 127, 127)
local blueColor = Color3.fromRGB(0, 0, 153)
local redColor = Color3.fromRGB(204, 0, 0)
--Player
local Player = game.Players.LocalPlayer

--Changes Player GUI's background color to team color or neutral color
function changeBackgroundColor()
	if PlayerGuiBackgroundColorKey.Value == 0 then
		PlayerGui.BackgroundColor3 = neutralColor
	else
		if Player.Team.Name == "Ninja Heroes 101" then
			PlayerGui.BackgroundColor3 = blueColor
		else
			PlayerGui.BackgroundColor3 = redColor
		end
	end
end

--Occurs when the player is added into a team or removed from the team
game.ReplicatedStorage:FindFirstChild("ChangePlayerGUIBackgroundColor").OnClientEvent:Connect(changeBackgroundColor)

--Gets called when a player spawns or respawns
changeBackgroundColor()