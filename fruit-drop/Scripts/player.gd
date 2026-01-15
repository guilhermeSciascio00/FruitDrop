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

var speed_power_up_multiplier : float = 0.20
var size_power_up_multiplier : float = 0.20

#References
@onready var fruit_gatherer: Area2D = $FruitGatherer
@onready var power_up_01: Timer = $PowerUP01
@onready var power_up_02: Timer = $PowerUP02
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var pick_up_sfx: AudioStreamPlayer2D = $PickUpSFX
const FRUIT_PICKUP_SFX : AudioStream = preload("res://SFX-Music/retro-coin-3-236679.mp3")
const POWER_UP_PICKUPSFX : AudioStream = preload("res://SFX-Music/win-176035.mp3")


signal on_game_over
signal on_damage_taken(remaining_lives : int)
signal on_powerup_taken(pw_type : ItemRes.powerup_types, turnOff : bool)

func _ready() -> void:
	apply_bought_upgrade(UpgradeManager.Upgrades.SPEED)
	apply_bought_upgrade(UpgradeManager.Upgrades.BOWLSIZE)
	
func _physics_process(_delta: float) -> void:
	if !is_game_over:
		flip_character(get_player_movement())
		player_movement_boundaries()
		move_and_slide()

func get_player_movement() -> int:
	var direction : float = Input.get_axis("MoveLeft", "MoveRight")
	var clamped_speed : float = clampf(player_speed, 0, SPEED_CAP)
	var movement : Vector2 = Vector2(direction * clamped_speed, 0)
	velocity = movement
	return direction
	
func flip_character(facing_dir : int) -> void:
	match facing_dir:
		-1:
			sprite_2d.flip_h = true
		1:
			sprite_2d.flip_h = false
	
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
				pick_up_sfx.stream = FRUIT_PICKUP_SFX
				pick_up_sfx.play()
				body.queue_free()
			
			ItemRes.item_types.POWER_UP:
				#print("We've got a pw-up")
				if body.power_up_type == ItemRes.powerup_types.SPEED and not has_speed_powerUP:
					power_up_01.wait_time = body.power_up_duration
					player_speed_temp = player_speed
					player_speed += (player_speed * speed_power_up_multiplier)
					has_speed_powerUP = true
					power_up_01.start()
					on_powerup_taken.emit(body.power_up_type, false)
					
				elif body.power_up_type == ItemRes.powerup_types.SIZE_INCREASE and not has_sizeI_powerUP:
					power_up_02.wait_time = body.power_up_duration
					fruit_gatherer_sizeI_temp = fruit_gatherer.scale.x
					fruit_gatherer.scale.x += (fruit_gatherer.scale.x * size_power_up_multiplier)
					has_sizeI_powerUP = true
					power_up_02.start()
					on_powerup_taken.emit(body.power_up_type, false)
					
				pick_up_sfx.stream = POWER_UP_PICKUPSFX
				pick_up_sfx.play()
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

func apply_bought_upgrade(upgrade : UpgradeManager.Upgrades) -> void:
	match(upgrade):
		UpgradeManager.Upgrades.SPEED:
			var speedBonus = player_speed
			if UpgradeManager.get_upgrade_level(upgrade) - 1 > 0:
				speedBonus += (UpgradeManager.get_upgrade_level(upgrade) - 1) * 100
				player_speed = speedBonus

		UpgradeManager.Upgrades.BOWLSIZE:
			var bowlSizeBonus = fruit_gatherer.scale.x
			if UpgradeManager.get_upgrade_level(upgrade) - 1 > 0:
				bowlSizeBonus += (UpgradeManager.get_upgrade_level(upgrade) - 1) * 0.10
				fruit_gatherer.scale.x = bowlSizeBonus
				print(fruit_gatherer.scale.x )
