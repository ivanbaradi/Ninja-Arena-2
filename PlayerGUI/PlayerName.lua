--[[ This script displays the player's username in the Player GUI. If the player owns
a MEGA VIP or VIP Gamepass, then they will get a MEGA VIP or VIP tag and the text color
of their usernames changes to silver or gold. The CREATOR tag is exclusive to the game
creator only]]

wait(1)
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")
--Player's Character
local character = script.Parent.Parent.Parent.Parent.Parent
--Player Object
local player = game.Players:GetPlayerFromCharacter(character)
--Player Name Text
local PlayerNameText = script.Parent
--Player's VIP Tag
local PlayerVIPTag = script.Parent.Parent:FindFirstChild("VIP Tag")

--Gold and Silver tags
local gold = Color3.fromRGB(255, 204, 0)
local silver = Color3.fromRGB(166, 166, 166)
--Purple tag for the creator
local purple = Color3.fromRGB(191, 128, 255)


--Adds player's VIP Tag
if player.UserId == 107263163 --[[GAME CREATOR ONLY]] then
	PlayerNameText.TextColor3 = purple
	PlayerVIPTag.TextColor3 = purple
	PlayerVIPTag.Text = "[CREATOR]"
elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP]] then
	PlayerNameText.TextColor3 = gold
	PlayerVIPTag.TextColor3 = gold
	PlayerVIPTag.Text = "[MEGA VIP]"
elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP]] then
	PlayerNameText.TextColor3 = silver
	PlayerVIPTag.TextColor3 = silver
	PlayerVIPTag.Text = "[VIP]"
end

PlayerNameText.Text = character.Name
