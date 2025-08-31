extends Control


@export var animations: AnimationPlayer

func _ready() -> void:
	animations.play(&"fade_in")
	await animations.animation_finished
	SceneManager.switch(SceneManager.GameScene.main_menu)
