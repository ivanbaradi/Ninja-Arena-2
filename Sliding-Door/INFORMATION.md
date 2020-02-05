# Information

Details:

The development of the sliding door model requires the usage of multiple objects and scripts. These components are the children of the model since they make up that sliding door. Sliding doors are mostly used in the lobby from my game.

What You Need to Know:
- The placements of objects and scripts DO matter. If you place them in the wrong branches, then the sliding door will not work. 
- The name of the objects (except the scripts) inside the model DO matter. When scripting, you need to reference the objects with their corect names to gain access to them.
- Remember that when you want to move the sliding door accordingly, make sure that the door moves along the corrext axis. For example, if you want the door to move along the x-axis, you need to update the x-value. The y and z values are constant during the run.

Instructions:

1. Go to Home -> Part, and add four block objects onto your workspace: LeftDoor, RightDoor, LeftDoorHandler, and RightDoorHandler (you may change their names if you wish, but keep in mind that when scripting, reference them with their corresponding names.)
2. Have the LeftDoor and RightDoor objects be adjacent to each other.
3. Place LeftDoorHandler and RightDoorHandler inside both doors and enlarge both handlers enough to cover the doors. Change the handlers' transparencies to 1 to make them invisible and set CanCollide from both handlers to false to prevent players from touching it. Both handlers should be the same size and have the same exact x, y, and z positions.
4. Add two sound objects inside LeftDoorHandler object (you may put them on the other handler, but you will need to slightly add code in the script from that handler to reference both sounds and play them). These sounds will play the opening and closing door sound effects. Make sure that both of them have the correct sound ids (these ids are found at the right of the web domain).
5. For the instructions of placing the scripts, go .lua files from the Sliding-Door directory and follow them.
6. Select all objects. Press right click and select Group.
