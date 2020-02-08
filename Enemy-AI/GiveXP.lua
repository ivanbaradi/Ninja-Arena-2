--[[
		This script is responsible for giving
		XP to player after they killed the enemy.
		
		INSTRUCTION: Place this script inside the
		enemy model with a humanoid named 'Zombie'.
--]]

local DataStore2 = require(1936396537)
DataStore2.Combine("DATA", "levelData", "killsData", "XP_Data")

local zombie = script.Parent.Zombie
script.Parent.Zombie.Died:Connect(function()	
	local tag = zombie:FindFirstChild("creator")
	if tag then
		if tag.Value then
			local leaderstats = tag.Value:FindFirstChild("leaderstats")
			if leaderstats then
				
				local player = leaderstats.Parent
				local level_DataStore = DataStore2("levelData", player)
				local kills_DataStore = DataStore2("killsData", player)
				local XP_DataStore = DataStore2("XP_Data", player)
				
				--Target exp to reach to the next level
				local target_exp = 1000 * leaderstats.Level.Value
				
				--Add kills and XP
				leaderstats.Kills.Value = leaderstats.Kills.Value + 1
				leaderstats.XP.Value = leaderstats.XP.Value + 1000
				
				--Updates data to player's DataStore
				kills_DataStore:Set(leaderstats.Kills.Value)
				XP_DataStore:Set(leaderstats.XP.Value)
				
				--Updates level and regenerates health if they reach target XP
				if leaderstats.XP.Value >= target_exp then
					leaderstats.Level.Value = leaderstats.Level.Value + 1
					level_DataStore:Set(leaderstats.Level.Value)
					
					local humanoid = player.Character:WaitForChild("Humanoid")
					humanoid.MaxHealth = 100 + (50 *(leaderstats.Level.Value - 1))
					humanoid.Health = humanoid.MaxHealth
				end

			end
		end
	end
end)