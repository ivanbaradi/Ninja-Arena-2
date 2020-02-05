--[[ 
	This script is responsible for opening and closing the
	right door when a player is close to it.
	
	INSTRUCTION: Place this script inside RightDoorHandler 
	object
	
--]]

right_door = script.Parent.Parent.RightDoor
moving_length = 6
x = right_door.Position.X
y = right_door.Position.Y
z = right_door.Position.Z
temp = x
processing = false


script.Parent.Touched:Connect(function(hit)
	
	if not processing then
		processing = true
		
		--Opens door
		while x ~= temp + moving_length do
			x = x + 0.5
			right_door.Position = Vector3.new(x,y,z)
			wait(0.01)
		end
		
		wait(3)
		temp = x
		
		--Closes door
		while x ~= temp - moving_length do
			x = x - 0.5
			right_door.Position = Vector3.new(x,y,z)
			wait(0.01)
		end
		temp = x
		
		processing = false
	end
end)