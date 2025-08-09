class_name AudioAtlas extends Resource
## Create an Audio Library to be used in the engine. Purpose is to provide a
## a unique index to an audio resource.
##
## Contains only an array of audiostreams wrapped as a resource

## Non-functional. For editor only
@export_multiline var comment: String = "Documentation Here"

## 1 to 1 mapping of index to an audio stream. Ensure each file is unique!
@export var audiostreams: Array[AudioStream]
