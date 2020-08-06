--Gets Player
local player = game.Players.LocalPlayer
--Gets Player's Current XP
local player_XP = player.leaderstats.XP
--Target XP Multiplier
local XP_Multiplier

while wait(0.1) do
	
	--Player gets higher XP multiplier as they level up
	if player.leaderstats.Level.Value < 9 then
		XP_Multiplier = 500
	else
		XP_Multiplier = 750
	end
	
	--Displays player's current XP and target XP
	script.Parent.Text = player_XP.Value.."/"..(player.leaderstats.Level.Value * XP_Multiplier).."XP"
end
