--[[This script performs APIs in Spectate Mode]]

--Replaces player's Humanoid Scripts with Spectator ones
function ChangeScripts(character)
	
	--Finds player's Animate and Humanoid scripts, and removes them from the player's character
	for _, obj in pairs(character:GetChildren()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") then
			if obj.Name == "Animate" or obj.Name == "Health" then
				obj:Remove()
			end
		end
	end
	
	--PlayerSpectatorScripts Folder
	local SpectatorFolder = game.ReplicatedStorage:FindFirstChild("PlayerSpectatorScripts")
	
	--Adds in Spectator scripts from PlayerSpectatorScripts folder to the player's character
	for _, obj in pairs(SpectatorFolder:GetChildren()) do
		obj.Parent = character
	end 
end

--Handles request of entering Spectate Mode
game.ReplicatedStorage:FindFirstChild("OnSpectateMode").OnServerEvent:Connect(function(player)
	
	--Spectators Team
	local SpectatorTeam
	
	--If "Spectators" Team doesn't exist
	if not game.Teams:FindFirstChild("Spectators") then
		SpectatorTeam = Instance.new("Team", game.Teams)
		SpectatorTeam.Name = "Spectators"
		SpectatorTeam.AutoAssignable = false
		SpectatorTeam.TeamColor = BrickColor.new("Brown")
		print("Spectators Team is added!")
	end
	
	--Assigns player to Spectators Team
	player.Team = SpectatorTeam
	
	--Player's Humanoid
	local humanoid = player.Character:FindFirstChild("Humanoid")
	humanoid.Name = "Spectator"
	
	--Calls ChangeScripts method
	ChangeScripts(player.Character)
	
	print("Player is now in Spectators Team!")
end)
