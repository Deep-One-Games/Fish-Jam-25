extends Node3D
class_name ApplyLinearRotation

@export var v_rot: Vector3
@export var nodes: Array[Node3D]

func _process(delta: float) -> void:
	for n in nodes:
		n.rotate_x(v_rot[0])
		n.rotate_y(v_rot[1])
		n.rotate_z(v_rot[2])
