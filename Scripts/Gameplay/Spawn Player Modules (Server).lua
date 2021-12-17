--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Gameplay Script
local GameplayScript = game.ServerScriptService:FindFirstChild('Gameplay')
--Spawn Player Script
local SpawnPlayer = script.Parent

--[[Displays the scoreboard when the player joins the server and 
	during the match
	
	Parameter(s):
	player => player obj
]]
SpawnPlayer:FindFirstChild('Display Scoreboard On Join').OnInvoke = function(player)
	if GameplayScript:FindFirstChild("RoundContinuing").Value then 
		ReplicatedStorage:FindFirstChild("CreateScoreBoard"):FireClient(player) 
	end
end

--[[Renames player's humanoid based on its team

	Parameter(s):
	player => player obj
	team => player's team
	humanoid => player's humanoid
]]
SpawnPlayer:FindFirstChild('Rename Player Humanoid').OnInvoke = function(player, team, humanoid)
	if team.Name == ReplicatedStorage:FindFirstChild("Selected Enemy Team Name").Value then --Enemy Team
		humanoid.Name = "Zombie"
	elseif team.Name == "Spectators" then --Spectator Team
		ServerStorage:FindFirstChild("Enter Spectate Mode"):Fire(player)
	end
end

--[[Freezes player (team fighter) on NPC spawning and countdown

	Parameter(s):
	humanoid => player's humanoid
]]
SpawnPlayer:FindFirstChild('Freeze Teammate').OnInvoke = function(humanoid)
	if not GameplayScript:FindFirstChild("PlayerCanMove").Value then
		if humanoid.Name ~= "Spectator" then humanoid.WalkSpeed = 0 end
	end
end

--[[Changes the state of the player's overhead GUI

	Parameter(s):
	player => player object
	char => player's character
	
]]
ServerStorage:FindFirstChild("Change Player Overhead GUI").Event:Connect(function(player, char)

	--[[Modifies a single player's overhead GUI color
	
		Parameters(s):
		stroke color => stroke color of the player's overhead GUI based on team
	]]
	local function changePlayerOverheadStrokeColor(stroke_color)

		--Player Overhead GUI
		local PlayerOverheadGUI = char.Head:FindFirstChild("Player GUI"):FindFirstChild('GUI')

		--Changes player name and VIP tag stroke color
		PlayerOverheadGUI:FindFirstChild('Player Name').TextStrokeColor3 = stroke_color
		PlayerOverheadGUI:FindFirstChild('VIP Tag').TextStrokeColor3 = stroke_color
	end

	if player.Team then
		local team_name = player.Team.Name
		if team_name == "Ninja Heroes 101" then
			changePlayerOverheadStrokeColor(Color3.fromRGB(0, 0, 255)) --blue
		elseif team_name == "Spectators" then
			changePlayerOverheadStrokeColor(Color3.fromRGB(128, 43, 0)) --brown
		else
			changePlayerOverheadStrokeColor(Color3.fromRGB(252, 1, 7)) --red
		end
	else
		changePlayerOverheadStrokeColor(Color3.fromRGB(0, 0, 0)) --black
	end
end)

--[[Respawns the player at the arena map after it dies

	Parameter(s):
	char => player's character
]]
SpawnPlayer:FindFirstChild('Respawn Player On Arena Map').OnInvoke = function(char)

	--Gets the map's name from ReplicatedStorage
	local RS_Map = ReplicatedStorage:FindFirstChild('Map').Value

	if workspace:FindFirstChild(RS_Map) then
		local ArenaMap = ServerStorage['Arena Maps']:FindFirstChild(RS_Map)
		ServerStorage:FindFirstChild('Respawn Character'):Fire(char, ArenaMap, false)
	else
		print('The arena map has not spawned in the workspace yet')
	end
end