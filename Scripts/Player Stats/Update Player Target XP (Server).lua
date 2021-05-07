--Only the server has to update the Target XP
game.ReplicatedStorage:FindFirstChild("Assign Target XP to Server").OnServerEvent:Connect(function(player, newTargetXP)
	player:FindFirstChild("Target XP").Value = newTargetXP
end)