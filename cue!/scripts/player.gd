extends CharacterBody2D

const SPEED = 110.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Handle jump.
	if input_direction.x > 0:
		animated_sprite.flip_h = false
	elif input_direction.x < 0:
		animated_sprite.flip_h = true

	if input_direction != Vector2.ZERO:
		velocity = input_direction * SPEED
		animated_sprite.play("idle")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		

	move_and_slide()
