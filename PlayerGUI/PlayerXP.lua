--Gets Player
local player = game.Players.LocalPlayer
--Gets Player's Current XP
local player_XP = player.leaderstats.XP

--Displays player's current XP and target XP
while wait(0.1) do
	script.Parent.Text = player_XP.Value.."/"..(player.leaderstats.Level.Value * 1000).."XP"
end