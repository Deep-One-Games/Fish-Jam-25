extends Node
## An autoload singleton that loads minigames and other major loading events

## Define scenes here
enum GameScene {
	main_menu,
	freeroam,
	racing,
	fishing
}

## Define paths to scenes from [member SceneManager.GameScene] enum
var SceneInstances := {
	GameScene.main_menu: preload("res://src/ui/menu.tscn"),
	GameScene.freeroam: preload("res://src/scenes/freeroam.tscn"),
	GameScene.racing: preload("res://src/scenes/racing.tscn"),
	GameScene.fishing: preload("res://src/scenes/fishing.tscn"),
}

## Declare such that this variable matches the play buttons load behavior in 
## the engine settings
var active_scene: GameScene = GameScene.main_menu

## Scene Switcher. Running this function will also initiate saving procedure so
## the save file is constant updated when moving between areas
func switch(to_scene: GameScene):
	var sc = SceneInstances[to_scene]
	get_tree().change_scene_to_packed(sc)
	active_scene = to_scene
