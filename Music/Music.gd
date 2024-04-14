extends Node

var _music_items := {}

var _queued_music_type
var _player: AudioStreamPlayer
var _timer: Timer


func register_music(parent: Node):
	for child in parent.get_children():
		var musicType = child.Type
		
		if _music_items.has(musicType):
			_music_items[musicType].append(child)
		else:
			_music_items[musicType] = [child]
	
	_timer = Timer.new()
	_timer.wait_time = 2.0
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_timer.start()

func _on_timer_timeout() -> void:
	var wait_time: float
	if _player != null && _player.playing:
		wait_time = 1.0
	elif _player != null && !_player.playing:
		_player.queue_free()
		_player = null
		wait_time = 3.0
	elif _queued_music_type != null:
		var music_items = _music_items[_queued_music_type]
		var music_item = music_items[randi() % music_items.size()]
		
		_player = AudioStreamPlayer.new()
		_player.stream = music_item.Stream
		_player.volume_db = music_item.DB
		_player.bus = "Music"
		_player.process_mode = Node.PROCESS_MODE_ALWAYS
		
		add_child(_player)
		_player.play()
		_queued_music_type = null
		wait_time = 1.0
	else:
		wait_time = 1.0
	
	_timer.wait_time = wait_time
	_timer.start()

func queue(music_type):
	_queued_music_type = music_type
	
func unqueue(music_type):
	_queued_music_type = null
