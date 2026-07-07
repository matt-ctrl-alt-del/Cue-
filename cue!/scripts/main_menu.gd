extends Control

var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_out")
	await $CanvasLayer/Fade_transition/AnimationPlayer.animation_finished


func _on_play_pressed() -> void:
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_pressed() -> void:
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")
	get_tree().quit()
