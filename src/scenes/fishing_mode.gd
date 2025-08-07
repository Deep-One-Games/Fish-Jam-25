extends Control
signal exit_fishing

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		emit_signal("exit_fishing")
