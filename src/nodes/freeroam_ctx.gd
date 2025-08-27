class_name FreeroamCtx extends Node3D

@export var day_scene: PackedScene
@export var night_scene: PackedScene

func _ready() -> void:
	if Storage.sf.is_daytime:
		self.add_child(day_scene.instantiate())
		return
	self.add_child(night_scene.instantiate())
