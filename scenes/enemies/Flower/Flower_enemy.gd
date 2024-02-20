extends Enemy

const MAX_HEALTH = 50
@export var health = MAX_HEALTH

const SPEED = 50
var player_chase = false
var player = null

var taking_damage = false
signal damage_done

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player_chase:
		var direction = (player.get_global_position()-position).normalized()
		velocity.x = direction.x * SPEED * delta
		move_and_collide(velocity)
		if !taking_damage:
			$AnimatedSprite2D.play("move")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !taking_damage:
			$AnimatedSprite2D.play("idle")
	move_and_slide()


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false

func take_damage(dam):
	taking_damage = true
	$AnimatedSprite2D.stop()
	print("taking damage, health at")
	print(health)
	$AnimatedSprite2D.play("hit")
	health -= dam
	if health <= 0:
		$AnimatedSprite2D.play("death")
		queue_free()
