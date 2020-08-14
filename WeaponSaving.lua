local DataStore = game:GetService("DataStoreService")
local BackpackStore = DataStore:GetDataStore("WeaponSave")

--Loading player weapon's
game.Players.PlayerAdded:Connect(function(player)
	
	local player_weapons = BackpackStore:GetAsync("User-"..player.UserId)
	
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

game.Players.PlayerRemoving:Connect(function(player)
	
	local player_backpack = {}
	
	--Adds all player weapons besides the Wooden Sword in the starter gear 
	for i, weapon in pairs(player.StarterGear:GetChildren()) do
		if weapon then
			print(weapon.Name)
			--if weapon.Name ~= "Wooden Sword" then
			table.insert(player_backpack, i, weapon.Name)
			print(weapon.Name.." is inserted in the table")
			--end
		end
	end
			
	--Prints all weapons
	print("Player weapons to be saved:")
	for j, print_weapon in pairs(player_backpack) do
		if print_weapon then
			print("Weapon "..j..": "..print_weapon)
		end
	end
	
	BackpackStore:SetAsync("User-"..player.UserId, player_backpack)
end)