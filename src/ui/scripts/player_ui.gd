extends Control

@export var options: PopupUI

var state := false

func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_cancel"):
			state = !state
			if state:
				options.popup_open()
				return
			options.popup_close()
