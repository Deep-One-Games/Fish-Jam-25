class_name NPCController extends Node3D

@export var fsm: FSM
@export var player_sensor: InteractableArea

@export_category("NPC Behavior")
@export var turn_speed := 10.0

var looking := false
var looking_target: Node3D
var default_basis: Basis

signal on_looking

func _ready() -> void:
	default_basis = basis.orthonormalized() 
	player_sensor.area_entered.connect(set_look_at.bind(true))
	player_sensor.area_exited.connect(set_look_at.bind(false))

func set_look_at(body: Node3D, look: bool):
	self.looking_target = body
	self.looking = look
	
	on_looking.emit(look)

func _process(delta: float) -> void:
	if looking:
		basis = basis\
			.slerp(
				Basis().looking_at(
					(looking_target.global_position - global_position).normalized(),
					Vector3.UP)
				, delta * turn_speed)
		return
	
	basis = basis.slerp(default_basis, delta * turn_speed)
