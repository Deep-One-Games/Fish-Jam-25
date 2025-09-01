extends Control

@export var balloon: DialogBox
@export var title: String

@export var loot_table: Array[FishData]

func _ready() -> void:
	loot_table.shuffle()

	var drop = loot_table[0].duplicate(true) as FishData
	drop.ai_sample_mean = 75.0
	drop.std = 15.0
	drop.generate()
	Storage.sf.last_winning_fish = drop 
	Storage.sf.fish_caught += 1

	print(drop.name)
	Storage.sf.inventory.append(drop)

	print("Appended:", drop, "inventory size now:", Storage.sf.inventory.size())
	Storage.save_process()

	balloon.start(balloon.npc.npc_dialogue,title)
	await DialogueManager.dialogue_ended
	SceneManager.switch(SceneManager.freeroam_context())
