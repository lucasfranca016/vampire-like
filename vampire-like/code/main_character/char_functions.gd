extends Node

func get_input():
	
	var input = Vector2.ZERO

	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	return input.normalized()

func player_movement(delta, input_vector, input_velocity, max_speed, accel, friction):

	var output_velocity = Vector2.ZERO
	var input_vetor = Vector2.ZERO

	if input_vector == Vector2.ZERO:
		if input_velocity.length() > (friction * delta):
			output_velocity -= input_velocity.normalized() * (friction * delta)
		else:
			output_velocity = Vector2.ZERO
	else:
		output_velocity = input_velocity + (input_vector * accel * delta)
		output_velocity = output_velocity.limit_length(max_speed)

	return output_velocity

func update_state_machine(player_input, last_input, animatiom_tree):

	if player_input == Vector2.ZERO:
		animatiom_tree.set("parameters/conditions/is_moving", false)
		animatiom_tree.set("parameters/conditions/is_idle", true)
		animatiom_tree.set("parameters/Idle/blend_position", last_input * Vector2(1,-1))
	else:
		animatiom_tree.set("parameters/conditions/is_moving", true)
		animatiom_tree.set("parameters/conditions/is_idle", false)
		animatiom_tree.set("parameters/Walk/blend_position", player_input * Vector2(1,-1))

func take_damage(damage, anim_sprite, kockback_tween) -> void:
	GlobalVariables.player_life -= damage
	anim_sprite.modulate = Color(1,0,0,1)
	kockback_tween.parallel().tween_property(anim_sprite, "modulate", Color(1,1,1,1), 0.5)
