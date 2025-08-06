class_name LinearFollow extends PathFollow3D

@export var mps: float = 0.50 # Meters Per Second

signal path_completed
signal play

var curve: Curve3D
var following_path := false

func _ready() -> void:
	curve = self.get_parent().curve
	play.connect(follow_path)

func follow_path():
	following_path = true

func _process(delta: float) -> void:
	if not following_path: return
	progress += mps * delta

	if progress_ratio == 1.0:
		# reset path
		progress_ratio = 0.0
		following_path = false
		path_completed.emit()
