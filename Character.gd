extends KinematicBody2D

onready var animation_player := $AnimationPlayer
onready var sprite := $Sprite
onready var deal_dmg_box := $DealDmgBox
onready var rcv_dmg_box := $RcvDmgBox

export(float) var acceleration := 450
export(float) var movement_speed := 80
export(float) var friction := 600
export(float) var y_tolerance := 10
export(int) var damage := 0
export(int) var max_hp := 20
export(int) var hp := 20

enum {IDLE, WALKING, ATTACKING, START_JUMP, JUMPING, FINISH_JUMP, HURTING}

func _ready():
	rcv_dmg_box.connect("area_entered", self, "_on_rcv_dmg_area_enter")

var state := IDLE
var velocity := Vector2.ZERO

func _on_rcv_dmg_area_enter(area):
	var hitter = area.get_parent()
	if abs(hitter.position.y - position.y) < y_tolerance:
		got_hit(hitter.damage)

func got_hit(dmg):
	state = HURTING
	animation_player.play("Hurt")
