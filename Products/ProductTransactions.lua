--DataStore 2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")
--Marketplace Service
local MarketPlace = game:GetService("MarketplaceService")

--Processes the transaction of purchasing cash
MarketPlace.ProcessReceipt = function(receipt)
	
	--Gets player
	local player = game.Players:GetPlayerByUserId(receipt.PlayerId)
	--Cash DataStore
	local cashDataStore = DataStore2("cash", player)
	
	--Goes through transaction
	if receipt.ProductId == 1079116891 then
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + 500
	elseif receipt.ProductId == 1079151406 then
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + 2000
	elseif receipt.ProductId == 1079180685 then
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + 8000
	elseif receipt.ProductId == 1079189615 then
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + 25000
	elseif receipt.ProductId == 1079199836 then
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + 70000
	else
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + 300000
	end
	
	--Saves player's cash
	cashDataStore:Set(player.leaderstats.Cash.Value)
	
	print("Purchased Complete!")
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end
