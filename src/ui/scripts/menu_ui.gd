extends Control

@export var options: PopupUI
@export var credits: PopupUI

@export_category("Buttons")
@export var btn_new: Button
@export var btn_continue: Button
@export var btn_options: Button
@export var btn_credits: Button
@export var btn_exit: Button

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	btn_new.pressed.connect(btn_new_pressed)
	btn_continue.pressed.connect(btn_continue_pressed)
	btn_options.pressed.connect(btn_opt_pressed)
	btn_credits.pressed.connect(btn_credits_pressed)
	btn_exit.pressed.connect(btn_exit_pressed)

	# Hide the continue button for games that have no new runtime
	btn_continue.visible = false
	if not Storage.runtime_is_new and Storage.sf.playerd.opened_game_once:
		btn_continue.visible = true

func btn_new_pressed():
	Storage.reset_save()
	SceneManager.switch(SceneManager.GameScene.freeroam)

func btn_continue_pressed():
	SceneManager.switch(SceneManager.GameScene.freeroam)

func btn_opt_pressed():
	clear_popups()
	options.popup_open()

func btn_credits_pressed():
	clear_popups()
	credits.popup_open()
	
func btn_exit_pressed(): get_tree().quit()

func clear_popups():
	options.popup_close()
	credits.popup_close()
