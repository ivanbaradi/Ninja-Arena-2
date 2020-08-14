wait(1)

--WeaponFrame
local weapon_frame = script.Parent.Parent:WaitForChild("Frame")
--Gets player
local player = game.Players.LocalPlayer
--XScales and YScales of the weapon button
local XScale = {0.01, 0.135, 0.26, 0.385, 0.51, 0.635, 0.76, 0.885}
local YScale = {0.014, 0.22, 0.426, 0.632, 0.838}
--Row and columnindex
local row, col = 1, 1
--SellWeapon Event
local SellWeapon = game.ReplicatedStorage:FindFirstChild("SellWeapon")
--Used to restock weapons after a player sells the weapon
local restockWeapons = game.ReplicatedStorage:FindFirstChild("RestockWeapons")

--All weapons from the shop (Still need to add more)
local Weapons = {
	{name = "Iron Sword", selling_price = 100},
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
	{name = "Shark Sword", selling_price = 25000}
}

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
	weapon_button.Text = weapon_name.." ["..selling_price.."]"
	weapon_button.TextColor3 = Color3.fromRGB(0, 0, 0)
	weapon_button.TextScaled = true
	weapon_button.TextTransparency = 0
	--Sets position of the frame
	weapon_button.Position = UDim2.new(x_scale,0,y_scale,0)
	--Sets size of the frame
	weapon_button.Size = UDim2.new(0.105,0,0.173,0)
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

--Displays all player's weapons in the Sell Gui
function displayWeapons()
	--Goes through all the playerweapons
	for i, weapon in pairs(player.Backpack:GetChildren()) do
		if weapon then
			if weapon.Name ~= "Wooden Sword" then
				local w = getWeapon(weapon.Name)
				if w then
					print("Weapon founded!")
					print("Name: "..w.name..", Selling Price: "..w.selling_price)
					
					--Creates a button for the weapon
					createWeaponButton(w.name, w.selling_price, XScale[col], YScale[row], i)
					print("Successfully built a button!")
					print()
					
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
		if weapon_frame then
			if weapon_button:IsA("TextButton") then
				weapon_button.Parent = nil
			end
		end
	end
end

--Redisplays weapons after buying or selling a weapon
restockWeapons.OnClientEvent:Connect(function()
	if table.getn(player.Backpack:GetChildren()) == 1 then
		
		removeWeapons()
		
		--Need to tell players that they don't have any bought weapons
		if script.Parent.Parent.Message.Text ~= "You don't have any weapons to sell." then
			script.Parent.Parent.Message.Text = "You don't have any weapons to sell."
		end
		
		script.Parent.Parent.Message.Visible = true
	else
		
		--Removes message because player had weapons
		if script.Parent.Parent.Message.Visible == true then
			script.Parent.Parent.Message.Visible = false
		end
		
		removeWeapons()
		row, col = 1, 1
		displayWeapons()
	end
end)

--Initiates whenever the player spawns
if table.getn(player.Backpack:GetChildren()) == 1 then
	script.Parent.Parent.Message.Text = "You don't have any weapons to sell."
else
	script.Parent.Parent.Message.Visible = false
	displayWeapons()
end