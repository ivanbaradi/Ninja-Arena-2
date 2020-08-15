wait(.5)

--Player
local player = game.Players.LocalPlayer
--Player Stats
local leaderstats = player.leaderstats

--Seperate thousands with commas
function formatNumber()
	
	local cash_InString = tostring(leaderstats.Cash.Value)
	local formatted = ""
	local rev_index_ptr = 1
	
	for i = string.len(cash_InString), 1, -1 do
	
		if rev_index_ptr % 3 == 1 and rev_index_ptr > 3 then
			formatted = string.sub(cash_InString,i,i)..","..formatted
		else
			formatted = string.sub(cash_InString,i,i)..formatted
		end
	
		rev_index_ptr = rev_index_ptr + 1
	end

	return formatted
end

while wait (0.1) do
	script.Parent.PlayerCash.Text = "$"..formatNumber()
end