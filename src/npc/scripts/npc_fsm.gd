class_name NPCFSM extends FSM

@export var animations: AnimationPlayer
@export var mesh: Mesh
@export var disable_floor_snapping: bool = false

@export_category("Dependencies")
@export var player_sensor: DialogueArea
@export var npc_controller: NPCController
@export var event_sensor: Area3D
@export var mesh_node: MeshInstance3D
@export var raycast_down: RayCast3D

var ignoring: bool

var ps_col_layers: int
var ps_col_mask  : int

func _ready() -> void:
	super()
	ps_col_layers = player_sensor.collision_layer
	ps_col_mask   = player_sensor.collision_mask

	mesh_node.mesh = mesh

	if disable_floor_snapping:
		raycast_down.enabled = false

func set_ignoring(_ignoring: bool):
	ignoring = _ignoring

	player_sensor.collision_mask = ps_col_mask
	player_sensor.collision_layer = ps_col_layers

	if ignoring:
		player_sensor.collision_mask  = 0
		player_sensor.collision_layer = 0
