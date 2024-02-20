extends CharacterBody2D

#class_name Player

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"] 
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var is_attacking = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction and is_attacking == false:
		velocity.x = direction * SPEED
		state_machine.travel("walk")
		if velocity.x <= 0:
			$Sprite2D.scale.x = -1
		else:
			$Sprite2D.scale.x = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state_machine.travel("idle")
	
	#handle attack
	if Input.is_action_just_pressed("attack"):
		attack()

	move_and_slide()

func attack():
	state_machine.travel("attack")
	if animation_tree.tree_root.get_node("attack").animation:
		is_attacking = true
	


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false

