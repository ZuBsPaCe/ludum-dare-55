extends Area2D

@export var particles:bool = true



func _on_body_entered(body):
	if body.is_in_group("LeftHand"):
		GlobalState.left_grip_count += 1
		GlobalState.left_grip_particles = particles
	elif body.is_in_group("RightHand"):
		GlobalState.right_grip_count += 1
		GlobalState.right_grip_particles = particles


func _on_body_exited(body):
	if body.is_in_group("LeftHand"):
		GlobalState.left_grip_count -= 1
	elif body.is_in_group("RightHand"):
		GlobalState.right_grip_count -= 1
