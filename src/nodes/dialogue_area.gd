class_name DialogueArea extends Area3D

@export var dialogue: DialogueResource
@export var title: String
@export var npc: SaveNPC

const dialogue_box = preload("res://src/ui/dialogue.tscn")

@export var titles: Array[String]
@export var title_key: String = ""

func _start_interaction(_title: String) -> void:
	var b: DialogBox = dialogue_box.instantiate()
	b.npc = npc
	get_tree().current_scene.add_child(b)
	b.start(dialogue, _title)

func start_interaction() -> void:
	if title_key: 
		cycle(Storage.sf.get_npc_itr(title_key) % len(titles))
		await DialogueManager.dialogue_ended
		Storage.sf.incr_npc_itr(title_key)
		return
	# play settings title
	_start_interaction(title)

func cycle(i: int) -> void:
	# play title by index
	assert(i < len(titles))
	_start_interaction(titles[i])
