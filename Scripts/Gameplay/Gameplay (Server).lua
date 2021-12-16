--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage

------------- BINDABLE AND REMOTE EVENTS -------------

--"Announce To All Players" Remote Event
local AnnounceToAllPlayers = ReplicatedStorage['Announce To All Players']

--CanPlaySong Object
local canPlaySong = ReplicatedStorage:FindFirstChild('Can Play Song')
--PlayerCanMove Object
local PlayerCanMove = script:FindFirstChild("PlayerCanMove")
--RoundContinuing Object
local RoundContinuing = script:FindFirstChild("RoundContinuing")
--PlayerCanReset Object
local PlayerCanReset = ReplicatedStorage:FindFirstChild("PlayerCanReset")
--Can Spawn On Map Object
local CanSpawnOnMap = ReplicatedStorage:FindFirstChild("Can Spawn On Map")

--PlayerCanUseSpeed Object
local PlayerCanUseSpeed = ReplicatedStorage:FindFirstChild("PlayerCanUseSpeed")
--True if points can get updates (All AIs must be initially spawned before setting this to true)
local CanUpdateScore = ReplicatedStorage:FindFirstChild("CanUpdateScore")

--[[PlayerGuiBackgroundColorKey Key Object
	0: Switch Player GUI background color to gray
	1: Switch Player GUI background color to red or blue]]
local PlayerGuiBackgroundColorKey = ReplicatedStorage:FindFirstChild("PlayerGuiBackgroundColorKey")

--True if players can use spectate mode button
local CanUseSpectateModeButton = ReplicatedStorage:FindFirstChild("Can Use Spectate Mode Button")

--Break Room
local BreakRoom = workspace:FindFirstChild("Break Room")
--NH101 Team
local NH101_Team = ServerStorage:FindFirstChild("NH101")
--Team Testers
local TeamTesters = ServerStorage:FindFirstChild('Team Testers')

--Gameplay runs HERE
function Gameplay()	
	
	--------------------------------------------------------------------------------
	--                           BREAKROOM INTERVENTION                           --
	--------------------------------------------------------------------------------	
	
	
	--Players have a 90-second break before the match starts.
	--wait(30) --Put back to 61 later
	
	--Selects an arena map randomnly
	local ArenaMap = script:FindFirstChild('Assign Arena Map'):Invoke()
	
	--Selects an enemy team randomnly
	local EnemyTeam = script:FindFirstChild('Assign Enemy Team'):Invoke()
	
	--Lets all players know about the chosen opponent team and map
	ReplicatedStorage:FindFirstChild('Display VS GUI'):FireAllClients(ArenaMap.Name)
	--wait(15)
			
	--Lets players know that the match is about to begin
	AnnounceToAllPlayers:FireAllClients("The Match is about to Begin", 0)
	--wait(12)
		
	--Remove all Spectate Mode GUI components from all clients' interfaces
	ReplicatedStorage:FindFirstChild("RemoveSpectateComponents"):FireAllClients()
	
	--Players cannot use Spectate Mode button during the match
	CanUseSpectateModeButton.Value = false
	wait(10) --Put 2 seconds later
			
	--Assigns all players to the team
	script:FindFirstChild('Assign All Players To Teams'):Invoke(EnemyTeam)
	
	--Spawns the arena map
	script:FindFirstChild('Spawn Map'):Invoke(ArenaMap, workspace:FindFirstChild("Arena Map Spawner"))
	
	
	--Can change the sky depending on the map or enemy team
	script:FindFirstChild('Change Sky'):Invoke(EnemyTeam, ArenaMap)
	
	--------------------------------------------------------------------------------
	--              PLAYER TELEPORTATION, NPC SPAWNING, & COUNTDOWN               --
	--------------------------------------------------------------------------------
	
	--[]]
	
	--Freezes all fighters (players who are not on Spectators team)
	script:FindFirstChild('Set Speedwalk To All Fighters'):Invoke(0)
	
	--Teleports all players to the map
	wait(.5)
	PlayerCanMove.Value = false
	script:FindFirstChild('Teleport All Players'):Invoke(ArenaMap)
	
	--Players are allowed to spawn on the map
	CanSpawnOnMap.Value = true
	
	--Disables reset button to all players
	PlayerCanReset.Value = false
	
	--Disables speed button to players with 2x Speed Gamepass
	PlayerCanUseSpeed.Value = false
	ReplicatedStorage:FindFirstChild("DisableSpeedButton"):FireAllClients()
	
	--Will need to close refrigerator GUI if players are still lookin for food
	ReplicatedStorage:FindFirstChild("CloseRefrigerator"):FireAllClients()
	
	--Despawns Break Room
	script:FindFirstChild('Despawn Map'):Invoke(BreakRoom)
	
	--Plays the song since the round started
	canPlaySong.Value = true
	
	--Calls the Songs Script to run the playlist
	ServerStorage:FindFirstChild("Run Playlist"):Fire()
	
	--Will need to create a scoreboard for the enemy and reset the scores to 0
	ReplicatedStorage:FindFirstChild('Create Scoreboard'):FireAllClients()
	
	--Spawn Ninja Heroes 101 NPCs to the arena map
	--script:FindFirstChild('Spawn NPCs'):Invoke(NH101_Team, EnemyTeam.Name, ArenaMap)
	--Spawn Enemy Team NPCs to the arena map
	--script:FindFirstChild('Spawn NPCs'):Invoke(EnemyTeam, nil, ArenaMap)
	
	--Spawns certain NPCs to the arena map (COMMENT THIS OUT IF YOU'RE NOT TESTING THIS)
	script:FindFirstChild('Spawn NPCs'):Invoke(ServerStorage['Use Team Testers']:Invoke(), nil, ArenaMap)
		
	--Displays countdown to all players 
	AnnounceToAllPlayers:FireAllClients(nil, 1)
	wait(5)
	
	--------------------------------------------------------------------------------
	--                            BATTLE IN PROGRESS                              --
	--------------------------------------------------------------------------------	
	print("THE ROUND HAS STARTED")
	
	--Team scores can now change
	CanUpdateScore.Value = true
	
	--AIs may now move
	PlayerCanMove.Value = true
	
	--Unfreezes all fighters (players who are not on Spectators team)
	script:FindFirstChild('Set Speedwalk To All Fighters'):Invoke(16)

	--Adds corresponding ChaseScripts to all NPCs
	script:FindFirstChild('Add Chase Scripts to All NPCs'):Invoke()
	
	--Players can now reset because the match started
	PlayerCanReset.Value = true
	
	--Players can now use speed button
	PlayerCanUseSpeed.Value = true
	ReplicatedStorage:FindFirstChild("EnableSpeedButton"):FireAllClients()
	
	--True because the match has started
	RoundContinuing.Value = true
	
	--Continuously runs the match until either of teams achieves victory score
	script:FindFirstChild('Run the Battle'):Invoke()
	
	--------------------------------------------------------------------------------
	--                             BATTLE HAS ENDED                               --
	--------------------------------------------------------------------------------	
	--Despawns All NPCs
	script:FindFirstChild('Despawn All NPCs'):Invoke()
	
	--False because the match has ended
	RoundContinuing.Value = false
	
	--Lets all players know that the round ended
	print("THE ROUND HAD ENDED")
	ReplicatedStorage:FindFirstChild("Round Has Ended"):FireAllClients()
	
	--Team scores cannot be updates after the round has ended
	CanUpdateScore.Value = false
	
	--Stops the song because the round is over
	canPlaySong.Value = false
	
	--Server makes scoreboards invisible to players' screens
	wait(8)
	ReplicatedStorage:FindFirstChild('Remove Scoreboard'):FireAllClients()
	
	--Resets team scores to 0 and also from the scoreboards
	script:FindFirstChild('Reset Team Scores'):Invoke()
	ReplicatedStorage:FindFirstChild('Update Team Points'):FireAllClients()
	
	--------------------------------------------------------------------------------
	--                         RETURNING TO THE BREAKROOM                         --
	--------------------------------------------------------------------------------	
	
	
	--Spawns the break room
	script:FindFirstChild('Spawn Map'):Invoke(BreakRoom, nil)
	
	--Teleports all players to break room
	script:FindFirstChild('Teleport All Players'):Invoke(BreakRoom)
	
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


--Server runs here!
--while true do Gameplay() end

--Debugging purposes 1 (COMMENT OUT AFTER TESTING THIS)
--while wait(10) do Gameplay() end

--Debugging purposes 2 (COMMENT OUT AFTER TESTING THIS)
Gameplay()