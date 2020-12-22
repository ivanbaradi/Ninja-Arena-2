--Gets DataStore2 module
local DataStore2 = require(1936396537)
--Combines three keys (level, kills, and xp)
DataStore2.Combine("DATA", "level", "XP")

--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Will regenerate player's new health when leveled up
function assignPlayerHP(player, humanoid, leaderstats)
	
	--Assigns HP base 
	local function assignHP_Base(level)
		if level >= 1 and level <= 10 then
			return 100
		elseif level > 10 and level <= 20 then
			return 650
		elseif level > 20 and level <= 30 then
			return 1700
		elseif level > 30 and level <= 40 then
			return 3250
		elseif level > 40 and level <= 50 then
			return 5300
		elseif level > 50 and level <= 60 then
			return 7900
		elseif level > 60 and level <= 70 then
			return 11550
		elseif level > 70 and level <= 80 then
			return 17050
		elseif level > 80 and level <= 90 then
			return 28050
		elseif level > 90 and level <= 99 then
			return 51050
		else
			return nil
		end
	end
	
	--Assigns HP Increment
	local function assignHP_Increment(level)
		
		if level >= 1 and level <= 10 then
			return 50
		elseif level > 10 and level <= 20 then
			return 100
		elseif level > 20 and level <= 30 then
			return 150
		elseif level > 30 and level <= 40 then
			return 200
		elseif level > 40 and level <= 50 then
			return 250
		elseif level > 50 and level <= 60 then
			return 350
		elseif level > 60 and level <= 70 then
			return 500
		elseif level > 70 and level <= 80 then
			return 1000
		elseif level > 80 and level <= 90 then
			return 2000
		elseif level > 90 and level <= 99 then
			return 5000
		else
			return nil
		end
	end
	
	--Returns 1 to 10
	local function getOnesDigitLevel(level)
		
		--[[ Level 100 ]]
		if level == 100 then
			return nil
		end
		
		--[[ Level 1-10 ]]
		if level >= 1 and level < 11 then -- Level 1-10
			return level
		end
		
		--[[ Level 11-99 ]]
		
		--Converts to string to get level ones digit
		local level_string = tostring(level)
		
		--Returns 1-9 or 10
		if level % 10 ~= 0 then
			return tonumber(string.sub(level_string,2,2))
		else
			return 10
		end
	end
	
	local HP_Base = assignHP_Base(leaderstats.Level.Value)
	local HP_Increment = assignHP_Increment(leaderstats.Level.Value)
	local OnesDigitLevel = getOnesDigitLevel(leaderstats.Level.Value)
	
	--Health before adding extra health if player owns VIP or MEGA VIP
	local sub_health
	
	if HP_Base ~= nil and HP_Increment ~= nil and OnesDigitLevel ~= nil then
		--Assigns player's appropriate HP
		sub_health = HP_Base + (HP_Increment * (OnesDigitLevel - 1))
		
		--Adds more HP if player owns VIP or MEGA VIP
		if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP: 25% Health]] then
			sub_health = sub_health + (sub_health * 0.50)
		elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP: 15% Health]]then
			sub_health = sub_health + (sub_health * 0.25)
		end
	else --[[For Level 100 Players]]
		if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP: 25% Health]]then
			sub_health = 125000
		elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP: 15% Health]] then
			sub_health = 115000
		else
			sub_health = 100000
		end
	end
	
	--Finalize Player Max Health
	humanoid.MaxHealth = sub_health
	humanoid.Health = humanoid.MaxHealth
end

--Returns player's target xp
function getTargetXP(level)
	
	--Used to determine the target XP (Part 1)
	local function assignXPMultiplier()
		if level <= 10 then
			return 500
		elseif level > 10 and level <= 20 then
			return 750
		elseif level > 20 and level <= 30 then
			return 1000
		elseif level > 30 and level <= 40 then
			return 1250
		elseif level > 40 and level <= 50 then
			return 1500
		elseif level > 50 and level <= 60 then
			return 1750
		elseif level > 60 and level <= 70 then
			return 2000
		elseif level > 70 and level <= 80 then
			return 2500
		elseif level > 80 and level <= 90 then
			return 5000
		elseif level > 90 and level <= 99 then
			return 10000
		else
			return nil
		end
	end
	
	--Used to determine the target XP (Part 2)
	local function assignXPBase()
		if level >= 1 and level <= 10 then
			return 500
		elseif level > 10 and level <= 20 then
			return 5750 
		elseif level > 20 and level <= 30 then
			return 13500 
		elseif level > 30 and level <= 40 then
			return 23750 
		elseif level > 40 and level <= 50 then
			return 36500 
		elseif level > 50 and level <= 60 then
			return 51750 
		elseif level > 60 and level <= 70 then
			return 69500 
		elseif level > 70 and level <= 80 then
			return 90000 
		elseif level > 80 and level <= 90 then
			return 117500
		elseif level > 90 and level <= 99 then
			return 172500
		else
			return nil
		end
	end
	
	--Returns 1 to 10
	local function getOnesDigitLevel()
		
		--[[ Level 100 ]]
		if level == 100 then
			return nil
		end
		
		--[[ Level 1-10 ]]
		if level >= 1 and level < 11 then -- Level 1-10
			return level
		end
		
		--[[ Level 11-99 ]]
		
		--Converts to string to get level ones digit
		local level_string = tostring(level)
		
		--Returns 1-9 or 10
		if level % 10 ~= 0 then
			return tonumber(string.sub(level_string,2,2))
		else
			return 10
		end
	end
	
	return assignXPBase() + (assignXPMultiplier() * (getOnesDigitLevel() - 1))
end

--Gets called after finishing the match
game.ReplicatedStorage:FindFirstChild("AddRoundXPToPlayer").OnServerEvent:Connect(function(player, result)
	
	--Do not give player another Round XP if they already received it
	--if earnedMatchXPAlready then return end
	
	--Player's leaderstats
	local leaderstats = player.leaderstats
	
	--Player's for level, and xp
	local level_DataStore = DataStore2("level", player)
	local XP_DataStore = DataStore2("XP", player)
	
	--Gives player XP
	if result == 0 then
		leaderstats.XP.Value += 150
	elseif result == 1  then
		leaderstats.XP.Value += 50
	else
		leaderstats.XP.Value += 75
	end
	
	--Saves player's XP
	XP_DataStore:Set(leaderstats.XP.Value)
	
	--If the player can level up
	local TargetXP = getTargetXP(leaderstats.Level.Value)
	if leaderstats.XP.Value >= TargetXP then
		
		--Levels up player and saves it
		leaderstats.Level.Value += 1
		level_DataStore:Set(leaderstats.Level.Value)
		
		--Player's Humanoid
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		
		--Restores player's health
		assignPlayerHP(player, humanoid, leaderstats)
	end
end)