class_name LightComponent
extends Node2D

## Add as a child of anything that should illuminate the scene (the player, a
## lamp, a glowing pickup, a light shaft).

const LIGHT_GROUP := "tdl_light"

## Light reach in world pixels (matches game-world units).
@export var radius: float = 120.0
## Tint of the emitted glow. White keeps the scene's own colors.
@export var color: Color = Color(1.0, 1.0, 1.0)
## Brightness multiplier. ~1.0 = solid lit core; lower for dim sources.
@export var intensity: float = 1.0
## 0 = steady. >0 randomly dims the light each frame (torch/fire feel).
@export_range(0.0, 1.0) var flicker: float = 0.0
## Toggle without removing the node.
@export var enabled: bool = true

func _enter_tree() -> void:
	add_to_group(LIGHT_GROUP)

func _exit_tree() -> void:
	remove_from_group(LIGHT_GROUP)
