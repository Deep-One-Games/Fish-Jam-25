class_name AudioEnvironment extends Node3D
## Create an audio environment for a scene. Manages and maintains a set of
## [AudioStreamPlayer]'s for you.
##
## The behavior of this node goes as follows: If 
## [member AudioEnvironment.area_ref_counter] goes to 0. Then all audio tracks
## will start to fade out to silence. If 
## [member AudioEnvironment.area_ref_counter] changes, then all 
## audio tracks are tweened to the first sample'd point t + 
## [member AudioEnvironment.transition_time] before continuing another resample.
## [br][br]
## Why do we do this? Effectively pausing future sampling efforts? This is 
## because we want to create an entry point to the looping curves new nature 
## from its current nature. We do this for every change in 
## [member AudioEnvironment.area_ref_counter], since new areas change the audio
## pattern by summation. Therefore to make the transition pleasant we must 
## interpolate between both curves.

@export var tracks: AudioAtlas   ## Audio Reference
@export var environment_players: Array[AudioEnvironmentPlayer]
@export var default_decay := 0.1 ## The DB lost per sample rate when ref=0
@export var transition_time := 1.0 ## Length in seconds when ref updates audio
@export var sample_rate := 2.0   ## 1 sample every X seconds. 2.0 is once every 2 seconds
@export var db_origin := 0.0     ## The loudness origin for curve summing

@export var player: FPController

var live_players: Array[AudioStreamPlayer]
var activated_curves: Array[AudioEnvironmentPlayer]
var area_ref_counter: int = 0

var time_dt := 0.0
var clock_s := 0.0

var audio_triggered := false
var transitioning := false

func _ready() -> void:
	for stream in tracks.audiostreams:
		var player = AudioStreamPlayer.new()
		player.stream = stream
		player.bus = &"SFX"
		live_players.append(player)
		add_child(player)

	for player in environment_players:
		player.activate_player.connect(adjust_area_ref.bind(1))
		player.deactivate_player.connect(adjust_area_ref.bind(-1))

func init_audio() -> void:
	if audio_triggered: return
	for player in live_players:
		player.play()
	audio_triggered = true

func fml(x: Array, y: Array) -> Array:
	## fuck gdscript!!
	var r = []
	for i in range(min(len(x), len(y))):
		r.append(x[i] + y[i])
	return r

func sum_active(t: float):
	## fuck gdscript!!
	var acc := []
	for lp in live_players: acc.append(db_origin)
	
	return activated_curves.reduce(
		func f(a, x: AudioEnvironmentPlayer):
			return fml(a, x.get_pos_y(t)), acc)

func transition_curves(t: float):
	transitioning = true
	var trans_tw = create_tween()

	var sum_v = sum_active(t + transition_time)
	for lp_i in range(len(live_players)):
		var lp = live_players[lp_i]
		trans_tw.tween_property(lp, "volume_db", sum_v[lp_i], transition_time)
	await trans_tw.finished

	transitioning = false


func adjust_area_ref(_obj_entered: Node, env_player: AudioEnvironmentPlayer, value: int):
	# When value = 1, we env_player activates
	# When value = -1, env_player deactivated
	area_ref_counter += value
	if value == 1:
		activated_curves.append(env_player)

	if value == -1:
		activated_curves.erase(env_player)

	# Transitions to zero just fade out audio. Check _process
	if area_ref_counter != 0: transition_curves(clock_s)
	init_audio()

func adjust_db_add(idx: int, value: float):
	live_players[idx].volume_db =\
		clamp(live_players[idx].volume_db + value, -70.0, 70.0)

func db_set(idx: int, value: float):
	live_players[idx].volume_db = db_origin + value

func _process(delta: float) -> void:
	clock_s += delta
	
	#Guard against leaving/entering live environment areas
	if transitioning: return

	# Guard against changing volume when other areas are controlling. If 
	# not areas controlling, fade audio out
	if area_ref_counter == 0:
		time_dt += delta
		if time_dt <= sample_rate: return
		time_dt = 0.0 # Reset to stay in pace with sample_rate
		for idx in range(len(live_players)):
			adjust_db_add(idx, -default_decay)
		return

	# If there ARE areas, we compute the volume set and apply
	var sum_v = sum_active(clock_s)
	for idx in range(len(live_players)):
		db_set(idx, sum_v[idx])
