--DataStore2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Updates player stats
function updateStats(player, player_stats, update_val, store_type)
	--Will check to see if you have VIP to earn double or triple cash
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP 3x Cash]] then
		player_stats += (update_val * 3)
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP 2x Cash]] then
		player_stats += (update_val * 2)
	else
		player_stats += update_val
	end

	--Saves Player's Cash
	DataStore2(store_type, player):Set(player_stats)
end

--Levels up player if they reach target XP, and regenerates player's health 
function updateLevel(player, leaderstats)
	if leaderstats.XP.Value >= player:FindFirstChild("Target XP").Value then

		--Levels up player
		leaderstats.Level.Value += 1

		--Saves player's level
		DataStore2("level", player):Set(leaderstats.Level.Value)
		print(player.Name.." leveled up!")

		--Regenerates player's health after leveling up
		game.ServerStorage:FindFirstChild("Health Regeneration"):Fire(player, player.Character:FindFirstChildOfClass("Humanoid"), leaderstats)
	else
		print(player.Name.." cannot level up more than once")
	end
end

--Updates player new stats (level, cash, and xp)
game.ServerStorage:FindFirstChild("Send Player New Stats").Event:Connect(function(player, leaderstats, cash, XP)
	if leaderstats then					
		
		--Gives players cash
		updateStats(player, leaderstats.Cash.Value, cash, "cash")

		--Players must be under Level 20 to earn XP and level up
		if leaderstats.Level.Value < 20 then
			updateStats(player, leaderstats.XP.Value, XP, "XP")
			updateLevel(player, leaderstats)
		else
			print("You have reached max level to earn XP here.")
		end
	end
end)