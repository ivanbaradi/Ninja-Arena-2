--DataStore2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Updates player stats (cash or XP)
function updateStats(player, player_stats, update_val, store_type)
	--Will check to see if you have VIP to earn double or triple cash
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP 3x Cash]] then
		player_stats += (update_val * 3)
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP 2x Cash]] then
		player_stats += (update_val * 2)
	else
		player_stats += update_val
	end

	--Saves player's cash
	DataStore2(store_type, player):Set(player_stats)
end

--Levels up player if they reach target XP, and regenerates player's health 
function updateLevel(player, leaderstats, LevelUpAmount)
	
--	print("Level Up Amount: "..LevelUpAmount.Value)
	
	--Do not level up the player more than once
	if LevelUpAmount.Value ~= 0 then return end
	
	--Prevents level system from being manipulated
	LevelUpAmount.Value = 1
	
	if leaderstats.XP.Value >= player:FindFirstChild("Target XP").Value then

		--Levels up player
		leaderstats.Level.Value += 1

		--Saves player's level
		DataStore2("level", player):Set(leaderstats.Level.Value)
		print(player.Name.." leveled up!")

		--Regenerates player's health after leveling up
		game.ServerStorage:FindFirstChild("Health Regeneration"):Fire(player, player.Character:FindFirstChildOfClass("Humanoid"), leaderstats)
		wait(5)
	end
	
	--Players are able to level up again
	LevelUpAmount.Value = 0
end

--Updates player new stats (level, cash, and xp)
game.ServerStorage:FindFirstChild("Send Player New Stats").Event:Connect(function(player, leaderstats, cash, XP)
	if leaderstats then					
		
		--Gives players cash
		updateStats(player, leaderstats.Cash.Value, cash, "cash")

		--Players must be under Level 20 to earn XP and level up
		if leaderstats.Level.Value < 20 then
			
			--Gives players XP
			updateStats(player, leaderstats.XP.Value, XP, "XP")
			
			--[[ Players can only level up once. This will keep track how
			many times a player can level up.
			
			0: Player can level up
			1: Player can't level up]]
			local LevelUpAmount = player:FindFirstChild("Level Up Amount")
			if not LevelUpAmount then
				LevelUpAmount = Instance.new("IntValue", player)
				LevelUpAmount.Name = "Level Up Amount"
				LevelUpAmount.Value = 0
			end
			
			--Levels up player
			updateLevel(player, leaderstats, LevelUpAmount)
		else
			print("You have reached max level to earn XP here.")
		end
	end
end)