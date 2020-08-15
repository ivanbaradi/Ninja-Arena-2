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
	--local backpackDataStore = DataStore2("backpack2",player)
	--Gets player's backpack DataStore
	local cashDataStore = DataStore2("cash",player)
	
	--Prints old player's backpack (Debugging purposes) 
	--[[print("Old Backpack:")
	for i, weapon in pairs(player.Backpack:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Wooden Sword" then
				print(i..". "..weapon.Name)
			end
		end
	end
	print()]]
	
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
	
	--Removes selling weapon
	if remove_weaponSG then
		remove_weaponSG.Parent = nil
	end
	
	--Gives player cash back
	player.leaderstats.Cash.Value = player.leaderstats.Cash.Value + selling_price
	
	--Prints new player's backpack (Debugging purposes) 
	--[[print("New Backpack:")
	for i, weapon in pairs(player.Backpack:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Wooden Sword" then
				print(i..". "..weapon.Name)
			end
		end
	end]]
	
	--Saves the weapon item in the backpack (Code this part)
	--[[local player_backpack = {}
	
	print("Weapons to be saved:")
	--Adds all player weapons besides the Wooden Sword in the starter gear 
	for i, weapon in pairs(player.Backpack:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Wooden Sword" then
				table.insert(player_backpack, i-1, weapon.Name)
				print(weapon.Name)
			end
		end
	end]]
	
	--Saves player's cash
	cashDataStore:Set(player.leaderstats.Cash.Value)
	--Saves player's backpack
	--backpackDataStore:Set(player_backpack)
	
	restockWeapons:FireClient(player)
end)