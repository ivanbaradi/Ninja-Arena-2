--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")
--Gamepass Weapons
local BlueSteelKatana = game.ReplicatedStorage.GamepassWeapons:FindFirstChild("Bluesteel Katana")
local ImmortalGodLongSword = game.ReplicatedStorage.GamepassWeapons:FindFirstChild("Immortal God Long Sword")
--AddSpeedButton Remote Event
local AddSpeedButton = game.ReplicatedStorage:FindFirstChild("AddSpeedButton")
--AddVIPTag Remote Event
local AddVIPTag_Remote = game.ReplicatedStorage:FindFirstChild("AddVIPTag")

--Fires when the player has purchased or cancel the gamepass
MarketPlace.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, purchased)
	
	--Only if the user decides to purchase a gamepass 
	if purchased then
		
		--[[
		If neither of the conditional statements are true,
		the the user must have bought the Refridgerator
		Gamepass.
		]]
		if gamepassId == 11322835 --[[Bluesteel Katana]] then
			BlueSteelKatana:Clone().Parent = player.Backpack
			BlueSteelKatana:Clone().Parent = player.StarterGear
		elseif gamepassId == 11330730 --[[ 2x Speed ]] then
			AddSpeedButton:FireClient(player)
		elseif gamepassId == 11353143 --[[Immortal God Long Sword]] then
			ImmortalGodLongSword:Clone().Parent = player.Backpack
			ImmortalGodLongSword:Clone().Parent = player.StarterGear
		elseif gamepassId == 11420620 or gamepassId == 11420646--[[VIP or MEGA VIP]]
			AddVIPTag_Remote:FireClient(player)
		end
		print("User purchased gamepass!")
	end
end)
