class_name NPCPatrol extends Node3D

@export_category("NPC Properties")
@export var npc_info: SaveNPC
@export var default_state: String
@export var patrol_title: String

@export_category("Dependencies")
@export var patroller: LinearFollow
@export var npc: NPCFSM

var event_active: bool # To sync looking behavior so they dont restart pathing 
					   # on on_looking leave
var look_active: bool  # Same idea!

signal stop_looking

func _ready() -> void:
	npc.player_sensor.dialogue = npc_info.npc_dialogue

	npc.npc_controller.on_looking.connect(on_looking)
	npc.event_sensor.area_entered.connect(event_trigger)

	npc.change_state(default_state)
	npc.player_sensor.title = patrol_title

	patroller.following_path = true

func event_trigger(e: AreaEvent):
	# Prepare states for event
	event_active = true
	patroller.following_path = false
	if e.dialogue_title: npc.player_sensor.title = e.dialogue_title
	
	patroller.mps = patroller.default_mps
	if e.overwrite_mps: patroller.mps = e.mps
	
	match e.event_type:
		AreaEvent.AreaEventType.ENTER_BUILDING: 
			var old_pos = global_transform.origin
			global_transform.origin = Vector3(69420, 6420, 6420) # BANISH

			await get_tree().create_timer(e.duration_s).timeout

			global_transform.origin = old_pos
			patroller.following_path = true
			return # fast return bc i have 7 days  u numbnut
			
		AreaEvent.AreaEventType.IDLE: npc.change_state("IDLE")
		AreaEvent.AreaEventType.WORKING: 
			npc.change_state("WORK")
			npc.set_ignoring(true)
		AreaEvent.AreaEventType.SITING_WORKING:
			npc.change_state("SIT_ACTION")
			npc.set_ignoring(true)
		AreaEvent.AreaEventType.SITTING:
			npc.change_state("SIT_IDLE")
			npc.set_ignoring(true)

	await get_tree().create_timer(e.duration_s).timeout
	
	# Clean up event state
	event_active = false
	npc.set_ignoring(false)
	
	# We need to link event_trigger and on_looking s.t. if the player is in zone
	# we pause execution of switching back dialog and pathing once they leave
	# the zone
	if look_active: await stop_looking
	npc.player_sensor.title = patrol_title # Go back to patrol state afterwards!
	patroller.following_path = true
	npc.change_state(default_state)

func on_looking(look_state: bool):
	look_active = look_state
	if not look_state: stop_looking.emit()
	if event_active: return
	patroller.following_path = !look_state
	
	if look_state:
		npc.change_state("IDLE")
		return
	npc.change_state("WALK")
