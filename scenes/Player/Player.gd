extends "res://Character.gd"

var nb_successive_hits := 0

func _process(delta):
	match state:
		IDLE:
			animation_player.play("Idle")
		WALKING:
			animation_player.play("Walk")
		ATTACKING:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	var input_vector := get_input_vector()


	if can_attack() and Input.is_action_just_pressed("punch"):
		input_vector = Vector2.ZERO
		state = ATTACKING
		nb_successive_hits += 1
		if nb_successive_hits == 3:
			nb_successive_hits = 0
			animation_player.play("RightHook")
		else:
			animation_player.play("LeftHook")
	elif state != ATTACKING:
		if input_vector != Vector2.ZERO:
			velocity = velocity.move_toward(input_vector * movement_speed, acceleration * delta)
			if input_vector.x > 0:
				sprite.scale.x = 1
			elif input_vector.x < 0:
				sprite.scale.x = -1
			state = WALKING
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			state = IDLE

	velocity = move_and_slide(velocity)

func get_input_vector() -> Vector2:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

func can_attack() -> bool:
	return state != ATTACKING

func on_finish_attack_animation() -> void:
	state = IDLE
