--Gets DataStore2 module
local DataStore2 = require(1936396537)

--If the player has never played the game, then give them this
local default_level = 1
local default_cash = 0
local default_xp = 0

--Player's Backpack (Weapons besides the Wooden Sword)
local player_backpack = {}

--True if the player is joining the game
local joining = true

--Combines three keys (level, kills, and xp)
DataStore2.Combine("DATA", "level", "cash", "XP", "backpack")

game.Players.PlayerAdded:Connect(function(player)
	
	--Player's key for level, kills, and xp
	local level_DataStore = DataStore2("level", player)
	local cash_DataStore = DataStore2("cash", player)
	local XP_DataStore = DataStore2("XP", player)
	local backpack_DataStore = DataStore2("backpack", player)
	
	--Sets backups for each storage in case data loss occurs
	level_DataStore:SetBackup(10)
	cash_DataStore:SetBackup(10)
	XP_DataStore:SetBackup(10)
	backpack_DataStore:SetBackup(10)

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
	
	--Clears backpack backup if it's set
	if backpack_DataStore:IsBackup() then
		backpack_DataStore:ClearBackup()
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
	
	--Calls everytime player's backpack gets updates
	local function updateBackpack(updateBackpackData)
		
		--Loads or saves player's weapon inventory
		player_backpack = backpack_DataStore:Get(updateBackpackData)
		
		--Loads player's weapons in the inventory (executes ONCE)
		if joining then
			print("Weapons to load:")
			for i, load_weapon in pairs(player_backpack) do
				print("Loading "..load_weapon)
				game.ReplicatedStorage:FindFirstChild(load_weapon):Clone().Parent = player.Backpack
				game.ReplicatedStorage:FindFirstChild(load_weapon):Clone().Parent = player.StarterGear
			end
			joining = false
		end
	end
	
	--[[Functions will be called once, because the player 
		has not been in this game before ]]
	updateLevel(default_level)
	updateCash(default_cash)
	updateXP(default_xp)
	updateBackpack(player_backpack)

	--Callback functions that get called to update player's data
	level_DataStore:OnUpdate(updateLevel)
	cash_DataStore:OnUpdate(updateCash)
	XP_DataStore:OnUpdate(updateXP)
	backpack_DataStore:OnUpdate(updateBackpack)
	
	--For Testing Purposes (Comment them out soon) [GAME CREATOR ONLY]
	--You can modify your data here
	if player.UserId == --[[Game Creator's User ID]] then
		
		--Modify level, cash, and xp here
		local LevelModified = 2
		local CashModified = 1000
		local XPModified = 0
		
		--[[
		
		LEVEL.Value = LevelModified
		CASH.Value = CashModified
		--XPoints.Value = XPModified
		
		--Save them if you wish
		level_DataStore:Set(LevelModified)
		cash_DataStore:Set(CashModified)
		--XP_DataStore:Set(XPModified)

		
		--Modify your backpack here
		
		--Next time you join the game, you only have the wooden sword
		--backpack_DataStore:Set({})  
		
		]]
		
	end
end)
