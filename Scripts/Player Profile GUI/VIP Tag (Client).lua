--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")
--Player
local player = game.Players.LocalPlayer
--AddVIPTag Remote Event
local AddVIPTag_Remote = game.ReplicatedStorage:FindFirstChild("AddVIPTag")

--[[Adds VIP or MEGA VIP tag, colorizes the text, and changes its font.
	Also adds the CREATOR tag for the game creator ]]
function AddVIPTag()
	if player.UserId == 107263163 --[[GAME CREATOR ONLY]] then
		script.Parent.PlayerName.TextColor3 = Color3.fromRGB(217, 179, 255)
		script.Parent.PlayerName.Text = "[CREATOR] "..player.Name
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP Gamepass]] then
		script.Parent.PlayerName.TextColor3 = Color3.fromRGB(255, 204, 0)
		script.Parent.PlayerName.Text = "[MEGA VIP] "..player.Name
	elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP Gamepass]] then
		script.Parent.PlayerName.TextColor3 = Color3.fromRGB(166, 166, 166)
		script.Parent.PlayerName.Text = "[VIP] "..player.Name
	end
end

--This will call after the player either purchases the VIP or MEGA VIP
AddVIPTag_Remote.OnClientEvent:Connect(function()
	AddVIPTag()
end)

--Gets called when the player spawns or respawns
AddVIPTag()