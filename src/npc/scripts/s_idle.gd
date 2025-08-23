extends FSMState

var fsm: NPCFSM 

## alt_action_p percent of the time, we show the alt
## action.
@export var alt_action_p := 0.3
var default_a            := "Fishmen_Idle"
var alt_a                := "Fishmen_Idle_Ver2"

func enter() -> void:
	fsm = get_parent() as NPCFSM;

	fsm.animations.stop()
	fsm.animations.play(default_a)

	fsm.animations.animation_finished.connect(on_animation_finish)

func on_animation_finish():
	var r = randf()
	if r <= alt_action_p:
		fsm.animations.play(alt_a)
		return
	fsm.animations.play(default_a)

func exit() -> void:
	fsm.animations.animation_finished.disconnect(on_animation_finish)
	fsm.animations.stop()
