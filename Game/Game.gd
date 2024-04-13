extends Node2D



func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	

func _process(delta):
	if OS.get_name() != "Web":
		if Input.is_action_just_pressed("ToggleFullscreen"):
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
