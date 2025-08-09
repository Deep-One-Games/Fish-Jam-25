class_name AudioEnvironmentPlayer extends Area3D
## An area that admits to changing the audio of an [AudioEnvironment] node.
##
## Define a set of curves with [PMFCurves]. This is then sampled by 
## [AudioEnvironment] to change the volume of different elements within its
## atlas over time. 
## [br][br]
## Constraints: [br] 
## x domain limited to [0, +inf). Represents time. Loops on sample overflow [br]
## y domain is not limited. Represents value to be added to volume. Setting range
## [+x, 0] will make curve represent loudness. Setting range [0,-x] will make
## curve represent quietness. 

enum SamplingTypes {
	USE_TIME,
	USE_RADIUS
}

@export_category("Setup")
@export var sampling_type: SamplingTypes = SamplingTypes.USE_TIME

@export_category("Data")
@export var pmf_curves: PMFCurves
@export var environment: AudioEnvironment
@export var shape: CollisionShape3D


var process_lock := true
var time_dt := 0.0
var audio_sample_pos := 0.0
var sample_res := 100 # Dont change unless you know what you're doing!!

signal activate_player
signal deactivate_player

func _ready() -> void:
	assert(pmf_curves and environment, "Missing required resources!")
	assert(len(pmf_curves.curves) == len(environment.tracks.audiostreams),
			"All tracks must have a curve defined!")
	
	# propogate signals alongside area entered
	self.area_entered.connect(func d(_a): activate_player.emit(_a, self))
	self.area_exited.connect(func d(_a): deactivate_player.emit(_a, self))

func get_pos_y(t: float) -> Array[float]:
	# WARNING: t is given by the environment. The environment only passes 
	# time here. The radius is a simple hack where we report by distance by 
	# selecting the player when sampling instead of time. Want more stats? Just
	# keep compiling them here since AudioEnvironments job is to only sum the
	# weights given by get_pos_y
	
	match sampling_type:
		SamplingTypes.USE_TIME:
			return pmf_curves.pmf_weights(t)
		SamplingTypes.USE_RADIUS:
			# We take the the domain to be [0,R] large. We place the players
			# distance d from the center point as a value between [0,R]. Then
			# linearly map [0,R] -> [0,1] and return pmf_curves.pmf_weights
			var radius = shape.shape.radius
			var player_pos = environment.player.global_transform.origin
			var center_pos = shape.global_transform.origin
			
			# Sometimes area starts reading too early because collisions detect closer than the
			# origin of the player. So we clamp the value. Negatives are impossible
			# only ~>1 values are
			var d = center_pos.distance_to(player_pos)
			var d_norm = float(int(clamp(d/radius, 0.0, 0.99) * sample_res + 0.5)) / sample_res
			print("d: %s, norm: %s" % [d, d_norm])
			var x = pmf_curves.pmf_weights(d_norm)
			print(x)
			return x

	return pmf_curves.pmf_weights(t)
