class_name PlayerUI extends Control

@export var options: OptionsControl
@export var player: FPController

@export_category("Dialog Controls")
@export var dialog_lbl: Control
var dialog_state := false
var dialog_area: DialogueArea

@export_category("Fishing Controls")
@export var fishing_lbl: Label 
@export var casting_lbl: Label
@export var currently_fishing: bool = false


var disable_options := false
var options_state := false
var fishing_available := false

var in_dialog:= false

signal fish_availability_update

func _ready() -> void:
	options.on_options_close.connect(free_mouse)
	DialogueManager.dialogue_ended.connect(func x(_y): free_mouse())

	player.interact_box.area_entered.connect(_dialog_area_entered)
	player.interact_box.area_exited.connect(_dialog_area_exited)

	fish_availability_update.connect(fishing_ui_update)
	fishing_lbl.visible = false
	dialog_lbl.visible = false

	casting_lbl.visible = currently_fishing
	DialogueManager.dialogue_ended.connect(set_in_dialog.bind(false))
	

func set_interact(area: DialogueArea, _visible: bool) -> void:
	dialog_lbl.visible = _visible
	dialog_state = _visible
	dialog_area = area if _visible else null

func _dialog_area_entered(area: Area3D) -> void:
	disable_options = true 
	if area is DialogueArea:
		set_interact(area, true)
		return

func _dialog_area_exited(area: Area3D) -> void:
	disable_options = false 
	if area is DialogueArea:
		set_interact(area, false)
		return

func _process(_delta: float) -> void:
	# CHECK FISHING COLLISIONS
	var hit = player.fishing_rc.get_collider()
	var can_fish = hit and hit.is_in_group("fishing_zone")

	# Send signal only if state transitioned
	if (fishing_available and not can_fish) or\
			(not fishing_available and can_fish):
		fish_availability_update.emit(can_fish)
	fishing_available = can_fish

func set_in_dialog(_r, state: bool):
	in_dialog = state

func _input(event: InputEvent) -> void:
	if currently_fishing: return
	# INTERACT
	if event.is_action_pressed("interact") and dialog_state and not in_dialog:
		dialog_area.start_interaction()
		in_dialog = true
		player.disable = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return

	if event.is_action_pressed("interact") and fishing_available:
		Storage.save_process()
		SceneManager.switch(SceneManager.GameScene.fishing)
		return

	# OPTIONS
	if event.is_action_pressed("options") and not disable_options:
		options_state = !options_state
		if options_state:
			options.popup_open()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.disable = true
			return
		clear_popups()
		free_mouse()
		return

func fishing_ui_update(fish_state: bool) -> void:
	casting_lbl.visible = false
	fishing_lbl.visible = false
	if fish_state and not currently_fishing:
		fishing_lbl.visible = true
	if fish_state and currently_fishing:
		casting_lbl.visible = true

func free_mouse() -> void:
	player.disable = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func clear_popups() -> void:
	options.popup_close()
