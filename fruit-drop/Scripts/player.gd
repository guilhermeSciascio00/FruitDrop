class_name Player extends CharacterBody2D

@export var player_speed : float
@export var bounds_offset : float
var player_lives : int = 3
const SPEED_CAP : float = 1200
var has_speed_powerUP : bool = false
var has_sizeI_powerUP : bool = false
var player_speed_temp : float
var fruit_gatherer_sizeI_temp : float
@onready var is_game_over: bool = false

#References
@onready var fruit_gatherer: Area2D = $FruitGatherer
@onready var power_up_01: Timer = $PowerUP01
@onready var power_up_02: Timer = $PowerUP02

signal on_game_over
signal on_damage_taken(remaining_lives : int)
signal on_powerup_taken(pw_type : ItemRes.powerup_types, turnOff : bool)

func _physics_process(_delta: float) -> void:
	if !is_game_over:
		get_player_movement()
		player_movement_boundaries()
		move_and_slide()

func get_player_movement() -> void:
	var direction : float = Input.get_axis("MoveLeft", "MoveRight")
	var clamped_speed : float = clampf(player_speed, 0, SPEED_CAP)
	var movement : Vector2 = Vector2(direction * clamped_speed, 0)
	velocity = movement
	
func player_movement_boundaries() -> void:
	var vp_size : Vector2 = get_viewport_rect().size
	var newPos : Vector2 = Vector2(clampf(position.x, 0 + bounds_offset, vp_size.x - bounds_offset), position.y)
	position = newPos
	
func take_damage() -> void:
	player_lives -= 1
	on_damage_taken.emit(player_lives)
	if player_lives <= 0:
		player_lives = 0
		is_game_over = true
		on_game_over.emit()
	
func _on_fruit_gatherer_body_entered(body: Node2D) -> void:
	if body is ItemBase:
		match (body.item_type):
			ItemRes.item_types.FRUIT:
				#print("We've got a fruit")
				CurrencyManager.add_score(body.item_points)
				body.queue_free()
			
			ItemRes.item_types.POWER_UP:
				#print("We've got a pw-up")
				if body.power_up_type == ItemRes.powerup_types.SPEED and not has_speed_powerUP:
					power_up_01.wait_time = body.power_up_duration
					player_speed_temp = player_speed
					player_speed *= 2
					has_speed_powerUP = true
					power_up_01.start()
					on_powerup_taken.emit(body.power_up_type, false)
					
				elif body.power_up_type == ItemRes.powerup_types.SIZE_INCREASE and not has_sizeI_powerUP:
					power_up_02.wait_time = body.power_up_duration
					fruit_gatherer_sizeI_temp = fruit_gatherer.scale.x
					fruit_gatherer.scale.x += 1
					has_sizeI_powerUP = true
					power_up_02.start()
					on_powerup_taken.emit(body.power_up_type, false)
					
				body.queue_free()
				
			ItemRes.item_types.HAZARD:
				#print("Oh no, we got hit")
				#Negative points will be subtracted by the score amount
				CurrencyManager.add_score(body.item_points)
				take_damage()
				body.queue_free()


func _on_power_up_01_timeout() -> void:
	has_speed_powerUP = false
	player_speed = player_speed_temp
	on_powerup_taken.emit(ItemRes.powerup_types.SPEED, true)

func _on_power_up_02_timeout() -> void:
	has_sizeI_powerUP = false
	fruit_gatherer.scale.x = fruit_gatherer_sizeI_temp
	on_powerup_taken.emit(ItemRes.powerup_types.SIZE_INCREASE, true)
