extends RigidBody2D

@export var chain_scene: PackedScene



const DEFAULT_SOFTNESS := 5.0
const HOLD_SOFTNESS := 0.0

const FIRST_CHAIN_OFFSET_LEFT := Vector2(-50.0, 0.0)
const FIRST_CHAIN_OFFSET_RIGHT := Vector2(50.0, 0.0)

const MAX_REACH := 620.0

class ArmInfo:
	var hold_pos: Vector2

	var joints := []
	var bodies := []
	var player: RigidBody2D
	var hand: RigidBody2D
	
	var shoulder_joint: PinJoint2D
	
	func init(p_player: RigidBody2D, hand_group: String):
		player = p_player
		
		hand = bodies.back()
		hand.gravity_scale = 0.0
		hand.mass = 0.5
		hand.modulate = Color.GREEN
		hand.add_to_group(hand_group)
		
		shoulder_joint = joints.front()
		
		for joint in joints:
			joint.softness = DEFAULT_SOFTNESS


var left_arm := ArmInfo.new()
var right_arm := ArmInfo.new()


func _ready():
	GlobalState.player = self
	
	add_chain(self, true, 6, FIRST_CHAIN_OFFSET_LEFT, left_arm.joints, left_arm.bodies)
	left_arm.init(self, "LeftHand")
	GlobalState.left_hand = left_arm.hand

	add_chain(self, true, 6, FIRST_CHAIN_OFFSET_RIGHT, right_arm.joints, right_arm.bodies)
	right_arm.init(self, "RightHand")
	GlobalState.right_hand = right_arm.hand
 

func _physics_process(delta):
	_process_arm(delta, left_arm, "HoldLeft", true)
	_process_arm(delta, right_arm, "HoldRight", false)
	

static func _process_arm(
		delta,
		arm: ArmInfo,
		hold_action: String,
		is_left: bool):
	
	
	if Input.is_action_just_pressed(hold_action):
		arm.hold_pos = arm.hand.global_position
		
		for joint in arm.joints:
			joint.softness = HOLD_SOFTNESS
		
		#var summed_dist := 0.0
		#for i in range(arm.bodies.size() - 1):
			#summed_dist += (arm.bodies[i].global_position - arm.bodies[i + 1].global_position).length()
		#
		#print(summed_dist)
		#if summed_dist > 1330:
		var offset = arm.joints[1].global_position - arm.joints[0].global_position
		arm.player.apply_central_impulse(offset.normalized() * 500)
		
	elif Input.is_action_just_released(hold_action):
		for joint in arm.joints:
			joint.softness = DEFAULT_SOFTNESS
	
	var impulse: Vector2
	
	var target_pos: Vector2
	if Input.is_action_pressed(hold_action):
		if (is_left && GlobalState.left_grip_count == 0) or (!is_left && GlobalState.right_grip_count == 0):
			arm.hold_pos.y += 100.0 * delta
		
		target_pos = arm.hold_pos
		impulse = (target_pos - arm.hand.global_position) * 50.0 
		arm.hand.set_fixed_velocity(impulse)
		arm.hand.gravity_scale = 0.0
		
		var push = Input.get_last_mouse_velocity().x
		push = clampf(push, -100, 100)
		arm.player.apply_central_impulse(Vector2.RIGHT * push * 0.05)
		
	else:
		target_pos = arm.player.get_global_mouse_position()
	
		var offset = target_pos - arm.shoulder_joint.global_position
		
		#print(offset.length())
		offset = offset.limit_length(MAX_REACH)
		target_pos = arm.shoulder_joint.global_position + offset

		impulse = (target_pos - arm.hand.global_position) * 10.0 

		arm.hand.set_fixed_velocity(impulse)
		arm.hand.gravity_scale = 0.0
		

func add_chain(parent: Node2D, first: bool, count: int, chain_offset: Vector2, joint_list: Array, body_list: Array):
	var chain:Node2D = chain_scene.instantiate()
	var body:Node2D = chain.get_node("ChainBody")
	
	if first:
		chain.position = chain_offset
	
	parent.add_child(chain)
	
	joint_list.append(chain)
	body_list.append(body)
	
	if count > 1:
		add_chain(body, false, count - 1, chain_offset, joint_list, body_list)
