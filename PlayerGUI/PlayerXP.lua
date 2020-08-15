--Gets Player
local player = game.Players.LocalPlayer
--Gets Player's Current XP
local player_XP = player.leaderstats.XP
--Target XP Multiplier
local XP_Multiplier

wait(.5)

function formatNumber(XP)
	
	local formatted = ""
	local rev_index_ptr = 1
	
	for i = string.len(XP), 1, -1 do
	
		if rev_index_ptr % 3 == 1 and rev_index_ptr > 3 then
			formatted = string.sub(XP,i,i)..","..formatted
		else
			formatted = string.sub(XP,i,i)..formatted
		end
	
		rev_index_ptr = rev_index_ptr + 1
	end

	return formatted
end

while wait(0.1) do
	
	--Player gets higher XP multiplier as they level up
	if player.leaderstats.Level.Value <= 10 then
		XP_Multiplier = 500
	elseif player.leaderstats.Level.Value > 10 and player.leaderstats.Level.Value <= 20 then
		XP_Multiplier = 750
	elseif player.leaderstats.Level.Value > 20 and player.leaderstats.Level.Value <= 30 then
		XP_Multiplier = 1000
	elseif player.leaderstats.Level.Value > 30 and player.leaderstats.Level.Value <= 40 then
		XP_Multiplier = 1250
	elseif player.leaderstats.Level.Value > 40 and player.leaderstats.Level.Value <= 50 then
		XP_Multiplier = 1500
	elseif player.leaderstats.Level.Value > 65 and player.leaderstats.Level.Value <= 80 then
		XP_Multiplier = 1750
	elseif player.leaderstats.Level.Value > 80 and player.leaderstats.Level.Value <= 90 then
		XP_Multiplier = 2000
	elseif player.leaderstats.Level.Value > 90 and player.leaderstats.Level.Value <= 95 then
		XP_Multiplier = 5000
	elseif player.leaderstats.Level.Value > 95 and player.leaderstats.Level.Value <= 99 then
		XP_Multiplier = 10000
	else
		XP_Multiplier = nil
	end
	
	--Displays player's current XP and target XP
	if XP_Multiplier then
		local CurrentXP = tostring(player_XP.Value)
		local TargetXP = tostring(player.leaderstats.Level.Value * XP_Multiplier)
		script.Parent.Text = formatNumber(CurrentXP).."/"..formatNumber(TargetXP)
	else
		script.Parent.Text = "MAX XP"
	end
end
