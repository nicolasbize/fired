extends "res://Character.gd"

export var nb_successive_hits : int = 0

var jump_strength : float = -3
var gravity : float = 8
var initial_offset_y : float = 0
var offset_vy := 0.0
var is_air_kicking := false

func _ready():
	initial_offset_y = sprite.offset.y

func _process(delta):
	match state:
		IDLE:
			animation_player.play("Idle")
		WALKING:
			animation_player.play("Walk")
		ATTACKING:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	var input_vector := get_input_vector()

	if state == JUMPING:
		offset_vy += gravity * delta
		sprite.offset.y += offset_vy
		if not is_air_kicking and Input.is_action_just_pressed("kick"):
			animation_player.play("AirKick")
			is_air_kicking = true
		if sprite.offset.y > initial_offset_y:
			sprite.offset.y = initial_offset_y
			state = IDLE
		
	else:
		if can_jump() and Input.is_action_just_pressed("jump"):
			state = START_JUMP
			animation_player.play("StartJump")
		elif can_attack() and Input.is_action_just_pressed("punch"):
			input_vector = Vector2.ZERO
			state = ATTACKING
			nb_successive_hits += 1
			if nb_successive_hits == 3:
				nb_successive_hits = 0
				animation_player.play("RightHook")
			else:
				animation_player.play("LeftHook")
		elif can_attack() and Input.is_action_just_pressed("kick"):
			input_vector = Vector2.ZERO
			state = ATTACKING
			animation_player.play("Kick")
				
	if state != ATTACKING:
		if input_vector != Vector2.ZERO:
			velocity = velocity.move_toward(input_vector * movement_speed, acceleration * delta)
			if input_vector.x > 0:
				sprite.scale.x = 1
			elif input_vector.x < 0:
				sprite.scale.x = -1
			if not is_in_air():
				state = WALKING
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if not is_in_air():
				state = IDLE

	velocity = move_and_slide(velocity)

func get_input_vector() -> Vector2:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

func can_attack() -> bool:
	return state != ATTACKING

func can_jump() -> bool:
	return not is_in_air()

func on_finish_attack_animation() -> void:
	state = IDLE

func on_finish_hurt_animatino() -> void:
	state = IDLE

func on_start_jump_animation_complete() -> void:
	state = JUMPING
	is_air_kicking = false
	offset_vy = jump_strength

func is_in_air() -> bool:
	return state == START_JUMP || state == JUMPING
	
