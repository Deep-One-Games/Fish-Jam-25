extends Node

@export var player_path: NodePath
@export var player_ui_path: NodePath
@export var ui_scene: PackedScene
@export var rod_scene: PackedScene

var fishing_ui: Control
var rod_instance: Node3D
var fps_controller: FPController

func enter_fishing_mode() -> void:
	# grab & disable the normal FPS
	fps_controller = get_node(player_path) as FPController
	fps_controller.disable = true

	# tell PlayerUI we're now fishing
	var ui = get_node(player_ui_path)
	ui.in_fishing_mode = true

	# spawn the fishing UI overlay
	fishing_ui = ui_scene.instantiate() as Control
	get_tree().current_scene.add_child(fishing_ui)
	fishing_ui.connect("exit_fishing", Callable(self, "_on_exit_fishing"))

	# spawn the rod under the camera
	var cam = fps_controller.camera
	rod_instance = rod_scene.instantiate() as Node3D
	cam.add_child(rod_instance)

	# position & rotate for lower-right “in-hand” view
	var t = Transform3D()
	t.basis = Basis().rotated(Vector3(1,0,0), deg_to_rad(-30))
	t.origin = Vector3(0.3, -0.2, -0.5)
	rod_instance.transform = t

func _on_exit_fishing() -> void:
	# remove UI & rod
	if fishing_ui:
		fishing_ui.queue_free()
	if rod_instance:
		rod_instance.queue_free()

	# re-enable the normal FPS
	if fps_controller:
		fps_controller.disable = false

	# clear fishing flag on PlayerUI
	var ui = get_node(player_ui_path)
	ui.in_fishing_mode = false

	# restore “Press F to Fish” prompt if needed
	ui.reset_fish_prompt()
