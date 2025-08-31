extends FSMState

@export var jack: JackNPC

func enter() -> void:
	Storage.save_process()
	jack.disable_walk_after_look = false 
	jack.animations.play(&"SalesMan_Walk")
	# follow path but do not loop. Start from 0
	jack.linear_follow.following_path = true 
	jack.path.curve = jack.c_town_to_home
	jack.linear_follow.loop = false
	jack.linear_follow.progress = 0
	jack.linear_follow.path_completed.connect(transition)

	var tfsm: TutorialFSM = get_parent()
	tfsm.player_sensor.dialogue = jack.profile.npc_dialogue
	tfsm.player_sensor.title = "JACK_patrol_back_home"
	tfsm.player_sensor.npc = jack.profile

func transition() -> void:
	var tfsm: TutorialFSM = get_parent()
	
	tfsm.change_state("Greet")
	jack.linear_follow.path_completed.disconnect(transition)
	Storage.sf.jack_state = "Greet"
	Storage.sf.story_complete = true
	Storage.sf.day_story_completed = Storage.sf.days
	Storage.save_process()
