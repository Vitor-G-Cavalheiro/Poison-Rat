extends CanvasLayer

var restart = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	restart = true


func reset() -> void:
	restart = false
	hide()
