extends CharacterBody2D

@export var max_speed = 100
@export var accel = 500
@export var friction = 300

var last_input = Vector2(0,1)
var player_input = Vector2.ZERO

@onready var anim_tree : AnimationTree  = $AnimationTree
@onready var anim_sprite : AnimatedSprite2D  = $AnimatedSprite2D

var functions = preload("res://code/main_character/char_functions.gd").new()

func update_last_input_value(player_input):
	if abs(player_input.x) >= 1 or abs(player_input.y) >= 1:
		last_input = player_input
	return last_input

func _physics_process(delta):
	
	if Engine.time_scale == 1:

		last_input = update_last_input_value(player_input)
		player_input = functions.get_input()
		functions.update_state_machine(player_input, last_input, anim_tree)

		velocity = functions.player_movement(delta, player_input, velocity, max_speed, accel, friction)

		move_and_slide()

func _on_hurt_box_hurt(damage: Variant) -> void:
	var kockback_tween := get_tree().create_tween()
	functions.take_damage(damage, anim_sprite, kockback_tween)
