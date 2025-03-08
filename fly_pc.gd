extends StaticBody2D

@export var speed = 1
var max_y
var min_y
var side = "up"
var die = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if die != true:
		if max_y == null:
			max_y = position.y + 25
		if min_y == null:
			min_y = position.y - 25

		if side == "up":
			position.y -= speed
		if position.y < min_y:
			side = "down"
		if side == "down":
			position.y += speed
		if position.y > max_y:
			side = "up"
	

func morte() -> void:
	die = true
	$AnimatedSprite2D.hide()
	$Dead.show()
	$Dead.play()
	$CollisionShape2D.disabled = true
	$AudioStreamPlayer.play()


func _on_dead_animation_finished() -> void:
	queue_free()
