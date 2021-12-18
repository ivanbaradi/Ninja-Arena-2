--Scoreboard GUI
local GUI = script.Parent
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Ally and Enemy Team Scoreboard
local AllyTeamScoreboard = GUI:FindFirstChild("Ally Team Scoreboard")
local EnemyTeamScoreboard = GUI:FindFirstChild("Enemy Team Scoreboard")
--Ally Points and Enemy Points Objects
local TeamPoints = ReplicatedStorage:FindFirstChild('Team Points')
local AllyPoints = TeamPoints:FindFirstChild('Ally Points')
local EnemyPoints = TeamPoints:FindFirstChild('Enemy Points')
--Formate Number Remote Function
local FormatNumber = ReplicatedStorage:FindFirstChild('Format Number')

---------- SCOREBOARD GUI COMPS ----------

--[[Makes the scoreboard visible or invisible to the player

	Parameter(s):
	state => {true: display scoreboard, false: don't display the scoreboard}
]]
function displayScoreboard(state)
	AllyTeamScoreboard.Visible = state
	EnemyTeamScoreboard.Visible = state
end

--Updates the both team points in the team
ReplicatedStorage['Update Team Points'].OnClientEvent:Connect(function ()
	AllyTeamScoreboard['Team Score'].Text = FormatNumber:InvokeServer(AllyPoints.Value)
	EnemyTeamScoreboard['Team Score'].Text = FormatNumber:InvokeServer(EnemyPoints.Value)
end)

--Creates a scoreboard for the player
ReplicatedStorage['Create Scoreboard'].OnClientEvent:Connect(function()
		
	--Assigns Enemy Scoreboard
	EnemyTeamScoreboard['Team Name'].Text = ReplicatedStorage['Selected Enemy Team Name'].Value
	EnemyTeamScoreboard['Team Icon'].Image = 'rbxassetid://'..ReplicatedStorage['Selected Enemy Icon'].Value
	
	--Displays the scoreboard
	displayScoreboard(true)
end)

--Removes the Scoreboard from the player
ReplicatedStorage['Remove Scoreboard'].OnClientEvent:Connect(displayScoreboard)