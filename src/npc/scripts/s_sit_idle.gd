extends FSMState

var fsm: NPCFSM 

func enter() -> void:
	print("STATE ENTER SIT IDLE")
	fsm = get_parent() as NPCFSM;

	fsm.animations.play("Fishman_Sitting")

func exit() -> void:
	fsm.animations.stop()
