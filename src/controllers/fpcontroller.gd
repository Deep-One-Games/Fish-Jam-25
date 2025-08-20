class_name FPController extends CharacterBody3D
## First Person Controller for character movement in freeroam mode
##
## This controller requires a UI component to manage mouse capturing. This is
## only the raw implementation of keyboard/mouse controls over a camera.

@export_range(1, 35, 1) var speed: float = 10 ## m/s
@export_range(10, 400, 1) var acceleration: float = 100 ## m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 ## m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

var jumping: bool = false ## Jumping state

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 ## Input direction for movement
var look_dir: Vector2 ## 1put direction for look/aim

var walk_vel: Vector3 ## Walking velocity 
var grav_vel: Vector3 ## Gravity velocity 
var jump_vel: Vector3 ## Jumping velocity

var disable := false

@export_category("On Ready Options")
@export var capture_mouse := false
@export var disable_walking := false
@export var disable_mouse := false
@export var skip_savefile := false

@export_category("Node Declares")
@export var camera: Camera3D
@export var interact_box: Area3D

func _ready() -> void:
	if not skip_savefile:
		#Read the position and rotation from the save file on the map
		self.global_position   = Storage.sf.playerd.position
		camera.global_rotation = Storage.sf.playerd.rotation
	
	if capture_mouse:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if disable: return
	if event is InputEventMouseMotion and not disable_mouse:
		look_dir = event.relative * 0.001
		_rotate_camera()

func _physics_process(delta: float) -> void:
	if disable: return
	if not disable_mouse: _handle_joypad_camera_rotation(delta)
	if not disable_walking: 
		velocity = _walk(delta) + _gravity(delta)
		move_and_slide()
	
	Storage.sf.playerd.position = self.global_position

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)
	
	Storage.sf.playerd.rotation = camera.global_rotation

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel
