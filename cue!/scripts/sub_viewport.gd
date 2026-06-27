extends SubViewport

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $"../../../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main_viewport = get_tree().root.get_viewport()
	self.world_2d = main_viewport.world_2d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position = player.global_position
