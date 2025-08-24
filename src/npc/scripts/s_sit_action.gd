extends FSMState

var fsm: NPCFSM 

func enter() -> void:
	print("STATE ENTER SIT ACTION")
	fsm = get_parent() as NPCFSM;

	fsm.animations.play("Fishman_Action_Sitting")

func exit() -> void:
	fsm.animations.stop()
