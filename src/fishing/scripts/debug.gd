extends Control

@export var fsm: FSM

@export_category("Controls")
@export var state: Label

func _process(delta: float) -> void:
	state.text = fsm.current_state.state_id
