extends Camera2D

var current_target_pos:Vector2

func _process(delta):
	var target_pos = (GlobalState.player.global_position + GlobalState.left_hand.global_position + GlobalState.right_hand.global_position) * 0.333
	
	target_pos.x = position.x
	
	if abs(target_pos.y - position.y) > 500.0:
		current_target_pos = target_pos
	
	position = lerp(position, current_target_pos, 0.5)
