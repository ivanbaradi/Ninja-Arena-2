--[[

This script teleports a player to a game mode when they walk up
to the button and presses it. It will send a remote event to
the client to display the teleporting message to the player.

This script teleports players to Normal Mode since this is passed
as a string argument to display "Teleporting to Normal Mode"

]]

--SendPlayerToPlace Remote Event
sendPlayerToPlace = game.ReplicatedStorage:WaitForChild("SendPlayerToPlace")

--Teleports player to Normal Mode
script.Parent.ClickDetector.MouseClick:Connect(function(player)
	
	--Runs a local script to make the teleport message visible to the player
	sendPlayerToPlace:FireClient(player, "Normal Mode")
	wait(2)
	--Teleports player to another place (Below is Normal Mode's placeID)
	game:GetService('TeleportService'):Teleport(5503417753, player)
end)
