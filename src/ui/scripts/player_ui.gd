extends Control

@export var options: OptionsControl
@export var inventory: Control
@export var player: FPController

var options_state := false
var inventory_state := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	options.on_options_close.connect(free_mouse)

func _input(event: InputEvent) -> void:
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
		inventory.visible = false
	
	if event.is_action_pressed("options"):
		if inventory_state: inventory.visible = false
		options_state = !options_state
		if options_state:
			options.popup_open()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.disable = true
			return
		
		clear_popups()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.disable = false

func free_mouse():
	player.disable = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func clear_popups() -> void:
	inventory.visible = false
	options.popup_close()
