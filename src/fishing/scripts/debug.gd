extends Control

@export var target: Control

@export var fsm: FSM
@export var player: FPController

func _ready() -> void:
	DebugMonitor.inject(target, fsm, [
		"initial_state",
		"current_state"])
	
	DebugMonitor.inject(target, player, [
		"look_dir",
		"disable_walking",
		"disable_mouse",
		"disable"])
