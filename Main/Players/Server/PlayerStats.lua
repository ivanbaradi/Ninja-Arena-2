--Gets DataStore2 module
local DataStore2 = require(1936396537)

--If the player has never played the game, then give them this
local default_level = 1
local default_cash = 0
local default_xp = 0

--Combines three keys (level, kills, and xp)
DataStore2.Combine("DATA", "level", "cash", "XP")

game.Players.PlayerAdded:Connect(function(player)
		
	--Player's key for level, kills, and xp
	local level_DataStore = DataStore2("level", player)
	local cash_DataStore = DataStore2("cash", player)
	local XP_DataStore = DataStore2("XP", player)

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
	
	--Modifies player's stats (Modify your stats on the function's params)
	local function changeStats(level, cash, xp)
		
		--
		LEVEL.Value = level
		CASH.Value = cash
		XPoints.Value = xp
		
		print(player.Name.."'s stats are modified.")
		
		
		--
		level_DataStore:Set(LEVEL.Value)
		cash_DataStore:Set(CASH.Value)
		XP_DataStore:Set(XPoints.Value)
		
		print(player.Name.."'s stats are saved.")
	end
	
	--[[For Testing Purposes (Comment them out soon)
		Edit level on 1st arg, cash on 2nd arg, and XP on 3rd arg]]
	if player.UserId == 107263163 then --Game Creator
		--changeStats(1, 0, 0)	
	elseif player.UserId == 1822766716 then --Testing Player
		--changeStats(1, 0, 0)
	end
end)