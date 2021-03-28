--Ally and Enemy Team Scoreboard
local AllyTeamScoreboard = script.Parent:FindFirstChild("Ally Team Scoreboard")
local EnemyTeamScoreboard = script.Parent:FindFirstChild("Enemy Team Scoreboard")
--AllyPoints and EnemyPoints Objects
local AllyPoints = game.ReplicatedStorage.TeamPoints:FindFirstChild("AllyPoints")
local EnemyPoints = game.ReplicatedStorage.TeamPoints:FindFirstChild("EnemyPoints")
--AddTeamPoints Remote Event
local AddTeamPoints = game.ReplicatedStorage:FindFirstChild("AddTeamPoints")
--CreateScoreBoard Event
local CreateScoreBoard = game.ReplicatedStorage:FindFirstChild("CreateScoreBoard")
--RemoveScoreBoard Event
local RemoveScoreBoard = game.ReplicatedStorage:FindFirstChild("RemoveScoreBoard")
--EndRound Remote Event
local EndTheRound = game.ReplicatedStorage:FindFirstChild("EndTheRound")
--True if points can get updates (All AIs must be initially spawned before setting this to true)
local CanUpdateScore = game.ReplicatedStorage:FindFirstChild("CanUpdateScore")
--Player Team
local player = game.Players.LocalPlayer
--SendMessageToAllPlayers Remote Event
local SendMessageToAllPlayers = game.ReplicatedStorage:FindFirstChild("SendMessageToAllPlayers")
--SendMessageToAllPlayers2 Remote Event
local SendMessageToAllPlayers2 = game.ReplicatedStorage:FindFirstChild("SendMessageToAllPlayers2")
--Song Handler Remote Event
local SongHandler = game.ReplicatedStorage:FindFirstChild("Song Handler")
--Enemy Team's Name
local EnemyTeamName, EnemyIcon = game.ReplicatedStorage:FindFirstChild("EnemyTeam"), game.ReplicatedStorage:FindFirstChild("EnemyIcon")
--VS Frame GUI
local VSFrame = script.Parent:FindFirstChild("VS Frame")

--[[AddRoundXPToPlayer RMEOTE event
Gets called when the battle ends and the player 
will earn XP]]
local AddRoundXPToPlayer = game.ReplicatedStorage:FindFirstChild("AddRoundXPToPlayer")

--[[RoundHasEnded REMOTE EVENT
This remote event will have the server tell all clients about who won,
and how many XP they earn playing the round.
]]
local RoundHasEnded = game.ReplicatedStorage:FindFirstChild("RoundHasEnded")

--Player's Messages
local Message1 = script.Parent:FindFirstChild("Message 1")
local Message2 = script.Parent:FindFirstChild("Message 2")
--White Color
local whiteColor = Color3.fromRGB(255, 255, 255)
--Map Index (Used to have players spawn at the correct spawn location when joining the game)
local MapIndex = game.ReplicatedStorage:FindFirstChild("Map")

--Adds commas on every thousands
function formatNumber(Points)
	
	local formatted = ""
	local rev_index_ptr = 1
	
	for i = string.len(Points), 1, -1 do
	
		if rev_index_ptr % 3 == 1 and rev_index_ptr > 3 then
			formatted = string.sub(Points,i,i)..","..formatted
		else
			formatted = string.sub(Points,i,i)..formatted
		end
	
		rev_index_ptr = rev_index_ptr + 1
	end

	return formatted
end

--[[
Creates a scoreboard for the player

Gets called when:
1. The match begins
2. The player has joined the match
]]
CreateScoreBoard.OnClientEvent:Connect(function()
		
	--Assigns Enemy Scoreboard
	EnemyTeamScoreboard.TeamName.Text = EnemyTeamName.Value
	EnemyTeamScoreboard.TeamIcon.Image = EnemyIcon.Value
	
	--Display score points
	AllyTeamScoreboard.TeamScore.Text = tostring(formatNumber(AllyPoints.Value))
	EnemyTeamScoreboard.TeamScore.Text = tostring(formatNumber(EnemyPoints.Value))
		
	--Scoreboards become visible to the player
	AllyTeamScoreboard.Visible = true
	EnemyTeamScoreboard.Visible = true
end)

--Removes player's scoreboard once the player gets teleported to the Break Room
RemoveScoreBoard.OnClientEvent:Connect(function()
	AllyTeamScoreboard.Visible = false
	EnemyTeamScoreboard.Visible = false
end)

--[[ 
The ADDTEAMPOINTS Remote Event:
1. Add points to NH101 or Enemy Team
2. Checks if either of the team scores reaches the victory score
3. Lets the player know if they won or lost
4. Gives player's round XP
5. Tells the server to end the Round (Only one client can do that)
]]
AddTeamPoints.OnClientEvent:Connect(function(team)
	if CanUpdateScore.Value then
		
		--Scores are updated everytime the AI dies
		if team == "Ninja Heroes 101" then
			AllyTeamScoreboard.TeamScore.Text = tostring(formatNumber(AllyPoints.Value))
		else
			EnemyTeamScoreboard.TeamScore.Text = tostring(formatNumber(EnemyPoints.Value))
		end
		--print("Current Team Scores: "..AllyPoints.Value.." to "..EnemyPoints.Value)
	end
end)


--RoundHasEnded Remote Event
RoundHasEnded.OnClientEvent:Connect(function()
			
	--Gets leaderstats to check if player is under Level 20
	local leaderstats = player:WaitForChild("leaderstats")
	
	--Result (0: Won, 1: Lost, 2: Tied)
	local result
	
	--Sound Object
	local Sound = game.Workspace:FindFirstChild("Results")
	--List of Result Song
	local ResultSongID = {
		"http://www.roblox.com/asset/?id=146876684", --Won!
		"http://www.roblox.com/asset/?id=1844173391", --Lost
		"http://www.roblox.com/asset/?id=259060012" --Tied
	}
	
	--[[ Message1 and Message2 changed color to red, blue, or gray ]]
	--Blue Color (Ninja Heroes 101 Team)
	--local blueColor = Color3.fromRGB(77, 121, 255)
	--Red Color (Enemy Team)
	--local redColor = Color3.fromRGB(255, 77, 77)
	
	--Delivers results to the player
	local function Results(color, resultMessage, XP_Message, soundID, RESULT)
		Message1.TextColor3 = color
		Message2.TextColor3 = color
		Message1.Text = resultMessage
		Message2.Text = XP_Message
		Sound.SoundId = soundID
		result = RESULT
	end
	
	if player.Team.Name == "Ninja Heroes 101" or player.Team.Name == EnemyTeamName.Value then --For Fighters
		if AllyPoints.Value > EnemyPoints.Value then --NH101 Team Won!
			if player.Team.Name == "Ninja Heroes 101" then
				Results(Color3.fromRGB(77, 121, 255), "Ninja Heroes 101 Won!", "+150XP", ResultSongID[1], 0)
			else --Enemy Team Lost
				Results(Color3.fromRGB(255, 77, 77), EnemyTeamName.Value.." Lost", "+50XP", ResultSongID[2], 1)
			end
		elseif AllyPoints.Value < EnemyPoints.Value then --If the Enemy Team won!
			if player.Team.Name == "Ninja Heroes 101" then 
				Results(Color3.fromRGB(77, 121, 255), "Ninja Heroes 101 Lost", "+50XP", ResultSongID[2], 1)
			else --NH101 Lost
				Results(Color3.fromRGB(255, 77, 77), EnemyTeamName.Value.." Won!", "+150XP", ResultSongID[1], 0)
			end
		else --Tied ._.
			Results(Color3.fromRGB(255, 255, 255), "Tied", "+75XP", ResultSongID[3], 2)
		end
		
		--Tells the server to give cash to player after the round has ended
		game.ReplicatedStorage:FindFirstChild("Add Round Cash To Player"):FireServer(result)
		
		--Gives player XP for finishing the match and makes XP message visible
		if leaderstats.Level.Value < 20 then			
			--Tells how many XP the player has
			Message2.Visible = true
			--Gets server to give player Round XP
			AddRoundXPToPlayer:FireServer(result)
		end
	else --For Spectators
		if AllyPoints.Value > EnemyPoints.Value then
			Results(Color3.fromRGB(77, 121, 255), "Ninja Heroes 101 Won!", "", ResultSongID[1], nil)
		elseif AllyPoints.Value < EnemyPoints.Value then
			Results(Color3.fromRGB(255, 77, 77), EnemyTeamName.Value.." Won!", "", ResultSongID[1], nil)
		else
			Results(Color3.fromRGB(255, 255, 255), "Tied", "", ResultSongID[3], nil)
		end
	end
	
	--Plays the winning, losing, or tied song
	Sound:Play()
	
	--Makes Victory and XP visible to the player
	Message1.Visible = true
	
	wait(8)
	
	--Makes Victory and XP invisible to the player
	Message1.Visible = false
	Message2.Visible = false
end)

--Tells the player that the match is about to begin and performs countdown
SendMessageToAllPlayers.OnClientEvent:Connect(function(key)
	
	if key == 0 then --Displays VS Frame
		
		--Enemy Frame from VS Frame
		local EnemyFrame = VSFrame:FindFirstChild("Enemy Frame")
		local TeamImage = EnemyFrame:FindFirstChild("Team Image")
		local TeamName = EnemyFrame:FindFirstChild("Team Name")
		
		--Assigns team name and image
		TeamImage.Image = EnemyIcon.Value
		TeamName.Text = EnemyTeamName.Value
		
		--Assigns map name
		local MapName = VSFrame:FindFirstChild("Map Name")
		MapName.Text = "Map: "..MapIndex.Value
		
		--Makes frame visible and then invisible
		VSFrame.Visible = true
		wait(8)
		VSFrame.Visible = false
		
	elseif key == 1 then --Displays "The Match is about to Begin" message
		Message1.TextColor3 = Color3.fromRGB(255, 255, 255) --message turns back to white
		Message1.Text = "The Match is about to Begin"
		Message1.Visible = true
		wait(4)
	else --Performs countdown
		Message1.Visible = true
		Message1.Text = "3"
		wait(1)
		Message1.Text = "2"
		wait(1)
		Message1.Text = "1"
		wait(1)
		--Sets the message color to orange
		Message1.TextColor3 = Color3.fromRGB(255, 204, 0)
		Message1.Text = "Fight!"
		wait(2)
	end
	
	Message1.Visible = false
end)

--Plays the battle song
SongHandler.OnClientEvent:Connect(function(playlist, instruction)
	if instruction == "Play" then
		playlist:Play()
	else
		playlist:Stop()
	end
end)