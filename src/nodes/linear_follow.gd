class_name LinearFollow extends PathFollow3D

@export var mps: float = 1.50 # Meters Per Second

signal path_completed

var curve: Curve3D
@export var following_path := false

var default_mps: float
var loops: int = 0

var cum := 0.0
func _ready() -> void:
	default_mps = mps
	curve = self.get_parent().curve

func _process(delta: float) -> void:
	if not following_path: return
	progress += mps * delta

	if progress_ratio == 1.0 or looped_check():
		# reset path
		loops += 1
		progress_ratio = 0.0
		path_completed.emit()
		following_path = loop

var prev_progress := 0.0
func looped_check() -> bool:
	var check = prev_progress > progress
	prev_progress = progress
	return check

func _cumulative_distance() -> float:
	var path_length := curve.get_baked_length()
	return int(self.progress + (loops*path_length))
