class_name FSMFishState extends FSMState

@export_category("Vars")
var can_fish:= false
var fishing_available := false


@export_category("Dependencies")
@export var cam: Camera3D
@export var origin: Node3D
@export var fish_ui: Control
@export var player_ui: PlayerUI
@export var player: FPController
@export var power_grad: PowerGradientUI

@export_category("Bob Behavior")
@export var fall_curve: Curve
@export var bobcast: RayCast3D
@export var mps: float
@export var bobber: PackedScene
@export var cast_point: Node3D
@export var animations: AnimationPlayer
var ttf := 0 # time to fall point
var cast_start_time := 0.0
var casting := false
var runtime_bobber : Node3D

@export var lr_state: FSMState

@export var help: Label

var rod: RodItem
var _instance: Node3D 

var has_casted_once := false
var fish_drop_timeleft := 0.0

func _ready() -> void:
	fish_ui.visible = false
	power_grad.visible = false

func enter():
	# transfer state to fishing label
	fish_ui.visible = player_ui.fishing_available 
	player_ui.fish_availability_update.connect(fish_update)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.disable_mouse = false
	rod = get_parent().rod

func exit():
	player_ui.fish_availability_update.disconnect(fish_update)
	lr_state.bobber = runtime_bobber

func fish_update(state: bool): 
	fish_ui.visible = state

var holding_cast := false
var has_casted	 := false
func update(_delta: float) -> void:
	if has_casted_once:
		fish_drop_timeleft -= _delta
		if fish_drop_timeleft < 0:
			get_parent().change_state("LR")
			return
	if player.disable_mouse: return
	if has_casted: return
	if Input.is_action_pressed("cast") and player_ui.fishing_available:
		holding_cast = true
		power_grad.set_power(0)
		power_grad.visible = true
		help.text = "Hold"
		
	
	if not Input.is_action_pressed("cast") and holding_cast:
		help.text = ""
		holding_cast = false
		power_grad.visible = false
		var cast_distance = (1-power_grad.power())*rod.max_cast_distance_m
		
		animations.play(&"Rod_Throw")
		await get_tree().create_timer(0.66).timeout
		has_casted = true
		cast_bober(cast_distance)	
		fish_drop_timeleft = randfn(30.0, 5.0)
		has_casted_once = true
		await animations.animation_finished
		animations.play(&"Rod_Fishing")
		has_casted = false

func cast_bober(d: float):
	# shift the raycast then force update
	bobcast.position.z = -d
	bobcast.force_raycast_update()

	if bobcast.is_colliding():
		if runtime_bobber: runtime_bobber.queue_free()
		var obj = bobcast.get_collider()
		if not obj.is_in_group("fishing_zone"): return
		var p = bobcast.get_collision_point()
		runtime_bobber = bobber.instantiate()
		runtime_bobber.travel_curve = fall_curve
		runtime_bobber.travel_time = d / mps
		runtime_bobber.from = cast_point.global_position
		runtime_bobber.to = p
		get_tree().root.add_child(runtime_bobber)
		power_grad.set_power(0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_ui.fishing_available:
		if _instance: _instance.queue_free()
		return
