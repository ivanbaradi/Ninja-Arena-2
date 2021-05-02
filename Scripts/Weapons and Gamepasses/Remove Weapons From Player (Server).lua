--Removes all weapons from the starter gear besides Gamepass weapons
game.ReplicatedStorage:FindFirstChild("Remove Weapons").OnServerEvent:Connect(function(player)
	for _, weapon in pairs(player.StarterGear:GetChildren()) do
		if weapon.Name ~= 	"Bluesteel Katana" and weapon.Name ~= "Immortal God Long Sword" then
			
			--Removes weapon from player's backpack or character
			if weapon.Name ~= "Wooden Sword" then
				
				--Weapon from player's backpack
				local weaponBP = player.Backpack:FindFirstChild(weapon.Name)
				
				if weaponBP then
					weaponBP:Remove()
				else
					player.Character:FindFirstChild(weapon.Name):Remove()
				end
			end

			--Removes weapon from starter gear
			weapon:Remove()
			
			print(weapon.Name.." removed!")
		end
	end
end)