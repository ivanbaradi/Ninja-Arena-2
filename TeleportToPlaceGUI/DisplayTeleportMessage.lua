--SendPlayerToPlace Remote Event 
sendPlayerToPlace = game.ReplicatedStorage:WaitForChild("SendPlayerToPlace")

--True, if the message is sent (Prevents the message from reconcatenation if the user rapidly clicks the button)
message_sent = false

--Opens Teleport Message to Player's Screen
sendPlayerToPlace.OnClientEvent:Connect(function(game_mode)
	if not message_sent then
		--Tells player to where they are being teleported to
		script.Parent.TextLabel.Text = script.Parent.TextLabel.Text..game_mode
		--Makes Teleport Message visible to the player
		script.Parent.Visible = true
		message_sent = true
	end
end)
