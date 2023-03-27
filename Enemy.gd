extends "res://Character.gd"

export(NodePath) var player_path = null

var player = null

func _ready():
	player = get_node(player_path)

func _process(delta):
	match state:
		IDLE:
			animation_player.play("Idle")
		WALKING:
			animation_player.play("Walk")
	sprite.scale.x = 1 if position.x < player.position.x else -1

func on_finish_attack_animation():
	state = IDLE

func on_finish_hurt_animation():
	state = IDLE
