# PlayerUI.gd
extends Control

@export var options: OptionsControl
@export var inventory: Control
@export var player: FPController

@export_category("Dialog Controls")
@export var show_dialog: Control
@export var dialog_lbl: Label
var dialog_state := false
var dialog_area: DialogueArea

@export_category("Fishing Controls")
@export var show_fishing: Control
@export var fishing_lbl: Label

var options_state := false
var inventory_state := false
var fishing_available := false

signal fish_availability_update

func _ready() -> void:
	options.on_options_close.connect(free_mouse)
	DialogueManager.dialogue_ended.connect(func x(_y): free_mouse())

	player.interact_box.area_entered.connect(_dialog_area_entered)
	player.interact_box.area_exited.connect(_dialog_area_exited)

	fish_availability_update.connect(fishing_ui_update)
	show_fishing.visible = false
	show_dialog.visible = false
	

func set_interact(area: DialogueArea, _visible: bool) -> void:
	show_dialog.visible = _visible
	dialog_state = _visible
	dialog_area = area if _visible else null

func _dialog_area_entered(area: Area3D) -> void:
	if area is DialogueArea:
		set_interact(area, true)
		return

func _dialog_area_exited(area: Area3D) -> void:
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

func _input(event: InputEvent) -> void:
	# INTERACT
	if event.is_action_pressed("interact") and dialog_state:
		dialog_area.start_interaction()
		player.disable = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return

	# INVENTORY
	if event.is_action_pressed("inventory"):
		inventory_state = !inventory_state
		if inventory_state:
			player.disable = true
			inventory.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return
		clear_popups()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.disable = false
		return

	# OPTIONS
	if event.is_action_pressed("options"):
		if inventory_state:
			inventory.visible = false
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
	show_fishing.visible = false
	if fish_state:
		show_fishing.visible = true

func free_mouse() -> void:
	player.disable = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func clear_popups() -> void:
	inventory.visible = false
	options.popup_close()
