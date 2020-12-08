--[[

This script does the following:
1. Designs TextButton components for each bought weapon
2. Displays these buttons on Sell UI
3. Matches a player's weapon to the weapon from Weapons dictionary
4. Deletes a TextButton component, because the player had sold a weapon
5. Restocks player's inventory after the player sells the weapon

]]--

--Treated as if the GUI is loading
wait(2)

--WeaponFrame
local weapon_frame = script.Parent.Parent:WaitForChild("Frame")
--Gets player
local player = game.Players.LocalPlayer
--XScales and YScales of the weapon button
local XScale = {0.01, 0.135, 0.26, 0.385, 0.51, 0.635, 0.76, 0.885}
local YScale = {0.01, 0.18, 0.36, 0.54, 0.72}-- -0.005
--Row and columnindex
local row, col = 1, 1
--SellWeapon Event
local SellWeapon = game.ReplicatedStorage:FindFirstChild("SellWeapon")
--Used to restock weapons after a player sells the weapon
local restockWeapons = game.ReplicatedStorage:FindFirstChild("RestockWeapons")
--Message
local message = script.Parent.Parent:FindFirstChild("Message")
--Marketplace
local MarketPlace = game:GetService("MarketplaceService")

--All weapons from the shop (Still need to add more)
local Weapons = {
	{name = "Iron Sword", selling_price = 50},
	{name = "Katana", selling_price = 150},
	{name = "Red Katana", selling_price = 225},
	{name = "Blue Katana", selling_price = 265},
	{name = "Kitchen Knife", selling_price = 310},
	{name = "Dark Lightsaber", selling_price = 400},
	{name = "Kylo's Lightsaber", selling_price = 525},
	{name = "Machete", selling_price = 800},
	{name = "Tiger Sword", selling_price = 925},
	{name = "Diamond Blade", selling_price = 1200},
	{name = "Sword of Light", selling_price = 1600},
	{name = "Fire Crystal Sword", selling_price = 2375},
	{name = "Omega Rainbow Katana", selling_price = 4050},
	{name = "Sword of Flames", selling_price = 7000},
	{name = "Halloween Sword", selling_price = 9750},
	{name = "Scourge of the Overseer", selling_price = 12500},
	{name = "Bear Knight", selling_price = 15120},
	{name = "The Golden Wrath", selling_price = 19000},
	{name = "Shark Sword", selling_price = 25000},
	{name = "Blizzard Striker", selling_price = 30300},
	{name = "Crimson Sword", selling_price = 36500},
	{name = "Excalibur", selling_price = 48000},
	{name = "Possessed Sword", selling_price = 62500},
	{name = "Wind Behemoth", selling_price = 105000},
	{name = "Purple Katana", selling_price = 140000},
	{name = "Demon Dagger", selling_price = 187500},
	{name = "Lava Blade", selling_price = 215000},
	{name = "Retro Blue", selling_price = 255000},
	{name = "Overseer Axe", selling_price = 292000},
	{name = "Obsidian Sword", selling_price = 335000},
	{name = "Corrupted Blade", selling_price = 400000},
	{name = "Azure Dragon Long Sword", selling_price = 500000},
	{name = "Yui Sao's Sword", selling_price = 1250000},
	{name = "Azure Dragon Elite Sword", selling_price = 3000000},
	{name = "Starlight Sword", selling_price = 4650000},
	{name = "Galactic Chainsaw", selling_price = 6500000},
	{name = "Deity Blade", selling_price = 10000000},
	{name = "Nightmare Sword", selling_price = 17500000},
	{name = "Dark Demon Long Sword", selling_price = 25000000},
	{name = "Ninja God Sword", selling_price = 50000000}
}

--Seperate thousands with commas
function formatNumber(selling_price)
	
	local formatted = ""
	local rev_index_ptr = 1
	
	for i = string.len(selling_price), 1, -1 do
	
		if rev_index_ptr % 3 == 1 and rev_index_ptr > 3 then
			formatted = string.sub(selling_price,i,i)..","..formatted
		else
			formatted = string.sub(selling_price,i,i)..formatted
		end
	
		rev_index_ptr = rev_index_ptr + 1
	end

	return formatted
end

--Function that creates a button for each bought weapon
function createWeaponButton(weapon_name, selling_price, x_scale, y_scale, button_number)
	
	--Creates a button for the weapon
	local weapon_button = Instance.new("TextButton", weapon_frame)
	--Activates button
	weapon_button.Active = true
	--Gives background and border color of the button
	weapon_button.BackgroundColor3 = Color3.fromRGB(255, 255, 10)
	weapon_button.BorderColor3 = Color3.fromRGB(0, 0, 0)
	--Gives transparency of the button
	weapon_button.BackgroundTransparency = 0
	--Gives border size 
	weapon_button.BorderSizePixel = 2
	--Gives button a name
	weapon_button.Name = "Button"..button_number --change soon
	--Sets text for the button
	weapon_button.Font = "Highway"
	weapon_button.Text = weapon_name.." ["..formatNumber(tostring(selling_price)).."]"
	weapon_button.TextColor3 = Color3.fromRGB(0, 0, 0)
	weapon_button.TextScaled = true
	weapon_button.TextTransparency = 0
	--Sets position of the frame
	weapon_button.Position = UDim2.new(x_scale,0,y_scale,0)
	--Sets size of the frame
	weapon_button.Size = UDim2.new(0.105,0,0.12,0)
	--
	weapon_button.MouseButton1Click:Connect(function()
		print("Selling "..weapon_name.." to get "..selling_price.." Cash")
		SellWeapon:FireServer(weapon_name, selling_price)
		print(weapon_name.." sold!")
	end)
end

--Gets the correct weapon object and returns it
function getWeapon(weapon)
	for i, a in pairs(Weapons) do
		if a then
			if weapon == Weapons[i].name then
				return Weapons[i]
			end
		end
	end
	return nil
end

--Displays all player's weapons in the Sell Gui (Except for Wooden Sword and Gamepass Weapons)
function displayWeapons()
	--Goes through all the playerweapons
	for i, weapon in pairs(player.StarterGear:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Bluesteel Katana" and weapon.Name ~= "Immortal God Long Sword" then
				local w = getWeapon(weapon.Name)
				if w then
					--print("Weapon founded!")
					--print("Name: "..w.name..", Selling Price: "..w.selling_price)
					
					--Creates a button for the weapon
					createWeaponButton(w.name, w.selling_price, XScale[col], YScale[row], i)
					--print("Successfully built a button!")
					--print()
					
					--Next column
					col = col + 1
					
					--Next Row
					if col == 9 then
						row = row + 1
						col = 1
					end
				end
			end
		end
	end
end

--Removes all player's weapons from the Sell Gui
function removeWeapons()
	for i, weapon_button in pairs(weapon_frame:GetChildren()) do
		if weapon_button then
			if weapon_button:IsA("TextButton") then
				weapon_button.Parent = nil
			end
		end
	end
end

--Redisplays weapons after buying or selling a weapon
restockWeapons.OnClientEvent:Connect(function()
	removeWeapons()
	if table.getn(player.StarterGear:GetChildren()) == 0 or (table.getn(player.StarterGear:GetChildren()) == 1 and (MarketPlace:UserOwnsGamePassAsync(player.UserId, 11322835) or MarketPlace:UserOwnsGamePassAsync(player.UserId, 11353143))) or (table.getn(player.StarterGear:GetChildren()) == 2 and MarketPlace:UserOwnsGamePassAsync(player.UserId, 11322835) and MarketPlace:UserOwnsGamePassAsync(player.UserId, 11353143)) then
		--Need to tell players that they don't have any bought weapons
		if message.Text ~= "You don't have any weapons to sell." then
			message.Text = "You don't have any weapons to sell."
			print(message.Text)
		end
		
		message.Visible = true
	else	
		--Removes message because player had weapons
		if message.Visible == true then
			message.Visible = false
		end
		
		--Will need to display weapons again
		row, col = 1, 1
		displayWeapons()
	end
end)

--[[
The "You don't have any weapons to sell" message will display if either:
1. The player had no gamepass and no items in the StarterGear
2. The player owns one gamepass (Bluesteel Katana OR Immortal God Long Sword) and has 1 item in the StarterGear
3. The player owns two gamepasses (BOTH Bluesteel Katana AND Immortal God Long Sword and has 2 items in the StarterGear
]]
if table.getn(player.StarterGear:GetChildren()) == 0 or (table.getn(player.StarterGear:GetChildren()) == 1 and (MarketPlace:UserOwnsGamePassAsync(player.UserId, 11322835) or MarketPlace:UserOwnsGamePassAsync(player.UserId, 11353143))) or (table.getn(player.StarterGear:GetChildren()) == 2 and MarketPlace:UserOwnsGamePassAsync(player.UserId, 11322835) and MarketPlace:UserOwnsGamePassAsync(player.UserId, 11353143)) then
	message.Text = "You don't have any weapons to sell."
else
	message.Visible = false
	displayWeapons()
end
