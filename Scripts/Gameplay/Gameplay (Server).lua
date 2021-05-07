--[[
EACH TEAM HAS THE FOLLOWING:
1. Name: Name of the team
2. Icon: Used to display it on the scoreboard
]]
local EnemyTeams = { --Add Icons to 4 other teams
	{Name = "Syberians", Icon = "rbxassetid://5611786471"},
	{Name = "Korblox", Icon = "rbxassetid://5797967479"},
	{Name = "The Undead", Icon = "rbxassetid://5857376360"},
	{Name = "The Kingdom", Icon = "rbxassetid://6715996787"}
}

--[[
EACH MAP HAS THE FOLLOWING:
- Name: Name of the map
- MinX and MaxX: Specific X position ranges for spawning character model
- Y: Y position for spawning character model
- MinZ and MaxZ: Specific Z position ranges for spawning character model
- PrimaryX, PrimaryY, and PrimaryZ: XYZ position of the Primary Part
- Primary Part: Used to spawn the primary part along with its adjacent parts/objects (Map) in the Workspace
]]
local Map = {
	{Name = "Greenlands", MinX = -246, MaxX = 140, Y = 23, MinZ = -341 , MaxZ = 43, PrimaryPart = "Grass", PrimaryX = -49, PrimaryY = 22.5, PrimaryZ = -151},
	{Name = "Desert", MinX = 20.5, MaxX = 434.5, Y = 12, MinZ = -312.5, MaxZ = 88.5, PrimaryPart = "Sand", PrimaryX = 225.5, PrimaryY = 10, PrimaryZ = -113.5},
	{Name = "Snow", MinX = 1215, MaxX = 1552, Y = 8, MinZ = -1112, MaxZ = -798, PrimaryPart = "Snow Grass", PrimaryX = 1380, PrimaryY = 3, PrimaryZ = -933},
	{Name = "Colosseum", MinX = 1502.5, MaxX = 1911.5, Y = -191.5, MinZ = -1042, MaxZ = -668, PrimaryPart = "Floor", PrimaryX = 1698.5, PrimaryY = -194.5, PrimaryZ = -858.5}
}

--Selected Map (Gets Map Struct)
local SelectedMap
--Selected Sky (Selected Blue Skys as default)
local SelectedSky = "Blue Skys"
--Map Index (Used to have players spawn at the correct spawn location when joining the game)
local MapIndex = game.ReplicatedStorage:FindFirstChild("Map")
--Selected Enemy Team (Gets Enemy Team String)
local SelectedEnemyTeam
--Total Number of AIs in the map
local AI_Count = 0
--CreateScoreBoard Remote Event
local CreateScoreBoard = game.ReplicatedStorage:FindFirstChild("CreateScoreBoard")
--RemoveScoreBoard Event
local RemoveScoreBoard = game.ReplicatedStorage:FindFirstChild("RemoveScoreBoard")
--EndRound Remote Event
local EndTheRound = game.ReplicatedStorage:FindFirstChild("EndTheRound")
--Teams (Player Teams)
local PlayerTeams = game:FindFirstChild("Teams")
--Enemy Team's Name and Icon (Shared by other scripts)
local EnemyTeamName, EnemyIcon = game.ReplicatedStorage:FindFirstChild("EnemyTeam"), game.ReplicatedStorage:FindFirstChild("EnemyIcon")
--MakePlayerMessagesInvisible Remote Event
local MakePlayerMessagesInvisible = game.ReplicatedStorage:FindFirstChild("MakePlayerMessagesInvisible")
--SendMessageToAllPlayers Remote Event
local SendMessageToAllPlayers = game.ReplicatedStorage:FindFirstChild("SendMessageToAllPlayers")
--CloseRefrigerator Event
local CloseRefrigerator = game.ReplicatedStorage:FindFirstChild("CloseRefrigerator")
--CanPlaySong Object
local canPlaySong = game.Workspace.Playlist.Songs:FindFirstChild("CanPlaySong")
--PlayerCanMove Object
local PlayerCanMove = script:FindFirstChild("PlayerCanMove")
--AllyPoints and EnemyPoints
local allyPoints = game.ReplicatedStorage.TeamPoints:FindFirstChild("AllyPoints")
local enemyPoints = game.ReplicatedStorage.TeamPoints:FindFirstChild("EnemyPoints")
--RoundContinuing Object
local RoundContinuing = script:FindFirstChild("RoundContinuing")
--PlayerCanReset Object
local PlayerCanReset = game.ReplicatedStorage:FindFirstChild("PlayerCanReset")
--Can Spawn On Map Object
local CanSpawnOnMap = game.ReplicatedStorage:FindFirstChild("Can Spawn On Map")
--Score to Win
local VictoryScore = 2500

--[[DisableSpeedButton Remote Event
	The server will tell all clients to disable players' speed buttons,
	because the round has not started yet due to AIs spawning]]
local DisableSpeedButton = game.ReplicatedStorage:FindFirstChild("DisableSpeedButton")

--[[EnableSpeedButton Remote Event
	The server will tell all clients to enable players' speed buttons,
	because the round now started]]
local EnableSpeedButton = game.ReplicatedStorage:FindFirstChild("EnableSpeedButton")

--PlayerCanUseSpeed Object
local PlayerCanUseSpeed = game.ReplicatedStorage:FindFirstChild("PlayerCanUseSpeed")
--True if points can get updates (All AIs must be initially spawned before setting this to true)
local CanUpdateScore = game.ReplicatedStorage:FindFirstChild("CanUpdateScore")

--[[PlayerGuiBackgroundColorKey Key Object
	0: Switch Player GUI background color to gray
	1: Switch Player GUI background color to red or blue]]
local PlayerGuiBackgroundColorKey = game.ReplicatedStorage:FindFirstChild("PlayerGuiBackgroundColorKey")

--[[RoundHasEnded REMOTE EVENT
This remote event will have the server tell all clients about who won,
and how many XP they earn playing the round.]]
local RoundHasEnded = game.ReplicatedStorage:FindFirstChild("RoundHasEnded")

--ChangePlayerGUIBackgroundColor Remote Event
local ChangePlayerGUIBackgroundColor = game.ReplicatedStorage:FindFirstChild("ChangePlayerGUIBackgroundColor")
--Change Playlist Bindable Event
local ChangePlaylist = game.ServerStorage:FindFirstChild("Change Playlist")
--True if players can use spectate mode button
local CanUseSpectateModeButton = game.ReplicatedStorage:FindFirstChild("Can Use Spectate Mode Button")


--Spawns enemy AIs from different groups per round
function spawnEnemyAI()
	
	--Used to get retrieve the Enemy AI models from the Folder
	local findTeam
	--All enemy AIs from a certain team
	local EnemyAIs
	--Selects AI pos value to spawn and prevents another AI from spawning
	local SelectedAIs = {}	
	--Spawns AI in a given position
	local function spawnAI(enemyAI)				
		--Cloning AI (Model)
		local cloneAI = findTeam:FindFirstChild(enemyAI.Name):Clone()
		cloneAI:MakeJoints()
		--Setting XYZ Spawn Limits
		wait(.7)
		--Spawning AI
		local X = math.random(SelectedMap.MinX, SelectedMap.MaxX)
		local Y = SelectedMap.Y 
		local Z = math.random(SelectedMap.MinZ, SelectedMap.MaxZ)
		cloneAI.PrimaryPart = cloneAI:FindFirstChild("Torso")
		cloneAI:SetPrimaryPartCFrame(CFrame.new(Vector3.new(X,Y,Z)))
		cloneAI.Parent = game.Workspace
		print(enemyAI.Name.." has spawned at ("..X..","..Y..","..Z..")")
		AI_Count += 1
	end
	
	--Selects Unique AIs (first parameter is a position of the first unique AI)
	local function selectUniqueAI(c)
		--Unique AIs that are already selected (Prevents duplication of unique AIs)
		local alreadySelected = {}
		--Starting index for inserting Unique AIs
		local x
		--Starting index is 1 in alreadySelected
		local y = 1
		--Certain amount Unique Characters can be selected
		local MaxSelected = 2
		--Counts how many AIs are already selected
		local Selected = 0
		
		--Index to the current position of adding AIs
		if SelectedEnemyTeam.Name == "Syberians" then
			x = 4
		elseif SelectedEnemyTeam.Name == "Korblox" then
			x = 3
		else --The Kingdom
			x = 5
		end
		
		while Selected < MaxSelected do
			--True if the item already exists in the alreadySelected table
			local found = false
			--Randomly selects an AI  pos value
			wait(1)
			local b = math.random(c, table.getn(EnemyAIs))
			
			--Checks if the AI already exists in the alreadySelected table
			for i, a in pairs(alreadySelected) do
				if EnemyAIs[b].Name == a then
					print("Error: "..EnemyAIs[b].Name.." is already selected!!")
					found = true
				end
			end
			
			--If not found, then insert the AI's pos value in SelectedAIs table
			if not found then
				--Inserts an AI in SelectedAI table
				table.insert(SelectedAIs, x, EnemyAIs[b])
				x += 1
				
				--Inserts an AI in alreadySelected table
				table.insert(alreadySelected, y, EnemyAIs[b].Name)
				y += 1

				print(EnemyAIs[b].Name.." is selected!")
				Selected += 1
			end
		end
	end
	
	--Clones Enemy AIs
	if SelectedEnemyTeam.Name == "Syberians" then
		--Gets Syberians Team
		findTeam = game.ServerStorage:FindFirstChild("Syberians")
		
		--Syberian characters
		EnemyAIs = {
			--SET 1 (Syberian Ninjas)
			{Name = "Syberian Male Ninja", TotalSpawn = 15},
			{Name = "Syberian Female Ninja", TotalSpawn = 8},
			--SET 2 (Syberian Elite)
			{Name = "Syberian Elite", TotalSpawn = 4},
			--SET 3 (Syberian Female Assassin)
			{Name = "Syberian Female Assassin", TotalSpawn = 3},
			--SET 4 (Syberian Male Assassin)
			{Name = "Syberian Male Assassin", TotalSpawn = 3},
			--SET 5 (Syberian Juggernaut)
			{Name = "Syberian Juggernaut", TotalSpawn = 1},
			--SET 6 (Unique Characters)
			{Name = "Henry", TotalSpawn = 1},
			{Name = "Penelope", TotalSpawn = 1},
			{Name = "Tashima", TotalSpawn = 1},
			{Name = "Aota", TotalSpawn = 1},
			{Name = "Talania", TotalSpawn = 1}
		}
		
		--SET 1: Syberian Male Ninja and Syberian Female Ninja
		table.insert(SelectedAIs, 1, EnemyAIs[1])
		table.insert(SelectedAIs, 2, EnemyAIs[2])

		--SET 2 to 4: Syberian Elite, Syberian Male Assassin, or Syberian Female Assassin
		local A = EnemyAIs[math.random(3,5)]
		table.insert(SelectedAIs, 3, A)
		print(A.Name.." is selected!")
		
		--SET 5 and 6: Syberian Juggernaut or Two Unique Characters
		local option = math.random(1,2)
		
		if option == 1 then
			table.insert(SelectedAIs, 4, EnemyAIs[6])
			print(EnemyAIs[6].Name.." is selected!")
		else
			selectUniqueAI(7)
		end
		
	elseif SelectedEnemyTeam.Name == "Korblox" then
		--Gets Korblox Team
		findTeam = game.ServerStorage:FindFirstChild("Korblox")
		
		--Korblox characters
		EnemyAIs = {
			--SET 1 (Korblox)
			{Name = "Korblox", TotalSpawn = 23},
			--SET 2 (Korblox Elites)
			{Name = "Korblox Elite", TotalSpawn = 4},
			--SET 3 (Korblox Captain)
			{Name = "Korblox Captain", TotalSpawn = 1},
			--SET 4 (Unique Characters)
			{Name = "Skelablox", TotalSpawn = 1},
			{Name = "Azidahaka", TotalSpawn = 1}
		}
		
		--Inserting NPCs from Sets 1 and 2
		table.insert(SelectedAIs, 1, EnemyAIs[1])
		table.insert(SelectedAIs, 2, EnemyAIs[2])
		
		--Set 3 or Set 4
		local random 
		random = math.random(1,2)
		--random = 2
		
		if random == 1 then
			table.insert(SelectedAIs, 3, EnemyAIs[3]) --Set 3 is selected
		else
			selectUniqueAI(4) --Set 4 is selected
		end
	elseif SelectedEnemyTeam.Name == "The Undead" then
		findTeam = game.ServerStorage:FindFirstChild("TheUndead")
		
		--The Undead AIs
		EnemyAIs = {
			--SET 1
			{Name = "Zombie", TotalSpawn = 8},
			{Name = "Swordman Zombie", TotalSpawn = 6},
			{Name = "Undead", TotalSpawn = 6},
			--SET 2
			{Name = "Alpha Zombie", TotalSpawn = 3},
			--SET 3
			{Name = "Speedy Zombie", TotalSpawn = 2},
			--SET 4
			{Name = "Brute Zombie", TotalSpawn = 1},
		}
		
		--Inserts Zombie and Undead AIs
		table.insert(SelectedAIs, 1, EnemyAIs[1])
		table.insert(SelectedAIs, 2, EnemyAIs[2])
		table.insert(SelectedAIs, 3, EnemyAIs[3])

		--Inserts Alpha Zombies or Speed Zombies
		local random
		random = math.random(1,2)
		--random = 2
		
		if random == 1 then
			table.insert(SelectedAIs, 4, EnemyAIs[4])
		else
			table.insert(SelectedAIs, 4, EnemyAIs[5])
		end
		
		--Inserts Brute Zombie
		table.insert(SelectedAIs, 5, EnemyAIs[6])
	else
		findTeam = game.ServerStorage:FindFirstChild("The Kingdom")

		EnemyAIs = {
			--SET 1
			{Name = "Knight", TotalSpawn = 13},
			{Name = "Blue Knight", TotalSpawn = 7},
			{Name = "Redcliff Knight", TotalSpawn = 5},
			--SET 2
			{Name = "Redcliff Elite", TotalSpawn = 4},
			{Name = "Redcliff Assassin", TotalSpawn = 2},
			--SET 3
			{Name = "Colossal Knight", TotalSpawn = 1},
			{Name = "Guardian", TotalSpawn = 1},
			--SET 4
			{Name = "Marco", TotalSpawn = 1},
			{Name = "Vaquez", TotalSpawn = 1},
			{Name = "Clayton", TotalSpawn = 1}
		}
		
		--Inserts Knight, Blue Knight, and Redcliff Knight NPCs (SET 1)
		table.insert(SelectedAIs, 1,EnemyAIs[1])
		table.insert(SelectedAIs, 2,EnemyAIs[2])
		table.insert(SelectedAIs, 3,EnemyAIs[3])
				
		--Inserts either Redcliff Elite or Redcliff Assassin (SET 2)
		local choice = EnemyAIs[math.random(4,5)]
		table.insert(SelectedAIs, 4, choice)
		print(choice.Name.." is selected!")
		
		--Inserts either Colossal Knight, Guardian, or Unique Characters (SET 3)
		choice = math.random(1,2)
		
		if choice == 1 then --Colossal Knight or Guardian
			table.insert(SelectedAIs, 5, EnemyAIs[math.random(6,7)])
		else --Unique Characters
			selectUniqueAI(8) 
		end
	end
		
	--Spawning in Enemy AIs
	for i, enemyAI in pairs(SelectedAIs) do
		print(enemyAI.Name.."'s turn to spawn")
		for j = 1, enemyAI.TotalSpawn, 1 do
			spawnAI(enemyAI)
		end
	end	
end

--Spawns NH101 AIs
function spawnAllyAI()
	
	--NH101 Team
	local NH101 = game.ServerStorage:FindFirstChild("NH101")
	--Total AIs it can select
	local MaxSelected = 0
	--Amount of AIs selected
	local Selected = 0
	--Table for selected AIs
	local selectedAIs = {}
	--Starting pos value to insert Unique AI
	local x = 5
	
	--List of NH101 characters
	local AllyAIs = {
		--SET 1 (Ninjas)
		{Name = "Male Ninja", TotalSpawn = 15},
		{Name = "Female Ninja", TotalSpawn = 8},
		--SET 2 (Ninjas 2.0)
		{Name = "Male Ninja 2", TotalSpawn = 15},
		{Name = "Female Ninja 2", TotalSpawn = 8},
		--SET 3 (Ninja Elite)
		{Name = "Ninja Elite", TotalSpawn = 4},
		--SET 4 (Royal Ninja)
		{Name = "Royal Ninja", TotalSpawn = 1},
		--SET 5 (Unique Characters)
		{Name = "Brent", TotalSpawn = 1},
		{Name = "Jade", TotalSpawn = 1},
		{Name = "Walter", TotalSpawn = 1},
		{Name = "Katherine", TotalSpawn = 1},
		{Name = "Jeff", TotalSpawn = 1},
		{Name = "Jonah", TotalSpawn = 1},
		{Name = "Marc", TotalSpawn = 1}
	}
		
	--Spawns AI in a given position
	local function spawnAI(allyAI)				
		--Cloning AI (Model)
		local cloneAI = NH101:FindFirstChild(allyAI.Name):Clone()
		cloneAI:MakeJoints()
		wait(.7)
		--Spawning AI
		local X = math.random(SelectedMap.MinX, SelectedMap.MaxX)
		local Y = SelectedMap.Y 
		local Z = math.random(SelectedMap.MinZ, SelectedMap.MaxZ)
		cloneAI.PrimaryPart = cloneAI:FindFirstChild("Torso")
		cloneAI:SetPrimaryPartCFrame(CFrame.new(Vector3.new(X,Y,Z)))
		cloneAI.Parent = game.Workspace
		print(allyAI.Name.." has spawned at ("..X..","..Y..","..Z..")")
		AI_Count += 1
	end
	
		--Selects AIs that are deemed to be choosen
	local function selectUniqueAI()
		while Selected < MaxSelected do
			--True if the item already exists in the alreadySelected table
			local found = false
			--Randomly selects an AI pos value
			wait(1)
			local b = math.random(7, table.getn(AllyAIs))
			
			--Checks if the AI already exists in the alreadySelected table
			for i, a in pairs(selectedAIs) do
				if AllyAIs[b].Name == a.Name then
					print("Error: "..AllyAIs[b].Name.." is already selected!!")
					found = true
				end
			end
			
			--If not found, then insert the AI's pos value in SelectedAIs table
			if not found then
				--Inserts an AI in SelectedAI table
				table.insert(selectedAIs, x, AllyAIs[b])
				x += 1
				
				print(AllyAIs[b].Name.." is selected!")
				Selected += 1
			end
		end
	end
	
	--SET 1 OR SET 2: Choose either "Male Ninja" and "Female Ninja" OR "Male Ninja 2" and "Female Ninja 2" based on the enemy team
	if SelectedEnemyTeam.Name == "Syberians" or SelectedEnemyTeam.Name == "The Kingdom" then
		table.insert(selectedAIs, 1, AllyAIs[1])
		table.insert(selectedAIs, 2, AllyAIs[2])
		print("Male Ninja and Female Ninja are selected!")
	else
		table.insert(selectedAIs, 1, AllyAIs[3])
		table.insert(selectedAIs, 2, AllyAIs[4])
		print("Male Ninja 2 and Female Ninja 2 are selected!")
	end
	
	--SET 3: Ninja Elite
	table.insert(selectedAIs, 3, AllyAIs[5])
	
	--SET 4 or SET 5 (1 = Royal Ninja, 2 = Two Unique AIs)
	local option = math.random(1,2)
	--local option = 2
	if option == 1 then
		table.insert(selectedAIs, 4, AllyAIs[6])
		print("Royal Ninja is selected!")
	else
		MaxSelected = 2
		selectUniqueAI()
	end
	
	--Spawning Ally AIs
	for i, AI in pairs(selectedAIs) do
		for j = 1, AI.TotalSpawn, 1 do
			spawnAI(AI)
		end
	end
end

--Sets XYZ Spawn Ranges
function setXYZSpawn()
	--Used to give specific positions to spawn AI
	local XYZSpawn = game.Workspace.SpawnXYZ
	
	--Sets MinX, MaxX, Y, MinZ, and MaxZ
	XYZSpawn.MinX.Value = SelectedMap.MinX
	XYZSpawn.MaxX.Value = SelectedMap.MaxX
	XYZSpawn.Y.Value = SelectedMap.Y
	XYZSpawn.MinZ.Value = SelectedMap.MinZ
	XYZSpawn.MaxZ.Value = SelectedMap.MaxZ
end

--Despawns all AIs
function despawnAIs()
	--Goes through all children in Model to find Humanoid
	local function findHumanoid(model)
		for i, instance in pairs(model:GetChildren()) do
			if instance:IsA("Humanoid") then
				return true
			end
		end
		return false
	end
	
	
	--Goes through all children in the Workspace to find AI Model
	local function findAIModel()
		for i, object in pairs(game.Workspace:GetChildren()) do
			if object:IsA("Model") then
				local found = findHumanoid(object)
				if found and object.Name == "" then --Players stay in the map
					--Despawning AI
					object:Remove()
					print("AI has despawned")
					AI_Count -= 1
					print("There are "..AI_Count.." AIs left.")
				end
			end
		end
	end
	
	--All AIs need to despawn 
	while AI_Count ~= 0 do
		findAIModel()
		print(AI_Count.." AIs has despawned in the map")
		wait(1) --Prevents the game from crashing!
	end
end

--Spawns the map
function spawnMap()
	
	--Clones the Map from ServerStorage
	local getMap = game.ServerStorage.Maps:FindFirstChild(SelectedMap.Name):Clone()
	
	--Gets the Map's Primary Part
	getMap.PrimaryPart = getMap:FindFirstChild(SelectedMap.PrimaryPart)
	
	--Sets the CFrame to place the map with corresponding positional coordinates
	local cFrame = CFrame.new(Vector3.new(SelectedMap.PrimaryX, SelectedMap.PrimaryY, SelectedMap.PrimaryZ))
	
	--If Colosseum is selected as the map, then the orientation coordinates will need to be adjusted too
	if SelectedMap.Name == "Colosseum" then
		cFrame *= CFrame.Angles(0, 0, math.rad(90))
	end
	
	getMap:SetPrimaryPartCFrame(cFrame)
	getMap.Parent = game.Workspace
end

--Despawns the map
function despawnMap()
	local m = game.Workspace:FindFirstChild(SelectedMap.Name)
	m:Remove()
end

--Teleports all players to the break room
function TeleportAllPlayersToBreakRoom()
	
	--Replaces character's zombie or spectator scripts with humanoid ones
	local function AddHumanoidScripts(char)
		
		--Will need to remove Zombie or Spectator scripts from the player
		char:FindFirstChild("Animate"):Remove()
		char:FindFirstChild("Health"):Remove()
		
		--Clones humanoid scripts and adds them to the player's character
		for _, HumanoidScript in pairs(game.ReplicatedStorage.PlayerHumanoidScripts:GetChildren()) do HumanoidScript:Clone().Parent = char end
	end
	
	--Teleports all players back to the Break Room
	for _, player in pairs(game:GetService("Players"):GetChildren()) do
		
		--Player's character
		local char = player.Character
		
		--Will need to replace zombie scripts with humanoid scripts
		if player.Team.Name ~= "Ninja Heroes 101" then
			
			--Adds humanoid scripts to the player
			AddHumanoidScripts(char)
			
			--Changes the player humanoid's name to Humanoid
			char:FindFirstChildOfClass("Humanoid").Name = "Humanoid"
		end
		
		--Chooses X, Y, and Z positions to teleport player
		local X = math.random(33.5, 79.5)
		local Y = 98.6
		local Z = math.random(-944, -889)
		
		--Sets Player's Primary Part
		char.PrimaryPart = char:FindFirstChild("Torso")
				
		--Teleports player to the break room
		local cFrame = CFrame.new(Vector3.new(X,Y,Z))
		char:SetPrimaryPartCFrame(cFrame)
	end
end

--Teleports all players to the map and sets their walkspeeds to 0
function TeleportAllPlayersToTheMap()
	
	local Players = game:GetService("Players")
	
	local SpawnPlayerToMap = game.ServerStorage:FindFirstChild("Spawn Player To Map")
	
	for _, player in pairs(Players:GetChildren()) do
		
		--Communicates with SpawnTeamPlayer script to spawn player at the map
		SpawnPlayerToMap:Fire(player.Character)
		
		--References player's humanoid if they are either on NH101 team or Enemy team
		local humanoid_fighter = player.Character:FindFirstChild("Humanoid") or player.Character:FindFirstChild("Zombie")
		
		--Sets player's humanoid walkspeed to 0
		if humanoid_fighter then humanoid_fighter.WalkSpeed = 0 end
	end
end

--Spawns Break Room
function spawnBreakRoom()
	
	--Gets the Break Room Model from the ServerStorage
	local m = game.ServerStorage:FindFirstChild("Break Room"):Clone()
	
	--Sets the Primary Part for Break Room
	m.PrimaryPart = m:FindFirstChild("Floor")
	
	--Spawns the Break Room
	local cFrame = CFrame.new(Vector3.new(56.5,97,-918))
	m:SetPrimaryPartCFrame(cFrame)
	m.Parent = game.Workspace
end

--Despawns Break Room
function despawnBreakRoom()
	local m = game.Workspace:FindFirstChild("Break Room")
	m:Remove()
end

--Assigns player teams
function assignPlayerTeams()
	
	--Used to get all players in the server
	local Player = game:GetService("Players")
	
	--Creates Ninja Heroes 101 Team
	local NH101_Team = Instance.new("Team", PlayerTeams)
	NH101_Team.Name = "Ninja Heroes 101"
	NH101_Team.AutoAssignable = true
	NH101_Team.TeamColor = BrickColor.new("Bright blue")
	
	--Creates Enemy Team
	local Enemy_Team = Instance.new("Team", PlayerTeams)
	Enemy_Team.Name = SelectedEnemyTeam.Name
	Enemy_Team.AutoAssignable = true
	Enemy_Team.TeamColor = BrickColor.new("Bright red")
	
	--[[ Team Types (You can change how you want to assign players)
	0: Balance teams out
	1: All Players in the same team (Debugger)
	
	(Set the value to 0 for the actual gameplay)]]
	local team_type = 0
	
	--[[ Used to balance out teams (Prevents one side from having too many teammates)
	1: Ninja Heroes 101, 2: Enemy Team (OPTION 0)]] 
	local team_balancer
			
	--Assigns player a team
	local team_selector
	
	if team_type == 0 then 
		team_balancer = math.random(1,2) --Balancer is used to accumulate the same num of players per team
	else
		team_selector = math.random(1,2) --All players are going to be at the same team
	end

	--Assigns player teams
	for _, player in pairs(Player:GetPlayers()) do
		
		--Spectators are already in a team
		if not player.Team then
			
			--Will have the same number of players per team (OPTION 0)
			if team_type == 0 then repeat team_selector = math.random(1,2) until team_selector ~= team_balancer end
						
			--Assigns player to be at NH101 Team or Enemy Team
			if team_selector == 1 then
				player.Team = NH101_Team
			else
				player.Team = Enemy_Team
				local humanoid = player.Character:FindFirstChild("Humanoid")
				humanoid.Name = "Zombie"
				--Communicates with SpawnTeamPlayer script to add zombie scripts to player
				game.ServerStorage:FindFirstChild("Add Zombie Scripts"):Fire(player.Character)
			end
			
--			print("Assigned "..player.Name.." to "..player.Team.Name.." team.")

			--Changes the Player GUI background color based on his team
			ChangePlayerGUIBackgroundColor:FireClient(player)

			--Communicates with SpawnTeamPlayer script to change the outline team color of player's name
			game.ServerStorage:FindFirstChild("Change Player Overhead GUI"):Fire(player)

			--Switches team to balance out number of players (OPTION 0)
			if team_type == 0 then
				if team_balancer == 1 then
					team_balancer = 2
				else
					team_balancer = 1
				end
			end
		else
--			print(player.Name.." is already in a team.")
		end
	end
end

--Removes Teams
function removeTeams()		
	
	--Removes a player from a team
	for _, player in pairs(game.Players:GetChildren()) do player.Team = nil end
	
	--Removes a team from Teams
	for _, team in pairs(game.Teams:GetChildren()) do 
		team:Remove() 
--		print(team.Name.." Team is removed!")
	end
end

--Reverts all players' overhead GUI text stroke color back to black
function revertPlayerOverHeadGUI()
	
	local Players = game:GetService("Players")
	
	for _, player in pairs(Players:GetChildren()) do
		
		--Player's character
		local character = player.Character
		--Player Overhead GUI
		local PlayerOverheadGUI = character.Head:FindFirstChild("Player GUI")
		--Player's Name and VIP Tag
		local PlayerName = PlayerOverheadGUI.GUI:FindFirstChild("Player Name")
		local VIPTag = PlayerOverheadGUI.GUI:FindFirstChild("VIP Tag")
		
		--Black Color
		local blackColor = Color3.fromRGB(0,0,0)
		
		--Changes player name and VIP tag stroke color to black
		PlayerName.TextStrokeColor3 = blackColor
		VIPTag.TextStrokeColor3 = blackColor
	end
end

--Adds all ChaseScripts to all AIs and restores all players' walkspeeds to 16
function addChaseScripts()
	
	--Checks to see if the model is an AI Model
	local function containsHumanoid(AI)
		for _, object in pairs(AI:GetChildren()) do
			if object:IsA("Humanoid") then
				return true
			end
		end
		return false
	end
	
	--Goes through all objects in the Workspace
	for _, AI_Model in pairs(game.Workspace:GetChildren()) do
		
		--[[
		1. Must check if the instance is a Model
		2. Must check if it contains a Humanoid and AI Model's Name is ""
		3. If so, then give AI a "ChaseScript" script
		]]
		if AI_Model:IsA("Model") then
			if containsHumanoid(AI_Model) and AI_Model.Name == "" then
				
				--AI is an Ally (Humanoid) or Enemy (Zombie)
				local humanoid = AI_Model:FindFirstChild("Humanoid") or AI_Model:FindFirstChild("Zombie")
				--ChaseScript script
				local ChaseScript
				
				--Clones the ChaseScript from the ServerStorage
				if humanoid.Name == "Humanoid" then
					ChaseScript = game.ServerStorage.ChaseScripts:FindFirstChild("ChaseScript (Ally)"):Clone()
				else
					ChaseScript = game.ServerStorage.ChaseScripts:FindFirstChild("ChaseScript (Enemy)"):Clone()
				end
				
				--Places the ChaseScript inside the AI model
				ChaseScript.Parent = AI_Model
				
			end
		end
	end
	
	--Players Service
	local Players = game:GetService("Players")
	
	--Restores player fighter's walkspeed to 16
	for _, player in pairs(Players:GetChildren()) do
		local humanoid_fighter = player.Character:FindFirstChild("Humanoid") or player.Character:FindFirstChild("Zombie")
		if humanoid_fighter then humanoid_fighter.WalkSpeed = 16 end	
	end
end

--Changes sky depending on the map
function changeSky()
	
	--Gets Lightning service
	local Lightning = game:GetService("Lighting")
	--Old Sky to be replaced by a new sky
	local OldSky = SelectedSky
	--Sky Object 
	local NewSky
	
	--[[SELECTS THE SKY
	If a selected enemy team is being compared and the conditional
	statement is true, then their sky is selected no matter what
	map it is. Otherwise, we choose the sky based on the selected map.
	
	If the sky does not need to change, because of the map or enemy team
	that assosciates with that sky, then jump out of this function.]]
	if SelectedEnemyTeam.Name == "The Undead" then
		if SelectedSky == "Spooky Skys" then
			return
		else
			SelectedSky = "Spooky Skys"
		end
	elseif SelectedMap.Name == "Desert" then --[[Desert map only]]
		if SelectedSky == "Violent Days" then
			return
		else
			SelectedSky = "Violent Days"
		end
	elseif SelectedMap.Name == "Snow" then --[[Snow map only]]
		if SelectedSky == "Snowy Mountains" then
			return
		else
			SelectedSky = "Snowy Mountains"
		end
	else
		if SelectedSky == "Blue Skys" then
			return
		else
			SelectedSky = "Blue Skys"
		end
	end
	
	--Removes the old sky
	Lightning:FindFirstChild(OldSky):Remove()
	print(OldSky.." is removed as the current sky")	
	
	--Changes Sky
	NewSky = game.ServerStorage.Skys:FindFirstChild(SelectedSky):Clone()
	NewSky.Parent = Lightning
end

--Gameplay Running HERE
function Gameplay()
	
	------------------------ 1. BREAK ROOM INTERVENTION -----------------------
	
	--Players have a 90-second break before the match starts.
	
	wait(61) --Put back to 61 later
	
	--Selects a map
	SelectedMap = Map[math.random(1,table.getn(Map))]

	--[TEST ONLY] Used to test a map of choice (Comment when done)
--	SelectedMap = Map[2]
	
	--print("The selected map is ".. SelectedMap.Name.."!")
	MapIndex.Value = SelectedMap.Name

	--Selects an enemy team
	SelectedEnemyTeam = EnemyTeams[math.random(1,table.getn(EnemyTeams))]
	
	--Only teams with NPCs can be selected at this time
--	SelectedEnemyTeam = EnemyTeams[math.random(1,3)]
	
	--[TEST ONLY] Used to test a certain enemy team (Comment when done)
--	SelectedEnemyTeam = EnemyTeams[4]
	print("The selected enemy team is "..SelectedEnemyTeam.Name)
	
	--Creates copies so other scripts have access to them
	EnemyTeamName.Value = SelectedEnemyTeam.Name
	EnemyIcon.Value = SelectedEnemyTeam.Icon
	
	--Lets all players know about the chosen opponent team and map
	SendMessageToAllPlayers:FireAllClients(0)
	wait(15) --Put back to 15 later
			
	--Lets players know that the match is about to begin
	SendMessageToAllPlayers:FireAllClients(1)
	wait(12) --Put back to 12 seconds later
		
	--Remove all Spectate Mode GUI components from all clients' interfaces
	game.ReplicatedStorage:FindFirstChild("RemoveSpectateComponents"):FireAllClients()
	
	--Players cannot use Spectate Mode button during the match
	CanUseSpectateModeButton.Value = false
	wait(2)
		
	--Assign players a team
	PlayerGuiBackgroundColorKey.Value = 1 
	assignPlayerTeams()
	
	--Spawns the map
	spawnMap()
	
	--Can change the sky depending on the map or enemy team
	changeSky()
--	print("The current sky is "..SelectedSky)
	
	-------------------- 2. NPC INITIAL SPAWNING AND COUNTDOWN ------------------
	
	--Sets XYZ Range Values
	setXYZSpawn()
	
	--Teleports all players to the map
	wait(.5)
	PlayerCanMove.Value = false
	TeleportAllPlayersToTheMap()
	
	--Players are allowed to spawn on the map
	CanSpawnOnMap.Value = true
	
	--Disables reset button to all players
	PlayerCanReset.Value = false
	
	--Disables speed button to players with 2x Speed Gamepass
	PlayerCanUseSpeed.Value = false
	DisableSpeedButton:FireAllClients()
	
	--Will need to close refrigerator GUI if players are still lookin for food
	CloseRefrigerator:FireAllClients()
	
	--Despawns Break Room
	despawnBreakRoom()
	
	--Plays the song since the round started
	canPlaySong.Value = true
	
	--Calls in the Songs Script to change playlist
	ChangePlaylist:Fire()
	
	--Spawn Ally AIs
	spawnAllyAI()
	
	--Spawns Enemy AIs
	spawnEnemyAI()
	--print(AI_Count.." AIs has spawned in the map")
	
	--Tell players to "Fight!" 
	SendMessageToAllPlayers:FireAllClients(2)
	wait(5)
	
	------------------------ 3. THE BATTLE BEGINS!!! ---------------------------
	
	print("THE ROUND HAS STARTED")
	
	--Team scores can now change
	CanUpdateScore.Value = true
	
	--AIs may now move
	PlayerCanMove.Value = true
	
	--Adds corresponding ChaseScripts to all AIs
	addChaseScripts()
	
	--Players can now reset because the match started
	PlayerCanReset.Value = true
	
	--Players can now use speed button
	PlayerCanUseSpeed.Value = true
	EnableSpeedButton:FireAllClients()
	
	wait(3)
	--Will need to create a scoreboard for the enemy and reset the scores to 0
	CreateScoreBoard:FireAllClients()
	
	--True because the match has started
	RoundContinuing.Value = true
		
	--Loop repeats until either of the teams reaches the victory score
	repeat wait(.1) until allyPoints.Value >= VictoryScore or enemyPoints.Value >= VictoryScore
	
	----------------------- 4. THE BATTLE HAS CONCLUDED ------------------------
	
	--False because the match has ended
	RoundContinuing.Value = false
	
	--Lets all players know that the round ended
	print("THE ROUND HAD ENDED")
	RoundHasEnded:FireAllClients()
	
	--Team scores cannot be updates after the round has ended
	CanUpdateScore.Value = false
	
	--Stops the song because the round is over
	canPlaySong.Value = false
	
	--Despawns All AIs
	despawnAIs()
		
	--Server makes scoreboards invisible to players' screens
	wait(8)
	RemoveScoreBoard:FireAllClients()
	
	--Resets team scores to 0
	allyPoints.Value = 0
	enemyPoints.Value = 0
	print("Ally Points is reset to "..allyPoints.Value)
	print("Enemy Points is reset to "..enemyPoints.Value)
	
	-------------------------- 5. RETURN TO BREAK ROOM ---------------------------
	
	--Spawns the break room
	spawnBreakRoom()
	
	--Teleports all players to break room
	wait(1)
	TeleportAllPlayersToBreakRoom()
	
	--Players can use spectate mode button after all them are back to the Break Room
	CanUseSpectateModeButton.Value = true
	
	--[[
	Certain buttons appear on a player's interface
	Fighters: Spectate Mode button appears
	Spectators: Store, Sell, Speed, and Spectate Mode buttons appear ]]
	game.ReplicatedStorage:FindFirstChild("AddCertainButtons"):FireAllClients(true)

	--Players are not allowed to spawn on the map
	CanSpawnOnMap.Value = false
	
	--Will need to revert all player's GUI color back to gray 
	PlayerGuiBackgroundColorKey.Value = 0
	ChangePlayerGUIBackgroundColor:FireAllClients()
	
	--Will need to revert all player's Overhead GUI text stroke color back to black 
	revertPlayerOverHeadGUI()
	
	--Spectator players exit Spectate Mode
	game.ServerStorage:FindFirstChild("Exit Spectate Mode"):Fire(game.Players)
	
	--Remove all teams (NH101, Enemy, and Spectators)
	removeTeams()
	
	--Despawns the Map
	despawnMap()	
end


--Server runs here! (Comment out the loop to prevent the game from running) [testing purposes only]
while true do Gameplay() end

--Runs gameplay once (Test Only)
--Gameplay()