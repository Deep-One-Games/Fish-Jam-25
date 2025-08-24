class_name DialogueArea extends Area3D

@export var dialogue: DialogueResource
@export var title: String

func start_interaction() -> void:
	DialogueManager.show_dialogue_balloon(dialogue, title)
