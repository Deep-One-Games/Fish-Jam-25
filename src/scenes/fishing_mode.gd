extends Node3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_exit_fishing()

func _exit_fishing() -> void:
	SceneManager.switch(SceneManager.GameScene.freeroam)
