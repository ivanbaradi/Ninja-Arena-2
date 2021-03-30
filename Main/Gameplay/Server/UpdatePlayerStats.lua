--DataStore2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Gives player cash
function giveCash(player, leaderstats, cash)
	
	--Will check to see if you have VIP to earn double or triple cash
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP 3x Cash]] then
		leaderstats.Cash.Value += (cash * 3)
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP 2x Cash]] then
		leaderstats.Cash.Value += (cash * 2)
	else
		leaderstats.Cash.Value += cash
	end

	--Saves Player's Cash
	DataStore2("cash", player):Set(leaderstats.Cash.Value)
	print(player.Name.." earned cash!")
end

--Gives player XP
function giveXP(player, leaderstats, XP)

	--Player earns XP and check to see if you have VIP to earn double or triple XP
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP 3x XP]] then
		leaderstats.XP.Value += (XP * 3)
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP 2x XP]] then
		leaderstats.XP.Value += (XP * 2)
	else
		leaderstats.XP.Value += XP
	end
	
	--Saves Player's XP
	DataStore2("XP", player):Set(leaderstats.XP.Value)

	--Levels up player if they reach target XP, and regenerates player's health 
	if leaderstats.XP.Value >= player:FindFirstChild("Target XP").Value then

		--Levels up player
		leaderstats.Level.Value += 1

		--Saves player's level
		DataStore2("level", player):Set(leaderstats.Level.Value)
		print(player.Name.." leveled up!")

		--Regenerates player's health after leveling up
		game.ServerStorage:FindFirstChild("Health Regeneration"):Fire(player, player.Character:FindFirstChildOfClass("Humanoid"), leaderstats)
	end
end

--Updates players new stats (level, cash, and xp)
game.ServerStorage:FindFirstChild("Send Player New Stats").Event:Connect(function(player, leaderstats, cash, XP)
	if leaderstats then					
		
		--Gives players cash
		giveCash(player, leaderstats, cash)

		--Players must be under Level 20 to earn XP and level up
		if leaderstats.Level.Value < 20 then
			giveXP(player, leaderstats , XP)
		else
			print("You have reached max level to earn XP here.")
		end
	end
end)