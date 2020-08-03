--Gets Player
local player = game.Players.LocalPlayer
--Gets Player's Current Level
local player_level = player.leaderstats.Level
--Old Level Value
local old_level = player_level.Value
--Initially displays player's current level
script.Parent.Text = "Level "..player_level.Value

while wait(0.1) do
	--Will need to update the text to display the correct level of the player
	if old_level ~= player_level.Value then
		old_level = player_level.Value
		script.Parent.Text = "Level "..player_level.Value
		print("Player Level Up!")
	end
end