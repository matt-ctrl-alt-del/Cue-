class_name LightObstructor
extends Node2D

## Add as a child of anything that should cast shadows / block light (walls,
## crates, big rocks). 
const OBSTRUCTOR_GROUP := "tdl_obstructor"

## Blocking radius in world pixels.
@export var radius: float = 40.0
## Toggle without removing the node.
@export var enabled: bool = true

func _enter_tree() -> void:
	add_to_group(OBSTRUCTOR_GROUP)

func _exit_tree() -> void:
	remove_from_group(OBSTRUCTOR_GROUP)
