extends FSMState

@export var racetrack:RaceTrack3D

@export var raceplate: PackedScene

@export var output: Label
@export var _origin: Control
@export var select_control: Control

func _ready() -> void:
	_origin.visible = false

func enter() -> void:
	_origin.visible = true
	racetrack.start_game()

func exit() -> void:
	_origin.visible = false

func update(_delta: float) -> void:
	# rank fish by distance traveled
	var ordered = []
	for lf in racetrack.live_fish:
		ordered.append([lf.follow_track._cumulative_distance(), lf])
	
	ordered.sort_custom(func(a,b): return a[0] > b[0])

	var s := ""
	var i := 0
	for dlf in ordered:
		i += 1
		var lf: RaceFish = dlf[1]
		s += "%s. %s" % [i, make_txt(lf.fishinfo, lf.follow_track)]

	output.text = s

	# check if any of the fish have lapped 3 times
	for lf in racetrack.live_fish:
		if lf.follow_track.loops == 3: 
			get_parent().change_state("FINISH")

func make_txt(fd: FishData, ft: LinearFollow) -> String:
	var _name = "NPC"
	if fd.name != "": _name = fd.name
	return "%s Laps: %s/3, %sm\n" % [_name, ft.loops, ft._cumulative_distance()]
