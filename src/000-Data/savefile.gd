class_name SaveFile extends Resource
## Save file that is loaded at the start of some scenes to resume player 
## progress
##
## This save file contains implementation to serialize and deserialize the
## resource. If you want something to persist throughout the game world, please
## place the data here and apply it to the serialize and deserialize functions

## Data concerning the player
@export var playerd: SavePlayer

## Data concerning the players inventory
@export var inventory: Array[GameItem]

## The current world state. Default is DAY. This changes either by the story
## or by the player
enum WORLD_STATE {DAY, NIGHT}
@export var world_state: WORLD_STATE = WORLD_STATE.DAY

## Whether the player has completed the story. Helps determine when the world
## state changes. [br][br]
## If story_complete is set to true, the world state changes 
## every time the player completes a fishing minigame or racing game. Player 
## has option to skip time if they wish to fish at night [br][br]
## If story_complete is set to false, the world state changes depending on 
## story progression. Therefore it relies on script triggers and wont be 
## automated!!
@export var story_complete: bool = false

## Used to track story progression and world state changes
@export var fish_caught: int

## Used to track story progression and world state changes
@export var races_won:   int
