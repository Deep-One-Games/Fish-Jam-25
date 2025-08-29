extends Node3D

@export var sensitivity: float = 0.01

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate pivot (this node) around Y axis
		rotate_y(-event.relative.x * (sensitivity/5))
