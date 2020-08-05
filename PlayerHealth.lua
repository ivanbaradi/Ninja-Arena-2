--[[ Script that generates player's appropriate health points]]

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(0.1)
		local leaderstats = player.leaderstats
		if leaderstats then
			local humanoid = char:WaitForChild("Humanoid")
			if humanoid then
				humanoid.MaxHealth = 100 + (50 *(leaderstats.Level.Value - 1))
				humanoid.Health = humanoid.MaxHealth
				--Kill player if it has inappropriate (only occurs when player joins the server
				if humanoid.MaxHealth == 50 then
					humanoid.Health = 0
				end
			end
		end
	end)
end)


