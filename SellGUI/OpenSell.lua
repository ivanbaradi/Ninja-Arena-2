--Sell Weapon GUI
sellGui = script.Parent.Parent.SellGui
--Weapon Shop GUI
shopGui = script.Parent.Parent.Parent:WaitForChild("ShopGUI").ShopGui

--Opens or closes the Sell Weapon GUI
script.Parent.MouseButton1Click:Connect(function()
	
	if not sellGui.Visible then
		
		--Closes the Weapon Shop GUI if opened
		--Disbales Weapon Shop button
		if shopGui.Visible then
			shopGui.Visible = false
			shopGui.Parent.ShopButton.Selectable = false
			print("Closed Shop GUI because Sell GUI is opened")
		end
		
		sellGui.Visible = true
	else
		
		--Re-enables weapon shop button
		if not shopGui.Parent.ShopButton.Selectable then
			shopGui.Parent.ShopButton.Selectable = true
			print("Because Sell GUI is closed, you can now open Shop GUI")
		end
		
		sellGui.Visible = false
	end
	
end)