extends CharacterBody2D

@export var gravity = 3000
@export var jump_scale = -1500
var die = false

func _ready() -> void:
	$JumpTimer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if die != true:
		velocity.x = 0
		
		if not is_on_floor():
			velocity.y += gravity * delta
			if velocity.y > 0:
				$AnimatedSprite2D.set_animation("Fall")
		else:
			$AnimatedSprite2D.set_animation("Idle")
		
		move_and_slide()

func morte() -> void:
	die = true
	$AnimatedSprite2D.hide()
	$Dead.show()
	$Dead.play()
	$CollisionShape2D.disabled = true
	$AudioStreamPlayer.play()
	$JumpTimer.stop()

func _on_jump_timer_timeout() -> void:
	$AnimatedSprite2D.play("Preparing")
	$AnimatedSprite2D.play("Jump")
	velocity.y = jump_scale

func _on_dead_animation_finished() -> void:
	queue_free()
