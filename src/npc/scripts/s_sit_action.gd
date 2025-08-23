extends FSMState

var fsm: NPCFSM 

func enter() -> void:
	("STATE ENTER IDLE")
	fsm = get_parent() as NPCFSM;

	fsm.animations.stop()
	fsm.animations.play("Fishman_Action_Sitting")

func exit() -> void:
	fsm.animations.stop()
