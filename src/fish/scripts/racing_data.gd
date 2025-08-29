class_name RacingData extends Resource

@export var racefish_options: Array[PackedScene] = []

@export var ai_count: int = 3

@export var contestants: Array[FishData] = []
@export var player_fish: FishData

func populate_ai() -> void:
	if len(contestants) > 0: return

	assert(len(racefish_options) > 0, 
	"Must have options to chose from to initialize game")

	for i in range(ai_count):
		var fish = racefish_options[randi() % len(racefish_options)]
		
		var fd = FishData.new()
		fd.generate()
		fd.racefish = fish

		contestants.append(fd)

func compute_probability_landscape() -> void:
	var sum := 0.0
	for c in contestants:
		sum += c.fitness()
	
	sum += player_fish.fitness()

	for c in contestants:
		c.boost_probability = c.fitness() / sum
	player_fish.boost_probability = player_fish.fitness() / 100
