extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	var speed = 500
	const RANGE = 200
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	if travelled_distance > RANGE:
		queue_free()
