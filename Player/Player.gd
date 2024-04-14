extends RigidBody2D

@export var chain_scene: PackedScene



const DEFAULT_SOFTNESS := 5.0
const HOLD_SOFTNESS := 0.0

const FIRST_CHAIN_OFFSET_LEFT := Vector2(-50.0, 0.0)
const FIRST_CHAIN_OFFSET_RIGHT := Vector2(50.0, 0.0)

const MAX_REACH := 620.0


class ArmInfo:
	var hold_pos: Vector2
	var sliding: bool
	var holding: bool

	var joints := []
	var bodies := []
	var player: RigidBody2D
	var hand: RigidBody2D
	
	var shoulder_joint: PinJoint2D
	
	func init(p_player: RigidBody2D, hand_group: String, left: bool):
		player = p_player
		
		hand = bodies.back()
		hand.mass = 0.5
		hand.add_to_group(hand_group)
		
		hand.enable_hand(left)
		
		shoulder_joint = joints.front()
		
		for joint in joints:
			joint.softness = DEFAULT_SOFTNESS


var left_arm := ArmInfo.new()
var right_arm := ArmInfo.new()

var head: Sprite2D
var left_eye: Sprite2D
var right_eye: Sprite2D

func _ready():
	GlobalState.player = self
	
	add_chain(self, true, 6, FIRST_CHAIN_OFFSET_LEFT, left_arm.joints, left_arm.bodies)
	left_arm.init(self, "LeftHand", true)
	GlobalState.left_hand = left_arm.hand

	add_chain(self, true, 6, FIRST_CHAIN_OFFSET_RIGHT, right_arm.joints, right_arm.bodies)
	right_arm.init(self, "RightHand", false)
	GlobalState.right_hand = right_arm.hand
	
	head = get_node("%Head")
	left_eye = get_node("%LeftEye")
	right_eye = get_node("%RightEye")
 
func _process(delta):
	var look_vec := (get_global_mouse_position() - head.global_position).normalized() * 4
	look_vec = look_vec.rotated(-head.global_rotation)
	left_eye.position = look_vec 
	right_eye.position = look_vec


func _physics_process(delta):
	_process_arm(delta, left_arm, "HoldLeft", true)
	_process_arm(delta, right_arm, "HoldRight", false)
	

func _process_arm(
		delta,
		arm: ArmInfo,
		hold_action: String,
		is_left: bool):
	
	
	if Input.is_action_just_pressed(hold_action):
		arm.sliding = true
		arm.hand.close_hand()
		
		for joint in arm.joints:
			joint.softness = HOLD_SOFTNESS
		
	elif Input.is_action_just_released(hold_action):
		arm.hand.open_hand()
		
		for joint in arm.joints:
			joint.softness = DEFAULT_SOFTNESS
	
	var impulse: Vector2
	
	var target_pos: Vector2
	arm.holding = false
	arm.hand.gravity_scale = 1.0
	if Input.is_action_pressed(hold_action):
		if (is_left && GlobalState.left_grip_count > 0) or (!is_left && GlobalState.right_grip_count > 0):
			arm.holding = true
			if arm.sliding:
				arm.sliding = false
				arm.hold_pos = arm.hand.global_position
		
			target_pos = arm.hold_pos
			impulse = (target_pos - arm.hand.global_position) * 50.0 
			arm.hand.set_fixed_velocity(impulse)
			arm.hand.gravity_scale = 0.0
			
			var push := Vector2.ZERO
			
			var push_side := Input.get_last_mouse_velocity().x
			push_side = clampf(push_side, -100, 100)
			push += Vector2.RIGHT * push_side * 0.05
			
			if left_arm.holding and right_arm.holding:
				var push_vert := Input.get_last_mouse_velocity().y
				push_vert = clampf(push_vert, -100, 100)
				push += Vector2.DOWN * push_vert * 0.15
				print(push_vert)
			
			if push != Vector2.ZERO:
				arm.player.apply_central_impulse(push)
			
			
		else:
			arm.sliding = true
	else:
		arm.sliding = false
	
	if !arm.holding:
		target_pos = arm.player.get_global_mouse_position()
	
		var offset = target_pos - arm.shoulder_joint.global_position
		
		#print(offset.length())
		offset = offset.limit_length(MAX_REACH)
		target_pos = arm.shoulder_joint.global_position + offset

		if !arm.sliding:
			impulse = (target_pos - arm.hand.global_position) * 10.0
			arm.hand.set_fixed_velocity(impulse)
		else:
			arm.hand.unset_fixed_velocity()

		

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
