extends Camera2D

var current_target_pos:Vector2

func _process(delta):
	var target_pos := Vector2.ZERO
	var pos_count := 0.0
	
	if GlobalState.player:
		target_pos += GlobalState.player.global_position
		pos_count += 1
	
	if GlobalState.left_hand:
		target_pos += GlobalState.left_hand.global_position
		pos_count += 1
	
	if GlobalState.right_hand:
		target_pos += GlobalState.right_hand.global_position
		pos_count += 1
	
	if pos_count > 0:
		target_pos /= pos_count 
	
		if abs(target_pos.x - position.x) > 500.0:
			current_target_pos.x = target_pos.x
		
		if abs(target_pos.y - position.y) > 500.0:
			current_target_pos.y = target_pos.y
		
		var vec := current_target_pos - position
		position += vec * delta * 3.0
