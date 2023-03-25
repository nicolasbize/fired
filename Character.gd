extends KinematicBody2D

onready var animation_player := $AnimationPlayer
onready var sprite := $Sprite

export(float) var acceleration := 450
export(float) var movement_speed := 80
export(float) var friction := 600

enum {IDLE, WALKING, ATTACKING}


var state := IDLE
var velocity := Vector2.ZERO
