extends Sprite2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation = animation_player["current_animation"]

func _process(_delta):
	look_at(get_global_mouse_position())

func shoot():
	animation_player.stop()
	animation_player.play("shoot")
	const BULLET = preload("res://scenes/gun1/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %Barrel.global_position
	new_bullet.global_rotation = %Barrel.global_rotation
	%Barrel.add_child(new_bullet)
