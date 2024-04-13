extends Node2D

var _hold_pos: Vector2

var _joints := []

func _ready():
	get_joints(self, _joints)
	for joint in _joints:
		joint.softness = 300.0
	return
	for child in get_children():
		if child is PinJoint2D:
			child.node_a = get_child(child.get_index() - 1).get_path()
			child.node_b = get_child(child.get_index() + 1).get_path()
			
			
func _physics_process(delta):
	var chain:RigidBody2D = get_node("%Chain3")
	
	if Input.is_action_just_pressed("Hold"):
		_hold_pos = chain.global_position
		
		for joint in _joints:
			joint.softness = 50.0
	elif Input.is_action_just_released("Hold"):
		for joint in _joints:
			joint.softness = 300.0
	
	var impulse: Vector2
	
	var target_pos: Vector2
	if Input.is_action_pressed("Hold"):
		target_pos = _hold_pos
		impulse = (target_pos - chain.global_position).normalized() * 50.0
	else:
		target_pos = get_global_mouse_position()
		impulse = (target_pos - chain.global_position) / 10.0
		impulse = impulse.limit_length(8)
	
	chain.apply_central_impulse(impulse)


func get_joints(parent, list:Array):
	for child in parent.get_children():
		if child is PinJoint2D:
			list.append(child)
		get_joints(child, list)
