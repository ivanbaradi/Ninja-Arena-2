--[[ After the round is complete, each player will be given cash for participating. 
Exclusive VIP members get twice or thrice the cash.]]

--Gets DataStore2 module
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "cash")

--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Players earn cash after the round has ended
game.ReplicatedStorage:FindFirstChild("Add Round Cash To Player").OnServerEvent:Connect(function(player, result)
	
	--Gets player's cash DataStore
	local cash_DataStore = DataStore2("cash", player)
	
	--Cash to give to players
	local cash_earned = 0
	
	--Adds initial cash
	if result == 0 then --Team Win!
		cash_earned += 100
	elseif result == 1 then --Team Loss
		cash_earned += 25
	else --Tied
		cash_earned += 50
	end
	
	--MEGA VIP and VIP players get more!
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP]] then
		cash_earned *= 3
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP]] then
		cash_earned *= 2
	end
		
	--Gives final cash amount to player
	player.leaderstats.Cash.Value += cash_earned
	
	--Saves player's cash value
	cash_DataStore:Set(player.leaderstats.Cash.Value)
end)