--[[ This script replicates a weapon to the player's inventory after buying it. ]]--

--DataStore 2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP")

--Used to have server communicate with the client in order to replicate weapon
give_weapon = game.ReplicatedStorage:FindFirstChild("GiveWeapon")
--RestockWeapons Event
restockWeapons = game.ReplicatedStorage:FindFirstChild("RestockWeapons")

--Called when players buy a weapon
give_weapon.OnServerEvent:Connect(function(player, new_weapon, subtract_cash)
		
	--Any weapon from the shop (weapon is cloned in backpack and startergear)
	local weaponBP, weaponSG
	
	--Gives players a new weapon if they don't have it
	if not player.Backpack:FindFirstChild(new_weapon) and not player.Character:FindFirstChild(new_weapon) then
		
		--Gets current cash value for player
		local cash_DataStore = DataStore2("cash", player)
		
		--Takes cash from player for a weapon
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value - subtract_cash
		
		--Replicates weapon to backpack and startergear
		weaponBP = game.ReplicatedStorage:FindFirstChild(new_weapon):Clone()
		weaponSG = game.ReplicatedStorage:FindFirstChild(new_weapon):Clone()
		weaponBP.Parent = player.Backpack 
		weaponSG.Parent = player.StarterGear
		
		--Saves cash value (Note: This often works if you don't test it in Roblox Studios)
		cash_DataStore:Set(player.leaderstats.Cash.Value)
		
		--Will need to restock weapons at Sell UI everytime a player purchases a weapon
		restockWeapons:FireClient(player)
	else
		print("You already have that weapon")
	end
end)
