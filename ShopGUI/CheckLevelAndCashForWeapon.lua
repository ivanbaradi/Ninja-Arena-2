--[[

This script is responsible for giving player weapons.
It will check if the player reaches at a higher level
and has enough cash to buy a weapon. If so, then 
the script fires a remote event to tell the server to 
clone the weapon from ReplicatedStorage and give that 
to the player.

In this prompt, the user is required to be at Level 23
and have 1,050 cash to purchase a weapon. 

]]

--Player
local player = game.Players.LocalPlayer
--Leaderstats
local leaderstats = player.leaderstats
--Get access to script that gives weapons to players
local give_weapon = game.ReplicatedStorage:FindFirstChild("GiveWeapon")
--Weapon Name
local weapon_name = script.Parent.WeaponName.Text
--Level and cash requirement to buy weapon
local required_level = 23
local required_cash = 1050

--Fires when player is purchasing a weapon
script.Parent.MouseButton1Click:Connect(function ()
	if leaderstats.Level.Value >= required_level and leaderstats.Cash.Value >= required_cash then
		print("Sending weapon to player")
		give_weapon:FireServer(weapon_name, required_cash)
	else
		print("Player doesn't have enough money and/or has not reach at this level")
	end
end)