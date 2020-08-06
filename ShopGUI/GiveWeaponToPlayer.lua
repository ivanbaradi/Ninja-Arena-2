--[[

This script will replicate a new weapon to the client's backpack 
from ReplicateStorage after the client purchased it. It will 
also save the backpack data, which includes all weapons that the
client bought. Next time the client joins the server, they will
retrieve all weapons.

]]

--DataStore 2
local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "level", "cash", "XP", "backpack")

--Used to have server communicate with the client in order to replicate weapon
give_weapon = game.ReplicatedStorage:FindFirstChild("GiveWeapon")

--Called when players buy a weapon
give_weapon.OnServerEvent:Connect(function(player, new_weapon, subtract_cash)
		
	--Any weapon from the shop (weapon is cloned in backpack and startergear)
	local weaponBP, weaponSG
	
	--Gives players a new weapon if they don't have it
	if not player.Backpack:FindFirstChild(new_weapon) and not player.Character:FindFirstChild(new_weapon) then
		
		--Gets current cash value for player
		local cash_DataStore = DataStore2("cash", player)
		--Gets player's old backpack
		local backpack_DataStore = DataStore2("backpack", player)
		
		--Takes cash from player for a weapon
		player.leaderstats.Cash.Value = player.leaderstats.Cash.Value - subtract_cash
		
		--Replicates weapon to backpack and startergear
		weaponBP = game.ReplicatedStorage:FindFirstChild(new_weapon):Clone()
		weaponSG = game.ReplicatedStorage:FindFirstChild(new_weapon):Clone()
		weaponBP.Parent = player.Backpack 
		weaponSG.Parent = player.StarterGear
		
		--Array containing all bought weapons plus the new one
		local player_backpack = {}
		
		--Adds all player weapons besides the Wooden Sword in the backpack 
		for i, weapon in pairs(player.Backpack:GetChildren()) do
			print(weapon.Name)
			if weapon.Name ~= "Wooden Sword" then
				table.insert(player_backpack, i-1, weapon.Name)
				print(weapon.Name.." is inserted in the table")
			end
		end
		
		--Saves all weapons (including the new one)
		backpack_DataStore:Set(player_backpack)
		
		--Saves cash value (Note: This often works if you don't test it in Roblox Studios)
		cash_DataStore:Set(player.leaderstats.Cash.Value)
	else
		print("You already have that weapon")
	end
end)
