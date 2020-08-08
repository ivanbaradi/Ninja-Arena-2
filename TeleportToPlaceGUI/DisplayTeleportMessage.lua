--SendPlayerToPlace Remote Event 
sendPlayerToPlace = game.ReplicatedStorage:WaitForChild("SendPlayerToPlace")

--Opens Teleport Message to Player's Screen
sendPlayerToPlace.OnClientEvent:Connect(function(game_mode)
	
	--Tells player to where they are being teleported to
	script.Parent.TextLabel.Text = script.Parent.TextLabel.Text..game_mode
	--Makes Teleport Message visible to the player
	script.Parent.Visible = true
end)