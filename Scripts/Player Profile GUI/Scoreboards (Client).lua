--Scoreboard GUI
local GUI = script.Parent
--Player Team
local player = game.Players.LocalPlayer
--Gets player's leaderstats
local leaderstats = player:WaitForChild("leaderstats")
--Gets player's level
local player_level = leaderstats:WaitForChild('Level').Value
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")
--Max Level in this game mode
local MaxLevel = ReplicatedStorage['Max Level'].Value
--Ally Points and Enemy Points Objects
local TeamPoints = ReplicatedStorage['Team Points']
local AllyPoints = TeamPoints["Ally Points"]
local EnemyPoints = TeamPoints["Enemy Points"]
--Sound Object
local ResultsSong = workspace:FindFirstChild("Results")
--Ally and Enemy Team Scoreboard
local AllyTeamScoreboard = GUI:FindFirstChild("Ally Team Scoreboard")
local EnemyTeamScoreboard = GUI:FindFirstChild("Enemy Team Scoreboard")



--AddTeamPoints Remote Event
local AddTeamPoints = ReplicatedStorage:FindFirstChild("AddTeamPoints")
--RemoveScoreBoard Event
local RemoveScoreBoard = ReplicatedStorage:FindFirstChild("RemoveScoreBoard")
--True if points can get updates (All AIs must be initially spawned before setting this to true)
local CanUpdateScore = ReplicatedStorage:FindFirstChild("CanUpdateScore")
--Song Handler Remote Event
local SongHandler = ReplicatedStorage:FindFirstChild("Song Handler")

--[[AddRoundXPToPlayer RMEOTE event
Gets called when the battle ends and the player 
will earn XP]]
local AddRoundXPToPlayer = ReplicatedStorage:FindFirstChild("AddRoundXPToPlayer")

--Player's Messages
local Message1 = GUI:FindFirstChild("Message 1")
local Message2 = GUI:FindFirstChild("Message 2")
--White Color
local whiteColor = Color3.fromRGB(255, 255, 255)
--Map Index (Used to have players spawn at the correct spawn location when joining the game)
local MapIndex = ReplicatedStorage:FindFirstChild("Map")

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
	
		rev_index_ptr += 1
	end

	return formatted
end

--[[Makes the scoreboard visible or invisible to the player

	Parameter(s):
	state => {true: display scoreboard, false: don't display the scoreboard}
]]
function displayScoreboard(state)
	AllyTeamScoreboard.Visible = state
	EnemyTeamScoreboard.Visible = state
end

--[[Creates a scoreboard for the player

	Parameter(s):
	enemy team => name of the enemy team
	enemy icon => icon of the enemy team
]]
ReplicatedStorage['Create Scoreboard'].OnClientEvent:Connect(function(enemyTeam, enemyIcon)
		
	--Assigns Enemy Scoreboard
	EnemyTeamScoreboard['Team Name'].Text = enemyTeam
	EnemyTeamScoreboard['Team Icon'].Image = enemyIcon
	
	--Display score points
	AllyTeamScoreboard['Team Score'].Text = formatNumber(AllyPoints.Value)
	EnemyTeamScoreboard['Team Score'].Text = formatNumber(EnemyPoints.Value)
	
	--Displays the scoreboard
	displayScoreboard(true)
end)

--Removes the Scoreboard from the player
ReplicatedStorage['Remove Scoreboard'].OnClientEvent:Connect(displayScoreboard)

--Updates the team scores in the team scoreboards
ReplicatedStorage['Update Team Points'].OnClientEvent:Connect(function()
	if CanUpdateScore.Value then
		AllyTeamScoreboard['Team Score'].Text = formatNumber(AllyPoints.Value)
		EnemyTeamScoreboard['Team Score'].Text = formatNumber(EnemyPoints.Value)
		--print("Current Team Scores: "..AllyPoints.Value.." to "..EnemyPoints.Value)
	end
end)


--Displays results and gives round XP to players
ReplicatedStorage['Round Has Ended'].OnClientEvent:Connect(function()
	
	--[[Writes a message about results and returns the amount
		of XP given based on the player's level and results
	
		Parameter(s):
		result message => tells the player who won, lost, or tied
		give XP => amount of XP given to player after the match
	]]
	local function writeResultMessage(resultMessage, give_XP)
		
		--Sets results message
		Message1.Text = resultMessage
		
		--[[Cannot give players XP because they have reached max level of this 
		game mode or the player is on Spectators team]]
		if player_level >= MaxLevel or player.Team.Name == 'Spectators' then
			give_XP = 0
		else
			-- Multiplies given XP based on player's owned gamepass
			if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP]] then
				give_XP *= 2
			elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP]] then
				give_XP *= 3
			end
			
			Message2.Text = '+'..tostring(give_XP)..'XP'
		end
		
		return give_XP
	end
	
	--[[Plays the winning, losing, or tied song based on the
		match results
	
		Parameter(s):
		song ID => asset ID of the results song
	]]
	local function playResultsSong(songID)
		ResultsSong.SoundId = 'http://www.roblox.com/asset/?id='..songID
		ResultsSong:Play()
	end
	
	--[[Determines the player whether they win or lose based
		on their team and the amount of points. This returns the amount
		of XP given to player after the match.
	
		Parameter(s):
		team name => name of the player's team
		team points 1 => supporting team's points (object)
		team points 2 => opposing team's points (object)
	]]
	local function determinePlayer(team_name, teamPoints1, teamPoints2)
		
		--Amount of XP to give to the player after the round ended
		local give_XP
		--List of XP amounts to give (1 => Win, 2 => Loss, 3 => Draw)
		local XPs = {150,50,75}
		
		if teamPoints1.Value > teamPoints2.Value then
			give_XP = writeResultMessage(team_name..' Won!', XPs[1])
			playResultsSong(ResultsSong['Won'].Value)
		elseif teamPoints1.Value < teamPoints2.Value then
			give_XP = writeResultMessage(team_name..' Lost', XPs[2])
			playResultsSong(ResultsSong['Lost'].Value)
		else
			give_XP = writeResultMessage('Game Tied', XPs[3])
			playResultsSong(ResultsSong['Tied'].Value)
		end
		
		return give_XP
	end
	
	--Amount of XP to give to player after the round has ended
	local roundXP
	
	--Determines the XP to be given to player based on team and results
	if player.Team then
		
		--Gets player's team name
		local team_name = player.Team.Name
		
		if team_name == "Ninja Heroes 101" or team_name ~= 'Spectators' then --For Fighters
			if team_name == "Ninja Heroes 101" then
				roundXP = determinePlayer(team_name, AllyPoints, EnemyPoints)
			else
				roundXP = determinePlayer(team_name, EnemyPoints, AllyPoints)
			end
		else--For Spectators
			if AllyPoints.Value > EnemyPoints.Value then
				roundXP = writeResultMessage('Ninja Heroes 101 Won!', 0)
			elseif AllyPoints.Value < EnemyPoints.Value then
				roundXP = writeResultMessage(EnemyTeamScoreboard['Team Name'].Text..' Won!', 0)
			else
				roundXP = writeResultMessage('Game Tied', 0)
			end
		end
	end
	
	--Tells server to give players round XP
	ReplicatedStorage:FindFirstChild("Add Round XP To Player"):FireServer(roundXP)
	
	wait(8)
	--Removes both messages
	Message1.Text = ''
	Message2.Text = ''
end)