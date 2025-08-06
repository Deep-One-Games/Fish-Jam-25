extends FSMState

@export var animation_player: AnimationPlayer

func enter() -> void:
	print("STATE ENTER IDLE")

	animation_player.stop()
	animation_player.play("Fishmen_Idle")

func exit() -> void:
	animation_player.stop()
