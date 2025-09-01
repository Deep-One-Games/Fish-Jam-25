class_name FSMFishingSelect extends FSMState

enum Types { Rods, Fish, Roam }
enum GameType { Fishing, Racing, Roam }

@export_category("Setup")
@export var use_savefile := true
var inventory: Array
@export var item_type: Types = Types.Rods
@export var game_type: GameType = GameType.Fishing

@export_category("Internal Dependencies")
@export var FSM_Owner: FSM
@export var controller: FPController
@export var select_control: Control
@export var item: MeshInstance3D
@export var item_title: Label
@export var item_desc: Label
@export var leave_btn: Button
@export var item_view: Control
@export var viewport_texture: TextureRect
@export var help_txt: Label

@export_category("Rod Lists")
@export var rod_list_target: Control
@export var item_ui: PackedScene 

@export_category("Buttons")
@export var inventory_btn: Button
@export var accept_btn: Button

@export_category("Animations")
@export var animation_player: AnimationPlayer

signal rod_selected(rod: GameItem, ui_rod: FishingRodItemUI)
signal rod_confirmed(rod: GameItem)

var prev_selected_rod: FishingRodItemUI

@export var page_0_y: float
@export var page_1_y: float
@export var scrollbox: ScrollContainer

var rod_lore: String = ""
var rod_desc: String = ""
var stats: String = ""
var rod_name: String = ""
@export var popup_state := true

var page_i: int = 0

func _ready() -> void:
	item_view.visible = false
	match item_type:
		Types.Rods:
			inventory = Storage.sf.inventory.\
				filter(func x(i: GameItem): return i is RodItem)
			item.scale = Vector3(1,1,1)
			item.position.y = 0
		Types.Fish:
			inventory = Storage.sf.inventory.\
				filter(func x(i: GameItem): return i is FishData)
			item.scale = Vector3(2.48, 2.48, 2.48)
			item.position.y = 1.655
		Types.Roam:
			accept_btn.visible = false 
			inventory = Storage.sf.inventory
			help_txt.text = "L to return"

	# Apply inventory to tree
	for r in inventory:
		var el = item_ui.instantiate() as FishingRodItemUI
		el.select_item.text = r.name
		rod_list_target.add_child(el)
		el.select_item.pressed.connect(select_rod.bind(r, el))
	
	inventory_btn.pressed.connect(inv_pressed)
	accept_btn.pressed.connect(accept_pressed)
	accept_btn.disabled = true

	# Initialize states
	select_control.visible = false
	update_popup(popup_state)
	await animation_player.animation_finished
	select_control.visible = true

# FSM States *#*#*#
func enter() -> void:
	match game_type:
		GameType.Fishing:
			controller.disable_mouse = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			inventory_btn.disabled = false

func exit() -> void:
	match game_type:
		GameType.Fishing:
			controller.disable_mouse = false
			inventory_btn.disabled = true
# *#*#*#*#

func inv_pressed():
	popup_state = !popup_state
	update_popup(popup_state)

func accept_pressed():
	rod_confirmed.emit(rod_selected)
	inv_pressed() # Simulate press the inventory btn
	FSM_Owner.change_state("PLAY")

func update_popup(to_open: bool):
	popup_state = to_open
	if to_open:
		animation_player.play(&"dropdown_rods")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		leave_btn.disabled = true
		return
	animation_player.play(&"dropup_rods")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	leave_btn.disabled = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("page_left"):
		page_i -= 1

	if event.is_action_pressed("page_right"):
		page_i += 1
	page_i = clamp(page_i, 0, 1)

	match page_i:
		0: # Show details page
			scrollbox.custom_minimum_size.y = page_0_y
			viewport_texture.visible = true
			item_title.visible = true
			item_title.text = rod_name 
			var txt = rod_desc + "\n\n"
			if game_type == GameType.Racing:
				txt += stats
			item_desc.text = txt 
		1: # Show lore page
			scrollbox.custom_minimum_size.y = page_1_y 
			viewport_texture.visible = false
			item_title.visible = false
			item_desc.text = rod_lore


func update_rod_ui(rod: GameItem, rod_ui: FishingRodItemUI):
	item.mesh = rod.mesh
	item_title.text = rod.name
	item_desc.text = rod.desc
	
	if rod is RodItem:
		item.scale = Vector3(1,1,1)
		item.position.y = 0
	if rod is FishData:
		item.scale = Vector3(2.48, 2.48, 2.48)
		item.position.y = 1.655

func select_rod(rod: GameItem, rod_ui: FishingRodItemUI):
	# Enable old rod and disable new rod
	if prev_selected_rod:
		prev_selected_rod.select_item.disabled = false
	item_view.visible = true

	rod_selected.emit(rod, rod_ui)
	update_rod_ui(rod, rod_ui)
	prev_selected_rod = rod_ui
	rod_lore = rod.lore
	rod_desc = rod.desc
	rod_name = rod.name
	if rod is FishData:
		stats = rod.stats_str()

	if rod is RodItem and game_type == GameType.Fishing:
		get_parent().rod = rod

	prev_selected_rod.select_item.disabled = true
	accept_btn.disabled = false
