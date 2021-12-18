--Gameplay Script
local Gameplay = script.Parent
--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Teams
local Teams = game:GetService('Teams')
--Players
local Players = game:GetService('Players')
--Lightning
local Lightning = game:GetService("Lighting")
--Team Points
local TeamPoints = ReplicatedStorage:FindFirstChild('Team Points')
local AllyPoints = TeamPoints:FindFirstChild('Ally Points')
local EnemyPoints = TeamPoints:FindFirstChild('Enemy Points')
--Score to Win
local VictoryScore = ServerStorage:FindFirstChild("Victory Score").Value
--Total Number of NPCs in the map
local NPC_Count = 0

--Runs the battle until either of the teams reached victory points
Gameplay:FindFirstChild('Run the Battle').OnInvoke = function()
	repeat 
		wait(.1) 
	until AllyPoints.Value >= VictoryScore or EnemyPoints.Value >= VictoryScore
end


--[[Randomly selects an arena map to spawn

	Return(s):
	Arena Map => Map model
]]
Gameplay:FindFirstChild('Assign Arena Map').OnInvoke = function()

	local ArenaMapFolder = ServerStorage:FindFirstChild("Arena Maps"):GetChildren()
	local ArenaMap = ArenaMapFolder[math.random(#ArenaMapFolder)]

	--COMMENT THIS OUT IF YOU'RE NOT TESTING THIS
	ArenaMap = ServerStorage['Get Arena Map for Test']:Invoke()
	print("The selected map is ".. ArenaMap.Name)

	local RS_Map = ReplicatedStorage:FindFirstChild('Map')
	RS_Map.Value = ArenaMap.Name

	return ArenaMap
end



--[[Randomnly selects an enemy team to participate for the next
	match.

	Return(s):
	Enemy Team => Collect of enemy NPC sets with NPCs
]]
Gameplay:FindFirstChild('Assign Enemy Team').OnInvoke = function()

	local EnemyTeams = ServerStorage:FindFirstChild("Enemy Teams"):GetChildren()
	local EnemyTeam = EnemyTeams[math.random(#EnemyTeams)]

	--COMMENT THIS OUT IF YOU'RE NOT TESTING THIS
	EnemyTeam = ServerStorage['Get Enemy Team for Test']:Invoke()
	print("The selected enemy team is "..EnemyTeam.Name)

	local RS_EnemyTeam = ReplicatedStorage:FindFirstChild("Selected Enemy Team Name")
	local EnemyIcon =  ReplicatedStorage:FindFirstChild("Selected Enemy Icon")

	--Needs data from the enemy for other scripts to use them
	RS_EnemyTeam.Value = EnemyTeam.Name --String
	EnemyIcon.Value = EnemyTeam.ImageID.Value --Integer

	return EnemyTeam
end



--[[Assigns player teams

	Parameter(s):
	enemy team folder => folder of the enemy team
]]
Gameplay:FindFirstChild('Assign All Players To Teams').OnInvoke = function(enemyTeamFolder)

	--Creates Ninja Heroes 101 Team
	local NH101_Team = Instance.new("Team", Teams)
	NH101_Team.Name = "Ninja Heroes 101"
	NH101_Team.AutoAssignable = true
	NH101_Team.TeamColor = BrickColor.new("Bright blue")

	--Creates Enemy Team
	local Enemy_Team = Instance.new("Team", Teams)
	Enemy_Team.Name = enemyTeamFolder.Name
	Enemy_Team.AutoAssignable = true
	Enemy_Team.TeamColor = BrickColor.new("Bright red")

	--[[ Team Types (You can change how you want to assign players)
	0: Balance teams out
	1: All Players in the same team (Debugger)
	
	(Set the value to 0 for the actual gameplay)]]
	local team_type = ServerStorage:FindFirstChild('Team Type').Value	
	--Assigns player a team
	local team_selector	
	--Balances out to an equal num of players in a team
	local team_balancer

	--[[Assigns each player to a different team and balances out the
		number of players assigned
		
		Parameters(s):
		player => player to be assigned to a team
	]]
	local function assignPlayerToDifferentTeam(player)

		--Assigns the team balancer ONCE
		if not team_balancer then team_balancer = math.random(1,2) end
		--Loops until the player is chosen a different team
		repeat team_selector = math.random(1,2) until team_selector ~= team_balancer 

		if team_selector == 1 then
			player.Team = NH101_Team
			team_balancer = 2
		else
			player.Team = Enemy_Team
			player.Character:FindFirstChild("Humanoid").Name = 'Zombie'
			team_balancer = 1
		end	
	end

	--Loops through every player in the server
	for _, player in pairs(Players:GetChildren()) do
		if not player.Team then --Otherwise, they are on 'Spectators' team

			--Assigns player to the same (exclusive) or different team
			if team_type == 0 then
				assignPlayerToDifferentTeam(player)
			else 
				team_selector = ServerStorage['Assign Player to the Same Team']:Invoke(player, team_selector, NH101_Team, Enemy_Team)
			end

			--Modifies player's overhead and background GUIs to match the team color
			ServerStorage['Change Player Overhead GUI']:Fire(player, player.Character)
			ReplicatedStorage['Change Player Background GUI']:FireClient(player)
		end
	end
end

--[[Spawns the map

	Paramater(s):
	map => model (map) that will be spawned in the Workspace
	spawner => part that relocates the map for spawning
]]
Gameplay:FindFirstChild('Spawn Map').OnInvoke = function(map, spawner)

	--Clones the Map from ServerStorage
	local clonedMap = ServerStorage['Arena Maps']:FindFirstChild(map.Name):Clone()

	--Assigns the map's primary part
	local base = clonedMap.Base
	clonedMap.PrimaryPart = base

	--Sets the CFrame to place the map with corresponding positional coordinates
	local cFrame
	if spawner then
		cFrame = CFrame.new(Vector3.new(spawner.Position.X, spawner.Position.Y, spawner.Position.Z))
	else --Break Room
		cFrame = CFrame.new(Vector3.new(base.Position.X, base.Position.Y, base.Position.Z))
	end

	--If Colosseum is selected as the map, then the orientation coordinates will need to be adjusted too
	if map.Name == "Colosseum" then cFrame *= CFrame.Angles(0, 0, math.rad(90)) end

	clonedMap:SetPrimaryPartCFrame(cFrame)
	clonedMap.Parent = workspace

	print(map.Name..' map has spawned in the game.')
end



--[[Despawns the map

	Parameter(s):
	map => model (map) to despawn from the Workspace
]]
Gameplay:FindFirstChild('Despawn Map').OnInvoke = function(map)
	workspace:FindFirstChild(map.Name):Remove()
end



--[[Changes sky depending on the map

	Parameter(s):
	team => enemy team selected to fight in the next round
	map => arena map that will spawn in the next round
]]
Gameplay:FindFirstChild('Change Sky').OnInvoke = function(team, map)

	--Selects a sky to add 
	local SelectedSky

	--The team is compared first before the map
	if team.Name == "The Undead" then
		SelectedSky = "Spooky Skys"
	elseif map.Name == "Desert" then --[[Desert map only]]
		SelectedSky = "Violent Days"
	elseif map.Name == "Snow" then --[[Snow map only]]
		SelectedSky = "Snowy Mountains"
	else
		SelectedSky = "Blue Skys"
	end

	--Checks whether the selected sky already exists
	local getSkyFromLightning = Lightning:FindFirstChild(SelectedSky)

	--Else replace the old sky with the new one
	if not getSkyFromLightning then
		Lightning:ClearAllChildren()
		local newSky = ServerStorage.Skys:FindFirstChild(SelectedSky)
		newSky:Clone().Parent = Lightning
		print("The new sky is "..newSky.Name)
	else
		print(getSkyFromLightning.Name..' already exists in Lightning')
	end
end



--[[Sets the speed walk to all players' characters

	Parameter(s):
	walk speed => walk speed of the character
]]
Gameplay:FindFirstChild('Set Speedwalk To All Fighters').OnInvoke = function(WalkSpeed)
	for _, player in pairs(Players:GetChildren()) do
		if player.Team then
			if player.Team.Name ~= 'Spectators' then
				player.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = WalkSpeed
			end
		end
	end
end



--[[Teleports a player or spawns/respawns an NPC to the map

	Parameter(s):
	character => character (model) that will be teleported/spawned to the map (cloned NPC or player)
	map => map (cloned model) where players/NPCs will spawn at
	isNPC => checks if the character comes from an NPC
]]
function teleporter(character, map, isNPC)

	-- Creates joints on NPC
	if isNPC then character:MakeJoints() end

	--Gets the spawn coordinates of the Map
	local SpawnCoordinates = map["Spawn Coordinates"]

	--Randomly selects X and Z values for spawning and selects Y too
	local X = math.random(SpawnCoordinates["Min X"].Value, SpawnCoordinates["Max X"].Value)
	local Y = SpawnCoordinates.Y.Value+2
	local Z = math.random(SpawnCoordinates["Min Z"].Value, SpawnCoordinates["Max Z"].Value)

	character.PrimaryPart = character:FindFirstChild("Torso")
	character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(X,Y,Z)))
	character.Parent = workspace
	print(character.Name.." has spawned at ("..X..","..Y..","..Z..")")
end

--Activates everytime the NPC or player gets respawned
ServerStorage:FindFirstChild('Respawn Character').Event:Connect(teleporter)

--[[Teleports all players to the map ot break room

	Parameter(s):
	map => map (model) where the players will spawn at
]]
Gameplay:FindFirstChild('Teleport All Players').OnInvoke = function(map)
	for i, player in pairs(Players:GetChildren()) do
		--print(i..": "..player.Name)
		teleporter(player.Character, map, false)
	end
end

--[[Spawns NPCs from a team

	Parameter(s):
	team => team (folder) containing all NPCs
	enemy team name => name of the enemy team
	map => map (model) where the NPCs will spawn at
]]
Gameplay:FindFirstChild('Spawn NPCs').OnInvoke = function(team, enemyTeam, map)

	--[[Spawns all non-unique NPCs to the map
	
		Parameter(s):
		NPC Set => collection of non-unique NPCs
	]]
	local function spawnAllNPCsFromSet(NPCSet)
		for _, NPC in pairs(NPCSet:GetChildren()) do
			if NPC:IsA('Model') then
				for i = 1, NPC['Total Spawn'].Value do
					teleporter(NPC:Clone(), map, true) --spawns NPC
					wait(1)
					NPC_Count += 1
					print(NPC_Count..' NPCs has spawned in the map')
				end
			end
		end
	end

	--[[Selects NPCs to spawn in the the map
	
		Parameter(s):
		NPC Set => collection of NPCs
		n => max amount of NPCs to spawn in the map
	]]
	local function spawnSelectedNPCsFromSet(NPCSet, n)

		--Table (Strings) of NPCs' names to spawn in 
		local NPCsList = {}
		--Current index of the table
		local i = 1
		--Iterates until the length uniqueNPCs table = max amount
		while table.getn(NPCsList) < n do

			--Randomly selects an NPC and repeats until an instance is a NPC model
			local NPC
			repeat NPC = NPCSet:GetChildren()[math.random(1, #NPCSet:GetChildren())] until NPC:IsA('Model')

			--Adds an NPC model to the table and spawns it to the arenamap
			if not table.find(NPCsList, NPC.Name) then
				table.insert(NPCsList, i, NPC.Name)
				for j = 1, NPC['Total Spawn'].Value do
					teleporter(NPC:Clone(), map, true)
					wait(1)
					NPC_Count += 1
					print(NPC_Count..' NPCs has spawned in the map')
				end				
				i += 1
			end
		end
	end

	--[[Selects NPCs from NH101 NPC Set 1 based from the
		enemy team.
		
		Parameter(s):
		NPC Set => collection of unique NPCs
	]]
	local function spawnSomeNPCsFromNH101NPCSet1(NPCSet)

		--Gets a collection of NH101's harder team opponents
		local HardEnemyTeams = NPCSet['Hard Enemy Teams']
		--Collection of selected NPCs to spawn in the arena
		local NPCsTable

		--Adds NPCs to the NPCs table
		if HardEnemyTeams:FindFirstChild(enemyTeam) then
			NPCsTable = {'Male Ninja 2', 'Female Ninja 2'}
		else
			NPCsTable = {'Male Ninja', 'Female Ninja'}
		end

		for _, NPC_Name in pairs(NPCsTable) do
			local NPC = NPCSet:FindFirstChild(NPC_Name)
			for i = 1, NPC['Total Spawn'].Value do
				wait(1)
				teleporter(NPC:Clone(), map, true)
				NPC_Count += 1
				print(NPC_Count..' NPCs has spawned in the map')
			end
		end
	end

	--Iterates through every NPC Set (Folder) in the team
	for _, NPCSet in pairs(team:GetChildren()) do
		if NPCSet:IsA("Folder") then
			--Selects NH101 NPCs from Set 1
			if NPCSet:FindFirstChild('Is NH101 NPC Set 1') then 
				spawnSomeNPCsFromNH101NPCSet1(NPCSet)
				--Selects NPCs to participate in the match
			elseif NPCSet:FindFirstChild('Num Selects') then 
				spawnSelectedNPCsFromSet(NPCSet, NPCSet['Num Selects'].Value)
				--Selects all NPCs
			else
				spawnAllNPCsFromSet(NPCSet)
			end
		end
	end
end



--Despawns all NPCs
Gameplay:FindFirstChild('Despawn All NPCs').OnInvoke = function()

	local function run()
		for _, obj in pairs(workspace:GetChildren()) do
			if obj:IsA("Model") then
				--Total Spawn property only exists in NPCs (not player characters)
				if obj:FindFirstChild('Total Spawn') then
					obj:Remove()
					--print(obj.Name..'has despawned')
					NPC_Count -= 1
					--print("There are "..AI_Count.." NPCs left.")
				end
			end
		end
	end

	--All AIs need to despawn 
	while NPC_Count ~= 0 do
		run()
		print(NPC_Count.." NPCs has despawned in the map")
		wait(1) --Prevents the game from crashing!
	end
end




--Adds Chase Scripts to all NPCs
Gameplay:FindFirstChild('Add Chase Scripts to All NPCs').OnInvoke = function()

	--[[Adds a Chase Script to an NPC model
	
		Parameter(s):
		NPC => NPC (model) needed to add a chase script to it
	]]
	local function addChaseScriptToNPC(NPC)
		ServerStorage['Other Scripts']:FindFirstChild("Chase Script"):Clone().Parent = NPC
	end

	--Goes through every NPC in the Workspace
	for _, NPC in pairs(workspace:GetChildren()) do
		--We will use the model's total spawn property to detect an NPC
		if NPC:IsA("Model") and NPC:FindFirstChild('Total Spawn') then	
			addChaseScriptToNPC(NPC) 
		end
	end

	--Fires after an NPC respawns to get the chase script
	ServerStorage:FindFirstChild("Add Chase Script to NPC").Event:Connect(addChaseScriptToNPC)
end



--Removes all teams
Gameplay:FindFirstChild('Remove All Teams').OnInvoke = function()		
	--Removes a player from a team
	--for _, player in pairs(Players:GetChildren()) do player.Team = nil end
	Teams:ClearAllChildren()
end



--Resets team scores to 0
Gameplay:FindFirstChild('Reset Team Scores').OnInvoke = function()
	AllyPoints.Value = 0
	EnemyPoints.Value = 0
end