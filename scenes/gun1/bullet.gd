extends Area2D

@export var speed = 500
@export var bullet_dam = 10
var travelled_distance = 0

func _physics_process(delta):
	const RANGE = 200
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	speed = 0
	$Projectile.scale.x = 1
	$Projectile.scale.y = 1
	$Projectile.play("Hit")
	if body is Enemy:
		body.take_damage(bullet_dam)
	


func _on_projectile_animation_finished():
	queue_free()
