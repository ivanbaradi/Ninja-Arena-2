--[[Script that generates player's appropriate health points]]

--MarketPlace
local MarketPlace = game:GetService("MarketplaceService")

--Function that assigns a player's health (regeneration)
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
		if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP: 50% Health]] then
			sub_health = sub_health + (sub_health * 0.50)
		elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP: 25% Health]]then
			sub_health = sub_health + (sub_health * 0.25)
		end
	else --[[For Level 100 Players]]
		if MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420646) --[[MEGA VIP: 50% Health]]then
			sub_health = 150000
		elseif MarketPlace:UserOwnsGamePassAsync(player.UserId, 11420620) --[[VIP: 25% Health]] then
			sub_health = 125000
		else
			sub_health = 100000
		end
	end
	
	--Finalize Player Max Health
	humanoid.MaxHealth = sub_health
	humanoid.Health = humanoid.MaxHealth
	print(player.Name.."'s health regenerated!")
end

--Fires when the player joins the game or respawns
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(1)
		local leaderstats = player.leaderstats
		if leaderstats then
			local humanoid = char:FindFirstChild("Humanoid") or char:FindFirstChild("Zombie")
			if humanoid then
				assignPlayerHP(player, humanoid, leaderstats)
			end
		end
	end)
end)

--Restores Player's Health After leveling up
game.ServerStorage:FindFirstChild("Health Regeneration").Event:Connect(assignPlayerHP)

--Restores Player's Health if the player unquips the Immortal God Long Sword
game.ReplicatedStorage:FindFirstChild("RestorePlayerHealth").OnServerEvent:Connect(assignPlayerHP)

--Grants player infinite health when equipping the Immortal God Long Sword
game.ReplicatedStorage:FindFirstChild("InfiniteHealth").OnServerEvent:Connect(function(player, humanoid)
	humanoid.MaxHealth = math.huge
	humanoid.Health = humanoid.MaxHealth
end)

