extends PinJoint2D


var _chainBody: RigidBody2D


func _ready():
	_chainBody = get_node("ChainBody")



func set_fixed_velocity(velocity: Vector2):
	_chainBody.set_fixed_velocity(velocity)

func unset_fixed_velocity():
	_chainBody.unset_fixed_velocity()

