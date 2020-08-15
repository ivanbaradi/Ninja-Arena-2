--DataStore 2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")

--Used to remove player's weapon for cash
local sellWeapon = game.ReplicatedStorage:FindFirstChild("SellWeapon")
--RestockWeapons Event
local restockWeapons = game.ReplicatedStorage:FindFirstChild("RestockWeapons")

--Called after the player selects a weapon to sell
sellWeapon.OnServerEvent:Connect(function(player, weapon_name, selling_price)
		
	--Gets player's backpack DataStore
	local cashDataStore = DataStore2("cash",player)
	
	--Removes weapon from the player's backpack
	local remove_weaponBP = player.Backpack:FindFirstChild(weapon_name)
	--Removes weapon from the player's character
	local remove_weaponCH = player.Character:FindFirstChild(weapon_name)
	--Removes weapon from starter gear
	local remove_weaponSG = player.StarterGear:FindFirstChild(weapon_name)
	
	--Removes the weapon from player's backpack or if equipped, removed from player character
	if remove_weaponBP then
		remove_weaponBP.Parent = nil
	else
		remove_weaponCH.Parent = nil
	end
	
	--Removes selling weapon from the starter gear so it doesn't get stored in the inventory when players spawn or respawn
	if remove_weaponSG then
		remove_weaponSG.Parent = nil
	end
	
	--Gives player cash back
	player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + selling_price
	
	--Saves player's cash
	cashDataStore:Set(player.leaderstats.Cash.Value)
	
	restockWeapons:FireClient(player)
end)
