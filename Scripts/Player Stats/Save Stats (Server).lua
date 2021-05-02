--DataStore2 module
local DataStore2 = require(1936396537)
--DataStore2.Combine("DATA", "level", "cash", "XP") --Coming Soon at v1.1
DataStore2.Combine("DATA", "level", "XP")

--In case the servers are shut down by the game creator, then data needs to be saved.
game.Players.PlayerRemoving:Connect(function(player)
	DataStore2("level", player):Save()
	--DataStore2("cash", player):Save() (Coming Soon at v1.1)
	DataStore2("XP", player):Save()
end)