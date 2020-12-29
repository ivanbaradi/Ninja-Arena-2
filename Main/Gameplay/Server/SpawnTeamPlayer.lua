--Teams
local Teams = game:FindFirstChild("Teams")
--Enemy Team's Name and Icon
local EnemyTeamName, EnemyIcon = game.ReplicatedStorage:FindFirstChild("EnemyTeam"), game.ReplicatedStorage:FindFirstChild("EnemyIcon")
--SendEnemyTeamToScoreBoard Remote Event
local SendEnemyTeamToScoreBoard = game.ReplicatedStorage:FindFirstChild("SendEnemyTeamToScoreBoard")
--PlayerCanMove Object
local PlayerCanMove = game.ServerScriptService.Gameplay:FindFirstChild("PlayerCanMove")
--CreateScoreBoard Event
local CreateScoreBoard = game.ReplicatedStorage:FindFirstChild("CreateScoreBoard")
--Song Handler Bindable Event
local SongHandler = game.ReplicatedStorage:FindFirstChild("Song Handler")
--Sound Object
local Sound = game.Workspace:FindFirstChild("Playlist")
--SongID Object
local song_id = Sound.Songs:FindFirstChild("SongID")
--CanPlaySong Object
local canPlaySong = Sound.Songs:FindFirstChild("CanPlaySong")
--RoundContinuing Object
local RoundContinuing = game.ServerScriptService.Gameplay:FindFirstChild("RoundContinuing")
--Spawn Player To Map Bindable Event
local SpawnPlayerToMap = game.ServerStorage:FindFirstChild("Spawn Player To Map")
--Add Zombie Scripts Bindable Function
local ZombieScriptsHandler = game.ServerStorage:FindFirstChild("Add Zombie Scripts")
--Change Player Overhead GUI Bindable Function
local ChangeOverheadGUI = game.ServerStorage:FindFirstChild("Change Player Overhead GUI")
--Can Spawn On Map Object
local CanSpawnOnMap = game.ReplicatedStorage:FindFirstChild("Can Spawn On Map")

--Will need  replace animation scripts and change it to Zombie versions of them
function AddZombieScripts(char)
		
	--Will need to remove Humanoid Scripts from the player
	local HumanoidAnimate = char:FindFirstChild("Animate")
	local HumanoidHealth = char:FindFirstChild("Health")
	
	if HumanoidAnimate and HumanoidHealth then
		HumanoidAnimate.Parent = nil
		HumanoidHealth.Parent = nil
		
		--Gets the Zombie version of these scripts
		local ZombieAnimate = game.ReplicatedStorage.PlayerZombieScripts:FindFirstChild("Animate"):Clone()
		local ZombieHealth = game.ReplicatedStorage.PlayerZombieScripts:FindFirstChild("Health"):Clone()
		
		--Places them inside the player's character
		ZombieAnimate.Parent = char
		ZombieHealth.Parent = char
	end
end

--Called from Gameplay Script
ZombieScriptsHandler.Event:Connect(AddZombieScripts)

--Will need to spawn player at the team spawn
function spawnTeamPlayer(char)
		
	--Map XZ Positions
	local MinX = game.Workspace.SpawnXYZ:FindFirstChild("MinX")
	local MaxX = game.Workspace.SpawnXYZ:FindFirstChild("MaxX")
	local MinZ = game.Workspace.SpawnXYZ:FindFirstChild("MinZ")
	local MaxZ = game.Workspace.SpawnXYZ:FindFirstChild("MaxZ")
	
	
	--Chooses X and Z positions to teleport player
	local FinalX = math.random(MinX.Value, MaxX.Value)
	local Y = game.Workspace.SpawnXYZ:FindFirstChild("Y").Value
	local FinalZ = math.random(MinZ.Value, MaxZ.Value)
	
	--Sets Player's Primary Part
	char.PrimaryPart = char:FindFirstChild("Torso")
	
	--Sets player's spawn location
	local cFrame = CFrame.new(Vector3.new(FinalX,Y,FinalZ))
	
	--Spawns player in a 
	char:SetPrimaryPartCFrame(cFrame)
	print("Player has spawned at position ("..FinalX..","..Y..","..FinalZ..")")
end

--Called from Gameplay Script
SpawnPlayerToMap.Event:Connect(spawnTeamPlayer)

--[[Will need to change the player overhead GUI outline color to
its appropriate team color]]
function changePlayerOverheadGUIOutlineColor(player)
	
	print("changePlayerOverheadGUIOutlineColor function called")
	
	--Player's character
	local character = player.Character
	--Player Overhead GUI
	local PlayerOverheadGUI = character.Head:WaitForChild("Player GUI")
	--Player's Name and VIP Tag
	local PlayerName = PlayerOverheadGUI.GUI:WaitForChild("Player Name")
	local VIPTag = PlayerOverheadGUI.GUI:WaitForChild("VIP Tag")
	
	--Blue, red, and brown colors 
	local blueColor = Color3.fromRGB(0, 0, 128) --NH101 Team Color
	local redColor = Color3.fromRGB(255, 0, 0) --Enemy Team Color
	local brownColor = Color3.fromRGB(128, 43, 0) --Spectator Team Color
	
	--Get player's team
	local PlayerTeam = player:WaitForChild("Team")

	if PlayerTeam.Name == "Spectators" then
		PlayerName.TextStrokeColor3 = brownColor
		VIPTag.TextStrokeColor3 = brownColor
	elseif PlayerTeam.Name == "Ninja Heroes 101" then
		PlayerName.TextStrokeColor3 = blueColor
		VIPTag.TextStrokeColor3 = blueColor
	else
		PlayerName.TextStrokeColor3 = redColor
		VIPTag.TextStrokeColor3 = redColor
	end
end

--Called from Gameplay Script
ChangeOverheadGUI.Event:Connect(changePlayerOverheadGUIOutlineColor)
	
--[[
THIS FUNCTION DOES THE FOLLOWING:
- Changes the player's humanoid's name to Zombie, if he/she is on the enemy's team
- Spawn team players at the team spawn object if the round is continuing
- Sets player's walkspeed to 0, if round has not begin yet and during the time that
  the AIs are currently spawning
]]
game.Players.PlayerAdded:Connect(function(player)
	
	
	--[[
	If the round is continuing, then the player needs to be initially spawned to 
	its corresponding team spawn position. The player's team is indexed to nil if
	all players are at the Break Room.
	]] 
	wait(2)
	if player.Team and RoundContinuing.Value then
			
		--[[Will need to let the client know about the current team scores 
		and must create the scoreboard for the player. The scoreboard should
		not be created when the AIs are spawning]]
		if RoundContinuing.Value then
			CreateScoreBoard:FireClient(player)
		end
		
		--[[Will need to have the client get the current battle song. The time 
		position doesn't need to be the same]]
		if canPlaySong.Value then
			Sound.SoundId = "http://www.roblox.com/asset/?id="..song_id.Value
			SongHandler:FireClient(player, Sound, "Play")
		end
	end
	
	--Fires when a player spawns or respawns
	player.CharacterAdded:Connect(function(char)
		print("Player spawned")
		--The player must belong in the team	
		
		if player.Team then	
			
			--Player's Humanoid (Humanoid or Zombie)
			local humanoid
			
			--[[Will need to change replace Humanoid scripts with Zombie or Spectator ones, 
			if a player is from the Enemy Team or Spectator Team]]
			if player.Team.Name == EnemyTeamName.Value then
				humanoid = char:FindFirstChild("Humanoid")
				humanoid.Name = "Zombie"
				AddZombieScripts(char)
			elseif player.Team.Name == "Spectators" then
				--Player reenters Spectate Mode because he respawned
				game.ServerStorage:FindFirstChild("Enter Spectate Mode"):Fire(player)
			end
			
			--If the player respawns, is not a Spectator, and walking is disabled, then the character's walkspeed is 0.
			if not PlayerCanMove.Value then
				if humanoid.Name ~= "Spectator" then humanoid.WalkSpeed = 0 end
			end
			
			--Changes the Player Overhead outline color to appropriate team color
			changePlayerOverheadGUIOutlineColor(player)
			
			--Spawns player in the map randomly
			if CanSpawnOnMap.Value then spawnTeamPlayer(char) end
		end
	end)
end)