extends Node
## Manages players save file globally. Allows all scripts access to [member sf]

## The save file being managed by the game
var sf: SaveFile

## Variable to check if this is the first time playing the game or if this is
## a returning player
var runtime_is_new := false

var SAVE_PATH := "user://save.tres"
var DEF_PATH  := "res://defaultsave.tres"

func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		sf = ResourceLoader.load(SAVE_PATH)
		return
	
	# If save file not found, we do a new game
	reset_save()

func reset_save():
	runtime_is_new = true
	sf = ResourceLoader.load(DEF_PATH)
	ResourceSaver.save(sf, SAVE_PATH)
	
func save_process() -> void: 
	runtime_is_new = false
	ResourceSaver.save(sf, SAVE_PATH)
