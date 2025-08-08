class_name AudioEnvironment extends Resource

@export var tracks: Array[AudioStream]
@export var pmf_curves: PMFCurves

func _init() -> void:
	assert(len(tracks) == len(pmf_curves.curves), 
		"All tracks must have a curved defined!")
