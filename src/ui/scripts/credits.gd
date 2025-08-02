extends PopupUI

func _ready() -> void:
	self.visible = false

func popup_open(): 
	self.visible = true

func popup_close(): 
	self.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.visible = false
