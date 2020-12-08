--DataStore2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Enemy's Humanoid
local Humanoid = script.Parent:FindFirstChild("Humanoid")

--Gives player cash
function giveCash(player, leaderstats)

	--Gets Cash DataStore2
	local cash_DataStore = DataStore2("cash", player)

	--MinCash and MaxCash
	local MinCash = script.Parent.MinCash.Value
	local MaxCash = script.Parent.MaxCash.Value

	--Randomly gets cash amount
	local cash = math.random(MinCash, MaxCash)

	--Chance that you may not earn cash
	local random_cash = math.random(1,2)
	if random_cash == 1 then

		--Will check to see if you have VIP to earn double or triple cash
		if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP 3x Cash]] then
			leaderstats.Cash.Value = leaderstats.Cash.Value + (cash * 3)
		elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP 2x Cash]] then
			leaderstats.Cash.Value = leaderstats.Cash.Value + (cash * 2)
		else
			leaderstats.Cash.Value += cash
		end

		--Saves Player's Cash
		cash_DataStore:Set(leaderstats.Cash.Value)
		print("You earned cash!")
	else
		print("You earned no cash :(")
	end
end

--Gives player XP
function giveXP(player, leaderstats)

	--Gets player's level, and XP
	local level_DataStore = DataStore2("level", player)
	local XP_DataStore = DataStore2("XP", player)

	--MinXP and MaxXP
	local MinXP = script.Parent.MinXP.Value
	local MaxXP = script.Parent.MaxXP.Value

	--Randomly gets XP amount
	local XP = math.random(MinXP, MaxXP)

	--Player earns XP and check to see if you have VIP to earn double or triple XP
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP 3x XP]] then
		leaderstats.XP.Value += (XP * 3)
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP 2x XP]] then
		leaderstats.XP.Value += (XP * 2)
	else
		leaderstats.XP.Value += XP
	end

	--Saves Player's XP
	XP_DataStore:Set(leaderstats.XP.Value)

	--Gets player's target XP 
	local TargetXP = player:FindFirstChild("Target XP").Value

	--Levels up player if they reach target XP, and regenerates player's health 
	if leaderstats.XP.Value >= TargetXP then

		--Levels up player
		leaderstats.Level.Value += 1

		--Saves player's level
		level_DataStore:Set(leaderstats.Level.Value)
		print("You leveled up!")

		--Regenerates player's health after leveling up
		local HealthRegeneration = game.ServerStorage:FindFirstChild("Health Regeneration")
		local humanoid = player.Character:FindFirstChild("Humanoid") or player.Character:FindFirstChild("Zombie")
		HealthRegeneration:Fire(player, humanoid, leaderstats)
	end
end

--Fires when this AI is dead
Humanoid.Died:Connect(function()	
	local tag = Humanoid:FindFirstChild("creator")
	if tag then
		if tag.Value then
			--Gets player's leaderstats
			local leaderstats = tag.Value:FindFirstChild("leaderstats")
			--Player
			local player = leaderstats.Parent

			if leaderstats then					
				--Gives players cash
				giveCash(player, leaderstats)

				--Players must be under Level 20 to earn XP and level up
				if leaderstats.Level.Value < 20 then
					giveXP(player, leaderstats)
				else
					print("You have reached max level to earn XP here.")
				end
			end
		end
	end
end)