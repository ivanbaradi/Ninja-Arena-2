--GUI
local GUI = script.Parent
--Messages
local Message1 = GUI:FindFirstChild('Message 1')
local Message2 = GUI:FindFirstChild('Message 2')
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Ally Points and Enemy Points Objects
local TeamPoints = ReplicatedStorage:FindFirstChild('Team Points')
local AllyPoints = TeamPoints:FindFirstChild('Ally Points')
local EnemyPoints = TeamPoints:FindFirstChild('Enemy Points')
--Player
local player = game.Players.LocalPlayer
--Gets player's leaderstats
local leaderstats = player:WaitForChild("leaderstats")
--Gets player's level
local player_level = leaderstats:WaitForChild('Level').Value
--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")
--Max Level in this game mode
local MaxLevel = ReplicatedStorage['Max Level'].Value
--Sound Object
local ResultsSong = workspace:FindFirstChild("Results")
--Enemy Team
local EnemyTeam = ReplicatedStorage:FindFirstChild('Selected Enemy Team Name')

--[[Displays a message

	Parameter(s):
	message => message to announce to all players
]]
function regularAnnouncement(message)
	Message1.Text = message
	wait(4)
end

--[[Counts down to start the round]]
function performCountdown()
	
	--Loops values from 3 to 1
	local countdown = 3
	while countdown > 0 do
		Message1.Text = countdown
		wait(1)
		countdown -= 1
	end
	
	Message1.Text = 'Fight!'
	wait(1)
end

--[[Announces to all the players on the screen

	Parameter(s):
	message => message to announce to all players
	key => type of announcement
]]
ReplicatedStorage:FindFirstChild('Announce To All Players').OnClientEvent:Connect(function(message, key)
	
	if key == 0 then
		regularAnnouncement(message)
	else
		performCountdown()
	end
	
	--Removes the message
	Message1.Text = ''
end)

--Displays results and gives round XP to players
ReplicatedStorage:FindFirstChild('Round Has Ended').OnClientEvent:Connect(function()

	--[[Writes a message about results and returns the amount
		of XP given based on the player's level and results
	
		Parameter(s):
		result message => tells the player who won, lost, or tied
		give XP => amount of XP given to player after the match
		
		Returns:
		give XP
	]]
	local function writeResultMessage(resultMessage, giveXP)

		--Sets results message
		Message1.Text = resultMessage

		--[[Cannot give players XP because they have reached max level of this 
		game mode or the player is on Spectators team]]
		if player_level >= MaxLevel or player.Team.Name ~= 'Spectators' then
			--Multiplies given XP based on player's owned gamepass
			giveXP = ReplicatedStorage:FindFirstChild('Double or Triple XP After the Round'):InvokeServer(giveXP)
			Message2.Text = '+'..tostring(giveXP)..'XP'
		end

		return giveXP
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
		
		Return(s):
		give XP => the amount of XP to give to player after the match
	]]
	local function determinePlayer(team_name, teamPoints1, teamPoints2)

		--Amount of XP to give to the player after the round ended
		local giveXP = 0
		--List of XP amounts to give (150 => Win, 50 => Loss, 75 => Draw)
		local XPs = {150,50,75}

		if teamPoints1.Value > teamPoints2.Value then
			giveXP = writeResultMessage(team_name..' Won!', XPs[1])
			playResultsSong(ResultsSong['Won'].Value)
			print('You won the match!')
		elseif teamPoints1.Value < teamPoints2.Value then
			giveXP = writeResultMessage(team_name..' Lost', XPs[2])
			playResultsSong(ResultsSong['Lost'].Value)
			print('You lost the match')
		else
			giveXP = writeResultMessage('Tied', XPs[3])
			playResultsSong(ResultsSong['Tied'].Value)
			print('The game is tied')
		end

		return giveXP
	end

	--Amount of XP to give to player after the round has ended
	local roundXP

	--Determines the XP to be given to player based on team and results
	if player.Team then

		--Gets player's team name
		local team_name = player.Team.Name

		if team_name ~= 'Spectators' then --For Fighters
			if team_name == "Ninja Heroes 101" then
				roundXP = determinePlayer(team_name, AllyPoints, EnemyPoints)
			else
				roundXP = determinePlayer(team_name, EnemyPoints, AllyPoints)
			end
		else--For Spectators
			if AllyPoints.Value > EnemyPoints.Value then
				roundXP = writeResultMessage('Ninja Heroes 101 Won!', 0)
				playResultsSong(ResultsSong['Won'].Value)
			elseif AllyPoints.Value < EnemyPoints.Value then
				roundXP = writeResultMessage(EnemyTeam.Value..' Won!', 0)
				playResultsSong(ResultsSong['Won'].Value)
			else
				roundXP = writeResultMessage('Tied', 0)
				playResultsSong(ResultsSong['Tied'].Value)
			end
		end
	end

	--Tells server to give players round XP
	ReplicatedStorage:FindFirstChild("Add Round XP To Player"):FireServer(leaderstats, roundXP)

	wait(8)
	--Removes both messages
	Message1.Text = ''
	Message2.Text = ''
end)