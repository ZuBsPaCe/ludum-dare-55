extends Sprite2D


func _process(delta):
	position.x -= 100.0 * delta
	
	if position.x < -7000.0:
		position.x += 7000.0 * 2.0
