class_name LinearFollow extends PathFollow3D

@export var mps: float = 1.50 # Meters Per Second

signal path_completed

var curve: Curve3D
var following_path := false

var default_mps: float
func _ready() -> void:
	default_mps = mps
	curve = self.get_parent().curve

func _process(delta: float) -> void:
	if not following_path: return
	progress += mps * delta

	if progress_ratio == 1.0:
		# reset path
		progress_ratio = 0.0
		path_completed.emit()
