extends FSMState

func enter() -> void:
	SceneManager.switch(SceneManager.GameScene.caught_fish)
