--Gets DataStore2 module
local DataStore2 = require(1936396537)

--If the player has never played the game, then give them this
local default_level = 1
local default_cash = 0
local default_xp = 0

--Player's Backpack (Weapons besides the Wooden Sword)
--local player_backpack = {}

--True if the player plays this game for the first time
local visitFirstTime = true

--Combines three keys (level, kills, and xp)
DataStore2.Combine("DATA", "level", "cash", "XP")

game.Players.PlayerAdded:Connect(function(player)
	
--[[
	Only the game creator and the testing users are allowed
	to join the game. Else, the rest will be kicked out with
	no given stats
	
	Enter other testing UserIDs
]]
	
	if player.UserId ~= 107263163 and player.UserId ~= 1822766716 then
		player:Kick("Game is in development. Sorry about that.")
	else		
		--Player's key for level, kills, and xp
		local level_DataStore = DataStore2("level", player)
		local cash_DataStore = DataStore2("cash", player)
		local XP_DataStore = DataStore2("XP", player)
		
		--Sets backups for each storage in case data loss occurs
		level_DataStore:SetBackup(10)
		cash_DataStore:SetBackup(10)
		XP_DataStore:SetBackup(10)
	
		--Clears level backup if it's set
		if level_DataStore:IsBackup() then
			level_DataStore:ClearBackup()
		end
		
		--Clears kills backup if it's set
		if cash_DataStore:IsBackup() then
			cash_DataStore:ClearBackup()
		end
		
		--Clears XP backup if it's set
		if XP_DataStore:IsBackup() then
			XP_DataStore:ClearBackup()
		end
	
		--Player's leaderboard data
		local leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"
		
		--Player's level
		local LEVEL = Instance.new("IntValue", leaderstats)
		LEVEL.Name = "Level"
		
		--Player's cash
		local CASH = Instance.new("IntValue", leaderstats)
		CASH.Name = "Cash"
		
		--Player's XP
		local XPoints = Instance.new("IntValue", leaderstats)
		XPoints.Name = "XP"
			
		--Calls everytime the level gets updated
		local function updateLevel(updateLevelData)
			LEVEL.Value = level_DataStore:Get(updateLevelData)
		end
		
		--Calls everytime kill counts gets updated
		local function updateCash(updateCashData)
			CASH.Value = cash_DataStore:Get(updateCashData)
		end
			
		--Calls everytime XP gets updated
		local function updateXP(updateXPData)
			XPoints.Value = XP_DataStore:Get(updateXPData)
		end
		
		--[[Functions will be called once, because the player 
			has not been in this game before ]]
		updateCash(default_cash)
		updateLevel(default_level)
		updateXP(default_xp)
	
		--Callback functions that get called to update player's data
		level_DataStore:OnUpdate(updateLevel)
		cash_DataStore:OnUpdate(updateCash)
		XP_DataStore:OnUpdate(updateXP)
		
		--For Testing Purposes (Comment them out soon) [GAME CREATOR]
		--You can modify your data here
		if player.UserId == 107263163 then
			--Modify level, cash, and xp here
			local LevelModified = 100
			local CashModified = 10000000000
			local XPModified = 0
			
			--[[
			
			--LEVEL.Value = LevelModified
			CASH.Value = CashModified
			--XPoints.Value = XPModified
			
			--level_DataStore:Set(LEVEL.Value)
			cash_DataStore:Set(CASH.Value)
			--XP_DataStore:Set(XPoints.Value)
			--]] 
		end
		
		--FOR TESTING USER
		if player.UserId == 1822766716 then
			--Modify level, cash, and xp here
			local LevelModified = 40
			local CashModified = 10000
			local XPModified = 0
			
			--
			
			--LEVEL.Value = LevelModified
			--CASH.Value = CashModified
			--XPoints.Value = XPModified
			
		end
	end
end)

