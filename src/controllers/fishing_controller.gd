extends Node

@export var bobber_scene: PackedScene
@export var player_path: NodePath
@export var player_ui_path: NodePath
@export var ui_scene: PackedScene
@export var rod_scene: PackedScene

var fishing_ui: Control
var rod_instance: Node3D
var bobber_instance: RigidBody3D
var fps_controller: FPController

var stored_speed: float
var stored_acceleration: float

var has_cast: bool = false

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("cast"): _cast_bobber()

func _cast_bobber() -> void:
	has_cast = true

	var tip = rod_instance.get_node_or_null("Tip") as Marker3D
	var origin: Vector3
	var forward: Vector3
	if tip:
		origin = tip.global_transform.origin
		forward = -tip.global_transform.basis.z.normalized()
	else:
		var cam = fps_controller.camera
		origin = cam.global_transform.origin + cam.global_transform.basis.z * -0.5 + cam.global_transform.basis.y * -0.2
		forward = -cam.global_transform.basis.z.normalized()

	bobber_instance = bobber_scene.instantiate() as RigidBody3D
	bobber_instance.global_transform.origin = origin
	get_tree().current_scene.add_child(bobber_instance)
	
	bobber_instance.gravity_scale = 0.3
	
	var arc_up = Vector3.UP * 2.0
	
	bobber_instance.linear_velocity = forward * 12.0 + arc_up
