class_name FishData extends GameItem 

var ai_sample_mean = 18
@export var sample_mean: float = ai_sample_mean
@export var std        : float = 2.0
@export var weight     : int
@export var size       : int
@export var madness    : int

@export var boost_probability : float = 0.0 # set by racing_data

@export var racefish: PackedScene

@export var rng_keys: Dictionary[int, float] = {}

func generate() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash("Fish God %s" % Time.get_ticks_msec())
	
	weight = int(rng.randfn(sample_mean, std))
	size = int(rng.randfn(sample_mean, std))
	madness = int(rng.randfn(sample_mean, std))

func stats_str() -> String:
	return "weight: %s \nsize: %s \nmadness: %s\n\n%s" % [weight, size, madness, win_chance()]

func win_chance() -> String:
	return "Winning chance: %s/100" % int((sample_mean / (ai_sample_mean*3) + sample_mean))

func fitness() -> float:
	return 0.25*weight + 0.25 * size + 0.5*madness

func will_accept_boost(key) -> bool:
	var ref = hash(key)
	if ref in rng_keys:
		return rng_keys[ref] < boost_probability
	
	rng_keys[ref] = randf()
	return rng_keys[ref] < boost_probability
