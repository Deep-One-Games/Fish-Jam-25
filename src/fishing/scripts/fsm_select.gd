extends FSMState

@export_category("Setup")
@export var use_savefile := true
@export var inventory: Array

@export_category("Internal Dependencies")
@export var FSM_Owner: FSM
@export var controller: FPController
@export var select_control: Control
@export var item: MeshInstance3D
@export var item_title: Label
@export var item_desc: Label

@export_category("Rod Lists")
@export var rod_list_target: Control
@export var item_ui: PackedScene 

@export_category("Buttons")
@export var inventory_btn: Button
@export var accept_btn: Button

@export_category("Animations")
@export var animation_player: AnimationPlayer

signal rod_selected(rod: RodItem, ui_rod: FishingRodItemUI)
signal rod_confirmed(rod: RodItem)

var prev_selected_rod: FishingRodItemUI
var popup_state := true

func _ready() -> void:
	# Load Inventory
	if use_savefile:
		inventory = Storage.sf.inventory.\
				filter(func x(i: GameItem): return i is RodItem)
	
	# Apply inventory to tree
	for r in inventory:
		var el = item_ui.instantiate() as FishingRodItemUI
		el.select_item.text = r.name
		rod_list_target.add_child(el)
		el.select_item.pressed.connect(select_rod.bind(r, el))
	
	inventory_btn.pressed.connect(inv_pressed)
	accept_btn.pressed.connect(accept_pressed)

	# Initialize states
	update_popup(popup_state)

# FSM States *#*#*#
func enter() -> void:
	controller.disable_mouse = true
	inventory_btn.disabled = false

func exit() -> void:
	controller.disable_mouse = false
	inventory_btn.disabled = true
# *#*#*#*#

func inv_pressed():
	popup_state = !popup_state
	update_popup(popup_state)

func accept_pressed():
	rod_confirmed.emit(rod_selected)
	inv_pressed() # Simulate press the inventory btn
	FSM_Owner.change_state("FISHING")

func update_popup(to_open: bool):
	if to_open:
		animation_player.play(&"dropdown_rods")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	animation_player.play(&"dropup_rods")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func update_rod_ui(rod: RodItem, rod_ui: FishingRodItemUI):
	item.mesh = rod.mesh
	item_title.text = rod.name
	item_desc.text = rod.desc

func select_rod(rod: RodItem, rod_ui: FishingRodItemUI):
	# Enable old rod and disable new rod
	if prev_selected_rod:
		prev_selected_rod.select_item.disabled = false

	rod_selected.emit(rod, rod_ui)
	update_rod_ui(rod, rod_ui)
	prev_selected_rod = rod_ui

	prev_selected_rod.select_item.disabled = true
