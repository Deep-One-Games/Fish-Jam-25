class_name FishData extends GameItem 

@export var sample_mean: float = 6.25 # Guarentees victory 20% of the time
@export var weight     : int
@export var size       : int
@export var madness    : int

@export var racefish: PackedScene

func generate() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash("Fish God")
	
	weight = int(rng.randfn()*sample_mean)
	size = int(rng.randfn()*sample_mean)
	madness = int(rng.randfn()*sample_mean)
