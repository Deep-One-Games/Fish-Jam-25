extends FSMState

@export var jack: JackNPC

func enter() -> void:
	Storage.save_process()
	jack.disable_walk_after_look = false 
	jack.animations.play(&"SalesMan_Walk")
	# follow path but do not loop. Start from 0
	jack.linear_follow.following_path = true 
	jack.path.curve = jack.c_lake_to_town
	jack.linear_follow.loop = false
	jack.linear_follow.progress = 0
	jack.linear_follow.path_completed.connect(transition)

	var tfsm: TutorialFSM = get_parent()
	tfsm.player_sensor.dialogue = jack.profile.npc_dialogue
	tfsm.player_sensor.title = "JACK_patrol_town"
	tfsm.player_sensor.npc = jack.profile

func transition() -> void:
	var tfsm: TutorialFSM = get_parent()
	
	tfsm.change_state("Town")
	jack.linear_follow.path_completed.disconnect(transition)
	Storage.sf.jack_state = "Town"
	Storage.save_process()
