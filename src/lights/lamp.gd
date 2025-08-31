extends Node3D

@export var light: OmniLight3D


func _process(delta: float) -> void:
	if Storage.sf.is_daytime: light.visible = false
	else: light.visible = true
