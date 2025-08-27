class_name FishingFSM extends FSM

@export var options_ui: Control
@export var leave: Button

@export_category("Dependencies")
@export var fsm_select: FSMFishingSelect 
@export var fpcontroller: FPController

var options_state := false
func _ready() -> void:
	super()
	leave.pressed.connect(leave_minigame)

func leave_minigame():
	SceneManager.switch(SceneManager.freeroam_context())

func allow_options() -> bool:
	return not fsm_select.popup_state

func capture():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fpcontroller.disable_mouse = false 

func release():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fpcontroller.disable_mouse = true 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("options") and allow_options():
		options_state = not options_state
		options_ui.visible = options_state
		if options_state: release()
		else: capture()
	
