extends CharacterBody2D

@export var target_to_follow : Node2D
@export var speed = 25
@export var hp = 2
var last_velocity = Vector2.ZERO

@onready var anim_tree : AnimationTree  = $AnimationTree

var functions = preload("res://code/enemies/enemy_funcs.gd").new()

func update_last_input_value(actual_velocity):
	if abs(actual_velocity.x) >= 1 or abs(actual_velocity.y) >= 1:
		last_velocity = actual_velocity
	return last_velocity

func _physics_process(delta: float) -> void:
	
	last_velocity = update_last_input_value(velocity)
	velocity = functions.follow_target(target_to_follow, position, speed)
	
	functions.update_state_machine(velocity.normalized(), last_velocity.normalized(), anim_tree)
	
	move_and_slide()

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	if hp <= 0:
		GlobalVariables.score += 50
		#dead = 1
		await get_tree().create_timer(1).timeout
		queue_free()
