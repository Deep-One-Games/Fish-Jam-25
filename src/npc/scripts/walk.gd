extends FSMState

@export var animation_player: AnimationPlayer

func enter() -> void:
	print("STATE ENTER WALK")
	animation_player.stop()
	animation_player.play("Fishmen_walk")

func exit() -> void:
	animation_player.stop()
