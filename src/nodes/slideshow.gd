extends TextureRect

@export var gallery: Array[CompressedTexture2D]
@export var state: Label

var curs = 0
var autoplay_time := 5.0

var elapsed := 0.0

var start_position : Vector2
var paused := false

const MAX_SIZE = Vector2(750,500)
func _ready() -> void:
	await get_tree().create_timer(0.4).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# start_position = position


func _process(delta: float) -> void:
	elapsed += delta
	
	# Texture update conditions:
	if elapsed > autoplay_time and not paused: seek(1)
	if Input.is_action_just_pressed("page_right"): seek(1)
	if Input.is_action_just_pressed("page_left"): seek(-1)

	state.text = "Playing"
	if paused: state.text = "Paused"

var dragging := false
var drag_offset := Vector2()

func set_texture_c(tex: Texture2D):
	texture = tex
	size = tex.get_size()

	position = (get_viewport_rect().size - size) / 2

func seek(e: int) -> void:
	elapsed = 0.0
	curs += e
	position = start_position
	set_texture_c(gallery[curs])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		paused = !paused
	if event.is_action_pressed("fish_exit"):
		SceneManager.switch(SceneManager.GameScene.main_menu)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT: return
		dragging = false
		if event.pressed:
			dragging = true
			paused = true
			drag_offset = event.position
			accept_event()
	elif event is InputEventMouseMotion and dragging:
		position += event.relative
		accept_event()
