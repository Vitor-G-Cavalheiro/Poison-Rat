extends Node2D

var camera_x
var camera_y
var frog = preload("res://enemy_frog.tscn")
var fly = preload("res://fly_pc.tscn")
var krab = preload("res://enemy_krab.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/DamageTimer.start()
	spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# ajustando camera
	camera_x = $Player.position.x
	$Camera2D.position.x = clamp(camera_x, 1000, 35000)
	camera_y = $Player.position.y
	$Camera2D.position.y = clamp(camera_y, -2000, 0)
	
	# Mira
	if $Player.enemy != null:
		$Mira.show()
		$Mira.position = $Player.enemy.position
	else:
		$Mira.hide()
	
	if $Player.dead: 
		$game_over.show()
	
	# Vida
	var vida = $Player.life / 10
	$Vida.set_frame_and_progress(vida, vida)
	$Vida.position.x = $Camera2D.position.x - 1000
	$Vida.position.y = $Camera2D.position.y - 100
	
	if $game_over.restart or Input.is_action_just_pressed("reset"):
		$Player.revive()
		$game_over.reset()
		despawn()
		spawn()
	
	if $Player.dash:
		$DashStyle.show()
		$DashStyle.position.y = $Player.position.y
		if $Player.velocity.x > 0:
			$DashStyle.position.x = $Player.position.x - 50
			$DashStyle.flip_h = false
		else:
			$DashStyle.position.x = $Player.position.x + 50
			$DashStyle.flip_h = true
	else:
		$DashStyle.hide()


func _on_fall_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Player.dead = true


func _on_win_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Player.win = true
		get_tree().change_scene_to_file("res://creditos.tscn")

func spawn():
	$Player.position = $Player_spawn.position
	# Spawn de Inimigos
	var frogs = get_tree().get_nodes_in_group("spawn_frog")
	for i in frogs.size():
		var frogLoad = frog.instantiate()
		add_child(frogLoad)
		frogLoad.position = frogs[i].position
	var flys = get_tree().get_nodes_in_group("spawn_fly")
	for i in flys.size():
		var flyLoad = fly.instantiate()
		add_child(flyLoad)
		flyLoad.position = flys[i].position
	var krabs = get_tree().get_nodes_in_group("spawn_krab")
	for i in krabs.size():
		var krabLoad = krab.instantiate()
		add_child(krabLoad)
		krabLoad.position = krabs[i].position

func despawn():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies.size():
		enemies[i].queue_free()
