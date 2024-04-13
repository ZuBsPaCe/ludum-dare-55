extends RigidBody2D

var _fixed := false
var _fixed_velocity
var _fixed_position

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
