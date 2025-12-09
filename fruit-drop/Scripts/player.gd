class_name Player extends CharacterBody2D

@export var player_speed : float
@export var bounds_offset : float
var player_lives : int = 3
@onready var is_game_over: bool = false
#References
@onready var fruit_gatherer: Area2D = $FruitGatherer

signal on_game_over

func _physics_process(_delta: float) -> void:
	if !is_game_over:
		get_player_movement()
		player_movement_boundaries()
		move_and_slide()

func get_player_movement() -> void:
	var direction : float = Input.get_axis("MoveLeft", "MoveRight")
	var movement : Vector2 = Vector2(direction * player_speed, 0)
	velocity = movement
	
func player_movement_boundaries() -> void:
	var vp_size : Vector2 = get_viewport_rect().size
	var newPos : Vector2 = Vector2(clampf(position.x, 0 + bounds_offset, vp_size.x - bounds_offset), position.y)
	position = newPos
	
func take_damage() -> void:
	player_lives -= 1
	if player_lives <= 0:
		player_lives = 0
		is_game_over = true
		on_game_over.emit()
	
func _on_fruit_gatherer_body_entered(body: Node2D) -> void:
	if body is ItemBase:
		match (body.item_type):
			ItemRes.item_types.FRUIT:
				print("We've got a fruit")
				#Increase the score
				body.queue_free()
			ItemRes.item_types.POWER_UP:
				print("We've got a pw-up")
				body.queue_free()
			ItemRes.item_types.HAZARD:
				print("Oh no, we got hit")
				take_damage()
				body.queue_free()
