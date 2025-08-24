class_name AreaEvent extends Area3D

enum AreaEventType {ENTER_BUILDING, IDLE, WORKING, SITING_WORKING, SITTING}

@export var event_type : AreaEventType
@export var duration_s : float
@export var dialogue_title: String
@export var overwrite_mps: bool = false
@export var mps: float = 1.5
