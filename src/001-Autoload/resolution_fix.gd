extends Node

func _ready():
	get_viewport().size_changed.connect(_on_screen_resized)

func _on_screen_resized():
	print("Resizing")
	var sz = DisplayServer.window_get_size()

	ProjectSettings.set_setting("display/window/size/width", sz.x)
	ProjectSettings.set_setting("display/window/size/height", sz.y)
