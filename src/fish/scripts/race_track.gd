class_name RaceTrack3D extends Node3D

@export var race_data: RacingData

@export_category("Index Mapped Vars")
@export var track_options: Array[Path3D]
@export var camera_options: Array[Camera3D]

@export var starting_mps: float = 3.0 

var selected_track: Path3D
var selected_camera: Camera3D
func _ready() -> void:
	race_data.populate_ai()
	select_racetrack()
	populate_race()

func select_racetrack() -> void:
	assert(len(track_options) == len(camera_options))
	var p = randi() % len(track_options) 
	
	selected_track = track_options[p]
	selected_camera = camera_options[p]

	for i in range(len(track_options)): if i != p:
		track_options[i].queue_free()

func populate_race() -> void:
	var pos_curs := -2.5
	for c in race_data.contestants:
		var fish = c.racefish.instantiate() as RaceFish
		pos_curs += 2.5 # magic number. meters seperation between fish
		fish.position.x = pos_curs

		var track_follow = LinearFollow.new()
		track_follow.mps = starting_mps

		selected_track.add_child(track_follow)
		track_follow.add_child(fish)
		# link dependencies
		fish.follow_track = track_follow
		track_follow.following_path = true

	var fish = race_data.player_fish.racefish.instantiate() as RaceFish
	pos_curs += 2.5
	fish.position.x = pos_curs

	# enable the camera on the selected race track
	selected_camera.current = true

	# players fish exists on the race track with the camera on it. Lets
	# The players fish always be in the middle
	var player_track = selected_camera.get_parent()
	player_track.add_child(fish)
	fish.follow_track = selected_camera.get_parent()
	player_track.following_path = true


