class_name NPCPatrol extends Node3D

@export var sequence: Array[Node]
@export var npc: NPCController
@export var npc_info: SaveNPC

var path: LinearFollow
func _ready() -> void:
	npc.player_sensor.dialogue = npc_info.npc_dialogue

	#npc.on_looking.connect(on_looking)

	for s in sequence: 
		assert(s is LinearFollow or s is Timer, 
				"LinearFollow and Timer types allowed only!!")
	
	while true:
		for s in sequence:
			if s is LinearFollow:
				path = s
				npc.fsm.change_state("WALK")
				npc.player_sensor.title = "WALK"
				
				# Move NPC to new path follow curve
				npc.get_parent().remove_child(npc)
				s.add_child(npc)
				
				s.follow_path() # Initiate path follow
				await s.path_completed # Wait for entity to reach end
				
			if s is Timer:
				npc.fsm.change_state("IDLE")
				npc.player_sensor.title = "IDLE"
				
				s.start()
				await s.timeout # Wait for timeout

#func on_looking(look_state: bool):
		#path.following_path = !look_state
		#if look_state:
			#npc.fsm.change_state("IDLE")
			#return
		#npc.fsm.change_state("WALK")
