class_name DialogueArea extends Area3D

@export var dialogue: DialogueResource
@export var title: String
@export var npc: SaveNPC

const dialogue_box = preload("res://src/ui/dialogue.tscn")

func start_interaction() -> void:
	var b: DialogBox = dialogue_box.instantiate()
	b.npc = npc
	get_tree().current_scene.add_child(b)
	b.start(dialogue, title)
