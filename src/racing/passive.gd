extends FSMState


@export var race_track: RaceTrack3D

@export var game_controls: Control

func enter() -> void:
	game_controls.queue_free()
