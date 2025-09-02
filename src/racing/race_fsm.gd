extends FSM

@export var options_ui: Control

@export_category("Dependencies")
@export var fsm_select: FSMFishingSelect 

@export var race_track: RaceTrack3D

var options_state := false
func _ready() -> void:
	super()
	if race_track.passive:
		change_state("PASSIVE")

func leave_minigame():
	SceneManager.switch(SceneManager.freeroam_context())

func allow_options() -> bool:
	return not fsm_select.popup_state

func capture():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if race_track.passive: return
	if event.is_action_pressed("options") and allow_options():
		options_state = not options_state
		options_ui.visible = options_state
		if options_state: release()
		else: capture()
	
