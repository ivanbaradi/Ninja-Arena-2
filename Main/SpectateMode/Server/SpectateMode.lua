--[[This script performs APIs in Spectate Mode]]

--Replaces player's Humanoid Scripts with Spectator ones
function ReplaceWithSpectatorScripts(character)
	
	print("ReplaceWithSpectatorScripts Called!")
	
	--Finds player's Animate and Humanoid scripts, and removes them from the player's character
	for _, obj in pairs(character:GetChildren()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") then
			if obj.Name == "Animate" or obj.Name == "Health" then
				obj:Remove()
			end
		end
	end
	
	--PlayerSpectatorScripts Folder
	local SpectatorFolder = game.ReplicatedStorage:FindFirstChild("PlayerSpectatorScripts")
	
	--Adds in Spectator scripts from PlayerSpectatorScripts folder to the player's character
	for _, obj in pairs(SpectatorFolder:GetChildren()) do obj:Clone().Parent = character end 
end

--Removes all player's weapons from the inventory
function RemoveWeaponsFromInventory(player)
	
	--Checks if the object is a food
	local function isFood(obj)
		
		--List of foods
		local foods = {"Bloxiade","Cheeseburger","Pizza","Sandwich","Bloxy Soda","Chicken Leg","Hot Dog","Mountain Dew","Starblox Latte","Taco"}
		
		--Returns true if the object's name matches the food's name
		for _, food in pairs(foods) do
			if obj == food then
				return true
			end
		end
		
		return false
	end
	
	--Player's weapon holder containing all player's wepaons
	local WeaponHolder
	
	--If the player goes on Spectate Mode for the 1st time in the server
	if not player:FindFirstChild("Weapon Holder") then
		WeaponHolder = Instance.new("Folder", player)
		WeaponHolder.Name = "Weapon Holder"
	end
	
	--Goes through player's items from StarterGear and removes only weapons from it and the backpack
	for _, obj in pairs(player.StarterGear:GetChildren()) do
		if not isFood(obj.Name) then
			--Removes item from the player's StarterGear and Backpack
			obj:Remove()
			player.Backpack:FindFirstChild(obj.Name):Remove()
			
			--Places weapon inside the WeaponHolder Folder
			local ObjHolder = Instance.new("StringValue", WeaponHolder)
			ObjHolder.Name = obj.Name
		end
	end
end

--[[Player enters Spectate Mode. This function does the following:
1. Creates a team called Spectators (if it doesn't exist)
2. Assigns player to "Spectators" Team
3. Changes Humanoid's name to "Spectator"
4. Changes character's walkspeed to 50.
5. Changes the animation scripts to make them compatible with Spectator Humanoid
6. Calls in the client to change the Player GUI background color to brown]]
function EnterSpectateMode(player)
	
	--Spectators Team
	local SpectatorTeam

	--If "Spectators" Team doesn't exist
	if not SpectatorTeam then
		SpectatorTeam = Instance.new("Team", game.Teams)
		SpectatorTeam.Name = "Spectators"
		SpectatorTeam.AutoAssignable = false
		SpectatorTeam.TeamColor = BrickColor.new("Brown")
		print("Spectators Team is added!")
	else
		SpectatorTeam = game.Teams:FindFirstChild("Spectators")
	end
	
	--Assigns player to Spectators Team
	if not player.Team then player.Team = SpectatorTeam end
	
	--Gets player's Humanoid
	local humanoid = player.Character:FindFirstChild("Humanoid")

	--Modifies humanoid's name and walkspeed
	humanoid.Name = "Spectator"
	humanoid.WalkSpeed = 50

	--Needs to replace old animation scripts to make them compatible with Spectator Humanoid
	ReplaceWithSpectatorScripts(player.Character)

	--Communicates local script to change the Player GUI's background color to brown
	game.ReplicatedStorage:FindFirstChild("ChangePlayerGUIBackgroundColor_BROWN"):FireClient(player)
	
	--Communicates with SpawnTeamPlayer script to change the Player Overhead GUI's stroke color to brown
	game.ServerStorage:FindFirstChild("Change Player Overhead GUI"):Fire(player)
end

--Handles request after the player presses "Yes" to enter Spectate Mode (Remote Event)
game.ReplicatedStorage:FindFirstChild("OnSpectateMode").OnServerEvent:Connect(EnterSpectateMode)

--Handles request after the "Spectator" player respawns (Bindable Event)
game.ServerStorage:FindFirstChild("Enter Spectate Mode").Event:Connect(EnterSpectateMode)