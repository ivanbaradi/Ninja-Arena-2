--[[
	WARNING: Do NOT test this script the game in Roblox Studios
	or it will overwrite another player's data. It will also not
	work if you're executing this script in RobloxStudios. You
	will need to publish the game and play from the website.

	This script utilizes data writing, data reading, and data
	recovery. This prevents player's data from being lost. 
	

]]--

--Gets DataStore2 module
local DataStore2 = require(1936396537)

--If the player has never played the game, then give them this
local default_level = 1
local default_kills = 0
local default_xp = 0

--Combines three keys (level, kills, and xp)
DataStore2.Combine("DATA", "test110", "test111", "test112")

game.Players.PlayerAdded:Connect(function(player)
	
	--Player's key for level, kills, and xp
	local level_DataStore = DataStore2("test110", player)
	local kills_DataStore = DataStore2("test111", player)
	local XP_DataStore = DataStore2("test112", player)
	
	--Sets backups for each storage in case data loss occurs
	level_DataStore:SetBackup(10)
	kills_DataStore:SetBackup(10)
	XP_DataStore:SetBackup(10)

	--Clears level backup if it's set
	if level_DataStore:IsBackup() then
		level_DataStore:ClearBackup()
	end
	
	--Clears kills backup if it's set
	if kills_DataStore:IsBackup() then
		kills_DataStore:ClearBackup()
	end
	
	
	--Clears XP backup if it's set
	if XP_DataStore:IsBackup() then
		XP_DataStore:ClearBackup()
	end

	--Player's leaderboard data
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	--Player's level
	local level = Instance.new("IntValue", leaderstats)
	level.Name = "Level"
	
	--Player's kills
	local kills = Instance.new("IntValue", leaderstats)
	kills.Name = "Kills"
	
	--Player's XP
	local xp = Instance.new("IntValue", leaderstats)
	xp.Name = "XP"
		
	--Calls everytime the level gets updated
	local function updateLevel(updateLevelData)
		level.Value = level_DataStore:Get(updateLevelData)
	end
	
	--Calls everytime kill counts gets updated
	local function updateKills(updateKillsData)
		kills.Value = kills_DataStore:Get(updateKillsData)
	end
		
	--Calls everytime XP gets updated
	local function updateXP(updateXPData)
		xp.Value = XP_DataStore:Get(updateXPData)
	end
	
	--[[Functions will be called once, because the player 
		has not been in this game before ]]
	updateLevel(default_level)
	updateKills(default_kills)
	updateXP(default_xp)

	--Callback functions that get called whenever the player's data changed
	level_DataStore:OnUpdate(updateLevel)
	kills_DataStore:OnUpdate(updateKills)
	XP_DataStore:OnUpdate(updateXP)
	
	--When player joins, then generate appropriate max HP
	local init_humanoid = player.Character:WaitForChild("Humanoid")
	init_humanoid.MaxHealth = 100 + (50 *(level.Value - 1))
	init_humanoid.Health = init_humanoid.MaxHealth
	
	--Generates player's health whenever they respawn
	player.CharacterAdded:connect(function(char)
		local humanoid = char:WaitForChild("Humanoid")
		if humanoid then
			humanoid.MaxHealth = 100 + (50 *(level.Value - 1))
			humanoid.Health = humanoid.MaxHealth
		end
	end)

end)

