extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		show()
		get_tree().paused = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_return_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen.tscn")
