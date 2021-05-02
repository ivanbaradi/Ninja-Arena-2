--Adds a player overhead GUI on the player's character
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local PlayerOverheadGUI = game.ReplicatedStorage:FindFirstChild("Player GUI"):Clone()
		local head = char:FindFirstChild("Head")
		PlayerOverheadGUI.Parent = head
	end)
end)