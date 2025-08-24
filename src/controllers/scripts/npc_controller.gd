class_name NPCController extends Node3D

@export var fsm: NPCFSM 

@export_category("NPC Behavior")
@export var turn_speed := 10.0

var looking := false
var allow_return := false

var looking_target: Node3D
var default_basis: Basis

var q_start: Quaternion

signal on_looking

func _ready() -> void:
	fsm.player_sensor.area_entered.connect(set_look_at.bind(true))
	fsm.player_sensor.area_exited.connect(set_look_at.bind(false))

func set_look_at(body: Node3D, look: bool):
	self.looking_target = body
	self.looking = look
	
	if look:
		q_start = global_transform.basis.get_rotation_quaternion()
		default_basis = global_transform.basis.orthonormalized()
		allow_return = true
	
	on_looking.emit(look)

func _process(delta: float) -> void:
	if fsm.ignoring: return # We don't look when ignoring
	var q_from = global_transform.basis.get_rotation_quaternion()
	if looking:
		var dir = looking_target.global_position - global_transform.origin
		dir.y = 0.0
		# Compute quaternions for where you start to where you want to look
		var q_to = Basis()\
					# Compute looking at basis 
					.looking_at(dir.normalized(), Vector3.UP).\
					# Rotate basis s.t. -z is facing dir rot matrix
					rotated(Vector3.UP, PI).\
					# retrieve quaternion
					get_rotation_quaternion() 
		
		# Over time update basis defined by a slerping smoothing function between
		# both computed quaternions
		global_transform.basis = Basis(q_from.slerp(q_to, clamp(delta * turn_speed, 0.0, 1.0)))
		return
	
	if allow_return:
		global_transform.basis = Basis(q_from.slerp(q_start, clamp(delta * turn_speed, 0.0, 1.0)))
		if global_transform.basis.z.dot(default_basis.z) > 0.995:
			global_transform.basis = default_basis
			allow_return = false
