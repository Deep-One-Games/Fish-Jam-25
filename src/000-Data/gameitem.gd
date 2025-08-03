extends Resource
class_name GameItem

@export var ref_id: String

@export_category("UI")
@export var name: String
@export_multiline var desc: String
@export_multiline var lore: String

@export_category("Rendering")
@export var thumb: Texture
@export var mesh: Mesh
