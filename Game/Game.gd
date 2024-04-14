extends Node2D


var win_screen: CanvasLayer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	Sounds.register_sounds(get_node("%Sounds"))
	Music.register_music(get_node("%Music"))
	
	win_screen = get_node("%WinScreen")
	win_screen.init()

func _process(delta):
	if OS.get_name() != "Web":
		if Input.is_action_just_pressed("ToggleFullscreen"):
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_win_area_body_entered(body):
	if body.is_in_group("Player"):
		win_screen.show_win_screen()


func _on_win_reset_area_body_entered(body):
	if body.is_in_group("Player"):
		win_screen.reset_win_screen()
