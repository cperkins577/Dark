extends CharacterBody2D

class_name Player

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"] 
const SPEED = 150.0
const JUMP_VELOCITY = -200.0

var is_wall_sliding = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_slide_gravity = 20
var wall_jump_pushback = 200

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#Gun aiming
	animation_tree["parameters/Idle/blend_position"] = get_local_mouse_position()
	animation_tree["parameters/Walk/blend_position"] = get_local_mouse_position()
	animation_tree["parameters/Jump_up/blend_position"] = get_local_mouse_position()
	animation_tree["parameters/Jump_middle/blend_position"] = get_local_mouse_position()
	animation_tree["parameters/Falling/blend_position"] = get_local_mouse_position()

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
			print(velocity.x)
		if is_on_wall() and Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback
		move_and_slide()
	
	var orig_y = velocity.y
	if is_on_floor() == false:
		if orig_y < 0:
			state_machine.travel("Jump_up")
		else:
			state_machine.travel("Falling")

	#Handle shoot
	if Input.is_action_just_pressed("attack"):
		$Gun1.shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			state_machine.travel("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			state_machine.travel("Idle")
	move_and_slide()
	wall_slide(delta)

func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left"):
			velocity.y += (wall_slide_gravity * delta)
			velocity.y = min(velocity.y, wall_slide_gravity)
			state_machine.travel("Wall_slide_left")
		if Input.is_action_pressed("move_right"):
			velocity.y += (wall_slide_gravity * delta)
			velocity.y = min(velocity.y, wall_slide_gravity)
			state_machine.travel("Wall_slide_right")
