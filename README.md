# Ninja Games 2

This project is currently under development.

Link to the preview of the game: https://www.roblox.com/games/2982863015/Ninja-Games-2-Preview

## About

Ninja Games 2 is a Roblox game, where players will be fighting against enemy AIs to earn new weapons, rank up, and meet new friends online. All players will be spawned inside a lobby when they join the game. Further features will be introduced when this project is progressing enough.

## Development

**Implementations So Far**
- Designed models and a lobby
- Enabled an API that saves and loads user’s data without occurrences of data loss
- Created a leaderboard that displays the player's level, cash, and XP points

**Future Implementations**
- Game modes
- Models
- Battle maps
- NPC models
- Weapon Shop GUI, Volume GUI, and other GUIs

## Game Modes
**Normal Mode:** Players will be fighting for NH101 or against it. They have an option to switch sides: NH101 team, opposing team, or spectating team. In the spectator's side, players were granted speed boost to go through different battles in an arena. All AIs respawn everytime they die and there is no time limit in the arena. You are free to leave the game if you are tired. Every two weeks, I change AIs.

**Pro Mode:** Players must be at least **Level 15** to play this mode. This is like Normal Mode except they face against stronger AIs and gain more XP.

**God Mode:** Players must be at least **Level 40** to play this mode. This is going to bring a lot of intensity towards players.

**Impossible Mode:** Players must be at least level **Level 90** to play this mode. You will not survive.

## Level and Health System

### New Players
- All new players begin at level 1 with no cash and XP.
- Players start with 100HP.
- Players only have a wooden sword.

### Level System
- The level range is between 1 to 100.
- Players level up of every 1,000XP they get.
- Players get certain amount of XP depending on the difficulty of the AI.

### Health System
- Players gain 50HP everytime they level up.
- Health Formula: **Max HP = 100 + (50 * (Player Level - 1))**
- Player's health regenerates to max if they level up.
