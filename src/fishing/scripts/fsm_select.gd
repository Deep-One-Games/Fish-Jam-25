extends FSMState

@export_category("Setup")
@export var use_savefile := true
@export var inventory: Array[GameItem]

@export_category("Internal Dependencies")
@export var select_control: Control
@export var item: MeshInstance3D
