extends FSMState

func enter() -> void:
	SceneManager.switch(SceneManager.GameScene.failed_fish)
