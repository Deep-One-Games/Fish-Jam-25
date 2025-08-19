class_name DebugMonitor extends RichTextLabel


var monitor: Node
var prop_names: Array[String]

## Static function meant to inject the monitor into the scene given a target.
static func inject(target: Node, _monitor: Node, _prop_names: Array[String]): 
	target.add_child(DebugMonitor.new(_monitor, _prop_names))

func _init(_monitor: Node, _prop_names: Array[String]) -> void:
	monitor = _monitor
	prop_names = _prop_names
	
	self.fit_content = true
	self.bbcode_enabled = true
	#self.size = Vector2(500, 500)

func _process(_delta: float) -> void:
	# Update text every frame
	var s := "PROP: %s\n" % monitor.name.capitalize()
	for pn in prop_names: s += "\t%s: %s\n" % [pn , monitor.get(pn)]

	self.text = s
