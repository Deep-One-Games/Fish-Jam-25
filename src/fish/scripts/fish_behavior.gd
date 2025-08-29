class_name FishBehavior extends Node3D

@export var jump_curve: Curve

@export_category("Dependencies")
@export var event_sensor: Area3D
@export var mesh: Node3D 
@export var animations: AnimationPlayer
@export var race_fish: RaceFish

var total_jump_anim_time := 1.4167
var jump_orig_time := 1.2 # 1 for jump action

var jump_time := 0.0 # total time of jump length
var jump_time_elapsed := 0.0 # time so far since jump started
var do_jump := false

var jump_event: JumpAreaEvent

func _ready() -> void:
	event_sensor.area_shape_entered.connect(on_jump_event)
	animations.play(&"Swimming")
	animations.seek(randf())

func _process(delta: float) -> void:
	if not do_jump: return
	jump_time_elapsed += delta
	if jump_time_elapsed > jump_time: 
		do_jump = false
		mesh.position.y = 0.0
		jump_time_elapsed = 0.0
		return
	
	mesh.position.y =\
			jump_curve.sample(jump_time_elapsed/jump_time)*jump_event.max_jump_height

func on_jump_event(r: RID, e: Area3D, area_shape_index: int, local_shape_index: int):
	if e is not JumpAreaEvent: return
	if not race_fish.fishinfo.will_accept_boost(r): return
	jump_event = e
	jump_time = jump_event.jump_distance / jump_event.mps
	animations.speed_scale = jump_orig_time / jump_time 
	do_jump = true 
	animations.play(&"Jumping")

	await get_tree().create_timer(jump_time).timeout
	print("finished")
	animations.play(&"Swimming")
