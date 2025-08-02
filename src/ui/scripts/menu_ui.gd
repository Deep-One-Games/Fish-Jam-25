extends Control

@export var options: PopupUI
@export var credits: PopupUI

@export_category("Buttons")
@export var btn_start: Button
@export var btn_options: Button
@export var btn_credits: Button
@export var btn_exit: Button

func _ready() -> void:
	btn_start.pressed.connect(btn_start_pressed)
	btn_options.pressed.connect(btn_opt_pressed)
	btn_credits.pressed.connect(btn_credits_pressed)
	btn_exit.pressed.connect(btn_exit_pressed)

func btn_start_pressed(): 
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
