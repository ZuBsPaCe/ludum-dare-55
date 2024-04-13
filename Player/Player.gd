extends Node2D

@export var chain_scene: PackedScene

var _hold_pos: Vector2

var _joints := []
var _chain:RigidBody2D

const DEFAULT_SOFTNESS := 50.0
const HOLD_SOFTNESS := 10.0

const FIRST_CHAIN_OFFSET := 100.0
const DEFAULT_CHAIN_OFFSET := 5.0

func _ready():
	
	var bodies := []
	add_chain(get_node("Box"), 10, FIRST_CHAIN_OFFSET, _joints, bodies)
	_chain = bodies.back()
	
	for joint in _joints:
		joint.softness = DEFAULT_SOFTNESS


func _physics_process(delta):
	#var chain:RigidBody2D = get_node("%Chain3")
	
	if Input.is_action_just_pressed("Hold"):
		_hold_pos = _chain.global_position
		
		for joint in _joints:
			joint.softness = HOLD_SOFTNESS
	elif Input.is_action_just_released("Hold"):
		for joint in _joints:
			joint.softness = DEFAULT_SOFTNESS
	
	var impulse: Vector2
	
	var target_pos: Vector2
	if Input.is_action_pressed("Hold"):
		target_pos = _hold_pos
		impulse = (target_pos - _chain.global_position).normalized() * 20.0
	else:
		target_pos = get_global_mouse_position()
		impulse = (target_pos - _chain.global_position) / 10.0
		impulse = impulse.limit_length(8)
	
	_chain.apply_central_impulse(impulse)


func add_chain(parent: Node2D, count: int, offset: float, joint_list: Array, body_list: Array):
	var chain:Node2D = chain_scene.instantiate()
	parent.add_child(chain)
	
	var body:Node2D = chain.get_node("ChainBody")
	body.position.y = offset
	
	joint_list.append(chain)
	body_list.append(body)
	
	if count > 1:
		add_chain(body, count - 1, DEFAULT_CHAIN_OFFSET, joint_list, body_list)
