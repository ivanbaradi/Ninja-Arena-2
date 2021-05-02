--Gets Player
local player = game.Players.LocalPlayer
--Gets Player's Current Level
local player_level = player.leaderstats.Level

while wait(0.1) do
	script.Parent.Text = "Level "..player_level.Value
end
