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

--Used to determine the target XP
function assignXPMultiplier(level)
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
	else --[[Level 91 - 99]]
		return 10000
	end
end

--Used to determine the target XP (Part 2)
function assignXPBase(level)
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
	else --[[Level 91 - 99]]
		return 172500
	end
end

--Returns 1 to 10
function getOnesDigitLevel(level)

	--[[ Level 1-10 ]]
	if level >= 1 and level < 11 then return level end -- Level 1-10

	--[[ Level 11-99 ]]

	--Returns 1-9 or 10
	if level % 10 ~= 0 then
		return tonumber(string.sub(tostring(level),2,2))
	else
		return 10
	end
end

while wait(0.1) do
	
	--Player's Current Level
	local level = player.leaderstats.Level.Value

	--In Version 1.0, Players can level up to 20. Uncomment later once they can rank up to 100.
	if level < 20 --[[100]] then

		--Determines Player's Target XP
		local XPMultiplier = assignXPMultiplier(level)

		--Calculates Target XP
		local TargetXP = assignXPBase(level) + (XPMultiplier * (getOnesDigitLevel(level) - 1))

		--Copies values inside the object values
		TargetXP_Object.Value = TargetXP
		
		--Let's the server know about the player's target XP (Battle Modes Only)
		game.ReplicatedStorage:FindFirstChild("Assign Target XP to Server"):FireServer(TargetXP)

		XPMultiplier_Object.Value = XPMultiplier
		
		--Displays the player's current XP and target XP
		text_XP.Text = tostring(formatNumber(player.leaderstats.XP.Value)).."/"..tostring(formatNumber(TargetXP)).."XP"
	else
		text_XP.Text = "MAX LEVEL"
	end
end