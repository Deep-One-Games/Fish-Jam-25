extends Control
signal exit_fishing

func _ready() -> void:
	# Ensure this Control grabs input focus
	focus_mode = FocusMode.FOCUS_ALL
	grab_focus()
	# Make sure unhandled input is processed
	set_process_unhandled_input(true)

func _input(event: InputEvent) -> void:
	# Listen for your new action
	if event.is_action_pressed("exit_fish"):
		emit_signal("exit_fishing")
