extends FSMState

@export var jack: JackNPC

@export var audio: AudioStreamPlayer3D

func enter() -> void:
	jack.path.curve = jack.c_home_to_lake
	Storage.save_process()
	jack.disable_walk_after_look = true
	jack.animations.play(&"SalesMan_Idle")
	jack.linear_follow.following_path = false
	jack.linear_follow.progress = 0
	var tfsm: TutorialFSM = get_parent()
	tfsm.player_sensor.dialogue = jack.profile.npc_dialogue
	tfsm.player_sensor.title = "JACK_start"
	tfsm.player_sensor.npc = jack.profile
	audio.play()

func exit() -> void:
	audio.stop()

