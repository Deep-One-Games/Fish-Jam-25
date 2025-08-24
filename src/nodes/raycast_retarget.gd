class_name RayCastRetarget extends RayCast3D
## Apply a target object to be at the position of the 
## first element that collides with the raycast

@export var target: Node3D

func _process(_delta: float) -> void:
	if not self.is_colliding(): return
	
	var xyz = self.get_collision_point()
	
	target.global_position = xyz
