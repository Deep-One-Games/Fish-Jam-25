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
