--[[ This script displays the player's current XP and the target XP. ]]

wait(1)

--Gets Player
local player = game.Players.LocalPlayer
--Text XP
local text_XP = script.Parent
--Target XP Object and XP Multiplier Object
local TargetXP_Object = script.Parent:FindFirstChild("Target XP")
local XPMultiplier_Object = script.Parent:FindFirstChild("XP Multiplier")

--Adds commas on every thousands
function formatNumber(EXP)
	
	local formatted = ""
	local rev_index_ptr = 1
	
	for i = string.len(EXP), 1, -1 do
	
		if rev_index_ptr % 3 == 1 and rev_index_ptr > 3 then
			formatted = string.sub(EXP,i,i)..","..formatted
		else
			formatted = string.sub(EXP,i,i)..formatted
		end
	
		rev_index_ptr = rev_index_ptr + 1
	end

	return formatted
end

--Used to determine the target XP (Part 1)
function assignXPMultiplier()
	if player.leaderstats.Level.Value <= 10 then
		return 500
	elseif player.leaderstats.Level.Value > 10 and player.leaderstats.Level.Value <= 20 then
		return 750
	elseif player.leaderstats.Level.Value > 20 and player.leaderstats.Level.Value <= 30 then
		return 1000
	elseif player.leaderstats.Level.Value > 30 and player.leaderstats.Level.Value <= 40 then
		return 1250
	elseif player.leaderstats.Level.Value > 40 and player.leaderstats.Level.Value <= 50 then
		return 1500
	elseif player.leaderstats.Level.Value > 50 and player.leaderstats.Level.Value <= 60 then
		return 1750
	elseif player.leaderstats.Level.Value > 60 and player.leaderstats.Level.Value <= 70 then
		return 2000
	elseif player.leaderstats.Level.Value > 70 and player.leaderstats.Level.Value <= 80 then
		return 2500
	elseif player.leaderstats.Level.Value > 80 and player.leaderstats.Level.Value <= 90 then
		return 5000
	elseif player.leaderstats.Level.Value > 90 and player.leaderstats.Level.Value <= 99 then
		return 10000
	else
		return nil
	end
end

--Used to determine the target XP (Part 2)
function assignXPBase(level)
	if level >= 1 and level <= 10 then
		return 500 --PASSED
	elseif level > 10 and level <= 20 then
		return 5750 --PASSED
	elseif level > 20 and level <= 30 then
		return 13500 --PASSED
	elseif level > 30 and level <= 40 then
		return 23750 --PASSED
	elseif level > 40 and level <= 50 then
		return 36500 --PASSED
	elseif level > 50 and level <= 60 then
		return 51750 --PASSED
	elseif level > 60 and level <= 70 then
		return 69500 --PASSED
	elseif level > 70 and level <= 80 then
		return 90000 --PASSED
	elseif level > 80 and level <= 90 then
		return 117500 --PASSED
	elseif level > 90 and level <= 99 then
		return 172500
	else
		return nil
	end
end

--Returns 1 to 10
function getOnesDigitLevel(level)
	
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

while wait(0.1) do
	
	--Player's Current XP
	local XP = player.leaderstats.XP.Value
	--Player's Current Level
	local level = player.leaderstats.Level.Value
	
	--Determines Player's Target XP
	local XPMultiplier = assignXPMultiplier()
	local XPBase = assignXPBase(level)
	local OnesDigitLevel = getOnesDigitLevel(level)
	
	if XPMultiplier and XPBase and OnesDigitLevel then
		--Calculates Target XP
		local TargetXP = XPBase + (XPMultiplier * (OnesDigitLevel - 1))
		
		--Copies values inside the object values
		TargetXP_Object.Value = TargetXP
		XPMultiplier_Object.Value = XPMultiplier
				
		text_XP.Text = tostring(formatNumber(XP)).."/"..tostring(formatNumber(TargetXP))
	else
		text_XP.Text = "MAX XP"
	end
end
