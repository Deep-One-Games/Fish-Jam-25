extends Node
## An autoload singleton that loads minigames and other major loading events

## Define scenes here
enum GameScene {
	main_menu,
	freeroam,
	racing,
	fishing
}

## Define animation colors here
var TRANSPARENT = Color(1,1,1,0)
var OPAQUE      = Color(1,1,1,1)
var TRANS_TYPE  = Tween.TRANS_SINE


## Define paths to scenes from [member SceneManager.GameScene] enum
var SceneInstances := {
	GameScene.main_menu: preload("res://src/ui/menu.tscn"),
	GameScene.freeroam: preload("res://src/scenes/freeroam_day.tscn"),
	GameScene.racing: preload("res://src/scenes/racing.tscn"),
	GameScene.fishing: preload("res://src/scenes/fishing.tscn"),
}

## Declare such that this variable matches the play buttons load behavior in 
## the engine settings
var active_scene: GameScene = GameScene.main_menu

func create_transition_element() -> TextureRect:
	var rect := TextureRect.new()
	var grad2d := GradientTexture2D.new()
	var grad := Gradient.new()

	# grad.add_point(0, Color.BLACK)
	grad.offsets = PackedFloat32Array([0.0])
	grad.colors = PackedColorArray([Color.BLACK])
	grad2d.gradient = grad
	
	# Assumed to be added to root, so this will cover entire screen
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.texture = grad2d
	rect.modulate = TRANSPARENT
	rect.z_index = 4096 # max z index

	return rect

## Scene Switcher. Running this function will also initiate saving procedure so
## the save file is constant updated when moving between areas
func switch(to_scene: GameScene):
	var sc = SceneInstances[to_scene]

	var el = create_transition_element()
	get_tree().root.add_child(el)

	var tw = get_tree().create_tween()
	tw.tween_property(el, "modulate", OPAQUE, 0.3).set_trans(Tween.TRANS_SINE)
	await tw.finished

	get_tree().change_scene_to_packed(sc)
	
	tw = get_tree().create_tween() # We do this because new tree!!
	tw.tween_property(el, "modulate", TRANSPARENT, 0.3).set_trans(Tween.TRANS_SINE)
	await tw.finished

	el.queue_free()
	active_scene = to_scene
