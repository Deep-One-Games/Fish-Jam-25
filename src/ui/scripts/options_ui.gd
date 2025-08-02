extends PopupUI

@export var audioDriver: AudioBusLayout

@export_category("Control Buttons")
@export var close: Button
@export var exit: Button

@export_group("Audio Sliders")
@export var master: HSlider
@export var music: HSlider
@export var sfx: HSlider

@export_group("View Options")
@export var toggle_fs: CheckBox
@export var options_mouse_mode: Input.MouseMode
var prev_mouse_mode: Input.MouseMode

func _ready() -> void:
	self.visible = false
	master.value_changed.connect(change_volume.bind("Master"))
	music.value_changed.connect(change_volume.bind("Music"))
	sfx.value_changed.connect(change_volume.bind("SFX"))
	
	toggle_fs.toggled.connect(fs_toggle)
	
	close.pressed.connect(popup_close)
	exit.pressed.connect(exit_game)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): popup_close()

func popup_open():
	prev_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(options_mouse_mode)
	self.visible = true

func change_volume(value: float, type: String) -> void:
	match type:
		"Master": 
			AudioServer.set_bus_volume_db(0, linear_to_db(value))
		"SFX": 
			AudioServer.set_bus_volume_db(1, linear_to_db(value))
		"Music": 
			AudioServer.set_bus_volume_db(2, linear_to_db(value))

func fs_toggle(toggled_state: bool):
	if toggled_state == true:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN)
		return
	
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1280, 720))

func exit_game():
	get_tree().quit()

func popup_close():
	Input.set_mouse_mode(prev_mouse_mode)
	self.visible = false
