extends Node
## Manages players save file globally. Allows all scripts access to [member sf]

## The save file being managed by the game
var sf: SaveFile

var disable_saving := false 

## Variable to check if this is the first time playing the game or if this is
## a returning player
var runtime_is_new := false

var SAVE_PATH := "user://save.tres"
var DEF_PATH  := "res://defaultsave.tres"

var ROD_5M = preload("res://src/000-Data/Items/rod_a.tres")
var ROD_10M = preload("res://src/000-Data/Items/rod_b.tres")
var ROD_20M = preload("res://src/000-Data/Items/rod_c.tres")

func _ready() -> void:
	if disable_saving:
		sf = copy_empty_save()
		return
	
	if FileAccess.file_exists(SAVE_PATH):
		sf = ResourceLoader.load(SAVE_PATH)
		return
	
	# If save file not found, we do a new game
	reset_save()

func copy_empty_save(): return ResourceLoader.load(DEF_PATH).duplicate(true)

func reset_save():
	runtime_is_new = true
	sf = copy_empty_save()
	ResourceSaver.save(sf, SAVE_PATH)
	
func save_process() -> void: 
	runtime_is_new = false
	ResourceSaver.save(sf, SAVE_PATH)
