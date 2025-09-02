extends Control

@export var options: PopupUI
@export var credits: PopupUI

@export_category("Buttons")
@export var btn_new: Button
@export var btn_continue: Button
@export var btn_options: Button
@export var btn_credits: Button
@export var btn_exit: Button
@export var btn_gal: Button

@export var night_b: Button
@export var day_b: Button

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	btn_new.pressed.connect(btn_new_pressed)
	btn_continue.pressed.connect(btn_continue_pressed)
	btn_options.pressed.connect(btn_opt_pressed)
	btn_credits.pressed.connect(btn_credits_pressed)
	btn_exit.pressed.connect(btn_exit_pressed)
	btn_gal.pressed.connect(func x(): SceneManager.switch(SceneManager.GameScene.gallery))

	# Hide the continue button for games that have no new runtime
	btn_continue.visible = false
	if not Storage.runtime_is_new and Storage.sf.playerd.opened_game_once:
		btn_continue.visible = true
	
	night_b.pressed.connect(to_night)
	day_b.pressed.connect(to_day)

	await get_tree().create_timer(0.4).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fish_exit"):
		clear_popups()

func to_day():
	SceneManager.switch(SceneManager.GameScene.freeroam_day)

func to_night():
	SceneManager.switch(SceneManager.GameScene.freeroam_night)

func btn_new_pressed():
	Storage.reset_save()
	btn_continue_pressed()

func btn_continue_pressed():
	SceneManager.switch(SceneManager.freeroam_context())

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
