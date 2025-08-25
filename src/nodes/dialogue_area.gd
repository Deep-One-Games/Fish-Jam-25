class_name DialogueArea extends Area3D

@export var dialogue: DialogueResource
@export var title: String

const dialogue_box = preload("res://src/ui/dialogue.tscn")

func start_interaction() -> void:
	var b: Node = dialogue_box.instantiate()
	get_tree().current_scene.add_child(b)
	b.start(dialogue, title)

	return
	DialogueManager.show_dialogue_balloon(dialogue, title)
