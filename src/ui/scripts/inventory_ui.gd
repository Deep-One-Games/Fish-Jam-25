extends Control

@export var max_inventory_size: int

@export var savefile: SaveFile

@export var inventory: GridContainer
@export var item_display: PackedScene

@export var item_mesh: MeshInstance3D	
@export var item_name: Label
@export var item_lore: Label

@export var start_visible := false

func _ready() -> void:
	self.visible = start_visible
	for item_data in savefile.inventory:
		var item: InventoryItem = item_display.instantiate()
		item.item_tex = item_data.thumb
		item.hover_text = item_data.desc
		item.item_selected.connect(
			item_selected.bind(item_data.ref_id))
		inventory.add_child(item)
		
	# fill remaining free slots:
	for i in range(max_inventory_size - len(savefile.inventory)):
		var item = item_display.instantiate()
		inventory.add_child(item)
	pass

func item_selected(id: String):
	var item: GameItem =\
		savefile.inventory.filter(func(x): return x.ref_id == id)[0]
	item_mesh.mesh = item.mesh
	item_name.text = item.name
	item_lore.text = item.lore
