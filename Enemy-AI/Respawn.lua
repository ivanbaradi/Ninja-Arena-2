--[[ 
		This script respawns the model, or AI enemy.
		
		INSTRUCTION: Place this script inside the
		enemy model with a humanoid named 'Zombie'.
]]

--Humanoid respawn time
respawn_time = 10

--Creates a copy of the model
copyModel=script.Parent:clone()

--When AI dies, then clone the model aka respawn
script.Parent.Zombie.Died:Connect(function()
	print("Enemy died")
	wait(respawn_time)
	copyModel=copyModel:clone()
	copyModel.Parent=script.Parent.Parent
	copyModel:makeJoints()
	script.Parent:remove()
	print("Enemy respawned")
end)