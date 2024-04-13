extends RigidBody2D

@export var chain_scene: PackedScene

var _hold_pos: Vector2

var _joints := []
var _bodies := []
var _chain: RigidBody2D

const DEFAULT_SOFTNESS := 0.0
const HOLD_SOFTNESS := 0.0

const FIRST_CHAIN_OFFSET := 100.0
const DEFAULT_CHAIN_OFFSET := 100.0


func _ready():
	
	add_chain(self, 10, FIRST_CHAIN_OFFSET, _joints, _bodies)
	_chain = _bodies.back()
	_chain.gravity_scale = 0.0
	_chain.mass = 0.5
	_chain.modulate = Color.GREEN
	
	for joint in _joints:
		joint.softness = DEFAULT_SOFTNESS



func _physics_process(delta):
	#var chain:RigidBody2D = get_node("%Chain3")
	
	if Input.is_action_just_pressed("Hold"):
		_hold_pos = _chain.global_position
		
		for joint in _joints:
			joint.softness = HOLD_SOFTNESS
		
		var summed_dist := 0.0
		for i in range(_bodies.size() - 1):
			summed_dist += (_bodies[i].global_position - _bodies[i + 1].global_position).length()
		
		print(summed_dist)
		if summed_dist > 1330:
			var offset = _chain.global_position - global_position
			apply_central_impulse(offset.normalized() * 1000)
		
	elif Input.is_action_just_released("Hold"):
		for joint in _joints:
			joint.softness = DEFAULT_SOFTNESS
	
	var impulse: Vector2
	
	var target_pos: Vector2
	if Input.is_action_pressed("Hold"):
		target_pos = _hold_pos
		impulse = (target_pos - _chain.global_position) * 50.0 
		_chain.set_fixed_velocity(impulse)
		_chain.gravity_scale = 0.0
		
		var push = Input.get_last_mouse_velocity().x
		push = clampf(push, -100, 100)
		apply_central_impulse(Vector2.RIGHT * push * 0.1)
		
	else:
		target_pos = get_global_mouse_position()
	
		var offset = target_pos - global_position
		
		#print(offset.length())
		offset = offset.limit_length(1480)
		target_pos = global_position + offset

		impulse = (target_pos - _chain.global_position) * 10.0 

		_chain.set_fixed_velocity(impulse)
		_chain.gravity_scale = 0.0
		


func add_chain(parent: Node2D, count: int, offset: float, joint_list: Array, body_list: Array):
	var chain:Node2D = chain_scene.instantiate()
	parent.add_child(chain)
	
	var body:Node2D = chain.get_node("ChainBody")
	body.position.y = -offset * 2
	
	
	joint_list.append(chain)
	body_list.append(body)
	
	if count > 1:
		add_chain(body, count - 1, DEFAULT_CHAIN_OFFSET, joint_list, body_list)
