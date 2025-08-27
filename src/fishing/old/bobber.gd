extends RigidBody3D

@export var gravity_override: Vector3 = Vector3.DOWN * ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# raycast down to find the water surface
	var from = global_transform.origin
	var to   = from + Vector3.DOWN * 5.0
	var space_state = get_world_3d().direct_space_state

	# build parameters
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.exclude = [self]
	params.collide_with_areas = true

	# perform the raycast
	var result = space_state.intersect_ray(params)

	if result and result.collider.is_in_group("fishing_zone"):
		# snap to float on water surface
		var water_y = result.position.y
		global_transform.origin.y = water_y + 0.05
		linear_velocity = Vector3.ZERO
		sleeping = true
	else:
		# otherwise, apply downward force
		apply_central_force(gravity_override)
