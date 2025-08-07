extends Node

@export var player: NodePath 
@export var ui_scene: PackedScene

var fishing_ui: Control
var fps_controller: FPController

func enter_fishing_mode() -> void:
	fps_controller = get_node(player)
	fps_controller.disable = true

	fishing_ui = ui_scene.instantiate()
	get_tree().current_scene.add_child(fishing_ui)
	fishing_ui.connect("exit_fishing", Callable(self, "_on_exit_fishing"))

func _on_exit_fishing() -> void:
	fishing_ui.queue_free()

	fps_controller.disable = false
