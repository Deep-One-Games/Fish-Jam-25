extends FSMState

@export var bobber: Node3D
@export var origin: Node3D
@export var power_grad: PowerGradientUI

@export var fish_fsm: FSMFishState 

@export var help: Label
@export var animations: AnimationPlayer
@export var audio: AudioStreamPlayer

@export var fish_resistance_score_ps := 7
@export var player_resistance_score_ps := 5

var pos: float = 50.0

func enter() -> void:
	power_grad.visible = true
	power_grad.disable_animation = true
	help.text = "Tap Z!"
	animations.play(&"Rod_Reel")
	audio.play()

func exit() -> void:
	power_grad.visible = false
	power_grad.disable_animation = false 

func update(_delta: float) -> void:
	pos -= fish_resistance_score_ps * _delta
	if Input.is_action_just_pressed("reel"):
		pos += player_resistance_score_ps 
	power_grad.set_powerf(float(pos) / 100.0)

	if pos < 0: state_machine.change_state("lost")
	if pos > 100: state_machine.change_state("won")
