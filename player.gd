extends CharacterBody2D

@export var speed = 600
@export var min_speed = 600
@export var max_speed = 4200
@export var acceleration = 20
@export var gravity = 3000
@export var jump_scale = -1500
@export var life = 100
@export var max_life = 100
@export var attack_time = 30
var enemy
var dash = false
var invencible = false
var dead = false
var win = false

func _ready() -> void:
	dead = false
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor() and dash == false and invencible != true:
		$AnimatedSprite2D.set_animation("Jump")
	# gravidade
	if not is_on_floor() and $AnimatedSprite2D.animation != "Attack":
		velocity.y += gravity * delta
		if $AnimatedSprite2D.animation != "Invencible":
			$AnimatedSprite2D.set_animation("Jump")
	if dash != true and invencible != true and win != true:
		# pulo
		if Input.is_action_just_pressed("jump")and is_on_floor():
				velocity.y = jump_scale
		
		# movimentação pros lados
		var direction := Input.get_axis("left", "right")
		if direction:
			if is_on_floor() and $AnimatedSprite2D.animation != "Run":
				$AnimatedSprite2D.set_animation("Run")
			speed += acceleration
			if speed > max_speed:
				speed = max_speed
			velocity.x = direction * speed
			if direction == 1:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			speed = min_speed
			if is_on_floor():
				$AnimatedSprite2D.set_animation("Idle")
		
	move_and_slide()
	
	# Ataque
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			if enemy == null || body.position.distance_to(position) < enemy.position.distance_to(position):
				enemy = body
			if Input.is_action_just_pressed("attack"):
				var attack_x
				var attack_y
				# Atacando de ladinho
				if enemy.position.x < position.x:
					attack_x = -100
					$AnimatedSprite2D.flip_h = true
				elif enemy.position.x > position.x:
					attack_x = 100
					$AnimatedSprite2D.flip_h = false
				# Atacando de cima pra baixo
				if enemy.position.y < position.y:
					attack_y = -50
				elif enemy.position.y > position.y:
					attack_y = 50
				attack(attack_x, attack_y)

	if life == 0:
		game_over()
	
	if win:
		velocity.x += min_speed
		gravity = 0
		life = 100

func _on_damage_timer_timeout() -> void:
	life -= 10

func life_heal() -> void:
	life += 20
	if life > max_life:
		life = max_life

func attack(x_speed, y_speed) -> void:
	if $DashCountdown.is_stopped() and invencible != true:
		$AnimatedSprite2D.set_animation("Attack")
		dash = true
		velocity.x = x_speed * attack_time
		velocity.y = y_speed * attack_time
		speed += min_speed
		$DashTimer.start()
		$DashCountdown.start()
		enemy.morte()
		if !enemy.is_in_group("not_heal"):
			life_heal()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemy == body:
		enemy = null

func take_damage() -> void:
	life -= 10

func _on_hurt_box_body_entered(enemy: Node2D) -> void:
	if dash == true:
		dash = false
		$DashTimer.stop()
	
	if $InvencibiliteTimer.is_stopped() and enemy.is_in_group("enemy"):
		speed = min_speed
		take_damage()
		$InvencibiliteTimer.start()
		$AnimatedSprite2D.set_animation("Invencible")
		invencible = true
		if enemy.position.x < position.x:
			velocity.x += 150
		elif enemy.position.x > position.x:
			velocity.x -= 150
		await($InvencibiliteTimer)

func _on_invencibilite_timer_timeout() -> void:
	invencible = false

func game_over() -> void:
	invencible = true
	$AnimatedSprite2D.hide()
	$Dead.show()
	$Dead.play()
	$AudioStreamPlayer.play()

func revive() -> void:
	dead = false
	invencible = false
	life = 100
	speed = min_speed
	$Dead.hide()
	$AnimatedSprite2D.show()

func _on_dash_timer_timeout() -> void:
	dash = false


func _on_dead_animation_finished() -> void:
	dead = true
