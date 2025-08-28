class_name RaceFish extends Node3D

@export var follow_track: LinearFollow

@export_category("Dependencies")
@export var event_sensor: Area3D

func _ready() -> void:
	event_sensor.area_entered.connect(on_speed_event) 

func on_speed_event(e: Area3D):
	if e is not RaceEvent3D: return

	if e.override_mps:
		follow_track.mps = e.mps
