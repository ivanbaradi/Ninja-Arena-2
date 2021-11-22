--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Total Number of NPCs in the map
local AI_Count = 0
--Players
local Players = game:GetService("Players")
--Teams
local Teams = game:GetService("Teams")
--Other Scripts (ServerStorage)
local OtherScripts_SS = ServerStorage:FindFirstChild('Other Scripts')
--Other Scripts (ReplicatedStorage)
local OtherScripts_RS = ReplicatedStorage:FindFirstChild('Other Scripts')

--Team Points
local TeamPoints = ReplicatedStorage:FindFirstChild('Team Points')
local AllyPoints = TeamPoints['Ally Points']
local EnemyPoints = TeamPoints['Enemy Points']

------------- BINDABLE AND REMOTE EVENTS -------------

--"Announce To All Players" Remote Event
local AnnounceToAllPlayers = ReplicatedStorage['Announce To All Players']
--"Change Player Overhead GUI" Event
local ChangePlayerOverheadGUI = ServerStorage['Change Player Overhead GUI']
--"Change Player GUI Background Color" Remote Event
local ChangePlayerBackgroundGUI = ReplicatedStorage['Change Player Background GUI']
--"Exchange Player Scripts" Event
--local ExchangePlayerScripts = ServerStorage['Exchange Player Scripts']


--RemoveScoreBoard Event
local RemoveScoreBoard = ReplicatedStorage:FindFirstChild("RemoveScoreBoard")
--Teams (Player Teams)
local PlayerTeams = game:FindFirstChild("Teams")
--Enemy Team's Name and Icon (Shared by other scripts)
local EnemyTeamName, EnemyIcon = ReplicatedStorage:FindFirstChild("EnemyTeam"), game.ReplicatedStorage:FindFirstChild("EnemyIcon")
--MakePlayerMessagesInvisible Remote Event
local MakePlayerMessagesInvisible = ReplicatedStorage:FindFirstChild("MakePlayerMessagesInvisible")
--CloseRefrigerator Event
local CloseRefrigerator = ReplicatedStorage:FindFirstChild("CloseRefrigerator")
--CanPlaySong Object
local canPlaySong = workspace.Playlist.Songs:FindFirstChild("CanPlaySong")
--PlayerCanMove Object
local PlayerCanMove = script:FindFirstChild("PlayerCanMove")
--RoundContinuing Object
local RoundContinuing = script:FindFirstChild("RoundContinuing")
--PlayerCanReset Object
local PlayerCanReset = ReplicatedStorage:FindFirstChild("PlayerCanReset")
--Can Spawn On Map Object
local CanSpawnOnMap = ReplicatedStorage:FindFirstChild("Can Spawn On Map")
--Score to Win
local VictoryScore = ServerStorage:FindFirstChild("Victory Score").Value

--[[DisableSpeedButton Remote Event
	The server will tell all clients to disable players' speed buttons,
	because the round has not started yet due to AIs spawning]]
local DisableSpeedButton = ReplicatedStorage:FindFirstChild("DisableSpeedButton")

--[[EnableSpeedButton Remote Event
	The server will tell all clients to enable players' speed buttons,
	because the round now started]]
local EnableSpeedButton = ReplicatedStorage:FindFirstChild("EnableSpeedButton")

--PlayerCanUseSpeed Object
local PlayerCanUseSpeed = ReplicatedStorage:FindFirstChild("PlayerCanUseSpeed")
--True if points can get updates (All AIs must be initially spawned before setting this to true)
local CanUpdateScore = ReplicatedStorage:FindFirstChild("CanUpdateScore")

--[[PlayerGuiBackgroundColorKey Key Object
	0: Switch Player GUI background color to gray
	1: Switch Player GUI background color to red or blue]]
local PlayerGuiBackgroundColorKey = ReplicatedStorage:FindFirstChild("PlayerGuiBackgroundColorKey")

--[[RoundHasEnded REMOTE EVENT
This remote event will have the server tell all clients about who won,
and how many XP they earn playing the round.]]
local RoundHasEnded = ReplicatedStorage:FindFirstChild("RoundHasEnded")

--Change Playlist Bindable Event
local ChangePlaylist = ServerStorage:FindFirstChild("Change Playlist")
--True if players can use spectate mode button
local CanUseSpectateModeButton = ReplicatedStorage:FindFirstChild("Can Use Spectate Mode Button")

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
	
	--Teleports/spawns players and NPCs
	character.PrimaryPart = character:FindFirstChild("Torso")
	character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(X,Y,Z)))
	character.Parent = workspace
	--print(character.Name.." has spawned at ("..X..","..Y..","..Z..")")
end

--Activates everytime the NPC or player gets respawned
ServerStorage:FindFirstChild('Respawn Character').Event:Connect(teleporter)

--[[Teleports all players to the map ot break room

	Parameter(s):
	map => map (model) where the players will spawn at
]]
function teleportAllPlayers(map)
	for _, player in pairs(Players:GetChildren()) do
		--wait(.7)
		teleporter(player.Character, map, false)
	end
end

--[[Spawns NPCs from a team

	Parameter(s):
	team => team (folder) containing all NPCs
	enemy team name => name of the enemy team
	map => map (model) where the NPCs will spawn at
]]
function spawnNPCs(team, enemyTeam, map)
	
	--[[Spawns all non-unique NPCs to the map
	
		Parameter(s):
		NPC Set => collection of non-unique NPCs
	]]
	local function spawnAllNonUniqueNPCs(NPCSet)
		for _, NPC in pairs(NPCSet:GetChildren()) do
			if NPC:IsA('Model') then
				for i = 1, NPC['Total Spawn'].Value do
					wait(.7)
					teleporter(NPC:Clone(), map, true) --spawns NPC
				end
			end
		end
	end
	
	--[[Spawns unique NPCs to the map
	
		Parameter(s):
		NPC Set => collection of unique NPCs
		n => max amount of unique NPCs to spawn in the map
	]]
	local function spawnSelectedUniqueNPCs(NPCSet, n)
		
		--Table (Strings) of unique NPCs' names to spawn in 
		local uniqueNPCs = {}
		--Current index of the table
		local i = 1
		--Iterates until the length uniqueNPCs table = max amount
		while table.getn(uniqueNPCs) < n do

			--Randomly selects an NPC and repeats until an instance is a NPC model
			local NPC
			repeat NPC = NPCSet:GetChildren()[math.random(1, #NPCSet:GetChildren())] until NPC:IsA('Model')

			--Adds an NPC model to the table and spawns it to the arenamap
			if not table.find(uniqueNPCs, NPC.Name) then
				table.insert(uniqueNPCs, i, NPC.Name)
				wait(.7)
				teleporter(NPC:Clone(), map, true)
				i += 1
			end
		end
	end
	
	--[[Selects NPCs from NH101 NPC Set 1 based from the
		enemy team.
		
		Parameter(s):
		NPC Set => collection of unique NPCs
	]]
	local function spawnSomeNPCsFromNH101NPCSet(NPCSet)
		
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
		
		--Goes through the names of NPCs in the table
		table.foreach(NPCsTable, function(_, NPC_Name)
			local NPC = NPCSet:FindFirstChild(NPC_Name)
			for j = 1, NPC['Total Spawn'].Value do
				wait(.7)
				teleporter(NPC:Clone(), map, true)
			end
		end)
	end
	
	--Iterates through every NPC Set (Folder) in the team
	for _, NPCSet in pairs(team:GetChildren()) do
		if NPCSet:IsA("Folder") then	
			if NPCSet["Can Add All"].Value then --Spawns all NPCs from the NPC Set
				spawnAllNonUniqueNPCs(NPCSet)
			elseif NPCSet:FindFirstChild('Is NH101 NPC Set 1') then --Selects some NPCs from NH101 NPC Set 1
				spawnSomeNPCsFromNH101NPCSet(NPCSet)
			else
				spawnSelectedUniqueNPCs(NPCSet, 2)
			end
		end
	end
end

--Despawns all NPCs
function despawnAllNPCs()
	
	local function run()
		for _, obj in pairs(workspace:GetChildren()) do
			if obj:IsA("Model") then
				if obj:FindFirstChildOfClass("Humanoid") --[[add more code to prevent players and other non-fighting NPCs from despawning]] then
					obj:Remove()
					--print("AI has despawned")
					AI_Count -= 1
					--print("There are "..AI_Count.." NPCs left.")
				end
			end
		end
	end
		
	--All AIs need to despawn 
	while AI_Count ~= 0 do
		run()
		print(AI_Count.." AIs has despawned in the map")
		wait(1) --Prevents the game from crashing!
	end
end

--[[Spawns the map

	Paramater(s):
	map => model (map) that will be spawned in the Workspace
	spawner => part that relocates the map for spawning
]]
function spawnMap(map, spawner)
	
	--Clones the Map from ServerStorage
	local clonedMap = ServerStorage.Maps:FindFirstChild(map.Name):Clone()
	
	--Assigns the map's primary part
	clonedMap.PrimaryPart = clonedMap.Base
	
	--Sets the CFrame to place the map with corresponding positional coordinates
	local cFrame = CFrame.new(Vector3.new(spawner.Position.X, spawner.Position.Y, spawner.Position.Z))
	
	--If Colosseum is selected as the map, then the orientation coordinates will need to be adjusted too
	if map.Name == "Colosseum" then cFrame *= CFrame.Angles(0, 0, math.rad(90)) end
	
	clonedMap:SetPrimaryPartCFrame(cFrame)
	clonedMap.Parent = workspace
end

--[[Despawns the map

	Parameter(s):
	map => model (map) to despawn from the Workspace
]]
function despawnMap(map)
	workspace:FindFirstChild(map.Name):Remove()
end


--[[Assigns player teams

	Parameter(s):
	enemy team => folder of the enemy team
]]
function assignAllPlayersToTeams(enemyTeamFolder)
	
	--Creates Ninja Heroes 101 Team
	local NH101_Team = Instance.new("Team", PlayerTeams)
	NH101_Team.Name = "Ninja Heroes 101"
	NH101_Team.AutoAssignable = true
	NH101_Team.TeamColor = BrickColor.new("Bright blue")
	
	--Creates Enemy Team
	local Enemy_Team = Instance.new("Team", PlayerTeams)
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
	
	--[[Assigns player to a team
	
		Parameters(s):
		player => player to be assigned to a team
	]]
	local function assignPlayerToTeam(player)
		--Assigns player to be at NH101 Team or Enemy Team
		if team_selector == 1 then
			player.Team = NH101_Team
			if team_balancer then team_balancer = 2 end
		else
			player.Team = Enemy_Team
			player.Character:FindFirstChild("Humanoid").Name = 'Zombie'
			--ExchangePlayerScripts:Fire(player.Character)
			if team_balancer then team_balancer = 1 end
		end
	end
	
	--[[Assigns a player to the same team
	
		Parameters(s):
		player => player to be assigned to a team
		i => current index of the player
	]]
	local function assignPlayerToTheSameTeam(player, i)
		
		--Only picks a team for all players ONCE
		if i == 1 then team_selector = math.random(1,2) end
		assignPlayerToTeam(player)
	end
	
	--[[Assigns each player to a different team and balances out the
		number of players assigned
		
		Parameters(s):
		player => player to be assigned to a team
	]]
	local function assignPlayerToDifferentTeam(player, i)
		
		--Assigns the team balancer ONCE
		if i == 1 then team_balancer = math.random(1,2) end
		--Loops until the player is chosen a different team
		repeat team_selector = math.random(1,2) until team_selector ~= team_balancer 
		assignPlayerToTeam(player)
	end
	
	--Loops through every player in the server
	for i, player in pairs(Players:GetChildren()) do
		if not player.Team then --Otherwise, they are on 'Spectators' team
			
			if team_type == 0 then
				assignPlayerToDifferentTeam(player, i)
			else 
				assignPlayerToTheSameTeam(player, i)
			end
			
			--Modifies player's overhead and background GUIs
			ChangePlayerOverheadGUI:Fire(player, player.Character)
			ChangePlayerBackgroundGUI:FireClient()
		end
	end
end

--Removes all teams
function removeAllTeams()		
	--Removes a player from a team
	--for _, player in pairs(Players:GetChildren()) do player.Team = nil end
	Teams:ClearAllChildren()
end

--Adds Chase Scripts to all NPCs
function addChaseScriptsToAllNPCs()
	
	
	--[[Adds a Chase Script to an NPC model
	
		Parameter(s):
		NPC => NPC (model) needed to add a chase script to it
	]]
	local function addChaseScriptToNPC(NPC)
		OtherScripts_SS:FindFirstChild("Chase Script"):Clone().Parent = NPC
	end
	
	--Goes through all objects in the Workspace
	for _, NPC in pairs(workspace:GetChildren()) do
		if NPC:IsA("Model") then	
			local humanoid = NPC:FindFirstChildOfClass("Humanoid")
			if humanoid then addChaseScriptToNPC(NPC) end
		end
	end
	
	--Fires after an NPC respawns to get the chase script
	ServerStorage:FindFirstChild("Add Chase Script to NPC").Event:Connect(addChaseScriptToNPC)
end

--[[Changes sky depending on the map

	Parameter(s):
	team => enemy team selected to fight in the next round
	map => arena map that will spawn in the next round
]]
function changeSky(team, map)
	
	--Selects a sky to add 
	local SelectedSky
	--Gets Lightning
	local Lightning = game:GetService("Lighting")
	
	--The team is compared first before the map
	if team then
		if team.Name == "The Undead" then
			SelectedSky = "Spooky Skys"
		end
	elseif map.Name == "Desert" then --[[Desert map only]]
		SelectedSky = "Violent Days"
	elseif map.Name == "Snow" then --[[Snow map only]]
		SelectedSky = "Snowy Mountains"
	else
		SelectedSky = "Blue Skys"
	end
	
	--Gets the new sky and places it in the lightning
	local newSky = ServerStorage.Skys:FindFirstChild(SelectedSky)
	if not newSky then
		Lightning:ClearAllChildren()
		newSky:Clone().Parent = Lightning
	end
end

--[[Resets team scores to 0]]
function resetTeamScores()
	AllyPoints.Value = 0
	EnemyPoints.Value = 0
end

--Break Room
local BreakRoom = workspace:FindFirstChild("Break Room")
--NH101 Team
local NH101_Team = ServerStorage:FindFirstChild("NH101")
--Spawners
local BreakRoomSpawner = workspace:FindFirstChild("Break Room Spawner")
local ArenaMapSpawner = workspace:FindFirstChild("Arena Map Spawner")

--Gameplay runs HERE
function Gameplay()
	
	------------------------ 1. BREAK ROOM INTERVENTION -----------------------
	
	--Players have a 90-second break before the match starts.
	
	--wait(61) --Put back to 61 later
	
	--Selects a random map
	local ArenaMapFolder = ServerStorage:FindFirstChild("Arena Maps")
	local ArenaMap = ArenaMapFolder[math.random(1, #ArenaMapFolder:GetChildren())]
	print("The selected map is ".. ArenaMap.Name)
	
	--Selects a random enemy team
	local EnemyTeams = ServerStorage:FindFirstChild("Enemy Teams")
	local EnemyTeam = EnemyTeams[math.random(1, #EnemyTeams:GetChildren())]
	--[TEST ONLY] Used to test a certain enemy team (Comment when done)
	--EnemyTeam = EnemyTeams[Name of the enemy team folder]
	
	--Gets enemy team icon (image ID)
	local EnemyIcon = EnemyTeam.ImageID

	print("The selected enemy team is "..EnemyTeam.Name)
	
	--Creates copies so other scripts have access to them
	--EnemyTeamName.Value = SelectedEnemyTeam.Name
	--EnemyIcon.Value = SelectedEnemyTeam.Icon
	
	--Lets all players know about the chosen opponent team and map
	ReplicatedStorage:FindFirstChild('Display VS GUI'):FireAllClients(EnemyTeam.Name, EnemyIcon.Value, ArenaMap.Name)
	wait(15)
			
	--Lets players know that the match is about to begin
	AnnounceToAllPlayers:FireAllClients("The Match is about to Begin", 0)
	wait(12)
	
	
		
	--Remove all Spectate Mode GUI components from all clients' interfaces
	game.ReplicatedStorage:FindFirstChild("RemoveSpectateComponents"):FireAllClients()
	
	--Players cannot use Spectate Mode button during the match
	CanUseSpectateModeButton.Value = false
	wait(2)
		
	--Assign players a team
	--PlayerGuiBackgroundColorKey.Value = 1 
	
	--Assigns all players to the team
	assignAllPlayersToTeams(EnemyTeam)
	
	--Tells all clients (players) to change the GUI background color based on their assigned teams
	ReplicatedStorage:FindFirstChild("Change Player GUI Background Color"):FireAllClients()
	
	--Spawns the arena map
	spawnMap(ArenaMap, ArenaMapSpawner)
	
	--Can change the sky depending on the map or enemy team
	changeSky()
	
	-------------------- 2. NPC INITIAL SPAWNING AND COUNTDOWN ------------------
	
	--Teleports all players to the map
	wait(.5)
	PlayerCanMove.Value = false
	teleportAllPlayers(ArenaMap)
	
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
	despawnMap(BreakRoom)
	
	--Plays the song since the round started
	canPlaySong.Value = true
	
	--Calls in the Songs Script to change playlist
	ChangePlaylist:Fire()
	
	--Spawn Ninja Heroes 101 NPCs to the arena map
	spawnNPCs(NH101_Team, EnemyTeam.Name, ArenaMap)
	--Spawn Enemy Team NPCs to the arena map
	spawnNPCs(EnemyTeam, nil, ArenaMap)
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
	
	--Adds corresponding ChaseScripts to all NPCs
	addChaseScriptsToAllNPCs()
	
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
	
	--Despawns All NPCs
	despawnAllNPCs()
		
	--Server makes scoreboards invisible to players' screens
	wait(8)
	RemoveScoreBoard:FireAllClients()
	
	--Resets team scores to 0
	resetTeamScores()
	
	-------------------------- 5. RETURN TO BREAK ROOM ---------------------------
	
	--Spawns the break room
	spawnMap(BreakRoom, BreakRoomSpawner)
	
	wait(1)
	
	--Teleports all players to break room
	teleportAllPlayers(BreakRoom)
	
	--Players can use spectate mode button after all them are back to the Break Room
	CanUseSpectateModeButton.Value = true
	
	--[[
	Certain buttons appear on a player's interface
	Fighters: Spectate Mode button appears
	Spectators: Store, Sell, Speed, and Spectate Mode buttons appear 
	game.ReplicatedStorage:FindFirstChild("AddCertainButtons"):FireAllClients(true)

	--Players are not allowed to spawn on the map
	CanSpawnOnMap.Value = false
	
	--Will need to revert all player's GUI color back to gray 
	PlayerGuiBackgroundColorKey.Value = 0
	ChangePlayerGUIBackgroundColor:FireAllClients()
	
	--Revert all player's Overhead GUI text stroke color back to black 
	modifyAllPlayersOverheadGUI(false)
	
	--Spectator players exit Spectate Mode
	game.ServerStorage:FindFirstChild("Exit Spectate Mode"):Fire(game.Players)
	
	--Remove all teams (NH101, Enemy, and Spectators)
	removeAllTeams()
	
	--Despawns the Map
	despawnMap(ArenaMap)	
	
	]]
end


--Server runs here! (Comment out the loop to prevent the game from running) [testing purposes only]
--while true do Gameplay() end

--Runs gameplay once (Test Only)
--Gameplay()