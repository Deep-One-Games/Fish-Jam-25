extends Node

enum GameScene {
	main_menu,
	freeroam,
	racing,
	fishing
}

var SceneInstances := {
	GameScene.main_menu: preload("res://src/ui/menu.tscn"),
	GameScene.freeroam: preload("res://src/scenes/freeroam_1.tscn"),
	GameScene.racing: preload("res://src/scenes/racing.tscn"),
	GameScene.fishing: preload("res://src/scenes/fishing.tscn"),
}

# Declare such that this variable matches the play buttons load behavior
var active_scene: GameScene = GameScene.main_menu

func switch(to_scene: GameScene):
	var sc = SceneInstances[to_scene]
	get_tree().change_scene_to_packed(sc)
	active_scene = to_scene
