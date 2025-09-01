class_name Bobber3D extends Node3D 

@export var travel_curve: Curve
@export var travel_time : float
@export var from: Vector3
@export var to	: Vector3

@export_category("Dependencies")
@export var mon: Control
@export var animations: AnimationPlayer
@export var fish_sil: MeshInstance3D
@export var audio: AudioStreamPlayer

func _ready() -> void:
	animations.pause()

var elapsed := 0.0

func _process(delta: float) -> void:
	if travel_time <= 0:
		return

	elapsed += delta
	var t := elapsed / travel_time
	t = clamp(t, 0.0, 1.0)

	var curve_value := travel_curve.sample_baked(t)

	var x = lerp(from.x, to.x, t)

	var y = lerp(from.y, to.y, t) + curve_value 
	var z = lerp(from.z, to.z, t) + t  # If you want lateral offset along z

	global_transform.origin = Vector3(x, y, z)

	if t == 1.0 and not animations.is_playing():
		animations.play()
		audio.play()
		await get_tree().create_timer(0.85).timeout
		audio.stop()
