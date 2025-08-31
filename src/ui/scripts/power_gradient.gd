class_name PowerGradientUI extends Control

@export_category("Vars")
@export var MAX_POWER_Y: float
@export var MIN_POWER_Y: float
@export var speed_mult : float = 1

@export_category("Dependencies")
@export var rod_item: RodItem
@export var slider: Control

var elapsed := 0.0
func _process(delta: float) -> void:
	if not visible:
		elapsed = 0.0
	if visible:
		elapsed += delta

		var pos_n = 1-rod_item.power_curve.sample(
			fposmod(elapsed*speed_mult, rod_item.power_curve.max_domain))

		slider.position.y = lerpf(MAX_POWER_Y, MIN_POWER_Y, pos_n) 

func power() -> float: return slider.position.y / 1000
func set_power(p: int):
	slider.position.y = p
