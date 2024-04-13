extends Area2D




func _on_body_entered(body):
	if body.is_in_group("LeftHand"):
		GlobalState.left_grip_count += 1
	elif body.is_in_group("RightHand"):
		GlobalState.right_grip_count += 1


func _on_body_exited(body):
	if body.is_in_group("LeftHand"):
		GlobalState.left_grip_count -= 1
	elif body.is_in_group("RightHand"):
		GlobalState.right_grip_count -= 1
