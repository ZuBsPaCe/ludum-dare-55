extends CanvasLayer

var container: Control
var screen1: Control
var screen2: Control
var stat_label: Label

var default_stat_label
var shown: bool

var _stopwatch: float
var _final_time: float

func init():
	container = get_node("%WinScreenContainer")
	screen1 = get_node("%Screen1")
	screen2 = get_node("%Screen2")
	stat_label = get_node("%StatLabel")
	
	reset_win_screen()

func _process(delta):
	_stopwatch += delta
	

func show_win_screen():
	if shown:
		return
	shown = true
	
	_final_time = _stopwatch
	
	var minutes = int(floor(_final_time / 60.0))
	var seconds = int(floor(_final_time - 60.0 * minutes))
	var res = str(minutes) + " minutes and " + str(seconds) + " seconds"
	stat_label.text = default_stat_label.replace("RESULT", res)
	
	visible = true
	get_tree().paused = true

func reset_win_screen():
	shown = false	
	
	visible = false
	screen1.visible = true
	screen2.visible = false
	
	if default_stat_label == null:
		default_stat_label = stat_label.text
	
	_stopwatch = 0.0


func _on_button_1_pressed():
	screen1.visible = false
	screen2.visible = true


func _on_button_2_pressed():
	visible = false
	
	get_tree().paused = false
