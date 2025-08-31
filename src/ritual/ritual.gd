class_name RitualUI extends Control

@export var balloon: DialogBox

func _ready() -> void:
	balloon.start(balloon.npc.npc_dialogue, "ritual")
	await DialogueManager.dialogue_ended
	SceneManager.switch(SceneManager.freeroam_context())
