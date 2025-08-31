class_name JackNPC extends Node3D

@export_category("Character")
@export var profile: SaveNPC

@export_category("Pathing Setup")
@export var path: Path3D
@export var linear_follow: LinearFollow
@export var c_home_to_lake: Curve3D
@export var c_lake_to_town: Curve3D
@export var c_town_to_home: Curve3D

@export_category("Dependencies")
@export var fsm: TutorialFSM
@export var pivot: NPCController

@export var animations: AnimationPlayer

var look_active
signal stop_looking
func _ready() -> void:
	pivot.on_looking.connect(on_looking)

var disable_walk_after_look: bool = false
func on_looking(look_state: bool):
	if disable_walk_after_look: return
	linear_follow.following_path = !look_state 
	if look_state:
		animations.play(&"SalesMan_Idle")
		return
	animations.play(&"SalesMan_Walk")
	if not look_state: stop_looking.emit()
