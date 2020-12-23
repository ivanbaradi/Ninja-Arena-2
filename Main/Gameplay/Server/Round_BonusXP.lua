--Gets DataStore2 module
local DataStore2 = require(1936396537)
--Combines three keys (level, kills, and xp)
DataStore2.Combine("DATA", "level", "XP")

--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Gets called after finishing the match
game.ReplicatedStorage:FindFirstChild("AddRoundXPToPlayer").OnServerEvent:Connect(function(player, result)
	
	--Player's leaderstats
	local leaderstats = player.leaderstats
	
	--Player's for level, and xp
	local level_DataStore = DataStore2("level", player)
	local XP_DataStore = DataStore2("XP", player)
	
	
	--Gives player XP
	if result == 0 then
		leaderstats.XP.Value += 150
	elseif result == 1  then
		leaderstats.XP.Value += 50
	else
		leaderstats.XP.Value += 75
	end
	
	--Saves player's XP
	XP_DataStore:Set(leaderstats.XP.Value)
		
	--Checks if the player reaches the target XP to level up
	if leaderstats.XP.Value >= player:WaitForChild("Target XP").Value then
		
		--Player's Humanoid
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		
		--Levels up player and saves it
		leaderstats.Level.Value += 1
		level_DataStore:Set(leaderstats.Level.Value)
		
		--Restores player's health
		game.ServerStorage:FindFirstChild("Health Regeneration"):Fire(player, humanoid, leaderstats)
	end
end)