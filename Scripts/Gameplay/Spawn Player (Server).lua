--Replicated Storage
local ReplicatedStorage = game.ReplicatedStorage
--ServerStorage
local ServerStorage = game.ServerStorage

--Used whenever a player respawns during the match
game.Players.PlayerAdded:Connect(function(player)
	
	--Displays scoreboard to the player who just joined the server if the round continues
	script:FindFirstChild('Display Scoreboard On Join'):Invoke(player)
	
	--Fires when a player spawns or respawns
	player.CharacterAdded:Connect(function(char)
		wait(.1)
		print("Player spawned")
		
		--The player must belong in the team	
		if player.Team then	
			
			--Gets Player's Humanoid 
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			
			--Renames player's humanoid
			script:FindFirstChild('Rename Player Humanoid'):Invoke(player, player.Team, humanoid)
			
			--Must freeze player if the fight hasn't start yet
			script:FindFirstChild('Freeze Teammate'):Invoke(humanoid)
			
			--Modifies player's overhead GUI
			ServerStorage:FindFirstChild('Change Player Overhead GUI'):Fire(player, char)
			
			--Teleports player to the arena map
			if ReplicatedStorage:FindFirstChild("Can Spawn On Map").Value then
				script:FindFirstChild('Respawn Player On Arena Map'):Invoke(char)
			else
				print('Cannot spawn player to the arena map because it is not at the workspace yet')
			end
		end
	end)
end)