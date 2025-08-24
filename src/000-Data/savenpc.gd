class_name SaveNPC extends Resource
## Similar to [GameItem] and [SavePlayer]. This stores all data of an NPC into
## a resource.
##
## It is recommended to save this file to disk to ensure it is unique 
## throughout the whole project.

## 2D Image representative of the NPC
@export var profile: Texture2D

## All dialogue this NPC will ever have. Titles here are referenced as indices
## in Dialogue Player systems.
@export var npc_dialogue: DialogueResource
