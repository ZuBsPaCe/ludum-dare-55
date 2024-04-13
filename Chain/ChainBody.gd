extends RigidBody2D

var _fixed := false
var _fixed_velocity
var _fixed_position

var hand:Sprite2D 
var hand_closed:Sprite2D

func _ready():
	hand = get_node("%Hand")
	hand_closed = get_node("%HandClosed")

#func set_fixed_velocity(velocity: Vector2):
	#_fixed_velocity = velocity
	#
	#if _fixed_velocity == Vector2.ZERO:
		#if !_fixed:
			#_fixed = true
			#_fixed_position = global_position
			#linear_velocity = Vector2.ZERO
	#else:
		#_fixed = false
#
#func _integrate_forces(state):
	#if _fixed:
		#global_position = _fixed_position
	#elif _fixed_velocity:
		#linear_velocity = _fixed_velocity

func set_fixed_velocity(velocity: Vector2):
	_fixed_velocity = velocity

func unset_fixed_velocity():
	_fixed_velocity = null

func _integrate_forces(state):
	if _fixed_velocity:
		linear_velocity = _fixed_velocity

	
func enable_hand(left: bool):
	hand.visible = true
	if !left:
		hand.scale = hand.scale * Vector2(-1, 1)
		hand_closed.scale = hand_closed.scale * Vector2(-1, 1)

func open_hand():
	hand.visible = true
	hand_closed.visible = false

func close_hand():
	hand.visible = false
	hand_closed.visible = true
