class_name RaceFish extends Node3D

@export var follow_track: LinearFollow

@export_category("Dependencies")
@export var event_sensor: Area3D

@export var data: RacingData 
@export var fishinfo: FishData

var bursting: bool = false
var burst_event: RaceEvent3D
var burst_time: float 

func _ready() -> void:
	event_sensor.area_shape_entered.connect(on_speed_event) 

func _process(delta: float) -> void:
	if not bursting: return

	follow_track.mps =\
			move_toward(follow_track.mps, follow_track.default_mps, 5.0*delta)
	
	if follow_track.mps == follow_track.default_mps:
		bursting = false

func on_speed_event(r: RID, e: Area3D, area_shape_index: int, local_shape_index: int):
	if e is not RaceEvent3D: return
	if not fishinfo.will_accept_boost(r): return
	if e.override_mps:
		follow_track.mps = e.mps
	bursting = e.burst_mode
