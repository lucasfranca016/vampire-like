extends Node

func follow_target(target_to_follow, actual_position, speed):

	var direction = (target_to_follow.position - actual_position).normalized()
	var new_velocity = direction * speed

	return new_velocity

func update_state_machine(actual_velocity, last_velocity, animatiom_tree):

	if actual_velocity == Vector2.ZERO:
		animatiom_tree.set("parameters/conditions/is_moving", false)
		animatiom_tree.set("parameters/conditions/is_idle", true)
		animatiom_tree.set("parameters/Idle/blend_position", last_velocity * Vector2(1,-1))
	else:
		animatiom_tree.set("parameters/conditions/is_moving", true)
		animatiom_tree.set("parameters/conditions/is_idle", false)
		animatiom_tree.set("parameters/Walk/blend_position", actual_velocity * Vector2(1,-1))
