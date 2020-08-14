--Will need to use DataStoreService API to render saving and loading player weapons
local DataStore = game:GetService("DataStoreService")
local BackpackStore = DataStore:GetDataStore("WeaponSave")

--Loads player's weapons when they join the server
game.Players.PlayerAdded:Connect(function(player)
	
	--Loads player's inventory
	local player_weapons = BackpackStore:GetAsync("User-"..player.UserId)
	
	--Will go through player's weapons to be replicated into their backpacks and startergears
	print("Weapons to load:")
	for i, weapon in pairs(player_weapons) do
		local loading_weapon = game.ReplicatedStorage:FindFirstChild(weapon)
		if loading_weapon then
			loading_weapon:Clone().Parent = player.Backpack
			loading_weapon:Clone().Parent = player.StarterGear
			print(loading_weapon)
		else
			print(weapon.." no longer exists in ReplicateStorage")
		end
	end
end)

--Saves player's weapons when they leave the server
game.Players.PlayerRemoving:Connect(function(player)
	
	--Will need to create a table to save all weapons from the starter gear
	local player_backpack = {}
	
	--Adds all player weapons in the starter gear 
	for i, weapon in pairs(player.StarterGear:GetChildren()) do
		if weapon then
			table.insert(player_backpack, i, weapon.Name)
			print(weapon.Name.." is inserted in the table")
		end
	end
			
	--Prints all weapons
	print("Player weapons to be saved:")
	for j, print_weapon in pairs(player_backpack) do
		if print_weapon then
			print("Weapon "..j..": "..print_weapon)
		end
	end
	
	--Saves player's inventory
	BackpackStore:SetAsync("User-"..player.UserId, player_backpack)
end)
