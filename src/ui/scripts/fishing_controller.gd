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

func enter_fishing_mode() -> void:
	# grab your FPS controller and *enable* it so it still processes look,
	# but zero out movement speed so you can’t walk.
	fps_controller = get_node(player_path) as FPController
	stored_speed = fps_controller.speed
	stored_acceleration = fps_controller.acceleration
	fps_controller.speed = 0
	fps_controller.acceleration = 0

	# signal PlayerUI
	var ui = get_node(player_ui_path)
	ui.in_fishing_mode = true

	# spawn overlay UI
	fishing_ui = ui_scene.instantiate() as Control
	get_tree().current_scene.add_child(fishing_ui)
	fishing_ui.connect("exit_fishing", Callable(self, "_on_exit_fishing"))

	# spawn the rod under the camera
	var cam = fps_controller.camera
	rod_instance = rod_scene.instantiate() as Node3D
	cam.add_child(rod_instance)
	var t = Transform3D()
	t.basis = Basis().rotated(Vector3(1,0,0), deg_to_rad(-30))
	t.origin = Vector3(0.3, -0.2, -0.5)
	rod_instance.transform = t

	# prepare for casting
	has_cast = false
	set_process_input(true)

func _input(event: InputEvent) -> void:
	# only while fishing and before casting
	if not fishing_ui or has_cast:
		return
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_cast_bobber()

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

func _on_exit_fishing() -> void:
	# remove UI & rod
	fishing_ui.queue_free()
	rod_instance.queue_free()

	# free the bobber if it still exists
	if bobber_instance and bobber_instance.is_inside_tree():
		bobber_instance.queue_free()

	# restore FPS movement
	fps_controller.speed = stored_speed
	fps_controller.acceleration = stored_acceleration

	# clear UI state
	var ui = get_node(player_ui_path)
	ui.in_fishing_mode = false
	ui.reset_fish_prompt()

	# stop listening for input
	set_process_input(false)
