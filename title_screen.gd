extends CanvasLayer

var volume = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if volume <= 0:
		get_tree().change_scene_to_file("res://tutorial.tscn")
	if $Controls.exit == true:
		$Controls.hide()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	if volume == 0:
		$Timer.stop()
	else:
		AudioServer.set_bus_volume_db(0, linear_to_db(volume))
		volume -= 0.15


func _on_controls_pressed() -> void:
	$Controls.show()
	$Controls.exit = false
