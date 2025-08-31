extends FSMState

@export var jack: JackNPC

func enter() -> void:
	Storage.save_process()
	jack.disable_walk_after_look = true
	jack.animations.play(&"SalesMan_Idle")
	# follow path but do not loop. Start from 0
	jack.path.curve = jack.c_home_to_lake
	jack.linear_follow.following_path = false 
	jack.linear_follow.loop = false
	jack.linear_follow.progress_ratio = 1

	var tfsm: TutorialFSM = get_parent()
	tfsm.player_sensor.dialogue = jack.profile.npc_dialogue
	tfsm.player_sensor.title = "JACK_tutorial_intro"
	tfsm.player_sensor.npc = jack.profile
