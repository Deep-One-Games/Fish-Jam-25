class_name OptionsControl extends PopupUI

signal on_options_close

@export var audioDriver: AudioBusLayout

@export_category("Control Buttons")
@export var save_menu: Button
@export var save_exit: Button

@export_group("Audio Sliders")
@export var master: HSlider
@export var music: HSlider
@export var sfx: HSlider

@export_group("View Options")
@export var toggle_fs: CheckBox

func _ready() -> void:
	self.visible = false
	master.value_changed.connect(change_volume.bind("Master"))
	music.value_changed.connect(change_volume.bind("Music"))
	sfx.value_changed.connect(change_volume.bind("SFX"))
	
	toggle_fs.toggled.connect(fs_toggle)
	
	save_menu.pressed.connect(exit_menu.bind(true))
	save_exit.pressed.connect(exit_game)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("options"): popup_close()

func popup_open():
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
	Storage.sf.playerd.opened_game_once = true
	
	Storage.save_process()
	get_tree().quit()

func exit_menu(save_too: bool):
	Storage.sf.playerd.opened_game_once = true
	if save_too: Storage.save_process()
	popup_close()
	SceneManager.switch(SceneManager.GameScene.main_menu)

func popup_close():
	on_options_close.emit()
	self.visible = false
