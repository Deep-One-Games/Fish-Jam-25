class_name AreaPlayer3D extends Area3D

var player: AudioStreamPlayer
var tw: Tween

func _ready() -> void:
	player = get_child(0)
	player.volume_db = -80.0

	body_entered.connect(play)
	body_exited.connect(pause)

func play(_a) -> void: 
	print("play")
	player.play()
	if tw: tw.kill()
	tw = create_tween()
	tw.tween_property(player, "volume_db", 0, 1.5) # fade in 

func pause(_a) -> void:
	print("pause")
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property(player, "volume_db", -80.0, 1.5) # fade out
	await tw.finished
	player.stop()
