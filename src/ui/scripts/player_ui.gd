extends Control

@export var options: OptionsControl
@export var inventory: Control
@export var show_interact: Control
@export var show_fish: Control
@export var player: FPController

var options_state := false
var inventory_state := false
var interact_state := false
var fishing_state := false
var fishing_area: Area3D
var interacting_with: InteractableArea

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	options.on_options_close.connect(free_mouse)
	DialogueManager.dialogue_ended.connect(func x(y): free_mouse())
	
	player.interact_box.area_entered.connect(_on_area_entered)
	player.interact_box.area_exited.connect(_on_area_exited)

func set_interact(area: Area3D, visible: bool):
	show_interact.visible = visible
	interact_state = true
	interacting_with = area

func _on_area_entered(area: Area3D) -> void:
	if area is InteractableArea:
		set_interact(area, true)
		return
		
	if area.is_in_group("fishing_area"):
		fishing_state = true
		fishing_area = area
		show_fish.visible = true
		
func _on_area_exited(area: Area3D) -> void:
	if area is InteractableArea:
		set_interact(area, false)
		return
		
	if area.is_in_group("fishing_area"):
		fishing_state = false
		fishing_area = null
		show_fish.visible = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_state:
		interacting_with.start_interaction()
		player.disable = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("fish") and fishing_state:
		print("fishing")
		SceneManager.switch(SceneManager.GameScene.fishing)
		
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
	
