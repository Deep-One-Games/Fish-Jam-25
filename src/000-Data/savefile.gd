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
@export var is_daytime: bool = true
@export var days: int

@export_category("NPC1")
@export var NPC1_interactions: int = 0

@export_category("NPC2")
@export var NPC2_interactions: int = 0

@export_category("NPC3")
@export var NPC3_interactions: int = 0

@export_category("NPC4")
@export var NPC4_interactions: int = 0

@export_category("NPC5")
@export var NPC5_interactions: int = 0

@export_category("NPC6")
@export var NPC6_interactions: int = 0

@export_category("NPC7")
@export var NPC7_interactions: int = 0

func pass_time(): # always save on call
	if is_daytime: # transition day -> night
		is_daytime = false
		Storage.save_process()
		return
	# transition night -> day
	days += 1
	is_daytime = true
	Storage.save_process()
