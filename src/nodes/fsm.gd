class_name FSM extends Node
## Finite State Machine Node. Attach [FSMState]'s to it with a dictionary to add new states.
##
## This node only provides a library without any behaviors. In order to trigger different 
## behaviors, you must call [callable FSM.change_state] from your own script process.
## [br][br]
## Constraints: [br]
## - stateid's must be unique

@export var initial_state: FSMState

var current_state: FSMState
var states: Dictionary[String, FSMState] = {}

func _ready() -> void:
	for child in get_children(): if child is FSMState:
		child.state_machine = self
		states[child.state_id] = child
	
	if initial_state:
		# Wait until frame has been processed to ensure enter() is 
		# available
		await get_tree().process_frame
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state: current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state: current_state.physics_update(delta)

func change_state(state_id: String) -> void:
	var new_state: FSMState = states.get(state_id)

	if !new_state: return
	if current_state: current_state.exit()
	
	new_state.enter()
	current_state = new_state
