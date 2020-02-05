--[[
	This script is responsible for opening and closing the
	left door when a player approaches it. It is also
	responsible for triggering an opening or closing door
	sound.
	
	INSTRUCTIONS:
		1. Place this script inside LeftDoorHandler object
		2. Choose two sound objects that creates opening and
		   closing sound effects and place them in the
		   LeftDoorHandler object.
	
--]]

--Accesses left door
left_door = script.Parent.Parent.LeftDoor
--How much the sliding door moves when ir's opening or closing
moving_length = 6
--Position coordinates of the left door
x = left_door.Position.X
y = left_door.Position.Y
z = left_door.Position.Z
--Used to update x to compute the destination of x pos
temp = x
--False if the door is not moving
processing = false
--Get access to the sound of opening and closing the door
doorOpenSound = script.Parent.DoorOpenSound
doorCloseSound = script.Parent.DoorCloseSound

script.Parent.Touched:Connect(function(hit)
	
	if not processing then
		processing = true
		
		--Opens door
		doorOpenSound:Play()
		while x ~= temp - moving_length do
			x = x - 0.5
			left_door.Position = Vector3.new(x,y,z)
			wait(0.01)
		end
		
		wait(3)
		temp = x
		
		--Closes door
		doorCloseSound:Play()
		while x ~= temp + moving_length do
			x = x + 0.5
			left_door.Position = Vector3.new(x,y,z)
			wait(0.01)
		end
		temp = x
		
		processing = false
	end
end)