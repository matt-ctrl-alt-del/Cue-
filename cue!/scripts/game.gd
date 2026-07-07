extends Node2D

var vinyls_collected = 0
var goal_vinyls = 4

@export var max_light: float = 100.0
@onready var current_light: float = max_light
@export var light_drain_rate: float = 0.25 # Loses 5 light per second


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl1.modulate.a = 0.25
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl2.modulate.a = 0.25
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl3.modulate.a = 0.25
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl4.modulate.a = 0.25
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_out")
	await $CanvasLayer/Fade_transition/AnimationPlayer.animation_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_light -= light_drain_rate * delta
	current_light = clamp(current_light, 0.0, max_light)
	$CanvasLayer/TextureProgressBar.value = current_light
	
	if current_light <= 0:
		get_tree().reload_current_scene()



func _on_vinyl_1_body_entered(body: Node2D) -> void:
	$Vinyls/Vinyl_1.queue_free()
	vinyls_collected += 1
	$CanvasLayer/Label.text = "Vinyls Collected: " + (str(vinyls_collected))
	print("+1 Vinyl")
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl2.modulate.a = 1.0
	



func _on_vinyl_2_body_entered(body: Node2D) -> void:
	$Vinyls/Vinyl_2.queue_free()
	vinyls_collected += 1
	$CanvasLayer/Label.text = "Vinyls Collected: " + (str(vinyls_collected))
	print("+1 Vinyl")
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl1.modulate.a = 1.0


func _on_vinyl_3_body_entered(body: Node2D) -> void:
	$Vinyls/Vinyl_3.queue_free()
	vinyls_collected += 1
	$CanvasLayer/Label.text = "Vinyls Collected: " + (str(vinyls_collected))
	print("+1 Vinyl")
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl3.modulate.a = 1.0


func _on_vinyl_4_body_entered(body: Node2D) -> void:
	$Vinyls/Vinyl_4.queue_free()
	vinyls_collected += 1
	$CanvasLayer/Label.text = "Vinyls Collected: " + (str(vinyls_collected))
	print("+1 Vinyl")
	$CanvasLayer/Vinyl_tracker/HBoxContainer/Vinyl4.modulate.a = 1.0


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "player": 
		if vinyls_collected >= 4:
			print("All vinyls collected! Game completed...")
			$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")
			await $CanvasLayer/Fade_transition/AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		else:
			print("The portal is locked! You only have " + str(vinyls_collected) + "/4 vinyls.")
			# Optional: Trigger an onscreen message or sound effect to alert the player
