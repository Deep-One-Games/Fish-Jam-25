extends FSMState

@export var race_track: RaceTrack3D

@export var select: FSMFishingSelect 

func enter() -> void:
	Storage.sf.pass_time()
	for lf in race_track.live_fish:
		if lf.follow_track.loops == 3:
			# it wouldnt make sense for the game designer
			# to lower the mean to less than 50 hence it is
			# a way to identify the player
			if lf.fishinfo.sample_mean > 50:
				dialog("JACK_won_race")
				Storage.sf.winning_fish_idx = select.id_location
				Storage.save_process()
				return
			dialog("JACK_lost_race")

func dialog(title: String)-> void:
	var b: DialogBox = race_track.dialogue_box.instantiate()
	b.npc = race_track.announcer 
	get_tree().current_scene.add_child(b)
	b.start(race_track.announcer.npc_dialogue, title) 

	await DialogueManager.dialogue_ended
	SceneManager.switch(SceneManager.freeroam_context())
