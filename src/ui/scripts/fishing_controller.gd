# FishingController.gd
extends Node

@export var player: NodePath            # your FPController
@export var ui_scene: PackedScene       # fishing.tscn
@export var player_ui_path: NodePath    # path to your PlayerUI node

var fishing_ui: Control
var fps_controller: FPController

func enter_fishing_mode() -> void:
	fps_controller = get_node(player)
	fps_controller.disable = true

	fishing_ui = ui_scene.instantiate()
	get_tree().current_scene.add_child(fishing_ui)
	fishing_ui.connect("exit_fishing", Callable(self, "_on_exit_fishing"))

func _on_exit_fishing() -> void:
	# remove the fishing UI
	fishing_ui.queue_free()

	# re-enable the normal FPS controller
	fps_controller.disable = false

	# tell PlayerUI to put the fish prompt back if needed
	var ui = get_node(player_ui_path) as Node
	if ui and ui.has_method("reset_fish_prompt"):
		ui.call("reset_fish_prompt")
