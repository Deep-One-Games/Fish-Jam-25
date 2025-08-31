class_name TutorialFSM extends FSM

@export var player_sensor: DialogueArea 
var ignoring: bool 

func _ready() -> void:
	super()
	change_state(Storage.sf.jack_state)
	Storage.sf.jack_update.connect(change_state)

func change_state(state_id: String) -> void:
	super(state_id)
	Storage.save_process()
