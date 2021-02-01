# Ninja Arena 2

## About
Ninja Arena 2 is a Roblox game, where players will be fighting against enemy AIs to earn new weapons, rank up, and meet new friends online. All players will be spawned inside a lobby when they join the game. Further features will be introduced when this project is progressing enough.

## Purpose
- Utilize object-oriented programming skills.
- Develop APIs to create services for players.
- Learn remote and server events, object duplication, and other Lua concepts.
- Have Fun!

## Technologies
- **Programming Languages**: Lua
- **Others**: Roblox Studios, Mac OS

## Release of the Game
The game will be released once I am done implementing **Beginner Mode** and **Practice Mode**. All other modes will be coming soon. For now, players can level up to Level 20.

## Gameplay
The gameplay server starts off with a 3-minute break in the Break Room for intervention. Players can talk with other players, relax, and eat foods in the food section. The server selects the map and Ninja Heroes 101's team opponent. After the break, all players will be teleported to the map and the server spawns NPC fighters. The match begins right after the countdown is over. To win the game, either of the teams must to accumulate 2,500 points. After the match is over, all players will return to the Break Room for another 3-minute intervention. The cycle repeats until the server gets shut down or there are no players left.

There are a total of four game modes: **Beginner Mode**, **Pro Mode (Level 20+)**, **Legendary Mode (Level 40+)**, and **Ninja God Mode (Level 70+)**. Players will earn more cash as they go through harder game modes. 

## Level, XP, Cash and Health System

### New Players
- All new players begin at level 1 with no cash and XP.
- Players start with 100HP.
- Players only have a wooden sword.

### Cash System
- Players can earn cash by killing the enemy depending on the difficulty of the enemy.
- There is a chance that players won't earn cash from killing enemies.

### Level and XP System
- The level range is between 1 to 100.
- Player's target XP gets higher as they level up.
- Players get certain amount of XP depending on the difficulty of the AI.
- Level 100 players no longer earn XP.
- Players no longer earn XP from previous modes, but they can still earn cash. For example, if the player is level 20 and plays on Beginner Mode, they will not earn XP. They will have to go to Pro Mode to earn XP.

### Health System
- Player's gains more HP as they level up.
- Player's health regenerates to max if they level up.
