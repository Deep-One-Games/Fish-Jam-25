class_name Fishcam extends Camera3D

@export var path_follow: PathFollow3D

func _process(delta: float) -> void:
	return
	var target_x = path_follow.global_transform

	var cur = target_x.origin

	var smooth = global_transform.basis.slerp(target_x.basis, delta * 5.0)
	global_transform = Transform3D(smooth, cur)

func _process2(delta: float) -> void:
	global_transform.origin = path_follow.global_transform.origin

	var target = path_follow.global_transform.basis
	global_transform.basis = global_transform.basis.slerp(target, delta*5.0)
