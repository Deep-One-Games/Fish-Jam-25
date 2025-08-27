class_name FSMFishState extends FSMState

@export_category("Vars")
var can_fish:= false
var fishing_available := false


@export_category("Dependencies")
@export var cam: Camera3D
@export var origin: Node3D
@export var bobber: PackedScene
@export var fish_ui: Control
@export var player_ui: PlayerUI

var _instance: Node3D 
func _ready() -> void:
	fish_ui.visible = false

func enter():
	# transfer state to fishing label
	fish_ui.visible = player_ui.fishing_available 
	player_ui.fish_availability_update.connect(fish_update)

func exit():
	player_ui.fish_availability_update.disconnect(fish_update)

func fish_update(state: bool): 
	fish_ui.visible = state

func _cast_bobber() -> void:
	var _origin = cam.global_transform.origin + cam.global_transform.basis.z * -0.5 + cam.global_transform.basis.y * -0.2
	var forward = -cam.global_transform.basis.z.normalized()

	var bobber_instance = bobber.instantiate() as RigidBody3D
	bobber_instance.global_transform.origin = _origin
	get_tree().current_scene.add_child(bobber_instance)
	
	bobber_instance.gravity_scale = 0.3
	
	var arc_up = Vector3.UP * 2.0
	
	bobber_instance.linear_velocity = forward * 12.0 + arc_up
	_instance = bobber_instance

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_ui.fishing_available:
		if _instance: _instance.queue_free()
		_cast_bobber()
		return
