extends Node

var _sound_items := {}
var _last_time := {}

var _loops := {}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func register_sounds(parent: Node):
	for child in parent.get_children():
		var soundType = child.Type
		
		if _sound_items.has(soundType):
			_sound_items[soundType].append(child)
		else:
			_sound_items[soundType] = [child]
		
		_last_time[soundType] = 0


func play(parent: Node, sound_type):
	var last_time = _last_time[sound_type]
	var current_time = Time.get_unix_time_from_system()
	if current_time - last_time < 0.25:
		return
	
	_last_time[sound_type] = current_time
	
	var sound_items = _sound_items[sound_type]
	var sound_item = sound_items[randi() % sound_items.size()]
	
	var player := AudioStreamPlayer2D.new()
	player.stream = sound_item.Stream
	player.volume_db = sound_item.DB
	player.bus = "Sound"
	parent.add_child(player)
	player.play()
	player.finished.connect(_finished.bind(player))


func _finished(player):
	player.queue_free()


func play_loop(parent: Node, sound_type):
	if _loops.has(sound_type) and _loops[sound_type].playing:
		return
	
	if _loops.has(sound_type):
		_loops[sound_type].queue_free()
	
	var sound_items = _sound_items[sound_type]
	var sound_item = sound_items[randi() % sound_items.size()]
	
	sound_item.Stream.loop = true
		
	var player := AudioStreamPlayer2D.new()
	player.stream = sound_item.Stream
	player.volume_db = sound_item.DB
	player.bus = "Sound"
	parent.add_child(player)
	player.play()
	
	_loops[sound_type] = player

func stop_loop(sound_type):
	if _loops.has(sound_type):
		_loops[sound_type].queue_free()
		_loops.erase(sound_type)

