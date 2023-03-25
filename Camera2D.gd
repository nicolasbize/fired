extends Camera2D

export(NodePath) var player_path = null

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

func _process(delta):
	if player.position.x > 128:
		position.x = player.position.x
