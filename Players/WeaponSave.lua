local DataStore = game:GetService("DataStoreService")
local BackpackStore = DataStore:GetDataStore("WeaponSave")

--Loading player's weapons (No Gamepass Weapons are to be loaded)
game.Players.PlayerAdded:Connect(function(player)
	
	local player_weapons = BackpackStore:GetAsync("User-"..player.UserId)
	
	print("Weapons to load:")
	for i, weapon in pairs(player_weapons) do
		local loading_weapon = game.ReplicatedStorage:FindFirstChild(weapon)
		if loading_weapon then
			if weapon.Name ~= "Bluesteel Katana" and weapon.Name ~= "Immortal God Long Sword" then
				loading_weapon:Clone().Parent = player.Backpack
				loading_weapon:Clone().Parent = player.StarterGear
				print(loading_weapon)
			end
		else
			print(weapon.." no longer exists in ReplicateStorage")
		end
	end
end)

--Saving player's weapons (No Gamepass Weapons are to be saved)
game.Players.PlayerRemoving:Connect(function(player)
	
	local player_backpack = {}
	local count = 1
	
	--Adds all player weapons besides the Wooden Sword in the starter gear 
	print("Weapons to be saved:")
	for i, weapon in pairs(player.StarterGear:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Bluesteel Katana" and weapon.Name ~= "Immortal God Long Sword" then
				table.insert(player_backpack, count, weapon.Name)
				print("Weapon "..count..": "..weapon.Name)
				count = count + 1
			end
		end
	end
	
	BackpackStore:SetAsync("User-"..player.UserId, player_backpack)
end)