class_name GameItem extends Resource 
## Resource that stores game item data. Make unique by saving them to 
## directory.
##
## Each game item has a unique string [code]ref_id[/code]. The game item will
## always be referenced using this unique identifier. 
## [br] [br]
## The UI category contains variables associated with text that is rendered to
## the player.
## [br] [br]
## The Rendering category contains variables associated with game assets that 
## will be rendered to the player. Ensure [member GameItem.mesh] has the
## correct textures and shaders applied to the mesh! Game systems will simply
## pass this to [MeshInstance3D]

## Unique internal reference name for this item
@export var ref_id: String

@export_category("UI")

@export var name: String

## Short object description
@export_multiline var desc: String

## Long object description
@export_multiline var lore: String

@export_category("Rendering")

## 2D Image that will be used to display this item in game
@export var thumb: Texture

## 3D Mesh that will be used to display this item in game
@export var mesh: Mesh
