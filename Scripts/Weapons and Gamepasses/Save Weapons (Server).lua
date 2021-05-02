local DataStore = game:GetService("DataStoreService")
local BackpackStore = DataStore:GetDataStore("WeaponSave")

--Loading player's weapons (No Gamepass Weapons are to be loaded)
game.Players.PlayerAdded:Connect(function(player)
	
	local player_weapons = BackpackStore:GetAsync("User-"..player.UserId)
	local count = 1
	
	print("Weapons to load:")
	for i, weapon in pairs(player_weapons) do
		local loading_weapon = game.ReplicatedStorage:FindFirstChild(weapon)
		if loading_weapon then
			if weapon.Name ~= "Bluesteel Katana" and weapon.Name ~= "Immortal God Long Sword" then
				loading_weapon:Clone().Parent = player.Backpack
				loading_weapon:Clone().Parent = player.StarterGear
				print("Weapon "..count..": "..loading_weapon.Name)
				count += 1
			end
		else
			print(weapon.." no longer exists in ReplicateStorage")
		end
	end
end)

--Saves player's weapons before the player leaves the game
function SaveWeapons(player, weapons)
	local player_backpack = {}
	local count = 1

	--Adds all player weapons (except Wooden Sword)
	for i, weapon in pairs(weapons:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Bluesteel Katana" and weapon.Name ~= "Immortal God Long Sword" and weapon.Name ~= "Wooden Sword" then
				table.insert(player_backpack, count, weapon.Name)
				print("Weapon "..count..": "..weapon.Name)
				count += 1
			end
		end
	end

	BackpackStore:SetAsync("User-"..player.UserId, player_backpack)
end

--Saving player's weapons (No Gamepass Weapons are to be saved)
game.Players.PlayerRemoving:Connect(function(player)
		
	--Saves player's weapons from Weapon Holder or StarterGear
	if player.Team and player.Team.Name == "Spectators" then
		print("Saving weapons from Weapon Holder")
		SaveWeapons(player, player:FindFirstChild("Weapon Holder"))
	else
		print("Saving weapons from player's StarterGear")
		SaveWeapons(player, player.StarterGear)
	end
end)