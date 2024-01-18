extends Sprite2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

func _process(_delta):
	look_at(get_global_mouse_position())

func shoot():
	const BULLET = preload("res://scenes/gun1/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %Barrel.global_position
	new_bullet.global_rotation = %Barrel.global_rotation
	state_machine.travel("shoot")
	%Barrel.add_child(new_bullet)
