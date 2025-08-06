extends Panel
class_name InventoryItem

@export var item_tex: Texture
@export var tex_display: Sprite2D
@export var hover_display: PanelContainer
@export var hover_label: Label

signal item_selected

var hover_state: bool = false
var hover_text: String = "Placeholder text"

func _ready() -> void:
	tex_display.texture = item_tex
	
	self.mouse_entered.connect(set_hover.bind(true))
	self.mouse_exited.connect(set_hover.bind(false))
	set_hover(hover_state)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		item_selected.emit()

func apply_item():
	tex_display.texture = item_tex

func set_hover(state: bool):
	hover_label.text = hover_text
	hover_state = state
	hover_display.visible = hover_state
