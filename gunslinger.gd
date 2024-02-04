extends CharacterBody2D

class_name Player

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"] 
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#Handle shoot
	if Input.is_action_just_pressed("attack"):
		$Gun1.shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			#state_machine.travel("Walk")
			pass
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			#state_machine.travel("Idle")
			pass
	move_and_slide()

