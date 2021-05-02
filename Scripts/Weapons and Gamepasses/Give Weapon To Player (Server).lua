--Called when players buy a weapon
game.ReplicatedStorage:FindFirstChild("Give Weapon").OnServerEvent:Connect(function(player, weapon)	
	--Replicates weapon to backpack and startergear
	game.ReplicatedStorage:FindFirstChild(weapon):Clone().Parent = player.Backpack 
	game.ReplicatedStorage:FindFirstChild(weapon):Clone().Parent = player.StarterGear
	print(player.Name.." has obtain "..weapon.."!")
end)