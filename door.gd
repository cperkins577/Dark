extends Area2D

@export var connected_door : Area2D
var move_to
var player : CharacterBody2D

func _ready():
	var door = get_path_to(connected_door)
	move_to = get_node(door)

func _process(_delta):
	if player and Input.is_action_just_pressed("enter_door"):
		player.position = move_to.global_position

func _on_door_body_entered(body: CharacterBody2D)->void:
	if body is Player:
		print("entered")
		player = body

func _on_door_body_exited(body: CharacterBody2D)->void:
	if body is Player:
		player = null
