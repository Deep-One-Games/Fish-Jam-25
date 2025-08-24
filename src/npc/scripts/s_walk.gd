extends FSMState

var fsm: NPCFSM 

func enter() -> void:
	fsm = get_parent() as NPCFSM;

	fsm.animations.play("Fishmen_walk")

func exit() -> void:
	fsm.animations.stop()
