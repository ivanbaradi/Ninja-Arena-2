--Marketplace
local MarketPlace = game:GetService("MarketplaceService")
--Gamepasses
local BlueSteelKatana = game.ReplicatedStorage.GamepassWeapons:FindFirstChild("Bluesteel Katana")
local ImmortalGodLongSword = game.ReplicatedStorage.GamepassWeapons:FindFirstChild("Immortal God Long Sword")


--Loads gamepasses when players join the game
game.Players.PlayerAdded:Connect(function(player)
	
	--Adds Bluesteel Weapon Gamepass if the user has it
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11322835) --[[Bluesteel Katana]] then
		print("User has the Bluesteel Katana Gamepass!")
		BlueSteelKatana:Clone().Parent = player.Backpack
		BlueSteelKatana:Clone().Parent = player.StarterGear
	end
	
	if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11353143) --[[Immortal God Long Sword]] then
		print("User has the Immortal God Long Sword Gamepass!")
		ImmortalGodLongSword:Clone().Parent = player.Backpack
		ImmortalGodLongSword:Clone().Parent = player.StarterGear
	end	
end)
